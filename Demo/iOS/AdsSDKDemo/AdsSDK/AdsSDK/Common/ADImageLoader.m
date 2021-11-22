//
//  ADImageLoader.m
//  AdsSDK
//
//  Created by zzyong on 2021/11/6.
//

#import "ADImageLoader.h"
#import <SDWebImage.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ADImageLoader

- (void)ad_setImageWithURL:(nullable NSURL *)url {
    UIImageView *imageView = [UIImageView new];
    [imageView sd_setImageWithURL:url];
}

@end
