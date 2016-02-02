//
//  SPScrollView.h
//  WarHorse
//
//  Created by Ramya on 8/25/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPDate;
@interface SPScrollView : UIView

@property (strong, nonatomic) SPDate *date;

- (void)updateView;

@end
