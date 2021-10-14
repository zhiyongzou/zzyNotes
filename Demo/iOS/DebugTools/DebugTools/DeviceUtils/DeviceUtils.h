//
//  DeviceUtils.h
//  DebugTools
//
//  Created by zzyong on 2021/10/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceUtils : NSObject

+ (double)memoryFootprint;

+ (float)cpuUsage;

@end

NS_ASSUME_NONNULL_END
