//
//  ZLMainTileCell.m
//  WarHorse
//
//  Created by Sparity on 7/5/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLMainTileCell.h"

@implementation ZLMainTileCell
@synthesize iconImageView=_tileImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 36, 36)];
        self.iconImageView.center = CGPointMake(frame.size.width/2, frame.size.height/2 - 9);
        
        [self.iconImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.iconImageView setAutoresizingMask: UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
        [self addSubview:self.iconImageView];
        
        
        self.badgeButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 30, 5.0, 25, 25)];
        self.badgeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.badgeButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
        self.badgeButton.titleLabel.textColor = [UIColor whiteColor];
        self.badgeButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
        [self addSubview:self.badgeButton];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconImageView.frame.origin.y+self.iconImageView.frame.size.height + 4, frame.size.width, 25)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleLabel setAutoresizingMask: UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];

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
