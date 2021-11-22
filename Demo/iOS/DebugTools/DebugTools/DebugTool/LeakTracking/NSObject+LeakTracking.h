//
//  NSObject+LeakTracking.h
//  DebugTools
//
//  Created by zzyong on 2021/11/22.
//

#ifdef DEBUG

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LeakTracking)

+ (void)registerTrackingClasses:(NSArray<Class>*)classes;

+ (void)ignoreTrackingClass:(Class)ignoreClass;

+ (void)startLeaksTracking;

+ (void)stopLeaksTrackingWithCompletion:(void(^)(NSDictionary* leaksObjects))completion;

+ (void)pauseLeaksTracking;

+ (void)resumeLeaksTracking;

+ (void)closeLeaksTracking:(BOOL)close;

@end

NS_ASSUME_NONNULL_END

#endif
