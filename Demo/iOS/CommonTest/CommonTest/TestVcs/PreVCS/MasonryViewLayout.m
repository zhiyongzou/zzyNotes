//
//  MasonryViewLayout.m
//  CommonTest
//
//  Created by zzyong on 2021/5/16.
//

#import "MasonryViewLayout.h"

@interface MasonryViewLayout ()

@property (nonatomic, assign) CGFloat interItemSpacing;
@property (nonatomic, assign) NSUInteger numuberOfColumns;

@end

@implementation MasonryViewLayout

- (void)prepareLayout {
    
    [super prepareLayout];
    
    CGFloat fullWidth = self.collectionView.frame.size.width;
    
    
}

@end
