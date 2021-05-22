//
//  ARCTestVC.m
//  CommonTest
//
//  Created by zzyong on 2021/4/17.
//

#import "ARCTestVC.h"

@interface ARCTestVC ()

@property (nonatomic, unsafe_unretained) id unsafeUnretained;

@end

@implementation ARCTestVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSObject __weak *obj = nil;
    {
        NSObject *obj2 = [NSObject new];
        obj = obj2;
        NSLog(@"A: %@", obj);
    }
    
    NSLog(@"B: %@", obj);
    
    
    
    {
        id obj = [NSObject new];
        // 隐式转换
        // void *p = obj; // Implicit conversion of Objective-C pointer type 'id' to C pointer type 'void *' requires a bridged cast
//        __unused void *p = obj;
    }
    
    {
        id obj = [NSObject new];
        void *p = (__bridge void *)(obj);
        __unused id obj2 = (__bridge id)(p);
    }
    
    {
        void *badAccess = nil;
        {
            id obj = [NSObject new];
            badAccess = (__bridge void *)(obj);
        }
    //    NSLog(@"%@", (__bridge id)badAccess); // EXC_BAD_ACCESS
    }

    {
        void *bridge_retained = nil;
        {
            id obj = [NSObject new];
            NSLog(@"bridge_retained: %@", obj);
            bridge_retained = (__bridge_retained void *)(obj);
        }
        NSLog(@"bridge_retained: %@", (__bridge id)bridge_retained);
        CFRelease(bridge_retained);
    }
    
    
    {
        id bridge_transfer = nil;
        {
            void *p = (__bridge_retained void *)([NSObject new]);
            NSLog(@"Before: %p", p);
            bridge_transfer = (__bridge_transfer id)(p);
        }
        NSLog(@"After: %@", bridge_transfer);
    }
    
    {
        __weak id bridge_leak = nil;
        {
            void *p = (__bridge_retained void *)([NSObject new]);
            NSLog(@"Before: %p", p);
            bridge_leak = (__bridge id)(p);
        }
        NSLog(@"After: %@", bridge_leak);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self unsafeTest];
}

- (void)unsafeTest {
    NSObject __unsafe_unretained *obj3 = nil;
    {
        NSObject *obj4 = [NSObject new];
        obj3 = obj4;
        NSLog(@"A: %@", obj3);
    }
    
    NSLog(@"B: %@", obj3);
}

@end
