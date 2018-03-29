//
//  ViewController.m
//  ButtonHighlightedFade
//
//  Created by linguang on 2017/3/29.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "ViewController.h"

#import "UIButton+HighlightedFade.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    NSInteger number = 10;
    CGFloat buttonHeight = (CGRectGetHeight([UIScreen mainScreen].bounds) - 44 - 30)/10.0f;
    for (NSInteger i = 0; i < number; i ++ ) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 44 + buttonHeight*i, width - 20, buttonHeight - 10)];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //添加圆角及边框
        button.layer.cornerRadius = 5.0f;
        button.layer.masksToBounds = YES;
        
        NSString *title = @"";
        switch (i) {
            case 0:
            {
                title = @"默认变淡";
                [button addHighlightedFadeAlpha];
            }
                break;
            case 1:
            {
                title = @"自定变淡";
                [button addHighlightedFadeAlpha:0.3f];
            }
                break;
            case 2:
            {
                title = @"变白";
                [button addHighlightedFadeWhite];
            }
                break;
            case 3:
            {
                title = @"变黑";
                [button addHighlightedFadeBlack];
            }
                break;
            case 4:
            {
                title = @"变灰";
                [button addHighlightedFadeGray];
            }
                break;
            case 5:
            {
                title = @"变紫";
                [button addHighlightedFadeColor:[UIColor purpleColor] alpha:0.5f];
            }
                break;
            case 6:
            {
                title = @"变红";
                [button addHighlightedFadeColor:[UIColor redColor] alpha:1.0f];
            }
                break;
            case 7:
            {
                title = @"变蓝";
                [button addHighlightedFadeColor:[UIColor blueColor] alpha:0.5f];
            }
                break;
            case 8:
            {
                title = @"变绿";
                [button addHighlightedFadeColor:[UIColor greenColor] alpha:0.5f];
            }
                break;
            case 9:
            {
                title = @"变黄";
                [button addHighlightedFadeColor:[UIColor yellowColor] alpha:0.5f];
            }
                break;
                
            default:
                break;
        }
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//按钮点击方法
- (void)buttonPress:(UIButton *)button
{
    NSLog(@"点击");
}


@end
