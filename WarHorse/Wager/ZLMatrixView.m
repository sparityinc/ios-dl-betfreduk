//
//  ZLMatrixView.m
//  OddsMatrix
//
//  Created by Sparity on 08/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLMatrixView.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLMatrixCell.h"
#import "WarHorseSingleton.h"
#import "ZLAppData.h"
#import "ZLAppDelegate.h"

#define PADDING 5
#define SHADOW_HEIGHT 1

@interface ZLMatrixView ()
{
    UIScrollView *topScrollView;
    UIScrollView *leftScrollView;
    UIScrollView *contentScrollView;
    int numberOfRows;
    CGFloat cellWidth;
    CGFloat cellHeight;
    int numberOfColumn;
}
@end

@implementation ZLMatrixView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate tag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tag = tag;
        self.delegate = delegate;
        [self setUpSubViews];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}

//- (void) awakeFromNib {
//    [super awakeFromNib];
//    [self setUpSubViews];
//}

- (void) setUpSubViews
{
    [self setBackgroundColor:[UIColor colorWithRed:243.0/255 green:243.0/255 blue:243.0/255 alpha:1.0]];
    numberOfRows = (int)[self.delegate numberOfRowsInMatrixView:self];
    numberOfColumn = (int)[self.delegate numberOfColumnsInMatrixView:self];
    
    if ([self.delegate respondsToSelector:@selector(widthForCellInMatrixView:)] )
    {
        cellWidth = [self.delegate widthForCellInMatrixView:self];
    }
    else
    {
        cellWidth = 42;
    }
    
    if ([self.delegate respondsToSelector:@selector(widthForCellInMatrixView:)] )
    {
        cellHeight = [self.delegate heightForCellInMatrixView:self];
    }
    else
    {
        cellHeight = 36;
    }
    
    
    UIImageView *horseIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
   // horseIcon.image = [UIImage imageNamed:@"horse.png"];
    [self addSubview:horseIcon];
    
    if ([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EBX"]||
        [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QBX"]||
        [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QNL"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"DBL"]){
        horseIcon.image = [UIImage imageNamed:@"with.png"];
    }
    else{
        horseIcon.image = [UIImage imageNamed:@"horse.png"];
        
    }

    

    
/*
 
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
    [titleLabel setBackgroundColor:[UIColor redColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"WITH\n>"];
    [titleLabel setFont:[UIFont systemFontOfSize:12]];
    [titleLabel setNumberOfLines:2];
    [self addSubview:titleLabel];*/

    
    topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(cellWidth + PADDING, 0, self.frame.size.width - (cellWidth + PADDING), cellHeight)];
    [topScrollView setDelegate:self];
    topScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    [self addSubview:topScrollView];
    
    leftScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,cellHeight + PADDING,cellWidth, self.frame.size.height - (cellWidth + PADDING))];
    [leftScrollView setDelegate:self];
    leftScrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    [self addSubview:leftScrollView];
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(cellWidth + PADDING,cellHeight + PADDING,self.frame.size.width - (cellWidth + PADDING), self.frame.size.height - (cellWidth + PADDING))];
    contentScrollView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth);
    [contentScrollView setDelegate:self];
    [self addSubview:contentScrollView];
    
    [self setContentToTopScrollView];
    [self setContentToLeftScrollView];
    [self setContentToContentScrollView];
}


