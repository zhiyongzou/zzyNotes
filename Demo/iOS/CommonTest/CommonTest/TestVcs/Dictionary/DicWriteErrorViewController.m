//
//  DicWriteErrorViewController.m
//  CommonTest
//
//  Created by zzyong on 2022/12/13.
//

#import "DicWriteErrorViewController.h"

@interface DicWriteErrorViewController ()

@end

@implementation DicWriteErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dicNullTest];
    [self arrayNullTest];
}

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

- (void)arrayNullTest {
    NSArray *array = @[@"name", NSNull.null];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"null_array_test"];
    
    NSLog(@"%@", path);
    
    BOOL success = [array writeToFile:path atomically:YES];
    NSLog(@"success: %@", @(success));
}

@end
