//
//  ZLCalendarScrollView.m
//  WarHorse
//
//  Created by Sparity on 02/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLCalendarScrollView.h"

@interface ZLCalendarScrollView()

@end

@implementation ZLCalendarScrollView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.selectedDate = [NSDate date];
        self.delegate = nil;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.selectedDate = [NSDate date];
    }
    return self;
}


- (void) setUpSubView
{
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"topbar_belowshadow.png"]]];
    
    CGFloat lineHeight = 4;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/3, self.frame.size.height - lineHeight, self.frame.size.width/3, lineHeight)];
    [line setBackgroundColor:[UIColor colorWithRed:67.0/255 green:160.0/255 blue:201.0/255 alpha:1.0]];
    [self addSubview:line];
    line = nil;
    
    self.dateFormater = [[NSDateFormatter alloc] init];
    [self.dateFormater setDateFormat:@"dd MMM yyyy"];
    
    self.dateLabelsArray = [[NSMutableArray alloc] init];
    
    if( self.scrollView ){
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	[self.scrollView setContentSize:CGSizeMake(5 * self.scrollView.frame.size.width/3, self.scrollView.frame.size.height)];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width/3, 0)];
	[self.scrollView setPagingEnabled:NO];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
	[self.scrollView setDelegate:self];
	
	for (int i = 0; i < 5; i++)
    {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * (self.scrollView.frame.size.width/3), 0, self.scrollView.frame.size.width/3, self.scrollView.frame.size.height)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        if (i == 2)
        {
            [label setTextColor:[UIColor whiteColor]];
        }
        else
        {
        [label setTextColor:[UIColor colorWithRed:136.0/255 green:136.0/255 blue:136.0/255 alpha:1.0]];
        }
        [label setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
        [self.dateLabelsArray addObject:label];
		[self.scrollView addSubview:label];
        
	}
	[self addSubview:self.scrollView];
    

    [self setDatesToLabels];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scrollView addGestureRecognizer:singleTap];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGPoint touchPoint=[gesture locationInView:self.scrollView];
                         
                         if (touchPoint.x <= (self.scrollView.frame.size.width/3) * 2)
                         {
                             [self.scrollView setContentOffset:CGPointMake(0, 0)];
                             self.selectedDate = [NSDate dateWithTimeInterval:-24 * 60 *60 sinceDate:self.selectedDate];
                         }
                         else if (touchPoint.x >= (self.scrollView.frame.size.width/3) * 3)
                         {
                             NSDate * date = [NSDate dateWithTimeInterval:24 * 60 *60 sinceDate:self.selectedDate];
                             if( [date timeIntervalSinceDate:[NSDate date]] <= 0){
                                 [self.scrollView setContentOffset:CGPointMake((self.frame.size.width/3) *2, 0)];
                                 self.selectedDate = [NSDate dateWithTimeInterval:24 * 60 *60 sinceDate:self.selectedDate];
                             }
                             else{
                                 
                             }
                         }
                     }
                     completion:^(BOOL finished){
                         [self finishedAnimation];
                     }];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self handleLabelAnimation];
    }
}

- (void) finishedAnimation
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width/3, 0)];
    [self setDatesToLabels];
    if( delegate != nil){
        [self.delegate dateDidChange];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    [self handleLabelAnimation];
}

- (void) handleLabelAnimation
{
  
        if (self.scrollView.contentOffset.x < self.frame.size.width/3)
         {
             [self.scrollView setContentOffset:CGPointMake(0, 0)];
             self.selectedDate = [NSDate dateWithTimeInterval:-24 * 60 *60 sinceDate:self.selectedDate];
             if( delegate != nil){
                 [self.delegate dateDidChange];
             }
         }
         else if (self.scrollView.contentOffset.x > self.frame.size.width/3)
         {
             NSDate * date = [NSDate dateWithTimeInterval:24 * 60 *60 sinceDate:self.selectedDate];
             if( [date timeIntervalSinceDate:[NSDate date]] <= 0){
                [self.scrollView setContentOffset:CGPointMake((self.frame.size.width/3) *2, 0)];
                 self.selectedDate = [NSDate dateWithTimeInterval:24 * 60 *60 sinceDate:self.selectedDate];
                 if( delegate != nil){
                     [self.delegate dateDidChange];
                 }
             }
             else{
                 [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width/3, 0)];
             }
         }
     
         [self finishedAnimation];
    
    
    //[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(finishedAnimation) userInfo:nil repeats:NO];
}

- (void) setDatesToLabels
{
    int day = -2;
    
    for (UILabel *label in self.dateLabelsArray) {
        NSDate * date = [NSDate dateWithTimeInterval:day * 24 * 60 * 60 sinceDate:self.selectedDate];
        if( [date timeIntervalSinceDate:[NSDate date]] > 0){
            [label setText:@""];
        }
        else{
            [label setText:[self.dateFormater stringFromDate:date]];
        }
        day ++;
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
