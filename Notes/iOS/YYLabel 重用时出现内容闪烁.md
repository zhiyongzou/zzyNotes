# YYLabel 重用时出现内容闪烁

## 原因
[YYLabel](https://github.com/ibireme/YYText) 为了有更好的用户体验在内容展示加了一个渐变动画。这个动画是由`contentsNeedFade`控制的（这里不讨论异步渲染的情况）。在没有点击的情况下`contentsNeedFade`是处于关闭状态的，如果触发内容点击操作，那么`contentsNeedFade` 则会被打开。此时 YYLable 被重用的话就会出现内容 “**闪烁**” 的问题（闪烁其实就是这个渐变动画）。

作者给开发者一个关闭这个动画的属性`fadeOnHighlight`，只要设置为`NO`即可避免重用的闪现问题。不幸的是在用户触摸时取消触摸事件（即触发：`touchesCancelled:withEvent:`）的情况下依然会出现闪现问题。这是因为在`_endTouch`方法里面的 `_removeHighlightAnimated` 是直接写死 YES 的，这导致了`contentsNeedFade` 被迫打开，最终造成了重用闪现的问题。具体源码如下：

```objc
// YYLabel.m
- (void)_endTouch {
    [self _endLongPressTimer];
    [self _removeHighlightAnimated:YES];
    _state.trackingTouch = NO;
}
```

## 解决
解决这问题也很简单，代码如下：

```objc
// YYLabel.m 
- (void)_endTouch {
    [self _endLongPressTimer];
    [self _removeHighlightAnimated:_fadeOnHighlight];
    _state.trackingTouch = NO;
}
```

本人最近也提交了[Pull requests](https://github.com/ibireme/YYText/pull/917)

## 测试 Demo: [YYLabelFadeBug](https://github.com/zhiyongzou/MyDemos/tree/master/YYLabelFadeBug)

### 闪现场景 1

1. 注释 `//_contentLabel.fadeOnHighlight = NO;` 触发点击
2. 滑动列表即可出现内容闪现问题

### 闪现场景 2

1. 取消注释 `_contentLabel.fadeOnHighlight = NO;`
2. 先点击内容，然后手指往下滑触发点击取消
3. 滑动列表即可出现内容闪现问题


## 更新
由于房间公屏增加了长按@人功能，所以使用了 YYLabel 的长按功能。意想不到的是 YYLabel 重用时也出现内容闪现问题。原因跟上述一样，所以修复方式相同。具体修复如下

```objc
- (void)_trackDidLongPress {
    [self _endLongPressTimer];
    if (_state.hasLongPressAction && _textLongPressAction) {
        NSRange range = NSMakeRange(NSNotFound, 0);
        CGRect rect = CGRectNull;
        CGPoint point = [self _convertPointToLayout:_touchBeganPoint];
        YYTextRange *textRange = [self._innerLayout textRangeAtPoint:point];
        CGRect textRect = [self._innerLayout rectForRange:textRange];
        textRect = [self _convertRectFromLayout:textRect];
        if (textRange) {
            range = textRange.asRange;
            rect = textRect;
        }
        _textLongPressAction(self, _innerText, range, rect);
    }
    if (_highlight) {
        YYTextAction longPressAction = _highlight.longPressAction ? _highlight.longPressAction : _highlightLongPressAction;
        if (longPressAction) {
            YYTextPosition *start = [YYTextPosition positionWithOffset:_highlightRange.location];
            YYTextPosition *end = [YYTextPosition positionWithOffset:_highlightRange.location + _highlightRange.length affinity:YYTextAffinityBackward];
            YYTextRange *range = [YYTextRange rangeWithStart:start end:end];
            CGRect rect = [self._innerLayout rectForRange:range];
            rect = [self _convertRectFromLayout:rect];
            longPressAction(self, _innerText, _highlightRange, rect);
            // [self _removeHighlightAnimated:YES];
            // 修复如下
            [self _removeHighlightAnimated:_fadeOnHighlight];
            _state.trackingTouch = NO;
        }
    }
}
```