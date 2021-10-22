//
//  NSObject+MLWhiteList.m
//  DebugTools
//
//  Created by zzyong on 2021/10/22.
//

#ifdef DEBUG

#import "NSObject+MLWhiteList.h"
#import <NSObject+MemoryLeak.h>

@implementation NSObject (MLWhiteList)

+ (void)load {
    [self swizzleSEL:@selector(willDealloc) withSEL:@selector(dt_willDealloc)];
}

- (BOOL)dt_willDealloc {
    NSString *clsName = NSStringFromClass(self.class);
    if ([clsName hasPrefix:@"FLEX"]) {
        NSLog(@"MLWhiteListClass: %@", clsName);
        return NO;
    }
    return [self dt_willDealloc];
}

@end

#endif
