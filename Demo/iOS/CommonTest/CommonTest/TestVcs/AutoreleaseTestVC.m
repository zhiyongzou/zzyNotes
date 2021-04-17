//
//  AutoreleaseTestVC.m
//  CommonTest
//
//  Created by zzyong on 2021/4/14.
//

#import "AutoreleaseTestVC.h"
#import "UIBlockObserver.h"

@interface AutoreleaseTestVC ()

@property (nonatomic, strong) UIBlockObserver *uiBlockObserver;

@end

@implementation AutoreleaseTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.uiBlockObserver = [UIBlockObserver new];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
