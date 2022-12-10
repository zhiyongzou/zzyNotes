//
//  UIView+GrayMask.h
//  GrayUI
//
//  Created by zzyong on 2022/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GrayMask)

- (void)gm_setGrayMask:(BOOL)hasMask;

- (void)gm_safeSetGrayMask:(BOOL)hasMask;

@end

NS_ASSUME_NONNULL_END
