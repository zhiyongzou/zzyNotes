//
//  main.m
//  AppLaunch
//
//  Created by zzyong on 2021/8/31.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

CFAbsoluteTime kAppStartTimeAfterMain;

int main(int argc, char * argv[]) {
    
    NSLog(@"Pre Main Time: %@", @([[NSDate date] timeIntervalSince1970] - [AppDelegate.class processStartTime] / 1000));
    kAppStartTimeAfterMain = CFAbsoluteTimeGetCurrent();
    
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
