//
//  ConvertRectVC.m
//  CommonTest
//
//  Created by zzyong on 2021/3/25.
//

#import "ConvertRectVC.h"

@interface ConvertRectVC ()

@property (nonatomic, strong) UILabel *redView;
@property (nonatomic, strong) UILabel *grayView;

@end

@implementation ConvertRectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    _redView = [UILabel new];
    _redView.text = @"redView";
    _redView.backgroundColor = UIColor.redColor;
    _redView.frame = CGRectMake(100, 200, 200, 200);
    [self.view addSubview:_redView];
    
    _grayView = [UILabel new];
    _grayView.text = @"grayView";
    _grayView.backgroundColor = UIColor.grayColor;
    _grayView.frame = CGRectMake(100, 100, 100, 100);
    [_redView addSubview:_grayView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"redView convert grayView's frame to self.view %@", NSStringFromCGRect([_redView convertRect:_grayView.frame toView:self.view]));
    NSLog(@"grayView convert grayView's bounds self.view %@", NSStringFromCGRect([_grayView convertRect:_grayView.bounds toView:self.view]));
    // NSLog(@"grayView convert grayView's frame to self.view %@", NSStringFromCGRect([_grayView convertRect:_grayView.frame toView:self.view]));
    
    NSLog(@"self.view convert grayView's frame from redView %@", NSStringFromCGRect([self.view convertRect:_grayView.frame fromView:_redView]));
    NSLog(@"self.view convert grayView's bounds from grayView %@", NSStringFromCGRect([self.view convertRect:_grayView.bounds fromView:_grayView]));
    
}

@end
