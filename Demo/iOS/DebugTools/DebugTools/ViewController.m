//
//  ViewController.m
//  DebugTools
//
//  Created by zzyong on 2021/10/14.
//

#import "ViewController.h"
#import "FPSLabel.h"
#import <FLEX.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FPSLabel *fpsLabel = [[FPSLabel alloc] initWithFrame:CGRectMake(10, 100, 0, 15)];
    [self.view addSubview:fpsLabel];
    
    [self setupFlex];
}

// FLEX
- (void)setupFlex {
    CGFloat flexW = 30;
    CGFloat flexX = (CGRectGetWidth([UIScreen mainScreen].bounds) - flexW) * 0.5;
    UIButton *flexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [flexBtn addTarget:self action:@selector(flexButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    flexBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [flexBtn setTitle:@"FLEX" forState:UIControlStateNormal];
    [flexBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    flexBtn.frame = CGRectMake(flexX, 120, flexW, 10);
    [self.view addSubview:flexBtn];
}

- (void)flexButtonDidClick {
    [[FLEXManager sharedManager] showExplorer];
}

@end
