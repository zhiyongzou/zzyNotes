//
//  ViewController.m
//  YYCopyLabelDemo
//
//  Created by zzyong on 2019/11/4.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "ViewController.h"
#import "YYCopyLabel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet YYCopyLabel *myCopyLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.myCopyLabel.copyEnabled = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

@end
