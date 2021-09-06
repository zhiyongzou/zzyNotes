//
//  main.m
//  ClangAttributeTest
//
//  Created by zzyong on 2021/9/6.
//
// https://releases.llvm.org/3.8.0/tools/clang/docs/AttributeReference.html
// https://blog.sunnyxx.com/2016/05/14/clang-attributes/

#import <Foundation/Foundation.h>

// __attribute__((objc_boxable))
typedef struct {
    CGFloat x, y, width, height;
} CG_BOXABLE BOXRect;

typedef struct {
    CGFloat x, y, width, height;
} NBOXRect;

// constructor 和 +load 都是在 main 函数执行前调用，但 +load 比 constructor 更早一点
// 构造器
__attribute__((constructor)) static void beforeMain(void) {
    NSLog(@"beforeMain");
}

// 析构器
__attribute__((destructor)) static void afterMain(void) {
    NSLog(@"afterMain");
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"main");
        
        // Illegal type 'NBOXRect' used in a boxed expression
//        NBOXRect rect1 = {1, 2, 3, 4};
//        NSValue *value1 = @(rect1);
        
        BOXRect rect2 = {1, 2, 3, 4};
        __unused NSValue *value2 = @(rect2);
    }
    return 0;
}
