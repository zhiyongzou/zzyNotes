## 内存泄漏 Try Catch

obj 可以正常释放么？

```objc
@try {
    MyObject *obj = [MyObject new];
    [obj description];

    @throw [NSException exceptionWithName:@"ML" reason:@"Memory Leak" userInfo:@{}];
} @catch (NSException *exception) {
    NSLog(@"%@", exception);
} @finally {
    NSLog(@"finally call");
}
```

myObject 可以正常释放么？

```objc
{
    ViewController *vc = [ViewController new];
    vc.myObject = [MyObject new];

    @try {
        [vc.myObject removeObserver:self forKeyPath:@"Unknown name"];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    } @finally {
        NSLog(@"finally call");
    }
}
```

运行结果：obj 和 myObject 都不能正常释放。这是为什么呢？在 [Objective-C Automatic Reference Counting (ARC)](http://clang.llvm.org/docs/AutomaticReferenceCounting.html#exceptions) 中有以下说明：
> By default in Objective C, ARC is not exception-safe for normal releases:
> 
> 1. It does not end the lifetime of __strong variables when their scopes are abnormally terminated by an exception.
> 2. It does not perform releases which would occur at the end of a full-expression if that full-expression throws an exception.

- obj 对象默认是强引用的，由于在作用域结束前发生异常，所以无法释放。满足第一点 
- 因为 `[vc.myObject removeObserver:self forKeyPath:@"Unknown name"]` 表达式引发异常，所以 myObject 的 release 没有调用，导致 myObject 无法释放。满足第二点

解决：

- 将 `@try` 中的局部变量挪到外面创建即可
- 第二种泄漏类型则需要在`@try`代码对应源文件设置 `-fobjc-arc-exceptions` 编译器标识符，这个编译器标识符同样适用于第一种情况

