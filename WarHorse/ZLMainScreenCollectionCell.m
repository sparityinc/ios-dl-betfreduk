//
//  ZLMainScreenCollectionCell.m
//  WarHorse
//
//  Created by Sparity on 30/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLMainScreenCollectionCell.h"

@implementation ZLMainScreenCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10.5, 7.5, 22, 22)];
        
        [self.iconImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.iconImageView];
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(41, 11.5, frame.size.width-41, 16)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        
        
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
