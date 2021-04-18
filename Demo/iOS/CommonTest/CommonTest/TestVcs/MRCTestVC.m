//
//  MRCTestVC.m
//  CommonTest
//
//  Created by zzyong on 2021/4/17.
//

#import "MRCTestVC.h"

@interface MRCTestVC ()

@end

@implementation MRCTestVC

- (void)dealloc
{
    NSLog(@"%s %@", __FUNCTION__, self.title);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MRCTestVC";
    
    MRCTestVC *obj = [MRCTestVC new];
    obj.title = @"obj";
    [obj release];
    
    MRCTestVC *obj1 = [MRCTestVC new];
    obj1.title = @"obj-1";
    [obj1 autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
}

@end
