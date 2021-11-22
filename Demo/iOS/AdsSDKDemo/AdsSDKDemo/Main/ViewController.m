//
//  ViewController.m
//  AdsSDKDemo
//
//  Created by zzyong on 2021/11/6.
//

#import "ViewController.h"
#import <AdsSDK/ADImageLoader.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADImageLoader *load = [ADImageLoader new];
    [load ad_setImageWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
}


@end
