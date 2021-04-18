//
//  YYCopyLabel.m
//  YYCopyLabelDemo
//
//  Created by zzyong on 2019/11/4.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "YYCopyLabel.h"

@interface YYCopyLabel ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGR;

@end

@implementation YYCopyLabel

- (void)setCopyEnabled:(BOOL)copyEnabled
{
    _copyEnabled = copyEnabled;
    
    // 确保 UILabel 可交互
    self.userInteractionEnabled = copyEnabled;
    
    if (copyEnabled && !self.longPressGR) {
        self.longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(handleLongPressGesture:)];
        [self addGestureRecognizer:self.longPressGR];
    }
    
    if (self.longPressGR) {
        self.longPressGR.enabled = copyEnabled;
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGR
{
    if (longPressGR.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}

#pragma mark - UIMenuController

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    // 自定义响应UIMenuItem Action，例如你可以过滤掉多余的系统自带功能（剪切，选择等），只保留复制功能。
    return (action == @selector(copy:));
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.text];
}

@end