- (void) setContentToTopScrollView
{
    for (int i = 0; i < numberOfColumn; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * (cellWidth+PADDING), 0, cellWidth, cellHeight - SHADOW_HEIGHT)];
        if ([self.delegate respondsToSelector:@selector(backgroundColorCellIndex:)] )
        {
            [label setBackgroundColor:[self.delegate backgroundColorCellIndex:i]];
        }
        
        if ([self.delegate respondsToSelector:@selector(textColorCellIndex:)] )
        {
            [label setTextColor:[self.delegate textColorCellIndex:i]];
        }
        if ([self.delegate respondsToSelector:@selector(matrixView:headerForColumn:)] )
        {
            [label setText:[self.delegate matrixView:self headerForColumn:i]];
        }
        else
        {
            [label setText:[NSString stringWithFormat:@"%i",i+1]];
        }
        
        [label setTextAlignment:NSTextAlignmentCenter];
        [topScrollView addSubview:label];
        if( [label.text rangeOfString:@"\n"].location != NSNotFound || [label.text isEqualToString:@"TOTAL"] ){
            label.numberOfLines = 2.0;
            label.font = [UIFont fontWithName:@"Roboto-Light" size:10];
            [label setBackgroundColor:[UIColor colorWithRed:9/255.0 green:75.0/255.0 blue:110.0/255.0 alpha:1.0]];
            [label setTextColor:[UIColor whiteColor]];
        }
        
        CALayer* layer = [label layer];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.borderColor = [UIColor grayColor].CGColor;
        bottomBorder.borderWidth = 1;
        bottomBorder.frame = CGRectMake(0, layer.frame.size.height-SHADOW_HEIGHT, layer.frame.size.width, SHADOW_HEIGHT);
        [bottomBorder setBorderColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor];
        [layer addSublayer:bottomBorder];
        
        
    }
    
    [topScrollView setContentSize:CGSizeMake(numberOfColumn * (cellWidth + PADDING), cellHeight)];
}

- (void) setContentToLeftScrollView
{
    for (int i = 0; i < numberOfRows; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,i * (cellHeight+PADDING), cellWidth, cellHeight)];
        
        if ([self.delegate respondsToSelector:@selector(backgroundColorCellIndex:)] )
        {
            [label setBackgroundColor:[self.delegate backgroundColorCellIndex:i]];
        }
        
        if ([self.delegate respondsToSelector:@selector(textColorCellIndex:)] )
        {
            [label setTextColor:[self.delegate textColorCellIndex:i]];
        }
        
        if ([self.delegate respondsToSelector:@selector(matrixView:headerForRow:)] )
        {
            [label setText:[self.delegate matrixView:self headerForRow:i]];
        }
        else
        {
            [label setText:[NSString stringWithFormat:@"%i",i+1]];
        }
        
        
        [label setTextAlignment:NSTextAlignmentCenter];
        [leftScrollView addSubview:label];
        
        CALayer* layer = [label layer];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.borderColor = [UIColor grayColor].CGColor;
        bottomBorder.borderWidth = 1;
        bottomBorder.frame = CGRectMake(0, layer.frame.size.height-SHADOW_HEIGHT, layer.frame.size.width, SHADOW_HEIGHT);
        [bottomBorder setBorderColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor];
        [layer addSublayer:bottomBorder];
    }
    [leftScrollView setContentSize:CGSizeMake(cellWidth,numberOfRows * (cellHeight + PADDING))];
}

- (void) setContentToContentScrollView
{
    for (int j = 0; j < numberOfColumn; j++) {
        for (int i = 0; i < numberOfRows; i++) {
            ZLMatrixCell *cell = [[ZLMatrixCell alloc] initWithFrame:CGRectMake(j * (cellWidth+PADDING), i * (cellHeight + PADDING), cellWidth, cellHeight)];
            cell.delegate = self;
            cell.rowNumbar = i;
            cell.columnNumber = j;
            if ([self.delegate respondsToSelector:@selector(matrixView:titleForRow:forColumn:)] )
            {
                [cell.titleLabel setText:[self.delegate matrixView:self titleForRow:i forColumn:j]];
            }
            else
            {
                [cell.titleLabel setText:@""];
            }
            
            [contentScrollView addSubview:cell];
        }
    }
    [contentScrollView setContentSize:CGSizeMake(numberOfColumn * (cellWidth + PADDING), numberOfRows * (cellHeight + PADDING))];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [topScrollView setContentOffset:CGPointMake(contentScrollView.contentOffset.x, 0)];
    [leftScrollView setContentOffset:CGPointMake(0, contentScrollView.contentOffset.y)];
}

-(void) tapedCellWithRow:(NSUInteger) row andWIthColumn:(NSUInteger)column
{
    if ([self.delegate respondsToSelector:@selector(tapedCellWithRow:andWIthColumn:)] )
    {
        [self.delegate tapedCellWithRow:row andWIthColumn:column];
    }

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
