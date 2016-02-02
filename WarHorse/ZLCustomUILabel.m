//
//  ZLCustomUILabel.m
//  WarHorse
//
//  Created by Enterpi on 17/09/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLCustomUILabel.h"

@implementation ZLCustomUILabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 0, 0, 3};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
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
