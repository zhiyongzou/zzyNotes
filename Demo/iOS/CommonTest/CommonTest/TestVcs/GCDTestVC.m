//
//  GCDTestVC.m
//  CommonTest
//
//  Created by zzyong on 2021/7/4.
//

#import "GCDTestVC.h"

@interface GCDTestVC ()

@end

@implementation GCDTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_queue_t myQueue = dispatch_queue_create("my.queue", NULL);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    // 更改队列的优先级
    dispatch_set_target_queue(myQueue, globalQueue);
}


@end
