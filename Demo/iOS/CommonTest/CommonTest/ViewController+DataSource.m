//
//  ViewController+DataSource.m
//  CommonTest
//
//  Created by zzyong on 2021/3/22.
//

#import "VCModel.h"
#import "ViewController+DataSource.h"
#import "DeallocTestVC.h"
#import "ConvertRectVC.h"
#import "AtomicTestVC.h"

@implementation ViewController (DataSource)

- (void)setupTestList {
    
    NSMutableArray *list = [NSMutableArray array];
    
    VCModel *atomicTest = [VCModel new];
    atomicTest.title = @"Atomic Test";
    atomicTest.targetVC = ^UIViewController * _Nonnull{
        return [AtomicTestVC new];
    };
    [list addObject:atomicTest];
    
    VCModel *deallocTest = [VCModel new];
    deallocTest.title = @"Dealloc Test";
    deallocTest.targetVC = ^UIViewController * _Nonnull{
        return [DeallocTestVC new];
    };
    [list addObject:deallocTest];
    
    VCModel *convertRectTest = [VCModel new];
    convertRectTest.title = @"Convert Rect Test";
    convertRectTest.targetVC = ^UIViewController * _Nonnull{
        return [ConvertRectVC new];
    };
    [list addObject:convertRectTest];
    
    self.testList = list;
}

@end
