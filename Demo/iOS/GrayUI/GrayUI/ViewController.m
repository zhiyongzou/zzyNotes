//
//  ViewController.m
//  GrayUI
//
//  Created by zzyong on 2022/12/10.
//

#import "ViewController.h"
#import "UIView+GrayMask.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *isSafe;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onValueChange:(UISwitch *)sender {
    if (_isSafe.isOn) {
        [self.view gm_safeSetGrayMask:sender.isOn];
    } else {
        [self.view gm_setGrayMask:sender.isOn];
    }
}

- (IBAction)onClearBg:(UISwitch *)sender {
    self.view.backgroundColor = sender.isOn ? UIColor.clearColor : UIColor.whiteColor;
}

@end
