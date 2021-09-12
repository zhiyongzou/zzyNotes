//
//  GCDTestVC.m
//  CommonTest
//
//  Created by zzyong on 2021/7/4.
//

#import "GCDTestVC.h"
#import "CTOperation.h"

@interface GCDTestVC ()

@end

@implementation GCDTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    CTOperation *operation = [[CTOperation alloc] init];
    [queue  addOperation:operation];
}

- (IBAction)setQueuePriority:(UIButton *)sender {
    // specify DISPATCH_QUEUE_SERIAL (or NULL) to create a serial queue or specify DISPATCH_QUEUE_CONCURRENT to create a concurrent queue
    dispatch_queue_t myQueue = dispatch_queue_create("my.queue", NULL);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    // 更改队列的优先级
    dispatch_set_target_queue(myQueue, globalQueue);
}

- (IBAction)commitSyncTaskToConcurrentQueue:(UIButton *)sender {
    dispatch_queue_t queue = dispatch_queue_create("CONCURRENT", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_sync(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

- (IBAction)commitSyncTaskToSerialQueue:(UIButton *)sender {
    dispatch_queue_t queue = dispatch_queue_create("SERIAL", NULL);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2");
        // __DISPATCH_WAIT_FOR_QUEUE__ ()
        dispatch_sync(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

@end

