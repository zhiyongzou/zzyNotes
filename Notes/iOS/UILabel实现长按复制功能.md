## UILabel实现长按复制功能

### 1. 创建 UILabel 的子类
```objc
@interface YYCopyLabel : UILabel

@property (nonatomic, assign) BOOL copyEnabled;

@end
```
### 2. 增加 UILongPressGestureRecognizer 手势
```objc
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
```
### 3. 实现 UIMenuController 的相关协议

``` objc
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

```

### 4. 使用UIMenuController出现UIViewControllerHierarchyInconsistency crash

* **Exception log:** `UICompatibilityInputViewController`的父控制器必须是`UIInputWindowController`，不能是其他自定义的控制器。

```bash
'UIViewControllerHierarchyInconsistency', reason: 'child view controller:<UICompatibilityInputViewController: 0x7f9b37f00fa0> should have parent view controller:<ClipboardLabelViewController: 0x7f9b3b009b90> but requested parent is:<UIInputWindowController: 0x7f9b3801d400>'
```

* **崩溃原因：**调用UIMenuController控制器的视图层级树(view tree)存在命名为**inputView**的view。上面例子是因为ClipboardLabelViewController 定义了inputView。

```objc
@property (nonatomic, strong) UIView *inputView;
```

* **解决办法：**找出自定义**inputView**，修改其命名，例如你可以改成**myInputView**

### 5. [YYCopyLabelDemo](https://github.com/zhiyongzou/zzyNotes/blob/main/Demo/iOS/YYCopyLabelDemo)