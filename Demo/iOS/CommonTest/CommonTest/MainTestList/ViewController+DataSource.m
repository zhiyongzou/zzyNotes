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
#import "AutoreleaseTestVC.h"
#import "MRCTestVC.h"
#import "ARCTestVC.h"
#import "StringToIntTest.h"
#import "TimerLeakVC.h"
#import "GradientTestVC.h"
#import "MasonryLayoutVC.h"
#import "ShiftOperatorVC.h"
#import "iOSAdaptVC.h"
#import "BlurEffectTestVC.h"

@implementation ViewController (DataSource)

- (void)setupTestList {
    
    NSMutableArray *list = [NSMutableArray array];
    
    VCModel *blurEffec = [VCModel new];
    blurEffec.title = @"iOS10 UIBlurEffec Disable By Mask";
    blurEffec.targetVC = ^UIViewController * _Nonnull{
        return [BlurEffectTestVC new];
    };
    [list addObject:blurEffec];
    
    VCModel *ios11 = [VCModel new];
    ios11.title = @"iOS System Adapt";
    ios11.targetVC = ^UIViewController * _Nonnull{
        return [iOSAdaptVC new];
    };
    [list addObject:ios11];
    
    VCModel *gradient = [VCModel new];
    gradient.title = @"Gradient Test";
    gradient.targetVC = ^UIViewController * _Nonnull{
        return [GradientTestVC new];
    };
    [list addObject:gradient];
    
    VCModel *shiftOperator = [VCModel new];
    shiftOperator.title = @"Shift Operator";
    shiftOperator.targetVC = ^UIViewController * _Nonnull{
        return [ShiftOperatorVC new];
    };
    [list addObject:shiftOperator];
    
    VCModel *masonryLayout = [VCModel new];
    masonryLayout.title = @"Masonry Layout";
    masonryLayout.targetVC = ^UIViewController * _Nonnull{
        return [MasonryLayoutVC new];
    };
    [list addObject:masonryLayout];
    
    VCModel *timerLeak = [VCModel new];
    timerLeak.title = @"Timer Leak Test";
    timerLeak.targetVC = ^UIViewController * _Nonnull{
        return [TimerLeakVC new];
    };
    [list addObject:timerLeak];
    
    VCModel *stringToIntTest = [VCModel new];
    stringToIntTest.title = @"StringToInt Test";
    stringToIntTest.targetVC = ^UIViewController * _Nonnull{
        return [StringToIntTest new];
    };
    [list addObject:stringToIntTest];
    
    VCModel *arcTest = [VCModel new];
    arcTest.title = @"ARC Test";
    arcTest.targetVC = ^UIViewController * _Nonnull{
        return [ARCTestVC new];
    };
    [list addObject:arcTest];
    
    VCModel *mrcTest = [VCModel new];
    mrcTest.title = @"MRC Test";
    mrcTest.targetVC = ^UIViewController * _Nonnull{
        return [MRCTestVC new];
    };
    [list addObject:mrcTest];
    
    VCModel *autoreleaseTest = [VCModel new];
    autoreleaseTest.title = @"Autorelease Test";
    autoreleaseTest.targetVC = ^UIViewController * _Nonnull{
        return [AutoreleaseTestVC new];
    };
    [list addObject:autoreleaseTest];
    
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
