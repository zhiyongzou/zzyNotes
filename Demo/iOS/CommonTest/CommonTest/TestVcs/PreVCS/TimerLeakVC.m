//
//  TimerLeakVC.m
//  CommonTest
//
//  Created by zzyong on 2021/5/7.
//

#import "TimerLeakVC.h"
#import "NSTimer+Extension.h"
#import "TimerTargetProxy.h"

@interface TimerLeakVC ()

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) TimerTargetProxy *timerProxy;

@end

@implementation TimerLeakVC

- (instancetype)init {
    if (self = [super init]) {
        _timerProxy = [[TimerTargetProxy alloc] initWithTarget:self];
    }
    return self;
}

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

- (IBAction)timerDeallocByBlock:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             repeats:YES
                                             forMode:NSRunLoopCommonModes
                                               block:^(NSTimer * _Nonnull timer) {
        [weakSelf helloWorld];
    }];
}

- (IBAction)timerDeallocByWeakProxy:(UIButton *)sender {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:_timerProxy
                                            selector:@selector(helloWorld)
                                            userInfo:nil
                                             repeats:YES];
}

- (IBAction)timerDeallocBySystemApi:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             repeats:YES
                                               block:^(NSTimer * _Nonnull timer) {
        [weakSelf helloWorld];
    }];
}

- (IBAction)timerInOtherThread {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self performSelector:@selector(timerSay) withObject:nil afterDelay:0];
        NSLog(@"%s %@", __func__, [NSThread currentThread]);
    });
}

- (void)timerSay {
    NSLog(@"%s", __func__);
}

@end
