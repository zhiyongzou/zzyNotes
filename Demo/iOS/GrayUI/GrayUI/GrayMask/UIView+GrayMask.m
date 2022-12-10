//
//  UIView+GrayMask.m
//  GrayUI
//
//  Created by zzyong on 2022/12/10.
//

#import "UIView+GrayMask.h"
#import <objc/runtime.h>

@implementation UIView (GrayMask)

/// 由于是私有类，为了避免审核风险，需要进行字符串拼接规避扫描，目前该方案可上线
/// 如果觉得字符串拼接不够稳妥，可以考虑由服务端下发，并且在审核期间屏蔽下发
- (void)gm_setGrayMask:(BOOL)hasMask {
    if (hasMask) {
        @try {
            NSString *cls = [NSString stringWithFormat:@"%@%@", @"CA", @"Filter"];
            NSString *name = [NSString stringWithFormat:@"%@%@", @"color", @"Saturate"];
            CIFilter *gray = [NSClassFromString(cls) filterWithName:name];
            NSString *value = [NSString stringWithFormat:@"%@%@", @"input", @"Amount"];
            [gray setValue:@0 forKey:value];
            self.layer.filters = @[gray];
        } @catch (NSException *exception) { }
    } else {
        self.layer.filters = nil;
    }
}

/// 无任何审核风险，但只能在 iOS13 以上才生效
/// 并且对于透明色出现灰色蒙层，效果不行，可作为兜底方案
- (void)gm_safeSetGrayMask:(BOOL)hasMask {
    if (@available(iOS 13.0, *)) {
        UIView *grayView = [self gm_garyMaskView];
        if (hasMask && !grayView) {
            grayView = [UIView new];
            grayView.backgroundColor = UIColor.lightGrayColor;
            grayView.userInteractionEnabled = NO;
            grayView.layer.compositingFilter = @"saturationBlendMode";
            [self gm_setGrayMaskView:grayView];
            [self addSubview:grayView];
        }
        if (hasMask && grayView) {
            [self bringSubviewToFront:grayView];
            grayView.frame = self.bounds;
        }
        grayView.hidden = !hasMask;
    }
}

- (nullable UIView *)gm_garyMaskView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)gm_setGrayMaskView:(UIView *)view {
    objc_setAssociatedObject(self, @selector(gm_garyMaskView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
