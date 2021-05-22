//
//  StringToIntTest.m
//  CommonTest
//
//  Created by zzyong on 2021/4/24.
//

#import "StringToIntTest.h"

@interface StringToIntTest ()

@end

@implementation StringToIntTest

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *string1 = @"12q3";
    NSLog(@"12q3: %@", @(string1.intValue));
    
    string1 = @"aaaa";
    NSLog(@"aaaa: %@", @(string1.intValue));
    
    string1 = @"aa11";
    NSLog(@"aa11: %@", @(string1.intValue));
    
    string1 = @"121212";
    NSLog(@"121212: %@", @(string1.intValue));
}


@end
