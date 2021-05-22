//
//  ShiftOperatorVC.m
//  CommonTest
//
//  Created by zzyong on 2021/5/22.
//

#import "ShiftOperatorVC.h"

@interface ShiftOperatorVC ()

@end

@implementation ShiftOperatorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        int a = 1, b = 2;
        int c = a | b;
        NSLog(@"%d", c);
    }
    
    {
        int a = 1, b = 2;
        int c = a & b;
        NSLog(@"%d", c);
    }
    
    {
        // 异或，相同为 0，不同为 1
        int a = 1, b = 2;
        int c = a ^ b;
        NSLog(@"%d", c);
    }
    
    {
        unsigned int a = 1;
        unsigned int b = ~a;
        NSLog(@"%u", b);
    }
    
    {
        int a = 1;
        int b = a << 1;
        NSLog(@"%d", b);
    }
    
    {
        int a = -2;
        int b = a >> 1;
        NSLog(@"%d", b);
    }
    
    {
        // 当位移操作数是负数时，标准说明这类位移是未定义的，由编译器决定
        int a = 1;
        int b = a << -1;
        NSLog(@"%d", b);
    }
}

@end
