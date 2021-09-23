//
//  KVOTestVC.m
//  CommonTest
//
//  Created by zzyong on 2021/7/9.
//

#import "KVOTestVC.h"

@interface KVOObserver : NSObject

@end

@implementation KVOObserver

/**
 #0 -[KVOObserver observeValueForKeyPath:ofObject:change:context:]
 #1 NSKeyValueNotifyObserver ()
 #2 NSKeyValueDidChange ()
 #3 -[NSObject(NSKeyValueObservingPrivate) _changeValueForKeys:count:maybeOldValuesDict:maybeNewValuesDict:usingBlock:] ()
 #4 -[NSObject(NSKeyValueObservingPrivate) _changeValueForKey:key:key:usingBlock:] ()
 #5 _NSSetObjectValueAndNotify ()

 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    // 不建议使用字符串 @"name"，建议使用 NSStringFromSelector(@selector(name))
    // 这样可以规避一些问题
    // 或者是宏定义一个 keyPath
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(name))]) {
        NSLog(@"%@", change);
    }
}

@end


@interface KVOTestVC ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) KVOObserver *observer;

@end

@implementation KVOTestVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addObservers];
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}

- (void)addObservers {
    
    self.observer = [KVOObserver new];
//    [self removeObserver:self.observer forKeyPath:@"name"];
    [self addObserver:self.observer forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self)];
}

#pragma mark - Actions

- (IBAction)changeName:(UIButton *)sender {
    
//    [self willChangeValueForKey:@"name"];
//    _name = [[NSDate date] description];
//    [self didChangeValueForKey:@"name"];
    self.name = [[NSDate date] description];
    NSLog(@"%@", self.name);
}


@end
