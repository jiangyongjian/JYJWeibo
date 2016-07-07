//
//  JYJEmotionListView.m
//  JYJ微博
//
//  Created by JYJ on 15/3/24.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//



#import "JYJEmotionListView.h"
#import "JYJEmotionGridView.h"

@interface JYJEmotionListView () <UIScrollViewDelegate>
/**
 *  显示所有页码的表情UIScrollView
 */
@property (nonatomic, weak) UIScrollView *scrollView;
/**
 *  显示页码的UIPageControl
 */
@property (nonatomic, weak) UIPageControl *pageControl;
@end
@implementation JYJEmotionListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.显示所有表情的UIScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];

        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 2.显示页码的UIPageControll
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [pageControl setValue:[UIImage imageWithName:@"compose_keyboard_dot_selected"] forKey:@"_currentPageImage"];
        [pageControl setValue:[UIImage imageWithName:@"compose_keyboard_dot_normal"] forKey:@"_pageImage"];
        [self addSubview:pageControl];
        
        self.pageControl = pageControl;
    }
    return self;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 设置总页数
    int totalPages = (emotions.count + JYJEmotionMaxCountPerPage - 1) / JYJEmotionMaxCountPerPage;
    int currentGridViewCount = self.scrollView.subviews.count;
    self.pageControl.numberOfPages = totalPages;
    self.pageControl.currentPage = 0;
    self.pageControl.hidden = totalPages <= 1;
    
    // 决定scrollView显示多少页表情
    for (int i = 0; i < totalPages; i++) {
        // 获得i位置对应的JYJEmotionGridView
        JYJEmotionGridView *gridView = nil;
        if (i >= currentGridViewCount) { // 说明JYJEmotionGridView的个数不够
            gridView = [[JYJEmotionGridView alloc] init];
            gridView.backgroundColor = JYJRandomColor;
            [self.scrollView addSubview:gridView];
        }else{ // 说明JYJEmotionGridView的个数足够，从self的scrollVIew的subview中取出JYJEmotionGridView
            gridView = self.scrollView.subviews[i];
        }
        
        // 给HMEmotionGridView设置表情数据
        int loc = i * JYJEmotionMaxCountPerPage;
        int len = JYJEmotionMaxCountPerPage;
        if ((loc + len) > emotions.count) { // 对越界进行判断处理
            len = emotions.count - loc;
        }
        NSRange gridViewEmotionsRange = NSMakeRange(loc, len);
        NSArray *gridViewEmotions = [emotions subarrayWithRange:gridViewEmotionsRange];
        gridView.emotions = gridViewEmotions;
        gridView.hidden = NO;
    }
    // 隐藏后面不需要用到的gridView
    for (int i = totalPages; i < currentGridViewCount; i++) {
        JYJEmotionGridView *gridView = self.scrollView.subviews[i];
        gridView.hidden = YES;
    }
    
    // 重新布局子控件
    [self setNeedsLayout];
    
    // 表情滚动到最前面
    self.scrollView.contentOffset = CGPointZero;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 1.UIPageControl的frame
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.y = self.height - self.pageControl.height;
    
    // 2.UIScrollView的frame
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    
    // 3.设置scrollView内部的控件尺寸
    int count = self.pageControl.numberOfPages;
    
    CGFloat gridW = self.scrollView.width;
    CGFloat gridH = self.scrollView.height;
    self.scrollView.contentSize = CGSizeMake(gridW * count, 0);
    for (int i = 0; i < count; i++) {
        JYJEmotionGridView *gridView = self.scrollView.subviews[i];
        gridView.width = gridW;
        gridView.height = gridH;
        gridView.x = i *gridW;
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.width + 0.5);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
