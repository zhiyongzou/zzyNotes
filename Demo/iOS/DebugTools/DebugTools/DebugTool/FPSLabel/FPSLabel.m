//
//  FPSLabel.m
//  DebugTools
//
//  Created by zzyong on 2021/10/14.
//

#ifdef DEBUG

#import "FPSLabel.h"
#import "DeviceUtils.h"

@interface FPSLabel ()

@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSTimeInterval lastTime;

@end

@implementation FPSLabel

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = NO;
        self.font = [UIFont systemFontOfSize:11];
        self.textColor = UIColor.whiteColor;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)dealloc {
    [_link invalidate];
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    self.text = [NSString stringWithFormat:@"%d FPS  %0.f%%  %0.1fM",(int)round(fps), [DeviceUtils cpuUsage], [DeviceUtils memoryFootprint]];
    CGFloat width = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}].width + 6;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height ?: 15);
}

@end

#endif
