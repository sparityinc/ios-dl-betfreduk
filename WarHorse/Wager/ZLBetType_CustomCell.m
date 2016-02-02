//
//  ZLBetType_CustomCell.m
//  WarHorse
//
//  Created by Sparity on 7/9/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLBetType_CustomCell.h"

@implementation ZLBetType_CustomCell
@synthesize betType_Label=_betType_Label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.betType_Label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        self.betType_Label.textAlignment = NSTextAlignmentCenter;
        self.betType_Label.textColor = [UIColor whiteColor];
        self.betType_Label.backgroundColor=[UIColor clearColor];
        [self.betType_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
        self.betType_Label.adjustsFontSizeToFitWidth = YES;

        [self addSubview:self.betType_Label];
    }
    return self;
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
