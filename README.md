# 一句话添加button高亮变淡，变色的效果

    //button添加高亮
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

![img](https://github.com/amin178671750/ProgramSavedGif/blob/master/buttonHighlightedFade.gif)
