//
//  ViewController.m
//  AppLaunch
//
//  Created by zzyong on 2021/8/31.
//

#import "ViewController.h"

extern CFAbsoluteTime kAppStartTimeAfterMain;

@interface ViewController ()

@end

@implementation ViewController

+ (void)load {
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [NSThread sleepForTimeInterval:2];
    
    NSLog(@"After Mian: %@", @(CFAbsoluteTimeGetCurrent() - kAppStartTimeAfterMain));
}

@end
