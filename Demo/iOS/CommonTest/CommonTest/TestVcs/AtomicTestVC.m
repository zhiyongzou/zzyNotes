//
//  AtomicTestVC.m
//  CommonTest
//
//  Created by zzyong on 2021/3/30.
//

#import "AtomicTestVC.h"

@interface AtomicTestVC ()

@property (atomic, strong) NSObject *atomicObj;
@property (nonatomic, strong) NSObject *nonatomicObj;

@property (nonatomic, assign) NSInteger currentTicket;

@end

@implementation AtomicTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didClickAtomic:(UIButton *)sender {
    for (int idx = 0; idx < 10; idx++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.atomicObj = [NSObject new];
        });
    }
}

- (IBAction)didClickNonatomic:(UIButton *)sender {
    for (int idx = 0; idx < 10; idx++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.nonatomicObj = [NSObject new];
        });
    }
}

- (IBAction)saleTicket:(UIButton *)sender {
    
    if (self.currentTicket > 0) {
        return;
    }
    
    NSInteger ticket = 10;
    self.currentTicket = ticket;
    NSThread *salerA = [[NSThread alloc] initWithBlock:^{
        while (1) {
            if (self.currentTicket > 0) {
                self.currentTicket--;
                NSLog(@"salerA 卖出第 %@ 张票，余票：%@", @(ticket - self.currentTicket), @(self.currentTicket));
            } else {
                NSLog(@"salerA 票卖完了");
                break;
            }
        }
    }];
    [salerA start];
    
    NSThread *salerB = [[NSThread alloc] initWithBlock:^{
        while (1) {
            if (self.currentTicket > 0) {
                [NSThread sleepForTimeInterval:0.1];
                self.currentTicket--;
                NSLog(@"salerB 卖出第 %@ 张票，余票：%@", @(ticket - self.currentTicket), @(self.currentTicket));
            } else {
                NSLog(@"salerB 票卖完了");
                break;
            }
        }
    }];
    [salerB start];
}


@end
