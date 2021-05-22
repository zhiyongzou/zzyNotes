//
//  UIColor+Extension.m
//  CommonTest
//
//  Created by zzyong on 2021/5/16.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random()%255/255.0
                           green:arc4random()%255/255.0
                            blue:arc4random()%255/255.0 alpha:1];
}

@end
