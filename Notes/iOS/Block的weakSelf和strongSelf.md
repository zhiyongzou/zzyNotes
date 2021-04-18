
# Block的weakSelf和strongSelf

```objc
// __weak 告诉 block 不要强引用 self，防止发生循环引用 
__weak typeof(self) weakSelf = self;

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    // 虽然加了判断，其实跟不加的效果一致
    if (weakSelf == nil) {
        return;
    }
    
    // 由于是弱引用，所以 weakSelf 随时都可能被释放。
    // 以下调用行为不确定，存在各种情况。可能都失败，或者都成功，或者部分成功
    [weakSelf doSomething];
    [weakSelf doSomethingElse];
});


dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    // 如果 weakSelf 未被释放， __strong 则保证 self 在 block 作用域不被释放
    __strong typeof(weakSelf) strongSelf = weakSelf;
    
    // 要么直接 return , 要么都会执行。调用行为确定
    if (strongSelf == nil) {
        return;
    }
    
    [strongSelf doSomething];
    [strongSelf doSomethingElse];
});

```

## 参考文档
[1. Block Implementation Specification](https://clang.llvm.org/docs/Block-ABI-Apple.html#block-escapes)

[2. I finally figured out weakSelf and strongSelf](https://dhoerl.wordpress.com/2013/04/23/i-finally-figured-out-weakself-and-strongself/)