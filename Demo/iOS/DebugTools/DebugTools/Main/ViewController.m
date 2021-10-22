//
//  ViewController.m
//  DebugTools
//
//  Created by zzyong on 2021/10/14.
//

#import "ViewController.h"
#import "MLTestVC.h"

@implementation ViewController

- (IBAction)didMLButtonClick:(UIButton *)sender {
    MLTestVC *vc = [MLTestVC new];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
