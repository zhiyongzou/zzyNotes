//
//  UIBlockObserver.h
//  CommonTest
//
//  Created by zzyong on 2021/4/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBlockObserver : NSObject

@property (nonatomic, readonly, class) BOOL runFlag;

@property (nonatomic, readonly, class) struct timeval runTime;

@end

NS_ASSUME_NONNULL_END
