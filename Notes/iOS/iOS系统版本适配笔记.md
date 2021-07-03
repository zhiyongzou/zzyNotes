# iOS 系统版本适配笔记

## iOS 14

## iOS 11

### [UICollectionView 的 VerticalScrollIndicator 被 SectionHeaderView 遮盖]()
* **原因：**iOS11 SectionHeaderView 的 zPosition = 1，iOS11 之前为 0

* **解决：**方案1可以在 delegate 方法`willDisplaySupplementaryView`中改变 zPosition（适用 iOS8 以上），方案 2 可以在 SectionHeaderView 中重写`didMoveToWindow`方法。

```objc
// after iOS8
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if (@available(iOS 11.0, *)) {
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            view.layer.zPosition = 0;
        }
    }
}
```

```objc
// All
- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if (@available(iOS 11.0, *)) {
        self.layer.zPosition = 0;
    }
}
```

### [UIToolbar上 的 subview 无法响应事件]()
**原因：** UIToolbar 的 Top subview 是`_UIToolbarContentView`，其可以响应事件。所以导致 _UIToolbarContentView 下面的视图无法响应事件，如下图所示的`UIButton`。

**解决：** 

**方案1：**UIToolbar 添加 subview 之前调用：`layoutIfNeeded`方法。

```objc
// 1. UIToolbar视图层级树

// before iOS10
<UIToolbar>
   | <_UIBarBackground>
   |    | <UIImageView>
   |    | <UIVisualEffectView>
   | <UIButton>

//after iOS10   
<UIToolbar>
   | <_UIBarBackground>
   |    | <UIImageView>
   |    | <UIVisualEffectView>
   | <UIButton>
   | <_UIToolbarContentView>
   |    | <_UIButtonBarStackView>
```

**方案2：**如果使用 UIToolbar 只是为了其高斯模糊效果，在 iOS9 以后可以使用`UIBlurEffect`实现相同效果。

**注意：**

> 在iOS10中，如果 UIVisualEffectView 的 superview 有设置 mask，那么则不会有高斯模糊效果。

[UIBlurEffect 测试 Demo](https://github.com/zhiyongzou/MyDemos/tree/master/VisualEffectiOS10Demo)

```objc
// UIBlurEffect 实现高斯模糊
UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect: blurEffect];
[customView addSubview:effectView];   
```

### [UIBarButtonItem 高亮状态下的字体与普通状态不一致]()
**原因：**如果 Highlighted 未设 TitleTextAttributes，系统不再默认将 Normal 状态下的文本属性赋值给Highlighted

**解决：**必须手动设置 Highlighted 下的 TitleTextAttributes

```objc
- (UIBarButtonItem *)cancleButtonItem
{
    UIBarButtonItem *cancleItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onCancleBarButtonItemClick:)];
    NSDictionary *textAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                     NSForegroundColorAttributeName : [UIColor blackColor]
                                     };
    [cancleItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    // 如果不设置，Highlighted 的文本属性则为系统默认属性。
    [cancleItem setTitleTextAttributes:textAttributes forState:UIControlStateHighlighted];
    
    return cancleItem;
}

```

### [navigationBar 自定义 titleView 设置 Frame 无效]()
**原因：**titleView 在 iOS11 后支持 Autolayout，假如自定义 titleView 中的 subviews 是采用 Autolayout，那么 titleView 其会根据 subviews 自适应尺寸大小来设置, 忽略设置的 Frame

**解决：**

**方案1：**自定义 titleView 中重写 `- intrinsicContentSize`方法

```objc 
// override
- (CGSize)intrinsicContentSize
{
    return UILayoutFittingExpandedSize;
}
```

**方案2：**自定义 titleView 的 subviews 采用代码布局

```objc
// frame
-(void)layoutSubviews
{
    [super layoutSubviews];
    // 计算 subviews 位置
}
```