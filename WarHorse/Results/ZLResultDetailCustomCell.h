//
//  ZLResultDetailCustomCell.h
//  WarHorse
//
//  Created by Sparity on 7/31/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLBetResult.h"
#import "ZLTrackResults.h"

@interface ZLResultDetailCustomCell : UITableViewCell

@property (nonatomic, strong) ZLTrackResults *trackResult;
@property (nonatomic,strong) NSString *breedType;
- (void)updateViewAtIndexPath:(NSIndexPath *)indexPath;

@end
