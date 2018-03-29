//
//  UIButton+HighlightedFade.h
//  ButtonHighlightedFade
//
//  Created by linguang on 2017/3/29.
//  Copyright © 2018年 LG. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 高亮渐变
 */
@interface UIButton (HighlightedFade)

/**
 按钮添加高亮变淡
 */
- (void)addHighlightedFadeAlpha;

/**
 按钮添加高亮变淡（可定义）

 @param alpha 透明度
 */
- (void)addHighlightedFadeAlpha:(CGFloat)alpha;

/**
 添加高亮变白
 */
- (void)addHighlightedFadeWhite;

/**
 添加高亮变黑
 */
- (void)addHighlightedFadeBlack;

/**
 添加高亮变灰
 */
- (void)addHighlightedFadeGray;

/**
 添加高亮自定义变颜色

 @param color 颜色
 @param alpha 透明度
 */
- (void)addHighlightedFadeColor:(UIColor *)color alpha:(CGFloat)alpha;

/**
 移除高亮
 */
- (void)removeHightlightedFade;

@end
