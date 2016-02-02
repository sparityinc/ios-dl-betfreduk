//
//  AKMTPScaleView.m
//  MTPComponent
//
//  Created by Sparity on 05/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "AKMTPScaleView.h"

#define GAP_BETWEEN_CIRCLES 58

@implementation AKMTPScaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    self.y = self.frame.size.height/2 + 10;
    
    [self drawLine:context from:CGPointMake(0, self.y) to:CGPointMake(self.frame.size.width, self.y)];
    [self drawVerticalLines:context];
}


- (void) drawLine: (CGContextRef) context from: (CGPoint) from to: (CGPoint) to
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGFloat lineColor[4] = {204.0/256, 203.0/256, 209.0/256, 1.0f};
    CGContextSetStrokeColor(c, lineColor);
    CGContextSetLineWidth(c, 1);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, from.x, from.y);
    CGContextAddLineToPoint(c, to.x, to.y);
    CGContextStrokePath(c);
        
    for (int i = 1; i <= self.numberOfPages; i++) {
        
        NSString *text;
        
       if (i == self.numberOfPages)
        {
            text  = [NSString stringWithFormat:@"> %i",(i-1)*self.interval];

        }
        else
        {
            text  = [NSString stringWithFormat:@"%i - %i",(i-1)*self.interval,i*self.interval];
        }
        
        [self drawPageAtPoint:CGPointMake(i * GAP_BETWEEN_CIRCLES, self.frame.size.height/2) context:context currentPage:i string:text];
    }
}

- (void) drawPageAtPoint:(CGPoint)point context:(CGContextRef) context currentPage:(int)currentPage string:(NSString *)string
{
    [self drawString:context atPoint:point currentPage:currentPage string:string];
}

- (void) drawString: (CGContextRef) context atPoint:(CGPoint)point currentPage:(int)currentPage string:(NSString *)string
{
    
    [[UIColor colorWithRed:149.0/256 green:149.0/256 blue:149.0/256 alpha:1.0] set];
    
    CGRect rect = CGRectMake((currentPage * GAP_BETWEEN_CIRCLES) - GAP_BETWEEN_CIRCLES/2, 2, GAP_BETWEEN_CIRCLES, 26);
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    
    
   [string drawInRect:rect withFont:font lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
}

-(void) drawVerticalLines: (CGContextRef) context
{
    for (int i = 0; i <= (self.numberOfPages * 5 ); i++)
    {
        float bottomPoint = (i % 5 == 0) ? self.y : self.y + 10;
        float topPoint = (i % 5 == 0) ? self.y - 15 : self.y - 10;

        [self drawLine:context from:CGPointMake(i * GAP_BETWEEN_CIRCLES/5, topPoint) to:CGPointMake(i * GAP_BETWEEN_CIRCLES/5,bottomPoint)];

        if (i % 5 == 0 & i !=0)
        {
            [self drawCircle:context center:CGPointMake(i * GAP_BETWEEN_CIRCLES/5, self.y) currentPage:i/5];
        }
    }
}

- (void) drawCircle: (CGContextRef) context center:(CGPoint)center currentPage:(NSInteger)currentPage
{
    float red = 169.0/256;
    float green = 169.0/256;
    float blue = 169.0/256;
    if (self.selectedPage == currentPage) {
        red = 20.0/256;
        green = 127.0/256;
        blue = 199.0/256;
    }
    
    //set the fill or stroke color
    CGContextSetRGBFillColor(context, red, green, blue, 1.0);
    CGContextSetRGBStrokeColor(context, red, green, blue, 1.0);
    
    //fill or draw the path
    CGContextDrawPath(context, kCGPathStroke);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextAddArc(context, center.x, center.y, 6, 0, 20, 0);
    
    //set the fill or stroke color
    CGContextSetRGBFillColor(context, red, green, blue, 1.0);
    CGContextSetRGBStrokeColor(context, red, green, blue, 1.0);
    //fill or draw the path
    CGContextDrawPath(context, kCGPathStroke);
    CGContextDrawPath(context, kCGPathFill);
    
    
    
    CGContextAddArc(context, center.x, center.y, 2, 0, 20, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
