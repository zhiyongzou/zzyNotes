//
//  LockTestVC.m
//  CommonTest
//
//  Created by zzyong on 2021/7/3.
//
//

/**
 死锁的四个必要条件
 1. 互斥条件：指进程对所分配到的资源进行排它性使用，即在一段时间内某资源只由一个进程占用。如果此时还有其它进程请求资源，则请求者只能等待，直至占有资源的进程用毕释放。
 2. 请求与保持条件：指进程已经保持至少一个资源，但又提出了新的资源请求，而该资源已被其它进程占有，此时请求进程阻塞，但又对自己已获得的其它资源保持不放。
 3. 不剥夺条件：指进程已获得的资源，在未使用完之前，不能被剥夺，只能在使用完时由自己释放。
 4.循环等待条件：若干进程之间形成一种头尾相接的循环等待资源关系
 
 */

#import "LockTestVC.h"

@interface LockTestVC ()

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSRecursiveLock *recursiveLock;

@end

@implementation LockTestVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.lock = [NSLock new];
    self.recursiveLock = [NSRecursiveLock new];
}


- (IBAction)clickRecurrsiveLock:(UIButton *)sender {
    
    [self.recursiveLock lock];
    
    [self.recursiveLock lock];
    
    NSLog(@"%s", __func__);
    
    [self.recursiveLock unlock];
    
    [self.recursiveLock unlock];

}

- (IBAction)clickSynchronized:(UIButton *)sender {
    
    @synchronized (self) {
        @synchronized (self) {
            NSLog(@"%s", __func__);
        }
    }
}

- (IBAction)clickLock:(UIButton *)sender {
    
    // 嵌套会死锁
//    [_lock lock];
    
    [_lock lock];
    
    NSLog(@"%s", __func__);
    
    [_lock unlock];
    
//    [_lock unlock];
}

@end
