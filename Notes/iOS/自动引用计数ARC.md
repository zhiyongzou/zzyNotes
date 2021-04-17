# ARC

ARC(Automatic Reference Countting)：自动引用计数，无需手动 retain 和 release，由编译器自动管理

## 内存管理方式
- 自己生成的对象，自己持有
- 非自己生成的对象，自己也能持有
- 不需要时释放自己持有的对象
- 不能释放非自己持有的对象

> 对象操作对应的OC方法

| 对象操作  | OC 方法  |
|---|---|
| 生成并持有对象  |  . alloc/new/copy/mutableCopy </br> . 使用 alloc/new/copy/mutableCopy 开头的方法，例如：newMyObject  |
| 持有对象  | retain  |
| 释放对象  | release |
| 废弃对象 | dealloc |

#### 生成并持有 vs 生成不持有
- 生成并持有

```objc
+ (id)newMyObject 
{
    id obj = [NSObject new];
    return obj;
}
```

- 生成不持有

```objc
+ (NSArray *)array
{
  // 生成并持有
  NSArray *array = [[NSArray alloc] init];
  
  // 加入自动释放池，解除自己持有
  [array autorelease];
  
  return array;
}
```

## Autorelease

