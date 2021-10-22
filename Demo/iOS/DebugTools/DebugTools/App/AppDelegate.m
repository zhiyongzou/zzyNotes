//
//  AppDelegate.m
//  DebugTools
//
//  Created by zzyong on 2021/10/14.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = UIColor.whiteColor;
#ifdef DEBUG
    [self debugToolInit];
#endif
    
    return YES;
}

#ifdef DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)debugToolInit {
    Class DebugTool = NSClassFromString(@"DebugTool");
    [DebugTool performSelector:NSSelectorFromString(@"toolInit")];
}

#pragma clang diagnostic pop
#endif


@end
