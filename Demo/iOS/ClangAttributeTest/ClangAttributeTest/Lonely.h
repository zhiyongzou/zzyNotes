//
//  Lonely.h
//  ClangAttributeTest
//
//  Created by zzyong on 2021/9/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// objc_subclassing_restricted: 不可被继承
__attribute__((objc_subclassing_restricted))
@interface Lonely : NSObject

- (void)sayHello NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
