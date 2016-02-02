//
//  ZLResultTrackDetailScrollContainer.m
//  WarHorse
//
//  Created by Sparity on 7/31/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLResultTrackDetailScrollContainer.h"

@implementation ZLResultTrackDetailScrollContainer

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return __scrollView;
    }
    return view;
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
