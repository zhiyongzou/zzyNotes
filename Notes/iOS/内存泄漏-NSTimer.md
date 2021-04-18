## 内存泄漏之 NSTimer

下面的 __weak 可以避免循环引用么？

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

target 无论传的是 `__weak` or `__strong` 其内部还是会对其进行强引用，无法避免循环引用。

## 解决方案

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
