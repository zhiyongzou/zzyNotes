//
//  DeallocTestVC.m
//  CommonTest
//
//  Created by zzyong on 2021/3/22.
//

#import "DeallocTestVC.h"
#import <objc/runtime.h>

@interface DeallocTestIVAR: NSObject

@end

@implementation DeallocTestIVAR

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end

@interface AssociatedObject: NSObject

@end

@implementation AssociatedObject

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end

@interface DeallocTestVC ()

@property (nonatomic, strong) DeallocTestIVAR *instance_1;
@property (nonatomic, strong) AssociatedObject *associatedObject;

@end

@implementation DeallocTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.instance_1 = [DeallocTestIVAR new];
    self.associatedObject = [AssociatedObject new];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)setAssociatedObject:(AssociatedObject *)associatedObject {
    objc_setAssociatedObject(self, @selector(associatedObject), associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AssociatedObject *)associatedObject {
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

@end
