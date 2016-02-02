//
//  SPScrollTrackView.h
//  WarHorse
//
//  Created by Ramya on 8/23/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPTrackDetails;
@class SPSelections;

@interface SPScrollTrackView : UIView

@property (strong, nonatomic) SPTrackDetails *trackDetails;
@property (strong, nonatomic) SPSelections *sectionsDetails;
- (void)updateView;

@end
