//
//  ZLAmount_CustomCell.m
//  WarHorse
//
//  Created by Sparity on 7/9/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLAmount_CustomCell.h"

@implementation ZLAmount_CustomCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        [self addSubview:self.backgroundImage];
        
        self.amount_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.0, frame.size.width, frame.size.height)];
        self.amount_Label.textAlignment = NSTextAlignmentCenter;
        self.amount_Label.backgroundColor = [UIColor clearColor];
        [self.amount_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:18]];
        [self addSubview:self.amount_Label];

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
