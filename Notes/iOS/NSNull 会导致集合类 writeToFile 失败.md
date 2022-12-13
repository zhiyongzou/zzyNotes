# NSNull 会导致集合类 writeToFile 失败

### NSDictionary 写入 NSNull 
有些坑没有跳过，你可能永远也想不到，`NSDictionary`写入文件也会失败，这听起来不大可能，幸运的是我遇见了，而且刚好在知识盲区里面。经过网上的一顿搜索和官方文档查阅，竟然毫无发现！！！

最后通过不断地测试和分析后发现（其实就是比较菜。。。），`NSDictionary`里面的元素如果包含`NSNull`值的话会导致 `writeToFile:atomically:` 方法写入失败。测试代码如下：

```objc
- (void)dicNullTest {
    NSDictionary *dic = @{
        @"null": NSNull.null,
        @"name": @"null",
        @"idx": @1
    };
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"null_dic_test"];
    
    NSLog(@"%@", path);
    
    BOOL success = [dic writeToFile:path atomically:YES];
    NSLog(@"success: %@", @(success));
    
    NSURL *url = [NSURL fileURLWithPath:path];
    if (url) {
        NSError *error = nil;
        BOOL success = [dic writeToURL:url error:&error];
        NSLog(@"success: %@ error: %@", @(success), error);
    }
}
```

可以看到字典里面包含了一个 `NSNull.null`，运行日志如下所示：

```
2022-12-13 22:58:03.190072+0800 CommonTest[66654:1881597] success: 0
2022-12-13 22:58:03.190544+0800 CommonTest[66654:1881597] success: 0 error: (null)
```

从运行日志中可以发现的确写入失败了，但是气人的是，`error`竟然也是`null `，而且官方文档也没有对应的说明，更可恨的是 `Android` 可以完美兼容 `null`。

**吐槽下：**
>error 返回 null 有点过分，本来一分钟可以排查的问题，结果要捣鼓半天，这应该算是苹果是一个 bug 吧

### NSArray 写入 NSNull 

怀着一颗好奇心，既然`NSDictionary`会失败，那么`NSArray`包含`NSNull`会不会也会写入失败？测试代码如下：

```objc
- (void)arrayNullTest {
    NSArray *array = @[@"name", NSNull.null];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"null_array_test"];
    
    NSLog(@"%@", path);
    
    BOOL success = [array writeToFile:path atomically:YES];
    NSLog(@"success: %@", @(success));
}
```

测试结果：

```
2022-12-13 23:08:22.374557+0800 CommonTest[66972:1890286] success: 0
```

去掉 `NSNull` 则写入成功，有兴趣的可以自行验证下。