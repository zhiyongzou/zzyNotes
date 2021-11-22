//
//  NSObject+LeakTracking.m
//  DebugTools
//
//  Created by zzyong on 2021/11/22.
//

#ifdef DEBUG

#import "JRSwizzle.h"
#import <UIKit/UIKit.h>
#import "NSObject+LeakTracking.h"

static const NSUInteger kMaxLeaksOtherObjectCount = 3;
static const NSUInteger kMaxLeaksUIViewObjectCount = 10;
static const NSUInteger kMaxLeaksUIViewControllerObjectCount = 1;

static BOOL isTracking = NO;
static BOOL isPausing = NO;
static BOOL isClosed = YES;
static NSMutableSet *trackingClasses = nil;
static NSMutableSet *ignoringClasses = nil;
static NSMutableDictionary *trackingObjects = nil;
static NSDictionary *objectLeaksCountConfig = nil;

@implementation NSObject (LeakTracking)

- (void)setupLeakTracking {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objectLeaksCountConfig = @{(id<NSCopying>)[UIView class]: @(kMaxLeaksUIViewObjectCount),
                                   (id<NSCopying>)[UIViewController class]: @(kMaxLeaksUIViewControllerObjectCount)};
    });
}

- (nullable instancetype)track_init {
    id instance = [self track_init];
    if (isTracking && !isPausing && trackingClasses.count > 0 && !isClosed) {
        Class belongClass = [self findBelongClassInRegisterClasses:instance];
        BOOL ignoreThisClass = [self shouldIgnoreInstance:instance];
        if (belongClass && !ignoreThisClass) {
            NSHashTable *objects = trackingObjects[belongClass];
            [objects addObject:instance];
        }
    }
    return instance;
}

+ (instancetype)lt_new {
    id obj = [self lt_new];
    if (isTracking && !isPausing && trackingClasses.count > 0 && !isClosed) {
        Class belongClass = [self findBelongClassInRegisterClasses:obj];
        BOOL ignoreThisClass = [self shouldIgnoreInstance:obj];
        if (belongClass && !ignoreThisClass) {
            NSHashTable *objects = trackingObjects[belongClass];
            [objects addObject:obj];
        }
    }
    return obj;
}

// 查找所属的基类是否在注册跟踪的集合中
- (Class)findBelongClassInRegisterClasses:(id)instance {
    Class belongClass = nil;
    for (Class registerClass in trackingClasses) {
        if ([instance isKindOfClass:registerClass]) {
            belongClass = registerClass;
            break;
        }
    }
    return belongClass;
}

// 忽略指定的类
- (BOOL)shouldIgnoreInstance:(id)instance {
    BOOL shouldIgnore = NO;
    if ([ignoringClasses containsObject:[instance class]]) {
        shouldIgnore = YES;
    }
    NSString *className = NSStringFromClass([instance class]);
    if ([className hasPrefix:@"UIKeyboard"] ||
        [className hasPrefix:@"UIInputWindowController"] ||
        [className hasPrefix:@"_UIRemoteInputViewController"] ||
        [className hasPrefix:@"_UIInteractiveHighlightEffectWindow"] ||
        [className hasPrefix:@"UICompatibilityInputViewController"] ||
        [className hasPrefix:@"UIApplicationRotationFollowingControllerNoTouches"]) {
        shouldIgnore = YES;
    }
    
    // 忽略UIViewController的对象，只关心其子类
    if ([instance isMemberOfClass:[UIViewController class]]) {
        shouldIgnore = YES;
    }
    
    return shouldIgnore;
}

+ (void)registerTrackingClasses:(NSArray<Class> *)classes {
    [self setupLeakTracking];
    
    [trackingClasses removeAllObjects];
    [trackingObjects removeAllObjects];
    if (classes.count > 0) {
        trackingClasses = [NSMutableSet set];
        trackingObjects = [NSMutableDictionary dictionary];
        for (Class cls in classes) {
            [trackingClasses addObject:cls];
            [trackingObjects setObject:[NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory] forKey:(id<NSCopying>)cls];
            [cls jr_swizzleMethod:@selector(init) withMethod:@selector(track_init) error:nil];
            [cls jr_swizzleClassMethod:@selector(new) withClassMethod:@selector(lt_new) error:nil];
        }
    }
}

+ (void)ignoreTrackingClass:(Class)ignoreClass {
    if (ignoringClasses == nil) {
        ignoringClasses = [NSMutableSet set];
    }
    [ignoringClasses addObject:ignoreClass];
}

+ (void)startLeaksTracking {
    isTracking = YES;
}

+ (void)stopLeaksTrackingWithCompletion:(void(^)(NSDictionary* leaksObjects))completion {
    isTracking = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion && trackingClasses.count > 0) {
            NSMutableDictionary *resultObjects = [NSMutableDictionary dictionaryWithCapacity:trackingClasses.count];
            for (Class cls in [trackingObjects.allKeys copy]) {
                NSHashTable *leaksObjects = [trackingObjects[cls] copy];
                NSUInteger leaksCount = 0;
                for (__unused id obj in leaksObjects.allObjects) {
                    leaksCount++;
                }
                NSUInteger maxLimitCount = [objectLeaksCountConfig[cls] unsignedIntegerValue] ?: kMaxLeaksOtherObjectCount;
                if (leaksCount >= maxLimitCount) {
                    NSLog(@"Leaks Objects: %@", leaksObjects);
                }
                NSAssert(leaksCount < maxLimitCount, @"Room objects may leak!");
                resultObjects[(id<NSCopying>)cls] = leaksObjects.allObjects;
                [cls jr_swizzleMethod:@selector(track_init) withMethod:@selector(init) error:nil];
                [cls jr_swizzleClassMethod:@selector(lt_new) withClassMethod:@selector(new) error:nil];
            }
            NSLog(@"All Leaks Objects: %@", resultObjects);
            completion(resultObjects);
        }
    });
    if (completion) {
        completion(nil);
    }
}

+ (void)pauseLeaksTracking {
    isPausing = YES;
}

+ (void)resumeLeaksTracking {
    isPausing = NO;
}

+ (void)closeLeaksTracking:(BOOL)close {
    isClosed = close;
}
@end

#endif
