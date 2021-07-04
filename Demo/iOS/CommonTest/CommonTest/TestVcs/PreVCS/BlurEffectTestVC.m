//
//  BlurEffectTestVC.m
//  CommonTest
//
//  Created by zzyong on 2021/6/14.
//

#import "BlurEffectTestVC.h"

@interface BlurEffectTestVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@end

@implementation BlurEffectTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addBlurEffectViewToView:self.imageView1 alpha:1 mask:nil];
//    [self addBlurEffectViewToView:self.imageView2 alpha:0.9 mask:nil];
    
    // https://developer.apple.com/forums/thread/50854
    // https://github.com/Tawa/TNTutorialManager/issues/16
    // iOS 10，只要 UIVisualEffectView 父试图设置了mask就会失效
    // UIRectCornerTopLeft | UIRectCornerTopRight
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.imageView3.bounds
                                                     byRoundingCorners:UIRectCornerAllCorners
                                                           cornerRadii:CGSizeMake(100, 100)];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.frame = self.imageView3.bounds;
    shapeLayer.strokeColor = [UIColor.redColor CGColor];
    shapeLayer.fillColor = [UIColor.clearColor CGColor];
    
//    shapeLayer.fillColor = [UIColor.redColor CGColor];
//    shapeLayer.strokeColor = [UIColor.clearColor CGColor];
    self.imageView3.layer.masksToBounds = YES;
//    self.imageView3.layer.cornerRadius = 10;
//    self.imageView3.layer.masksToBounds = YES;
    [self addBlurEffectViewToView:self.imageView3 alpha:1 mask:shapeLayer];
}

- (void)addBlurEffectViewToView:(UIView *)target alpha:(CGFloat)alpha mask:(CALayer *)mask {
    
//    UIView *blurSpuerView = [UIView new];
//    blurSpuerView.frame = target.bounds;
//    blurSpuerView.alpha = alpha;
//    if (mask) {
//        [blurSpuerView.layer setMask:mask];
//    }
//
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    blurEffectView.frame = blurSpuerView.bounds;
//    [blurSpuerView addSubview:blurEffectView];
    
    target.layer.mask = mask;
//    [target.layer.mask addSublayer:mask];
}

@end
