//
//  AKMTPControl.m
//  MTPComponent
//
//  Created by Sparity on 05/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "AKMTPControl.h"

#define GAP_BETWEEN_CIRCLES 58

@implementation AKMTPControl

@synthesize scaleView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:243.0/256 green:243.0/256 blue:243.0/256 alpha:1.0]];
        
        self.minValue = 0;
        self.maxValue = 70;
        self.interval = 10;
        self.numberOfPages = (self.maxValue - self.minValue) / self.interval;
        
        [self setContentSize:CGSizeMake((self.numberOfPages * GAP_BETWEEN_CIRCLES) + (GAP_BETWEEN_CIRCLES/2), 0)];
        [self setShowsHorizontalScrollIndicator:NO];
        
        
        scaleView = [[AKMTPScaleView alloc] initWithFrame:CGRectMake(0, 0, (self.numberOfPages * GAP_BETWEEN_CIRCLES) + (GAP_BETWEEN_CIRCLES/2), self.frame.size.height)];
        scaleView.numberOfPages = self.numberOfPages;
        scaleView.interval = self.interval;
        scaleView.minValue = self.minValue;
        scaleView.maxValue = self.maxValue;
        [scaleView setBackgroundColor:self.backgroundColor];
        [self addSubview:scaleView];
        
    }
    return self;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    scaleView.selectedPage = (int) ((touchPoint.x + GAP_BETWEEN_CIRCLES/2) / GAP_BETWEEN_CIRCLES);
    [self.currentBetTypeDelegate filterTracksBasedonMTPValueofSelectedPage:scaleView.selectedPage];
    
    [scaleView setNeedsDisplay];
    
}

- (void)setMTPSelectedForPage:(NSInteger)selectedPage
{
    scaleView.selectedPage = selectedPage;
    [scaleView setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //[myCustomView setNeedsDisplay];
    
}


@end
