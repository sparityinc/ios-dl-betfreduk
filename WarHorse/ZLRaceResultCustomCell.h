//
//  ZLRaceResultCustomCell.h
//  WarHorse
//
//  Created by Jugs VN on 9/29/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLTrackResults.h"

@interface ZLRaceResultCustomCell : UIView<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) ZLTrackResults *trackResult;

-(void) setup;
@end
