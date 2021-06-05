//
//  TimerTargetProxy.m
//  CommonTest
//
//  Created by zzyong on 2021/6/5.
//

#import "TimerTargetProxy.h"

@implementation TimerTargetProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _target;
}

@end
