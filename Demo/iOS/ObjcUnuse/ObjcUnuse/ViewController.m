//
//  ViewController.m
//  ObjcUnuse
//
//  Created by zzyong on 2021/10/30.
//

#import "ViewController.h"
#import "MainViewController.h"
#import "GameViewController.h"

@interface ViewController ()

@property (nonatomic, strong) MainViewController *mianVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mianVC = [MainViewController new];
    [self unuseMethod];
}

- (void)unuseMethod {
    
}

- (void)unuseMethod_2 {
    
}

@end
