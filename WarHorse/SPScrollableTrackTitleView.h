//
//  SPScrollableTrackTitleView.h
//  WarHorse
//
//  Created by Enterpi on 23/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPSCRChanges;

@interface SPScrollableTrackTitleView : UIView

@property (strong, nonatomic) SPSCRChanges *scrChanges;
@property (assign, nonatomic) BOOL isSCRChanges;


- (void)updateView;

@end
