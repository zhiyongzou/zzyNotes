//
//  main.m
//  PreprocessorTest
//
//  Created by zzyong on 2021/4/15.
//

#import <Foundation/Foundation.h>

#define MAX_NUM 100

#import "ImportTest.h"
#import "ImportTest.h"

#include "IncludeTest.h"
//#include "IncludeTest.h" // Duplicate interface definition for class 'IncludeTest'

// 去掉注释能编译通过吗？
//#define REDEFINE 1

#ifdef REDEFINE

#error redefine

#endif

#define MULTI_LINT_IMP if (idx == 1) {\
                            NSLog(@"1");\
                        } else if (idx == 2) {\
                            NSLog(@"2");\
                        } else {\
                            NSLog(@"3");\
                        }


#define  Hello(name) NSLog(@"Hello, %s", #name)

#define Instance(name) instance##name

void multiLineDefine(int idx);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
#if 1
        NSLog(@"DEBUG");
#else
        NSLog(@"RELEASE");
#endif
        
#ifdef DEBUG
        NSLog(@"DEBUG");
#else
        NSLog(@"RELEASE");
#endif
        
    }
    
#warning TODO by zzyong
    
    NSLog(@"%s %s %s %d %s", __DATE__, __TIME__, __FILE_NAME__, __LINE__, __FUNCTION__);
    NSLog(@"%s", __FILE__);
    
    multiLineDefine(1);
    
    Hello(zzyong);
    
    __unused int Instance(1) = 1;
    __unused int Instance(2) = 2;
    
    return 0;
}

void multiLineDefine(int idx)
{
//    if (idx == 1) {
//        NSLog(@"1");
//    } else if (idx == 2) {
//        NSLog(@"2");
//    } else {
//        NSLog(@"3");
//    }
    MULTI_LINT_IMP
}
