//
//  GradientTestVC.m
//  CommonTest
//
//  Created by zzyong on 2021/6/9.
//

#import "GradientTestVC.h"
#import "UIView+Frame.h"

@interface GradientTestVC ()

@property (weak, nonatomic) IBOutlet UIButton *button;


@end

@implementation GradientTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGradientBorderForButton];
}

- (void)addGradientBorderForButton {
    
    CAGradientLayer *gradient = [CAGradientLayer new];
    gradient.frame = self.button.bounds;
    // startPoint 和 endPoint 属性，他们决定了渐变的方向，左上角坐标是{0, 0}，右下角坐标是{1, 1}
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);
    gradient.cornerRadius = 5;
    gradient.colors = @[(id)[UIColor colorWithWhite:0 alpha:0.5].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor, (id)[UIColor colorWithWhite:0 alpha:0].CGColor];
    // button w: 50 h = 200
    [self.button.layer addSublayer:gradient];
    self.button.layer.cornerRadius = 5;
    
    CGFloat yOffset = 20 + CGRectGetMaxY(self.navigationController.navigationBar.frame) + _button.height;
    
    CAShapeLayer *shape = [CAShapeLayer new];
    shape.lineWidth = 3;
    shape.path = [UIBezierPath bezierPathWithRoundedRect:_button.bounds cornerRadius:5].CGPath;
    shape.strokeColor = UIColor.redColor.CGColor;
    shape.fillColor = UIColor.clearColor.CGColor;
    yOffset += 20;
    shape.frame = CGRectMake(_button.x, yOffset, _button.width, _button.height);
    [self.view.layer addSublayer:shape];
    
    // CALayer gradient border
    CAGradientLayer *gradient_1 = [CAGradientLayer new];
    gradient_1.startPoint = CGPointMake(0, 0.5);
    gradient_1.endPoint = CGPointMake(1, 0.5);
    gradient_1.cornerRadius = 5;
    gradient_1.colors = @[(id)[UIColor orangeColor].CGColor, (id)[UIColor clearColor].CGColor];
    yOffset += (20 + _button.height);
    gradient_1.frame = CGRectMake(_button.x, yOffset, _button.width, _button.height);
    
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.lineWidth = 5;
    mask.path = [UIBezierPath bezierPathWithRoundedRect:_button.bounds cornerRadius:5].CGPath;
    // mask 图层的 Color 属性是无关紧要的，真正重要的是图层的轮廓。 mask 图层实心的部分会被保留下来，其他的则会被抛弃。strokeColor 可以任意颜色
    mask.strokeColor = UIColor.redColor.CGColor;
    mask.fillColor = UIColor.clearColor.CGColor;
    mask.frame = _button.bounds;
    gradient_1.mask = mask;
    
    [self.view.layer addSublayer:gradient_1];
    
}

@end
