//
//  LayoutFeedbackLoopsVC.m
//  CommonTest
//
//  Created by zzyong on 2021/3/17.
//

#import "LayoutFeedbackLoopsVC.h"

@interface LayoutFeedbackLoopsVC ()

@end

@implementation LayoutFeedbackLoopsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view setNeedsLayout];
}

@end
