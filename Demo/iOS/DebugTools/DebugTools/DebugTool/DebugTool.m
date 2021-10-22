//
//  DebugTool.m
//  DebugTools
//
//  Created by zzyong on 2021/10/22.
//

#ifdef DEBUG

#import <FLEX.h>
#import "DebugTool.h"
#import "FPSLabel.h"
#import "DTWindow.h"
#import <NSObject+MemoryLeak.h>

static FPSLabel *_fpsLabel;
static DTWindow *_flexWindow;
static DTWindow *_fpsWindow;

@interface DebugTool ()

@property (nonatomic, class, readonly) FPSLabel *fpsLabel;
@property (nonatomic, class, readonly) DTWindow *flexWindow;
@property (nonatomic, class, readonly) DTWindow *fpsWindow;

@end

@implementation DebugTool

#pragma mark - Public

+ (void)toolInit {
    // FLEX
    [self setupFlex];
    
    // FPS CPU Memory
    [self setupFps];
    
    // Memory Leak white list
    [self setupMLWhiteListClass];
}

#pragma mark - Private

+ (void)setupMLWhiteListClass {
    // Memory leak white list
//    [self addClassNamesToWhitelist:@[
//        @"DebugTool"
//    ]];
}

+ (void)setupFps {
    self.fpsLabel.frame = self.fpsWindow.bounds;
    [self.fpsWindow addSubview:self.fpsLabel];
}

+ (void)setupFlex {
    UIButton *flexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [flexBtn addTarget:self
                action:@selector(flexButtonDidClick)
      forControlEvents:UIControlEventTouchUpInside];
    flexBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [flexBtn setTitle:@"FLEX" forState:UIControlStateNormal];
    [flexBtn setTitleColor:[UIColor blueColor]
                  forState:UIControlStateNormal];
    flexBtn.frame = self.flexWindow.bounds;
    [self.flexWindow addSubview:flexBtn];
}

#pragma mark - Actions

+ (void)flexButtonDidClick {
    [[FLEXManager sharedManager] showExplorer];
}

#pragma mark - Setter/Getter

+ (FPSLabel *)fpsLabel {
    if (!_fpsLabel) {
        _fpsLabel = [FPSLabel new];
    }
    return _fpsLabel;
}

+ (DTWindow *)flexWindow {
    if (!_flexWindow) {
        _flexWindow = [DTWindow new];
        _flexWindow.backgroundColor = UIColor.clearColor;
        _flexWindow.windowLevel = UIWindowLevelStatusBar + 2;
        _flexWindow.rootViewController = [UIViewController new];
        CGFloat flexY = CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
        CGFloat flexW = 30;
        CGFloat flexX = ([UIScreen mainScreen].bounds.size.width - flexW) * 0.5;
        _flexWindow.frame = CGRectMake(flexX, flexY, flexW, 13);
        _flexWindow.hidden = NO;
    }
    return _flexWindow;
}

+ (DTWindow *)fpsWindow {
    if (!_fpsWindow) {
        _fpsWindow = [DTWindow new];
        _fpsWindow.clipsToBounds = NO;
        _fpsWindow.userInteractionEnabled = NO;
        _fpsWindow.backgroundColor = UIColor.clearColor;
        _fpsWindow.windowLevel = UIWindowLevelStatusBar + 1;
        _fpsWindow.rootViewController = [UIViewController new];
        CGFloat fpsY = CGRectGetMinY(self.flexWindow.frame);
        _fpsWindow.frame = CGRectMake(10, fpsY, 0, 15);
        _fpsWindow.hidden = NO;
    }
    return _fpsWindow;
}

@end

#endif

