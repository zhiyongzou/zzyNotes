//
//  ViewController.m
//  AppLaunch
//
//  Created by zzyong on 2021/8/31.
//

#import "ViewController.h"

extern CFAbsoluteTime kAppStartTimeAfterMain;

static int x __attribute__((used,section("__DATA,__mysection"))) = 4;
static int y __attribute__((used,section("__DATA,__mysection"))) = 10;
static int z __attribute__((used,section("__DATA,__mysection"))) = 22;

static void __attribute__((used,section("__DATA,__mysection"))) functionA(void) {

}

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
