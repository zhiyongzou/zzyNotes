//
//  NSTimer+Extension.h
//  CommonTest
//
//  Created by zzyong on 2021/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Extension)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                    repeats:(BOOL)repeats
                                    forMode:(NSRunLoopMode)mode
                                      block:(void(^)(NSTimeInterval time))block;

@end

NS_ASSUME_NONNULL_END
