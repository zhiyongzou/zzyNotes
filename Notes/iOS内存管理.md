## ARC
ARC（Automatic Reference Counting）是指内存管理中对引用采用自动计数。由编译器自动管理 retain 和 release。此外，在对象释放后，OC运行时库将会把指向该对象的所有 weak 变量置 nil。

### 内存管理方式
- 自己生成的对象，自己持有；alloc/new/copy/mutableCopy等
- 持有其他对象; retain
- 释放自己持有的对象; release
- 废弃对象; dealloc, 系统自动调用
- 通过 alloc/new/copy/mutableCopy 方法才能够自己生成并持有对象，其他情况只是持有其他对象而并非自己生成

### Autorelease
#### 用于类方法返回 Autorelease 对象
```objc
// ARC
id array = [NSArray array];

// MRC
id array = [[[NSArray alloc] init] autorelease];
```
#### AutoreleasePool 对象释放时机
在 `RunLoop` 即将进入休眠（`kCFRunLoopBeforeWaiting`）时释放池中对象

#### 产生大量 autorelease 对象时，应使用 AutoreleasePool 降低内存使用峰值
```objc
for (int idx = 0; idx < INT_MAX; idx++) {
    @autoreleasepool {
        NSString *string = [NSString stringWithFormat:@"%@ say: Hello World!", @(idx)];
        NSLog(@"%@", string);
    }
}
```
## ARC 规则
#### 单一文件可选择是否使用 ARC
在 Build Phases --> Compile Sources --> xxx.m --> Compiler Flags 设置是否使用 ARC。`-fobjc-arc`表示禁用 ARC

#### ARC 所有权修饰符
- `__strong`：强引用，是 id 类型和对象类型默认的所有权修饰符

- `__weak`：弱引用，对象释放后，变量会被自动置 nil。主要用来解决循环引用问题

- `__unsafe_unretained`：非安全弱引用，其修饰的变量不属于编译器的内存管理对象。对象隐式赋值时可以用 `__unsafe_unretained` 避免多次 release

- ` __autoreleasing`：自动释放修饰符，一般用于局部变量和方法参数

#### 对象指针
- id的指针（`id *obj`）或对象的指针(`NSObject **obj`)在没有显式指定时会被附加上 `__autorelease` 修饰符。

```objc
- (void)performSelectorWithError:(NSError **)error
{

}    
// 等同于
- (void)performSelectorWithError:(NSError * __autoreleasing *)error
{
    
}
```

- 赋值给对象指针时，所有权修饰符必须一致

```objc
// error: pointer to non-const type 'NSError *' with no explicit ownership
NSError *error = nil;
NSError **pError = &error;

// right
NSError *error = nil;
NSError * __strong *pError = &error;
```

#### 打印注册到 autoreleasepool 上的对象
无论 ARC 是否有效，调试时可使用 `_objc_autoreleasePoolPrint()`

```
(lldb) po _objc_autoreleasePoolPrint()
```

#### 不要显式调用 dealloc
- 无论 ARC 是否有效，只要对象的引用计数为0，该对象就被废弃。对象被废弃时，系统会自动调用 `dealloc` 方法。
- ARC 无需调用 `[super dealloc]`

#### 显示转换 id 和 void *
 `id`型或对象型变量赋值给 `void *` 或着逆向赋值时都需要进行特定的转换。如果只想单纯赋值，则可以使用`__bridge`转换

```objc
// error: Implicit conversion of Objective-C pointer type 'id' to C pointer type 'void *' requires a bridged cast
id obj = [NSObject new];
void *p = obj;

// right
id obj = [NSObject new];
void *p = (__bridge void *)(obj);
id obj_1 = (__bridge id)(p);
```

#### `__bridge_retained`
转换要赋值的变量并持有该对象

```objc
// ARC 
id obj = [NSObject new];
void *p = (__bridge_retained void *)obj;
    
// __bridge_retained 对等于下面非 ARC 实现
id obj = [NSObject new];
void *p = obj;
[(id)p retain];    

// error: EXC_BAD_ACCESS
void *p = 0;
{
    id obj = [NSObject new];
    p = (__bridge void *)obj;
}
NSLog(@"%@", (__bridge id)p);

// right
void *p = 0;
{
    id obj = [NSObject new];
    p = (__bridge_retained void *)obj;
}
NSLog(@"%@", (__bridge id)p);

```

#### `__bridge_transfer`
与`__bridge_retained`相反，被转换的变量所持有的对象在该变量被赋值给转换目标变量后随之释放

```objc
// ARC 
id obj = (__bridge_transfer id)p;

// __bridge_transfer 对等于下面非 ARC 实现
id obj = (id)p;
[obj retain];
[(id)p release];
```

## 有意思的例子
### 1. Double release

```objc
// ARC 隐式无效
// *** -[CFString release]: message sent to deallocated instance 0x6000009e9620
{
	id string = nil;
	@autoreleasepool {
	    NSNumber *num = [[NSNumber alloc] initWithLong:6666666666666666];
	    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSNumber instanceMethodSignatureForSelector:@selector(stringValue)]];
	    invocation.target = num;
	    invocation.selector = @selector(stringValue);
	    [invocation invoke];
	    [invocation getReturnValue:&string];
	    NSLog(@"%p", string);
	}
}

// 解决
// __weak
__weak id string = nil;

// __unsafe_unretained
__unsafe_unretained id string = nil;
```

