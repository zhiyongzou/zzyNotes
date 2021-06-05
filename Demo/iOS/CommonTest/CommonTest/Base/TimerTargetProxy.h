//
//  TimerTargetProxy.h
//  CommonTest
//
//  Created by zzyong on 2021/6/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerTargetProxy : NSProxy

@property (nonatomic, weak, readonly, nullable) id target;

- (instancetype)initWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
