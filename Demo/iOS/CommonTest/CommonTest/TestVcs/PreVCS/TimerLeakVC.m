//
//  TimerLeakVC.m
//  CommonTest
//
//  Created by zzyong on 2021/5/7.
//

#import "TimerLeakVC.h"
#import "NSTimer+Extension.h"

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

- (IBAction)timerDeallocByBlock:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             repeats:YES
                                             forMode:NSRunLoopCommonModes
                                               block:^(NSTimeInterval time) {
        [weakSelf helloWorld];
    }];
}

- (IBAction)timerDeallocByWeakProxy:(UIButton *)sender {
    
}

- (IBAction)timerDeallocBySystemApi:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             repeats:YES
                                               block:^(NSTimer * _Nonnull timer) {
        [weakSelf helloWorld];
    }];
}

@end
