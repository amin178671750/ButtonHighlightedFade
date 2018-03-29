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

@implementation UIButton (HighlightedFade)

- (void)addHighlightedFadeAlpha:(CGFloat)alpha
{
    [self lg_setHighlightedFadeAlpha:alpha];
    
    [self addTarget:self
             action:@selector(lg_highlightedFadeButton:)
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
    [self addHighlightedFadeColor:[UIColor grayColor] alpha:0.5f];
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
                action:@selector(lg_cancelHighlightedFadeButton:)
      forControlEvents:[UIButton lg_highlightedEvent]];
    [self removeTarget:self
                action:@selector(lg_cancelHighlightedFadeButton:)
      forControlEvents:[UIButton lg_cancelHighlightedEvent]];
}

#pragma mark - Events

- (void)lg_highlightedFadeButton:(UIButton *)button
{
    [self lg_changeFadeWithHighlighted:YES];
}

- (void)lg_cancelHighlightedFadeButton:(UIButton *)button
{
    [self lg_changeFadeWithHighlighted:NO];
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

- (void)lg_changeFadeWithHighlighted:(BOOL)highlighted
{
    UIView *fadeView = [self lg_highlightedFadeView] ?: self;
    if (highlighted) {
        //取消高亮的时候需要用到原始透明度
        [self lg_setHighlightedOriginalAlpha:fadeView.alpha];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        CGFloat alpha = highlighted ? [self lg_highlightedFadeAlpha] : [self lg_highlightedOriginalAlpha];
        fadeView.alpha = alpha;
    }];
}

- (void)highlightFadeViewWithColor:(UIColor *)color {
    UIView *fadeView = [self lg_highlightedFadeView] ?: [[UIView alloc] init];
    fadeView.frame = self.bounds;
    fadeView.backgroundColor = color;
    fadeView.alpha = 0.0f;
    
    [self addSubview:fadeView];
    [self bringSubviewToFront:fadeView];
    [self lg_setHighlightedFadeView:fadeView];
}

#pragma mark - getters and setters

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
