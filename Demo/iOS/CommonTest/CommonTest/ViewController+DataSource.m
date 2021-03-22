//
//  ViewController+DataSource.m
//  CommonTest
//
//  Created by zzyong on 2021/3/22.
//

#import "VCModel.h"
#import "ViewController+DataSource.h"
#import "DeallocTestVC.h"

@implementation ViewController (DataSource)

- (void)setupTestList {
    
    VCModel *deallocTest = [VCModel new];
    deallocTest.title = @"Dealloc Test";
    deallocTest.targetVC = ^UIViewController * _Nonnull{
        return [DeallocTestVC new];
    };
    
    self.testList = @[deallocTest];
}

@end
