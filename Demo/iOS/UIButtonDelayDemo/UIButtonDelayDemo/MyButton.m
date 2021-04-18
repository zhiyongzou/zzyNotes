//
//  MyButton.m
//  UIButtonDelayDemo
//
//  Created by zzyong on 2019/11/8.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"%s", __func__);
    
    return [super hitTest:point withEvent:event];
}

@end