### 2. 可以正常运行么？
```objc
// NSTaggedPointerString
{
	id string = nil;
	@autoreleasepool {
	    NSNumber *num = [[NSNumber alloc] initWithLong:666];
	    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSNumber instanceMethodSignatureForSelector:@selector(stringValue)]];
	    invocation.target = num;
	    invocation.selector = @selector(stringValue);
	    [invocation invoke];
	    [invocation getReturnValue:&string];
	    NSLog(@"%p", string);
	}
}
```

### 3. Block 为啥还要 strongSelf

```objc
// __weak 告诉 block 不要强引用 self，防止发生循环引用 
__weak typeof(self) weakSelf = self;

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    // 虽然加了判断，其实跟不加的效果一致
    if (weakSelf == nil) {
        return;
    }
    
    // 由于是弱引用，所以 weakSelf 随时都可能被释放。
    // 以下调用行为不确定，存在各种情况。可能都失败，或者都成功，或者部分成功
    [weakSelf doSomething];
    [weakSelf doSomethingElse];
});


dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    // 如果 weakSelf 未被释放， __strong 则保证 self 在 block 作用域不被释放
    __strong typeof(weakSelf) strongSelf = weakSelf;
    
    // 要么直接 return , 要么都会执行。调用行为确定
    if (strongSelf == nil) {
        return;
    }
    
    [strongSelf doSomething];
    [strongSelf doSomethingElse];
});

```

**下面的代码阔以编译通过么?**

```objc
// Dereferencing a __weak pointer is not allowed due to possible null value caused  
// by race condition, assign it to strong variable first

__weak typeof(self) weakSelf = self;
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    weakSelf->_someProperty = [NSObject new];
});

```

### 4. 下面的 __weak 可以避免循环引用么？
```objc
@interface ViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	    
	__weak typeof(self) weakSelf = self;
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1
	                                              target:weakSelf
	                                            selector:@selector(onTimerFire)
	                                            userInfo:nil
	                                             repeats:YES];
}

@end
```

官方文档的注释如下：
> The object to which to send the message specified by aSelector when the timer fires. The timer maintains a strong reference to target until it (the timer) is invalidated.

target 无论传的是 `__weak` or `__strong` 其内部还是会对其进行强引用，无法避免循环引用。下面说说一种通用的解决方案，代码如下：

```objc
@implementation NSTimer (Extension)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(void(^)(NSTimeInterval time))block
                                    repeats:(BOOL)repeats
                            loopCommonModes:(BOOL)loopCommonModes {
	
	// 将 NSTimer 类对象作为 target，这样子就可以完美的解决循环引用的问题
	NSTimer *timer = [self scheduledTimerWithTimeInterval:interval
                                                   target:self
                                                 selector:@selector(blockInvoke:)
                                                 userInfo:[block copy]
                                                  repeats:repeats];
	
	if (loopCommonModes) {
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
	}
	
	return timer;
}


+ (void)blockInvoke:(NSTimer *)timer 
{
	if (timer.isValid) {
		void (^block)(NSTimeInterval) = timer.userInfo;
		if (block) {
			block([timer timeInterval]);
		}
	}
}

@end

``` 

### 5. Exceptions 下的 try catch 内存泄漏
#### obj 可以正常释放么？
```objc
@try {
    MyObject *obj = [MyObject new];
    [obj description];

    @throw [NSException exceptionWithName:@"ML" reason:@"Memory Leak" userInfo:@{}];
} @catch (NSException *exception) {
    NSLog(@"%@", exception);
} @finally {
    NSLog(@"finally call");
}
```

#### myObject 可以正常释放么？
```objc
{
    ViewController *vc = [ViewController new];
    vc.myObject = [MyObject new];

    @try {
        [vc.myObject removeObserver:self forKeyPath:@"Unknown name"];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    } @finally {
        NSLog(@"finally call");
    }
}
```

运行结果：obj 和 myObject 都不能正常释放。这是为什么呢？在 [Objective-C Automatic Reference Counting (ARC)](http://clang.llvm.org/docs/AutomaticReferenceCounting.html#exceptions) 中有以下说明：
> By default in Objective C, ARC is not exception-safe for normal releases:
> 
> 1. It does not end the lifetime of __strong variables when their scopes are abnormally terminated by an exception.
> 2. It does not perform releases which would occur at the end of a full-expression if that full-expression throws an exception.

- obj 对象默认是强引用的，由于在作用域结束前发生异常，所以无法释放。满足第一点 
- 因为 `[vc.myObject removeObserver:self forKeyPath:@"Unknown name"]` 表达式引发异常，所以 myObject 的 release 没有调用，导致 myObject 无法释放。满足第二点

解决：

- 将 `@try` 中的局部变量挪到外面创建即可
- 第二种泄漏类型则需要在`@try`代码对应源文件设置 `-fobjc-arc-exceptions` 编译器标识符，这个编译器标识符同样适用于第一种情况

## 参考文档
[1. Block Implementation Specification](https://clang.llvm.org/docs/Block-ABI-Apple.html#block-escapes)

[2. Objective-C Automatic Reference Counting (ARC)](http://clang.llvm.org/docs/AutomaticReferenceCounting.html)

[3. I finally figured out weakSelf and strongSelf](https://dhoerl.wordpress.com/2013/04/23/i-finally-figured-out-weakself-and-strongself/)

[4. 深入理解Tagged Pointer](https://blog.devtang.com/2014/05/30/understand-tagged-pointer/)
