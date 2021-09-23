//
//  CategoryTestVC.m
//  CommonTest
//
//  Created by zzyong on 2021/9/23.
//

#import "CategoryTestVC.h"

@interface CategoryTestVC ()

@end

@implementation CategoryTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self sayHello];
}

/*
 输出内容取决于最后编译的那个分类，具体可查看 build phases
 */
- (void)sayHello {
    NSLog(@"%s", __func__);
}

@end
