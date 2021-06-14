//
//  iOS11AdaptVC.m
//  CommonTest
//
//  Created by zzyong on 2021/6/14.
//

#import "iOS11AdaptVC.h"

@interface iOS11AdaptVC ()

@end

@implementation iOS11AdaptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [self cancleButtonItem];
}

#pragma mark - UIBarButtonItem

- (UIBarButtonItem *)cancleButtonItem {
    UIBarButtonItem *cancleItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onCancleBarButtonItemClick:)];
    NSDictionary *textAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                     NSForegroundColorAttributeName : [UIColor blackColor]
                                     };
    [cancleItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    // 如果不设置，Highlighted 的文本属性则为系统默认属性。文本高亮颜色为系统蓝色
//    [cancleItem setTitleTextAttributes:textAttributes forState:UIControlStateHighlighted];
    
    return cancleItem;
}

- (void)onCancleBarButtonItemClick:(UIBarButtonItem *)item {
    NSLog(@"%s", __func__);
}

@end
