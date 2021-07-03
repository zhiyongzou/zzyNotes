# iOS 编码规范总结
良好的编码规范不但可以提高项目的可维护性和可读性，而且也可以减少一些不必要的错误。个人极力推荐日常编码过程中尽量可以遵守 Apple 编码指南：[Apple CodingGuidelines](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html#//apple_ref/doc/uid/10000146-SW1)。下面是个人在开发过程中的一些总结。

#### 基本风格
单个源文件中保留相同的代码风格

``` objc
// 不推荐
@property (nonatomic, strong) NSString *aString;
@property (strong, nonatomic) UIView *aView;
   
- (void)method1 {

}
   
- (void)method2
{

}
   
// 推荐
@property (nonatomic, strong) NSString *aString;
@property (nonatomic, strong) UIView *aView;
   
- (void)method1
{

}
   
- (void)method2
{

}
```
  
属性修饰符尽量不要省略

```objc
// 不推荐
@property (nonatomic) NSNumber *aNumber;
   
// 推荐
@property (nonatomic, strong) NSNumber *aNumber;
```

合理的使用空格、换行和缩进，保持代码美观。建议参考 Apple 空格使用风格

```objc
// 不推荐
-(void)myMethod{
    if(1==a){
        NSLog(@"%@",@"666");
    }
    b=1;
    a=b>1?b:2;
    c=a+b;
    d ++;
}
	
// 推荐
- (void)myMethod {
    
    if (1 == a) {
        NSLog(@"%@", @"666");
    }
	
    b = 1;
    a = (b > 1) ? b : 2;
    c = a + b;
    d++;
}
```
 
变量命名和格式如果拿捏不准的话，可以参考 Apple 风格。

```objc
// 不推荐【大多数人】
@property (nonatomic, assign) BOOL canScroll; 

// 推荐【Apple】
@property (nonatomic, assign) BOOL scrollEnable; 
```   
   
代码对齐，让代码美如画

```objc
// 不推荐
static NSString *const kMyStringIsLongLong = @"kMyString";
static NSString *const kYourString = @"kYourString";
static NSString *const kHeString = @"kHeString";
   	
// 推荐
static NSString *const kMyStringIsLongLong = @"kMyStringIsLongLong";
static NSString *const kYourString         = @"kYourString";
static NSString *const kHeString           = @"kHeString";
```
 	
方法名过长时注意换行，以`:`进行对齐。此外方法的参数最好不要超过 6 个，方法实现控制在 200 行以内，太长会导致可读性变差

```objc
// 不推荐
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
	
// 推荐
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(onEnterBackground)
                                             name: UIApplicationDidEnterBackgroundNotification
                                           object:nil];
```
		
#### Notifications 命名规则
规则：`[Name of associated class] + [Did | Will] + [UniquePartOfName] + Notification`

```objc
// 示例
UIKIT_EXTERN NSNotificationName const UIApplicationDidEnterBackgroundNotification;
```

#### 多使用泛型
集合类带上存储类型

```objc
// 不推荐
@property (nonatomic, strong) NSMutableArray *childViewControllers;
	
// 推荐
@property (nonatomic, strong) NSMutableArray<UIViewController *> *childViewControllers;
```

	
#### block 里面的代码尽量少
block 里面的代码尽量不要超过 5 行，最好抽成一个方法。这样可以防止遗漏 weakSlef 可能导致的循环引用问题，其次由于是弱引用，所以 weakSelf 可能随时被释放，这样还可以避免  block 里面方法调用行为不确定的问题

```objc
// 不推荐
__weak typeof(self) weakSelf = self;
[self queryMoreGameLivesWithCompletion:^(NSArray *rsp, BOOL success) {
	// weakSelf 可能随时被释放，所以下面的方法调用行为是不确定
    weakSelf.rsp = rsp;
    [weakSelf doSomething];
    [weakSelf doSomething2];
}];
	
// 推荐
[self queryMoreGameLivesWithCompletion:^(NSArray *rsp, BOOL success) {
    // 调用行为确定
    [weakSelf handleMoreGameLivesWithRsp:rsp success:success];
}];
    
- (void)handleMoreGameLivesWithRsp:(id)rsp success:(BOOL)success
{
    self.rsp = rsp;
    [self doSomething];
    [self doSomething2];
}
```

#### 创建使用集合类安全方法
建议最好为集合类创建安全方法，这样防止越界和插入空对象等异常【注意区分外放和内测版本】。例如为 NSArray 增加一个 safe 前缀完全方法
	
```objc
@implementation NSArray (Safe)
	
- (id)safeObjectAtIndex:(NSUInteger)index
{
    // 增加内侧版本是为了可以在测试阶段屏蔽保护，做到及时发现问题，这样可以避免引起一些业务上的异常
    if (INTERNAL_VERSION) {
        return [self objectAtIndex:index];
    } else {
        if (self.count > index) {
            return [self objectAtIndex:index];
        }
        return nil;
    }
}
	
@end
	
NSArray *infos = [NSArray array];
// 不推荐
id model = [infos objectAtIndex:index];
	
//推荐
id model = [infos safeObjectAtIndex:index];
```

#### UICollectionView 注册默认 Cell 和 SupplementaryView
UICollectionView 注册默认 Cell 和 SupplementaryView，防止发生异常

```objc
[collectionView  registerClass:[UICollectionViewCell class]
    forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
[collectionView  registerClass:[UICollectionReusableView class]
    forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
           withReuseIdentifier:@"header"];
    
[collectionView  registerClass:[UICollectionReusableView class]
    forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
           withReuseIdentifier:@"footer"];
```
               
#### delegate 方法
delegate 方法建议声明为 @required，未实现方法时编译器会发出警告，有利于及时发现问题。如果为可选，在调用代理方法加上 `respondsToSelector` 判断

```objc
// @optional
if ([self.delegate respondsToSelector:@selector(myViewDidClick)]) {
    [self.delegate myViewDidClick];
}
```

#### 使用 switch 语句时最好去除 default
无 default 分支时，当有分支未实现时，编译器会发出警告，有利于及时发现问题。如果你对于警告不是很敏感的话，建议加上 **default** 分支，并且在 **default** 分支加上 **NSAssert** (断言)，这样可以避免不必要的崩溃和及时发现问题。

#### 关键路径输出日志
关键路径输出日志有利于问题的发现与定位。例如一些较难重现的野指针崩溃，往往这些 Crash 日志的调用栈全是系统调用，此时如何是好？当然是结合用户日志进行综合分析，这样可以通过日志定位户当时在哪个页面和用户的操作路径，这些都是有利于提高崩溃重现概率的点。

#### 避免同时使用 setNeedsLayout 和 layoutIfNeeded
如需要重新布局只需要调用 `setNeedsLayout` 即可，避免耗尽当次循环时间。除非需要同步布局才使用 layoutIfNeeded 更新布局

```objc
// 不推荐
- (void)setUserInfo:(id)userInfo
{
    _userinfo = userInfo;
	
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
	
// 推荐
- (void)setUserInfo:(id)userInfo
{
    _userinfo = userInfo;

    [self setNeedsLayout];
}
	
```
	
#### UIView 视图布局时机
在 **layoutSubviews（View）** 和 **viewDidLayoutSubviews（ViewController）** 这个两个方法中进行视图布局。如果使用自动布局的话，请在初始化方法中完成

```objc
@implementation View
	
- (void) layoutSubviews
{
    [super layoutSubviews];
    // UI 布局
}
	
@end
	
	
@implementation ViewController
	
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    // UI 布局
}
	
@end
```

#### 移除一些不可见的定时器轮播
例如一些广告轮播视图在其不可见时应该停止轮播，防止额外的开销，提高整体 App 的性能

```objc
// 视图是否可见判断条件
if (viewController.isViewLoaded && viewController.view.window) {
	// viewController is visible
}
	
if (view.window) {
	//view is visible
}
	
// 推荐
- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if (self.window) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}
	
```
	
#### @[ ] 与 @{ } 注意空异常
使用 **@[ ]** 和 **@{ }** 创建集合对象时要确保容器内的 object 和 key 不为空。曾经遇到过 imageWithName: 返回为空导致的崩溃。

```objc
// 不推荐
@[[UIImage imageWithName:@"icon"]];
	
// 推荐
[NSArray alloc] initWithObjects:[UIImage imageWithName:@"icon"], nil];
	
[NSDictionary alloc] initWithObjectsAndKeys:@(1) : @"key", nil];
	
```
	
#### 复杂视图应该遵循的 3 个原则

1. 应该继承 UIView，而不是 UICollectionViewCell 或者 UITableViewCell等特定类。这样有利于项目其他模块复用

2. 如果视图层级过于复杂，建议将视图进行分层，例如分为：top / middle / bottom，这样不仅使得视图的层级结构更加清晰，而且有利于问题定位

3. 复杂视图建议使用**代码创建**，而不是 **storyboard** 或者 **xib**。有利于后续维护和后来者接手。当然自己维护还好，但是后来者的话，看到满屏的线条和模糊不清的层级结构，只能说剪不断理还乱

```objc
1. 该继承谁？
// 不推荐
@interface MomentView : UICollectionViewCell 
@end
	
// 推荐
@interface MomentView : UIView 
@end
	
2. 代码 or Xib，分层 ？ 
// 不推荐
@interface MomentView : UIView 
	
@property (nonatomic, weak) IBOutlet UIImageView *coverImageView;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *fansLabel;
@property (nonatomic, weak) IBOutlet UICollectionView *picturesView;
@property (nonatomic, weak) IBOutlet UILabel  *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *commentBtn;
@property (nonatomic, weak) IBOutlet UIButton *likeBtn;
@property (nonatomic, weak) IBOutlet UIButton *shareBtn;
	
@end
	
// 推荐
@interface MomentView : UIView 
	
// top
@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *fansLabel;
	
// bottom
@property (nonatomic, strong) UIView *bottomContainerView;
@property (nonatomic, strong) UICollectionView *picturesView;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *shareBtn;
	
@end
	
```

#### 避免多余循环，记得使用 break
如果是为了查找集合内的某个特定对象，查找完毕后记住 **break**, 防止多余循环。我相信大多少人都知道是应该这样做，但是我就是忘了呀，所以在 bug 不多的时候多回去看看自己的代码，或者是互相 review 代码。

```objc
// 不推荐
UIView *videoPreView = nil;
for (UIView *subview in self.subviews) {
    if ([subview isKindOfClass:[VideoView class]]) {
        videoPreView = subview;
    }
}
	
// 推荐
UIView *videoPreView = nil;
for (UIView *subview in self.subviews) {
    if ([subview isKindOfClass:[VideoView class]]) {
        videoPreView = subview;
        break;
    }
}
```

#### 分类避免使用 property
给 **Category** 增加关联属性时避免直接声明 **property** ，应该使用对应的存取方法代替。这样可以避免由于归档时将该变量存入本地数据库，防止版本更新可能导致数据类型不对的异常。例如：V1.0 myObject 是 NSNumber，在 V2.0时由于 xx 原因改为 NSString。如果测试没有覆盖到，那么上线你会哭

```objc
@interface NSObject (Extension)
	
// 不推荐
@property (nonatomic, strong) NSNumber *myObject;
	
// 推荐
- (NSObject *)myObject;
- (void)setMyObject:(NSObject *)myObject;

@end
```

#### 避免直接使用第三方库 API
使用第三方库时应该独立封装一个中间层进行管理，避免直接调用，不然以后更换第三方库的时候会崩溃。

```objc
// 举例 SDWebImage
// 不推荐
[self.coverImgView  sd_setImageWithURL:[NSURL URLWithString:@"http://xxx.com/my.png"]
                      placeholderImage:[UIImage imageNamed:@"default"]];
	
// 推荐
@interface UIImageView (MyWebCache)
	
- (void)cc_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder;
	
@end
	
[self.coverImgView  cc_setImageWithURL:[NSURL URLWithString:@"http://xxx.com/my.png"]
                      placeholderImage:[UIImage imageNamed:@"default"]];
	
```

#### reloadSections 使用需慎重
使用 **reloadSections** 时一定要确保其他 **section** 的数据不会改变，如果性能影响不大的话，建议使用 **reloadData**

#### 避免多重循环（for）
当用到多层 **for** 循环时一定要慎重考虑，想想有没有更好的方法。因为往往他就是性能杀手

```objc
// 好好想想有没有更好的方法
for (int a = 0; a < MAX; a++) {
	for (int b = 0; b < MAX; b++) {
		for (int c = 0; c < MAX; c++) {
			// do something
		}
	}
}
```

#### 使用 static 代替 define
常量定义建议使用 **static const** 代替 **#define**。 **define** 只是纯粹的文本替换，没有类型安全检测, 而且宏重定义编译器并不会报错。虽然编译器有类型检测警告，但是你忽略了呢？那必定是强势背锅。

```objc
//1. define
// 类型错误 警告 ⚠️
#define MY_STRING @666 
	
// 重定义 警告 ⚠️
#import "People.h"
	
#define MY_STRING @"myString" 
	
@interface People : NSObject
@end
	
// 有一天你的同事隔壁老王也定义一个全局同名的 MY_STRING 宏，此时你的宏就有可能被覆盖，杯具就开始了
#define MY_STRING @"geBiLaoWang" 
	
//2. static const
// 类型错误 --> Error!!!
static NSString  *const kMyString = @1; 
	
// 变量重名 --> Error!!!
static NSString  *const kMyString = @"myString"; 
extern static NSString  *const kMyString;
	
#import "People.h"
static NSString  *const kMyString = @"peopleString";
```

#### 多用 CGRectGetXxx 方法
使用 **CGRectGetXxx** 代替 **view.frame.xx.xx**，极力推荐给 UIView 扩展 MaxX 等方法

```objc
// 不推荐
self.frame.size.width;
self.frame.origin.x;
self.frame.origin.y;
    
// 推荐
CGRectGetWidth(self.frame);
CGRectGetMinX(self.frame);
CGRectGetMinY(self.frame);

// 极力推荐
@implementation UIView (Layout)
	
- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}
	
@end
```

#### 多使用 sizeWithAttributes 计算文本
建议文本计算使用 **sizeWithAttributes：** 代替 **sizeToFit**。原因是 **sizeToFit** 开销大，会影响滑动性能。 **sizeToFit** 不但把文本宽高计算出来，而且还帮你把 **frame** 都一起设置了。由于你还是需要手动设置 frame 的，所以相当于多设置一次 frame , 而且 **sizeToFit** 背后做的事情远不止这些，具体使用 **instruments** 查看其调用栈。

```objc
// 不推荐
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(6, 6, CGRectGetWidth(self.titleLabel.frame), 6);
}
	
// 推荐
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat title_w = ceil([_titleLabel.text sizeWithAttributes:@{NSFontAttributeName : _titleLabel.font}].width);
    self.titleLabel.frame = CGRectMake(6, 6, title_w, 6);
}
```

#### frame 避免分开设置
在一些对性能要求较高的业务中，使用frame 布局时不应该用 **.x .y .top .bottom** 等便捷方法，这样会导致多次设置视图 frame，导致多余开销，影响交互性能。正确的姿势应该是一次性直接 setFrame: 

```objc
@interface UIView (Frame)
	
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat widtf;
@property (nonatomic, assign) CGFloat height;

@end

	
UIView *aView = [[UIView alloc] init];
// 不推荐
aView.x = 2;
aView.y = 6;
aView.width = 66;
aView.height = 66;
	
// 推荐
aView.frame = CGRectMake(2, 6, 66, 66);
```
#### 尽量避免 UIView Misaligned
当 UIView 发生 **Misaligned** (像素未对齐)时怎么办？快用 `CGRectIntegral( )`, 如果视图的 frame 已是整数值了，确定不会有 Misaligned，那问题很大可能出在其 **superView** 上，此时只需要对其父视图做一次 **CGRectIntegral** 即可。Misaligned 经常会出现在 UILabel 和 UIImageView 上。

```objc
Misaligned
1. 影响: 
	视图或图片的点数(point),不能换算成整数的像素值(pixel),导致显示视图的时候需要对没对齐的边缘进行额外混合计算,影响性能
2. 表现
	洋红色: UIView 的 frame 像素不对齐,即不能换算成整数像素值
	黄色: UIImageView 的图片像素大小与其 frame.size 不对齐,图片发生了缩放造成
	
// 示例
CGFloat title_w = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName : _titleLabel.font}].width;
self.titleLabel.frame = CGRectIntegral(CGRectMake(6, 6, title_w, 6));
```

**Tip**

>  至于 image 的话，如果是本地图片，UIImageView 尺寸大小设置为 image 尺寸即可。
> 如果是从服务器下载的图片，那将下载到的图片缩放到与 UIImageView 对应的尺寸，再显示出来，
> 但是要注意图片缩放也是一笔额外开销，所以对于频繁变动的 image 不建议这样做。因为图片缩放可能影响更大
> 
> 基于之前的列表优滑动化经验发现 Misaligned 对滑动性能影响较小，可有可无，所以就让他去吧。
> 如果是几乎不会变动的才考虑这样做，并且把处理后的图片缓存起来

#### 给 import 分类
当一个文件引入的头文件 **很多** 时，建议按照头文件类型进行分类，如果你是个追求极致的人，甚至还可以严格按照头文件长度再次排序。如下

```objc
// controller
#import "Controller1.h"
#import "Controller2.h"
#import "Controller3.h"
	
// model
#import "Model1.h"
#import "Model2.h"
	
// view
#import "View1.h"
#import "View2.h"
	
// other
#import "Other1.h"
```

#### 多用 @class 和 @protocol
使用 **@class** 和 **@protocol** 代替 **#import** ,有利于加快编译速度

```objc
// 不推荐
#import "Dog.h"
	
// 推荐
@class Dog;
	
@interface People : NSObject
	
@property (nonatomic, strong) Dog *dog;
	
@end
```

#### 只读属性建议加上 readonly
如果公有属性是只读的，建议加上修饰符 **readonly**

```objc
@interface People : NSObject
	
// 不推荐
@property (nonatomic, strong) NSString *name;
	
// 推荐
@property (nonatomic, strong, readonly) NSString *name;
	
@end
```

#### 对象初始化依赖多参数时多属性赋值
如果创建一个对象需要调用者传多个参数进行初始化时，此时最好不要使用**多属性赋值**，而是封装成一个方法给调用者，这样可以避免属性赋值顺序等问题。这里强调 `初始化`，一些特殊的属性更新除外 

```objc
@interface MyView : UIView
	
// 不推荐
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) CGFloat topMargin;

MyView *my = [MyView new];
my.title = @"";
my.type = 0;
my.topMargin = 0;
	
// 推荐
- (void)setTitle:(NSString *)title
            type:(int)type
       topMargin:(CGFloat) topMargin;
	
@end
```

#### 合理使用	BitMask 合并多个请求
如何合并多个服务器请求？这里可以合理 **位掩码**（BitMask），好处就是代码简洁易懂，计算速度快等

```objc
typedef NS_OPTIONS(NSUInteger, InfoQueryOptions) {
    InfoQueryNone = 0,
    InfoQueryMine = 1 << 0,  // mine
    InfoQueryFans = 1 << 1   // fans
};
	
@property (nonatomic, assign) InfoQueryOptions queryOptions;
	
__weak typeof(self) weakSelf = self;
[self queryInfoMineWithCompletion:^(id *rsp, BOOL success) {
    weakSelf.queryOptions |= InfoQueryMine;
    [weakSelf reloadDataIfNeed];
}];
	
[self queryInfoFansWithCompletion:^(id *rsp, BOOL success) {
    weakSelf.queryOptions |= InfoQueryFans;
    [weakSelf reloadDataIfNeed];
}];
	
- (void)reloadDataIfNeed
{
    if ([weakSelf isInfoQueryFinished]) {
        //一顿操作
    }
}
	
- (BOOL)isInfoQueryFinished
{
    return (self.queryOptions & InfoQueryMine == InfoQueryMine) &&
           (self.queryOptions & InfoQueryFans == InfoQueryFans)
}
```

#### 合理使用 Extension 和 Category 拆分业务
如何处理 Massive viewControlle（MVC 痛点）,暂且定义大于 1500 行代码就算臃肿。这边推荐 Extension 和 Category 进行功能模块划分。该方法同样适用于其他类

```objc
@interface MyViewController : UIViewController
	
@end
	
1. CollectionView 模块 （DataSource / Delegate）
@interface MyViewController ()
	
// 引入主类必要的一些属性或方法
- (void)reloadDataIfNeed;
	
@end
	
@interface MyViewController (CollectionView) <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
	
- (void)setupCollectionView;
	
@end
	
2. 数据请求模块
@interface MyViewController ()
	
// 引入主类必要的一些属性或方法
@property (nonatomic, assign) BOOL isQuerying;
@property (nonatomic, strong) NSArray<InfoModel *> *sectionsData;
	
@end
	
@interface MyViewController (DataQuery)
	
- (void)queryMineList;
- (void)queryfansList;
	
@end
	
3. 数据上报模块
@interface MyViewController ()
	
// 引入主类必要的一些属性或方法
	
@end
	
@interface MyViewController (EventReport)
	
@end
```
	
#### 持续更新...