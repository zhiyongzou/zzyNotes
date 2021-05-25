//
//  NSTimer+Extension.m
//  CommonTest
//
//  Created by zzyong on 2021/5/25.
//

#import "NSTimer+Extension.h"

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
