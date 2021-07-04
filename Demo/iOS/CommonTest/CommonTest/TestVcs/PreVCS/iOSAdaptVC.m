//
//  iOSAdaptVC.m
//  CommonTest
//
//  Created by zzyong on 2021/6/14.
//

#import "iOSAdaptVC.h"
#import "UIColor+Extension.h"
#import "UIView+Frame.h"

@interface CTViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *button;

@end

@implementation CTViewCell

@end

@interface CTTitleView : UILabel

@end

@implementation CTTitleView

- (CGSize)intrinsicContentSize
{
    return UILayoutFittingExpandedSize;
}

@end

@interface iOSAdaptVC () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation iOSAdaptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [self cancleButtonItem];
    [self setupCollectionView];
    [self setupTitleView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = CGRectMake(10, 100, 100, 200);
}

#pragma mark - Title View

- (void)setupTitleView {
    CTTitleView *titleView = [CTTitleView new];
    titleView.backgroundColor = UIColor.lightGrayColor;
    titleView.text = @"自定义标题视图";
    titleView.frame = CGRectMake(0, 0, 100, 50);
    self.navigationItem.titleView = titleView;
}

#pragma mark - UICollectionView

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = CGSizeMake(45, 45);
    flowLayout.sectionHeadersPinToVisibleBounds = YES;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CTViewCell class] forCellWithReuseIdentifier:@"CTViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CTViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CTViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    if (cell.button == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"🔘" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cellButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        button.frame = cell.bounds;
        [cell addSubview:button];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.width, 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    view.backgroundColor = UIColor.orangeColor;
    return view;
}

- (void)cellButtonDidClick {
    NSLog(@"%s", __func__);
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
