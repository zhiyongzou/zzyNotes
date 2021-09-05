//
//  SVGATestVC.m
//  CommonTest
//
//  Created by zzyong on 2021/8/24.
//

#import "SVGATestVC.h"
#import <SVGA.h>
#import "UIView+Frame.h"
#import "GradientView.h"

@interface SVGATestVC ()<SVGAPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (nonatomic, assign) NSInteger stepFrameIdx;
@property (nonatomic, strong) SVGAParser *parser;
@property (nonatomic, strong) GradientView *progress;
@property (nonatomic, strong) SVGAPlayer *effectPlayer;
@property (nonatomic, strong) SVGAPlayer *starPlayer;

@end

@implementation SVGATestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progress = [GradientView new];
    CAGradientLayer *progressLayer = (CAGradientLayer *)_progress.layer;
    progressLayer.startPoint = CGPointMake(0, 0.5);
    progressLayer.endPoint = CGPointMake(1, 0.5);
    progressLayer.cornerRadius = 5;
    progressLayer.colors = @[
                             (id)[UIColor colorWithRed:111/255.0 green:61/255.0 blue:255/255.0 alpha:1].CGColor,
                             (id)[UIColor colorWithRed:1 green:55/255.0 blue:190/255.0 alpha:1].CGColor,
                             (id)[UIColor colorWithRed:1 green:170/255.0 blue:72/255.0 alpha:1].CGColor,
                           ];
    [self.view addSubview:_progress];
    _progress.frame = CGRectMake(10, 200, 0, 10);
    
    self.effectPlayer = [SVGAPlayer new];
    self.effectPlayer.hidden = YES;
//    self.effectPlayer.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:self.effectPlayer];
    self.effectPlayer.frame = CGRectMake(10, 160, 186, 90);
    self.effectPlayer.contentMode = UIViewContentModeScaleAspectFit;
    
    self.parser = [SVGAParser new];
    [self.parser parseWithNamed:@"effect" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        self.effectPlayer.videoItem = videoItem;
    } failureBlock:^(NSError * _Nonnull error) {
            
    }];
    
    self.starPlayer = [SVGAPlayer new];
    self.starPlayer.loops = 1;
    self.starPlayer.hidden = YES;
    self.starPlayer.frame = CGRectMake(10, 175, 100, 60);
    [self.view addSubview:self.starPlayer];
    self.starPlayer.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.parser parseWithNamed:@"star" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        self.starPlayer.videoItem = videoItem;
    } failureBlock:^(NSError * _Nonnull error) {
            
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (IBAction)onStepperValueChange:(UIStepper *)sender {
     
    CGFloat width = self.view.frame.size.width - 20;
    CGFloat progress = sender.value / 100.0;
    CGFloat progressEndW = width * progress;
    
    CGFloat beginx = self.progress.maxX - self.effectPlayer.width;
    CGFloat endx = (progressEndW - self.effectPlayer.width + self.progress.x + 30);
    CGFloat duration = (endx - beginx) * 0.005;
    self.effectPlayer.x = beginx;
    self.effectPlayer.hidden = NO;
    [self.effectPlayer startAnimation];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.progress.width = progressEndW;
        self.effectPlayer.x = endx;
    } completion:^(BOOL finished) {
        
        [self.effectPlayer stopAnimation];
        self.effectPlayer.hidden = YES;
        
        self.starPlayer.hidden = NO;
        [self.starPlayer startAnimation];
        self.starPlayer.x = (self.progress.width - self.starPlayer.width * 0.5 + self.progress.x);
    }];
}

- (void)animated1:(UIStepper *)sender {
    CGFloat width = self.view.frame.size.width - 20;
    CGFloat progress = sender.value / 100.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.progress.width = width * progress;
    } completion:^(BOOL finished) {
        CGFloat beginx = -self.effectPlayer.width + self.progress.x;
        CGFloat endx = (self.progress.width - self.effectPlayer.width + self.progress.x);
        CGFloat duration = (endx - beginx) * 0.004;
        self.effectPlayer.x = beginx;
        self.effectPlayer.hidden = NO;
        [self.effectPlayer startAnimation];
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.effectPlayer.x = endx;
        } completion:^(BOOL finished) {
            [self.effectPlayer stopAnimation];
            self.effectPlayer.hidden = YES;
            
            self.starPlayer.hidden = NO;
            [self.starPlayer startAnimation];
            self.starPlayer.x = (self.progress.width - self.starPlayer.width * 0.5 + self.progress.x);
        }];
    }];
}

@end
