//
//  UIButton+HighlightedFade.m
//  ButtonHighlightedFade
//
//  Created by linguang on 2017/3/29.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "UIButton+HighlightedFade.h"
@import ObjectiveC.runtime;

static const void *LGHighlightedFadeAlpha = &LGHighlightedFadeAlpha;
static const void *LGHighlightedOriginalAlpha = &LGHighlightedOriginalAlpha;
static const void *LGHighlightedFadeView = &LGHighlightedFadeView;
static const void *LGDiffusionAnimated = &LGDiffusionAnimated;

#define floatAnimationDuration 0.5f

@implementation UIButton (HighlightedFade)

@dynamic diffusionAnimated;

- (void)addHighlightedFadeAlpha:(CGFloat)alpha
{
    [self lg_setHighlightedFadeAlpha:alpha];
    
    [self addTarget:self
             action:@selector(lg_highlightedFadeButton:events:)
   forControlEvents:[UIButton lg_highlightedEvent]];
    [self addTarget:self
             action:@selector(lg_cancelHighlightedFadeButton:)
   forControlEvents:[UIButton lg_cancelHighlightedEvent]];
}

- (void)addHighlightedFadeAlpha
{
    [self addHighlightedFadeAlpha:0.8f];
}

- (void)addHighlightedFadeWhite
{
    [self addHighlightedFadeColor:[UIColor whiteColor] alpha:0.5f];
}

- (void)addHighlightedFadeBlack
{
    [self addHighlightedFadeColor:[UIColor blackColor] alpha:0.5f];
}

- (void)addHighlightedFadeGray
{
    [self addHighlightedFadeColor:[UIColor grayColor] alpha:0.3f];
}

- (void)addHighlightedFadeColor:(UIColor *)color alpha:(CGFloat)alpha
{
    //添加变淡view
    [self highlightFadeViewWithColor:color];
    
    //添加高亮变淡透明度
    [self addHighlightedFadeAlpha:alpha];
}

- (void)removeHightlightedFade
{
    //清空runtime存储
    [self lg_setHighlightedFadeView:nil];
    [self lg_setHighlightedFadeAlpha:-1];
    [self lg_setHighlightedOriginalAlpha:-1];
    
    //移除点击方法
    [self removeTarget:self
                action:@selector(lg_highlightedFadeButton:events:)
      forControlEvents:[UIButton lg_highlightedEvent]];
    [self removeTarget:self
                action:@selector(lg_cancelHighlightedFadeButton:)
      forControlEvents:[UIButton lg_cancelHighlightedEvent]];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIView *fadeView = [self lg_highlightedFadeView];
    if (fadeView) {
        fadeView.layer.cornerRadius = self.layer.cornerRadius;
    }
}

#pragma mark - Events

- (void)lg_highlightedFadeButton:(UIButton *)button events:(UIEvent *)events
{
    UITouch *touch = [[events touchesForView:button] anyObject];
    CGPoint point = [touch locationInView:button];
    [self lg_changeFadeWithHighlighted:YES touchPoint:point];
}

- (void)lg_cancelHighlightedFadeButton:(UIButton *)button
{
    [self lg_changeFadeWithHighlighted:NO touchPoint:CGPointZero];
}

#pragma mark - Private

+ (NSUInteger)lg_highlightedEvent
{
    return UIControlEventTouchDown;
}

+ (NSUInteger)lg_cancelHighlightedEvent
{
    return UIControlEventTouchDragExit | UIControlEventTouchUpInside | UIControlEventTouchCancel;
}

- (void)lg_changeFadeWithHighlighted:(BOOL)highlighted touchPoint:(CGPoint)touchPoint
{
    UIView *fadeView = [self lg_highlightedFadeView] ?: self;
    if (highlighted) {
        //取消高亮的时候需要用到原始透明度
        [self lg_setHighlightedOriginalAlpha:fadeView.alpha];
        
        BOOL isNotSelf = fadeView != self;
        //刷新位置，前置
        if (isNotSelf) {
            [self refreshFadeFrameWithView:fadeView];
            [self bringSubviewToFront:fadeView];
        }
        
        //添加扩散动画
        if (self.diffusionAnimated && isNotSelf) {
            [self addDiffusionAnimationWithFadeView:fadeView touchPoint:touchPoint];
        }
    }
    
    [UIView animateWithDuration:floatAnimationDuration animations:^{
        CGFloat alpha = highlighted ? [self lg_highlightedFadeAlpha] : [self lg_highlightedOriginalAlpha];
        fadeView.alpha = alpha;
    }];
}

