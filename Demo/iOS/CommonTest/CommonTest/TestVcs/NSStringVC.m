//
//  NSStringVC.m
//  CommonTest
//
//  Created by zzyong on 2021/7/11.
//

#import "NSStringVC.h"
#import "objc/runtime.h"

@interface NSStringVC ()

@property (nonatomic, strong) NSString *tagString;
@property (nonatomic, weak)   NSString *weakTagString;

@property (nonatomic, strong) NSString *string;
@property (nonatomic, weak)   NSString *weakString;

@property (nonatomic, strong) NSString *constString;
@property (nonatomic, weak)   NSString *weakConstString;

@end

@implementation NSStringVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // NSTaggedPointerString
    _tagString = [NSString stringWithFormat:@"%@",@"myString"];
    NSLog(@"%@", object_getClass(_tagString));
    _weakTagString = _tagString;
    _tagString = nil;
    NSLog(@"%@", _weakTagString);
    
    // __NSCFString
    _string = [NSString stringWithFormat:@"%@",@"哈哈"];
    NSLog(@"%@", object_getClass(_string));
    _weakString = _string;
    _string = nil;
    NSLog(@"%@", _weakString);
    
    // __NSCFConstantString
    _constString = @"Const";
    NSLog(@"%@", object_getClass(_constString));
    _weakConstString = _constString;
    _constString = nil;
    NSLog(@"%@", _weakConstString);
}

- (IBAction)clickButton:(UIButton *)sender {
    
    NSLog(@"%@", _weakTagString);
}

- (IBAction)clickHaHaButton:(UIButton *)sender {
    
    NSLog(@"%@", _weakString);
}

- (IBAction)clickConstButton:(UIButton *)sender {
    
    NSLog(@"%@", _weakConstString);
}


@end
