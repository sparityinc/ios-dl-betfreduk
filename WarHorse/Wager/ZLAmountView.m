//
//  ZLAmountView.m
//  AmountSelectionComponent
//
//  Created by Sparity on 17/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLAmountView.h"
#import <QuartzCore/QuartzCore.h>

#define NO_OF_ITEMS_VIEW 5
#define ROW_HEIGHT 43


@implementation ZLAmountView

- (id)initWithFrame:(CGRect)frame delegate:(id)deleage
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.delegate = deleage;
        [self setupSubViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self)  {
        [self setupSubViews];
    }
    
    return (self);
}

- (void) setupSubViews
{
    [self setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]];
    
    CGFloat y = [self.delegate yValueToStart];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, 82)];
    //[bgImageView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [bgImageView setImage:[UIImage imageNamed:@"tramsparent.png"]];
    [self addSubview:bgImageView];
    bgImageView=nil;
    
    int topItems = (NO_OF_ITEMS_VIEW/2);
    backgroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 0, 156, ROW_HEIGHT * NO_OF_ITEMS_VIEW)];
    
    [backgroundView setCenter:CGPointMake(157, 20+(y + backgroundView.frame.size.height/2) - (topItems * ROW_HEIGHT))];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:67.0/255 green:66.0/255 blue:66.0/255 alpha:0.9]];
    backgroundView.layer.borderColor = [UIColor colorWithRed:0.062745 green:0.062745 blue:0.062745 alpha:1.0].CGColor;
    backgroundView.layer.borderWidth = 2.0;
    [self addSubview:backgroundView];
    
    selectionView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backgroundView.frame.size.width, ROW_HEIGHT)];
    [selectionView setCenter:CGPointMake(backgroundView.frame.size.width/2, backgroundView.frame.size.height/2)];
    [selectionView setImage:[UIImage imageNamed:@"blue_transparent.png"]];
    [backgroundView addSubview:selectionView];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, backgroundView.frame.size.width, backgroundView.frame.size.height)];
    [scrollView setDelegate:self];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [backgroundView addSubview:scrollView];
    
    [self loadAmountsInScrollView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)s willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        int y = (int)round([scrollView contentOffset].y/ROW_HEIGHT);
        self.selectRow = y;
        //[scrollView setContentOffset:CGPointMake(0, y*ROW_HEIGHT)];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)s{
    int y = (int)round([scrollView contentOffset].y/ROW_HEIGHT);
    self.selectRow = y;
    //[scrollView setContentOffset:CGPointMake(0, y*ROW_HEIGHT)];
    [self.delegate selectedRowWithIndex:y];
}

- (void) loadAmountsInScrollView:(UIScrollView *) s;
{
    NSUInteger numberOfItems = [self.delegate numberOfItems];
    
    CGFloat heightToScroll = (2 * selectionView.frame.origin.y) + (numberOfItems * selectionView.frame.size.height);
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, heightToScroll)];
    
    CGFloat y = selectionView.frame.origin.y;
    for (int i = 0; i < numberOfItems; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y + (i* selectionView.frame.size.height), selectionView.frame.size.width-20, selectionView.frame.size.height)];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont boldSystemFontOfSize:16]];
        [label setText:[self.delegate titleForItem:i]];
        [label setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:label];        
    }
}

- (void) setSelectRow:(NSUInteger)selectRow
{
    _selectRow = selectRow;
    [scrollView setContentOffset:CGPointMake(0, selectRow * ROW_HEIGHT)];
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
