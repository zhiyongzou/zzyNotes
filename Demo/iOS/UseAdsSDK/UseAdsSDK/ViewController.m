//
//  ViewController.m
//  UseAdsSDK
//
//  Created by zzyong on 2021/11/7.
//

#import "ViewController.h"
#import <AdsSDK/ADImageLoader.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ADImageLoader new] ad_setImageWithURL:[NSURL URLWithString:@"huhuhu"]];
    // Do any additional setup after loading the view.
}


@end
