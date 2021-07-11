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
    
    id autoObj = [NSArray array];
    __weak id weakAuto = autoObj;
    autoObj = nil;
    NSLog(@"autoObj: %@", weakAuto);
    
    id obj = [[NSArray alloc] init];
    __weak id weakObj = obj;
    obj = nil;
    NSLog(@"obj: %@", weakObj);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (IBAction)clickRunLoopObserver:(UIButton *)sender {
    
    if (!self.uiBlockObserver) {
        self.uiBlockObserver = [UIBlockObserver new];
    }
}

@end
