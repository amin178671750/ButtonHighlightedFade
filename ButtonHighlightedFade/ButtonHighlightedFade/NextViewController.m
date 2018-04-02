// NextViewController.m
// ButtonHighlightedFade
//
// Created by linguang on 2018/4/2.
// Copyright © 2018年 LG. All rights reserved.
// 

#import "NextViewController.h"
#import "UIButton+HighlightedFade.h"

@interface NextViewController ()

@end

@implementation NextViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 44, width - 20, width - 20)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.diffusionAnimated = YES;
    [button addHighlightedFadeColor:[UIColor magentaColor] alpha:0.5f];
    [self.view addSubview:button];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, width - 20 + 64, width - 20, 60)];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    backButton.diffusionAnimated = YES;
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addHighlightedFadeColor:[UIColor blueColor] alpha:0.2f];
    [self.view addSubview:backButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//按钮点击方法
- (void)buttonPress:(UIButton *)button
{
    NSLog(@"点击");
}

//返回按钮点击方法
- (void)backButtonPress:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
