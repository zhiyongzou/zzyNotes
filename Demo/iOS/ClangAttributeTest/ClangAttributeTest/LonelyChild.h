//
//  LonelyChild.h
//  ClangAttributeTest
//
//  Created by zzyong on 2021/9/6.
//

#import "Lonely.h"

NS_ASSUME_NONNULL_BEGIN

// Cannot subclass a class that was declared with the 'objc_subclassing_restricted' attribute
//@interface LonelyChild : Lonely
@interface LonelyChild : NSObject

@end

NS_ASSUME_NONNULL_END
