//
//  ZLMatrixCell.m
//  OddsMatrix
//
//  Created by Sparity on 08/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLMatrixCell.h"
#import <QuartzCore/QuartzCore.h>

#define SHADOW_HEIGHT 1

@implementation ZLMatrixCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpSubView];
    }
    return self;
}

- (void) setUpSubView
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height - SHADOW_HEIGHT)];
    [self.titleLabel setBackgroundColor:[UIColor whiteColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setTextColor:[UIColor colorWithRed:15.0/255 green:77.0/255 blue:114.0/255 alpha:1.0]];
    [self.titleLabel setMinimumScaleFactor:10.0/[UIFont labelFontSize]];
    [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    [self addSubview:self.titleLabel];
    
    CALayer* layer = [self.titleLabel layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor grayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(0, layer.frame.size.height-SHADOW_HEIGHT, layer.frame.size.width, SHADOW_HEIGHT);
    [bottomBorder setBorderColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor];
    [layer addSublayer:bottomBorder];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(tapedCellWithRow:andWIthColumn:)] )
    {
        [self.delegate tapedCellWithRow:self.rowNumbar andWIthColumn:self.columnNumber];
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
