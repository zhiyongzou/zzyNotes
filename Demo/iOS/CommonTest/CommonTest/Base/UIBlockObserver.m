//
//  UIBlockObserver.m
//  CommonTest
//
//  Created by zzyong on 2021/4/14.
//

#import "UIBlockObserver.h"
#import <sys/time.h>

static BOOL _runFlag;
static struct timeval _runTime;

@interface UIBlockObserver ()

@property (nonatomic, assign) CFRunLoopObserverRef beginObserver;
@property (nonatomic, assign) CFRunLoopObserverRef endObserver;

@end

@implementation UIBlockObserver

- (void)dealloc {
    NSRunLoop *curRunLoop = [NSRunLoop currentRunLoop];
    
    CFRunLoopRef runloop = [curRunLoop getCFRunLoop];
    CFRunLoopRemoveObserver(runloop, _beginObserver, kCFRunLoopCommonModes);
    CFRunLoopRemoveObserver(runloop, _endObserver, kCFRunLoopCommonModes);
    
    CFRelease(_beginObserver);
    CFRelease(_endObserver);
}

- (instancetype)init {
    if (self = [super init]) {
        [self addRunLoopObserver];
    }
    return self;
}

- (void)addRunLoopObserver {
    NSRunLoop *curRunLoop = [NSRunLoop currentRunLoop];
    
    CFRunLoopObserverRef beginObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, LONG_MIN, &__observeRunLoopBeginCallback, NULL);
    CFRetain(beginObserver);
    
    CFRunLoopObserverRef endObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, LONG_MAX, &__observeRunLoopEndCallback, NULL);
    CFRetain(endObserver);
    
    CFRunLoopRef runloop = [curRunLoop getCFRunLoop];
    CFRunLoopAddObserver(runloop, beginObserver, kCFRunLoopCommonModes);
    CFRunLoopAddObserver(runloop, endObserver, kCFRunLoopCommonModes);
    
    _beginObserver = beginObserver;
    _endObserver = endObserver;
}

#pragma mark - Callback

/**
 kCFRunLoopEntry = (1UL << 0),
 kCFRunLoopBeforeTimers = (1UL << 1),
 kCFRunLoopBeforeSources = (1UL << 2),
 kCFRunLoopBeforeWaiting = (1UL << 5),
 kCFRunLoopAfterWaiting = (1UL << 6),
 kCFRunLoopExit = (1UL << 7),
 kCFRunLoopAllActivities = 0x0FFFFFFFU
 */

void __observeRunLoopBeginCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            _runFlag = YES;
            NSLog(@"kCFRunLoopEntry");
            break;
            
        case kCFRunLoopBeforeTimers:
            if (_runFlag == NO) {
                gettimeofday(&_runTime, NULL);
            }
            _runFlag = YES;
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
            
        case kCFRunLoopBeforeSources:
            if (_runFlag == NO) {
                gettimeofday(&_runTime, NULL);
            }
            _runFlag = YES;
            NSLog(@"kCFRunLoopBeforeSources");
            break;
            
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
            
        case kCFRunLoopAfterWaiting:
            if (_runFlag == NO) {
                gettimeofday(&_runTime, NULL);
            }
            _runFlag = YES;
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
            
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
            
        case kCFRunLoopAllActivities:
            NSLog(@"kCFRunLoopAllActivities");
            break;
            
        default:
            break;
    }
}

void __observeRunLoopEndCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopBeforeWaiting:
            gettimeofday(&_runTime, NULL);
            _runFlag = NO;
            break;
            
        case kCFRunLoopExit:
            _runFlag = NO;
            break;
            
        case kCFRunLoopAllActivities:
            break;
            
        default:
            break;
    }
}

#pragma mark - Getter/Setter

+ (BOOL)runFlag {
    return _runFlag;
}

+ (struct timeval)runTime {
    return _runTime;
}


@end
