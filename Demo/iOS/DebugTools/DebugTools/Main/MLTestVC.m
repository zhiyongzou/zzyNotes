//
//  MLTestVC.m
//  DebugTools
//
//  Created by zzyong on 2021/10/22.
//

#import "MLTestVC.h"

typedef void(^MLBlock)(void);

@interface MLTestVC ()

@property (nonatomic, strong) MLBlock mlBlock;
@property (nonatomic, strong) NSString *name;

@end

@implementation MLTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemOrangeColor;
    MLBlock mlBlock = ^{
        self.name = @"MLTestVC1";
    };
    self.mlBlock = mlBlock;
    self.mlBlock();
    
    MLTestVC *vc = [MLTestVC new];
    MLBlock mlBlock2 = ^{
        vc.title = @"MLTestVC2";
    };
    [self setVC:vc block:mlBlock2];
    
    MLTestVC *vc1 = [MLTestVC new];
    vc1.mlBlock = ^{
        vc1.title = @"MLTestVC3";
    };
    vc1.mlBlock();
}

- (void)setVC:(MLTestVC *)vc block:(MLBlock)block {
    vc.mlBlock = block;
    vc.mlBlock();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