- (void)highlightFadeViewWithColor:(UIColor *)color {
    UIView *fadeView = [self lg_highlightedFadeView] ?: [[UIView alloc] init];
    fadeView.backgroundColor = color;
    fadeView.alpha = 0.0f;
    fadeView.layer.masksToBounds = YES;
    [self refreshFadeFrameWithView:fadeView];
    
    [self addSubview:fadeView];
    [self bringSubviewToFront:fadeView];
    [self lg_setHighlightedFadeView:fadeView];
}

- (void)refreshFadeFrameWithView:(UIView *)fadeView
{
    CGRect frame = self.bounds;
    
    if (self.diffusionAnimated) {
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        CGFloat maxWidth = MAX(width, height);
        frame.size.width = maxWidth;
        frame.size.height = maxWidth;
        frame.origin.x = (width - maxWidth)/2.0f;
        frame.origin.y = (height - maxWidth)/2.0f;

        if (fadeView.layer.cornerRadius != maxWidth/2.0f) {
            fadeView.layer.cornerRadius = maxWidth/2.0f;
        }
    }
    
    if (!CGRectEqualToRect(frame, fadeView.frame)) {
        fadeView.frame = frame;
    }
}

//添加扩散动画
- (void)addDiffusionAnimationWithFadeView:(UIView *)fadeView touchPoint:(CGPoint)touchPoint
{
    touchPoint.x -= fadeView.frame.origin.x;
    touchPoint.y -= fadeView.frame.origin.y;
    
    touchPoint.x /= fadeView.frame.size.width;
    touchPoint.y /= fadeView.frame.size.height;
    
    CGRect oldFrame = fadeView.frame;
    fadeView.layer.anchorPoint =  touchPoint;
    fadeView.frame = oldFrame;
    
    //放大
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithDouble:0];
    scaleAnimation.toValue = [NSNumber numberWithDouble:1.5];
    scaleAnimation.duration= floatAnimationDuration;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    NSString *key = [NSString stringWithFormat:@"scale%@",@(random())];
    [fadeView.layer addAnimation:scaleAnimation forKey:key];
    
    //调整圆角
    CGFloat cornerRadiusDuration = 0.1f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((scaleAnimation.duration - cornerRadiusDuration) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation * corerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        corerRadiusAnimation.fromValue = [NSNumber numberWithDouble:fadeView.layer.cornerRadius];
        corerRadiusAnimation.toValue = [NSNumber numberWithDouble:self.layer.cornerRadius];
        corerRadiusAnimation.duration= cornerRadiusDuration;
        corerRadiusAnimation.delegate = self;
        NSString *key = [NSString stringWithFormat:@"cornerRadius%@",@(random())];
        [fadeView.layer addAnimation:corerRadiusAnimation forKey:key];
    });
}

#pragma mark - getters and setters

- (void)setDiffusionAnimated:(BOOL)diffusionAnimated
{
    if (diffusionAnimated) {
        self.layer.masksToBounds = YES;
    }
    
    NSValue *value = [NSValue value:&diffusionAnimated withObjCType:@encode(BOOL)];
    objc_setAssociatedObject(self, &LGDiffusionAnimated, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)diffusionAnimated
{
    NSValue *value = objc_getAssociatedObject(self, &LGDiffusionAnimated);
    if (value) {
        BOOL diffusion;
        [value getValue:&diffusion];
        return diffusion;
    }
    return NO;
}

- (void)lg_setHighlightedFadeAlpha:(CGFloat)alpha
{
    NSNumber *alphaNumber = (alpha >= 0) ? @(alpha) : nil;
    objc_setAssociatedObject(self, LGHighlightedFadeAlpha, alphaNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lg_highlightedFadeAlpha
{
    return [objc_getAssociatedObject(self, LGHighlightedFadeAlpha) floatValue];
}

- (void)lg_setHighlightedOriginalAlpha:(CGFloat)alpha
{
    NSNumber *alphaNumber = (alpha >= 0 )? @(alpha) : nil;
    objc_setAssociatedObject(self, LGHighlightedOriginalAlpha, alphaNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lg_highlightedOriginalAlpha
{
    return [objc_getAssociatedObject(self, LGHighlightedOriginalAlpha) floatValue];
}

- (void)lg_setHighlightedFadeView:(UIView *)fadeView
{
    objc_setAssociatedObject(self, LGHighlightedFadeView, fadeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)lg_highlightedFadeView
{
    return objc_getAssociatedObject(self, LGHighlightedFadeView);
}

@end
