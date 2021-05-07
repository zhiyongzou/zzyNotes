//
//  TimerLeakVC.m
//  CommonTest
//
//  Created by zzyong on 2021/5/7.
//

#import "TimerLeakVC.h"

@interface TimerLeakVC ()

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation TimerLeakVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    [_timer invalidate];
}

- (void)helloWorld {
    NSLog(@"Hello World!");
}

- (IBAction)timerLeak:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:weakSelf
                                                    selector:@selector(helloWorld)
                                                    userInfo:nil
                                                     repeats:YES];
    _timer = timer;
}

- (IBAction)timerDeallocByBlock:(UIButton *)sender {
    
}

- (IBAction)timerDeallocByWeakProxy:(UIButton *)sender {
    
}
@end
