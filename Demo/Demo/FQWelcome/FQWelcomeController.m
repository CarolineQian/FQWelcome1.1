//
//  FQWelcomeController.m
//  Demo
//
//  Created by 冯倩 on 2017/8/25.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import "FQWelcomeController.h"
#import "AppDelegate.h"

#define PAGE_COUNT           3
#define DeviceIsIPhone4      [[UIScreen mainScreen] bounds].size.height == 480
#define DeviceIsIPhone5      [[UIScreen mainScreen] bounds].size.height == 568
#define iphone4Rate          480 / 667.0
#define iphone5Rate          568 / 667.0

@interface FQWelcomeController ()<UIScrollViewDelegate>
{
    UIScrollView     *_scrollView;       //滚动视图
    UIPageControl    *_pageControl;      //页码
    
    NSMutableArray   *_viewArray;       //视图数组
    int              _currentIndex;     //当前页码
}

@end

@implementation FQWelcomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _currentIndex = 0;
    _viewArray = [[NSMutableArray alloc] init];
    [self layoutUI];
}

- (void)dealloc
{
    _scrollView = nil;
    _pageControl = nil;
    _viewArray = nil;
}

#pragma mark - UI
- (void)layoutUI
{
    //添加scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width * PAGE_COUNT, 0 )];
    [_scrollView setDelegate:self];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setBounces:NO];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:_scrollView];
    
    //添加imageView
    int deviceType = 6;
    if(DeviceIsIPhone4)
        deviceType = 4;
    else if(DeviceIsIPhone5)
        deviceType = 5;
    
    for( int i = 0; i < PAGE_COUNT; i++ )
    {
        CGRect imageFrame = self.view.frame;
        imageFrame.origin.x = self.view.frame.size.width * i;
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:imageFrame];
        [imgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcome_%d_%d", deviceType, i]]];
        [_viewArray addObject:imgV];
        
        //最后一页添加按钮
        if( i == ( PAGE_COUNT - 1 ))
        {
            //响应用户交互
            [imgV setUserInteractionEnabled:YES];
            //设置位置
            NSInteger buttonHeight = 20;
            CGRect buttonFrame = CGRectMake(48, self.view.frame.size.height - 72 - buttonHeight, self.view.frame.size.width - 96, buttonHeight);
            if(DeviceIsIPhone4)
            {
                buttonFrame.origin.y = self.view.frame.size.height - 72 * iphone4Rate - 10;
            }
            else if(DeviceIsIPhone5)
            {
                buttonFrame.origin.y = self.view.frame.size.height - 72 * iphone5Rate - 20;
            }
            buttonFrame.size.height = 40;
            
            //设置属性
            UIButton *openButton = [UIButton buttonWithType:UIButtonTypeCustom];
            openButton.frame = buttonFrame;
            [openButton addTarget:self action:@selector(onClickButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [openButton setTitle:@"立即体验" forState:UIControlStateNormal];
            [openButton setTitleColor:[UIColor colorWithRed:23/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
            openButton.layer.borderWidth = 2;
            openButton.layer.borderColor = [UIColor colorWithRed:23/255.0 green:203/255.0 blue:255/255.0 alpha:1].CGColor;
            [openButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [openButton setContentMode:UIViewContentModeCenter];
            [openButton.layer setCornerRadius:7.f];
            [openButton setClipsToBounds:YES];
            [imgV addSubview:openButton];
            [imgV bringSubviewToFront:openButton];
        }
        [_scrollView addSubview:imgV];
    }
    
    //添加PageControl
    CGPoint centerPos =CGPointMake( _scrollView.bounds.size.width / 2, _scrollView.bounds.size.height - 72 - 3);
    if( DeviceIsIPhone4 )
        centerPos.y = _scrollView.bounds.size.height - 72 * iphone4Rate;
    else if( DeviceIsIPhone5)
        centerPos.y = _scrollView.bounds.size.height - 72 * iphone5Rate;
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = PAGE_COUNT;
    _pageControl.currentPage = 0;
    [_pageControl setCenter:centerPos];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:23/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:_pageControl];
    [self.view bringSubviewToFront:_pageControl];
}

#pragma mark - Actions
//点击立即体验界面跳转
- (void)onClickButtonPressed
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //app跳转页面
    [app resetRootViewController];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //更新点
    CGPoint offset = scrollView.contentOffset;
    CGFloat offsetPage = offset.x / self.view.frame.size.width;
    _pageControl.currentPage = offsetPage;
    //最后一页隐藏pageControl
    if ( _currentIndex < (PAGE_COUNT - 1) && offsetPage - _currentIndex > 0.9 )
    {
        _currentIndex += 1;
    }
    else if ( _currentIndex > 0 && offsetPage - _currentIndex < -0.9 )
    {
        _currentIndex -= 1;
    }
    [_pageControl setHidden:_currentIndex == (PAGE_COUNT - 1)];
    
    
    
    //滑动动效
    for ( int i = 0; i < PAGE_COUNT; i++ )
    {
        CGFloat offsetPageItem;
        if ( offsetPage < i )
            offsetPageItem = i - offsetPage;
        else
            offsetPageItem = offsetPage - i;
        
        UIView *view = [_viewArray objectAtIndex:i];
        if ( offsetPageItem < 0.05 )
            view.alpha = 1;
        else if ( offsetPageItem > 0.4 )
            view.alpha = 0;
        else
            view.alpha = ( 0.4 - offsetPageItem ) / ( 0.4 - 0.05 );
    }
}


@end
