## 内存泄漏 NSTimer

下面的 __weak target 可以避免内存泄漏吗？

```objc
@interface TimerLeakVC ()

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation TimerLeakVC

- (void)dealloc {
    [_timer invalidate];
    NSLog(@"%s", __func__);
}

- (void)helloWorld {
    NSLog(@"Hello World!");
}

- (IBAction)timerLeak:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:weakSelf
                                            selector:@selector(helloWorld)
                                            userInfo:nil
                                             repeats:YES];
}
@end
```

官方文档的描述如下：
> The object to which to send the message specified by aSelector when the timer fires. The timer maintains a strong reference to target until it (the timer) is invalidated.

target 无论传的是 `__weak` or `__strong` NSTimer 内部依然会对其目标对象进行强引用，外部无法改变强引用关系。

他们之间的引用关系如下所示：

<img src="../imgs/timer_ref.jpg">

主线程 RunLoop 是常驻对象，同时 NSTimer 也会保留其目标对象直至定时器失效才会释放目标对象。 由于目标对象被定时器持有，控制器无法释放，所以 dealloc 方法不会被调用，因此定时器也无法主动失效，最终导致内存泄漏。

## 解决方案

### 方案 1
如果项目只支持系统版本 >= iOS 10，那么直接使用系统方法（带 block 回调）即可 

```objc
- (IBAction)timerDeallocBySystemApi:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             repeats:YES
                                               block:^(NSTimer * _Nonnull timer) {
        [weakSelf helloWorld];
    }];
}
```

### 方案 2
目前大多数项目依然还支持 iOS 9 ,所以无法直接使用系统方法。既然无法使用，我们可以自己创建一个 block 回调方法即可。

**实现原理：**

将 NSTimer 类对象作为 timer 实例的 target 对象，然后用 timer 的 userInfo 来保存回调 block。具体实现如下：

```objc

@implementation NSTimer (Extension)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                    repeats:(BOOL)repeats
                                    forMode:(NSRunLoopMode)mode
                                      block:(void(^)(NSTimeInterval time))block {
    
    // 将 NSTimer 类对象作为 target，这样子就可以完美的解决强引用 VC 的问题。由于 VC 不再被定时器引用，
    // 所以 VC 就可以正常释放了
    NSTimer *timer = [self scheduledTimerWithTimeInterval:interval
                                                   target:self
                                                 selector:@selector(blockInvoke:)
                                                 userInfo:[block copy]
                                                  repeats:repeats];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:mode];
    
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

### 方案 3
NSProxy


