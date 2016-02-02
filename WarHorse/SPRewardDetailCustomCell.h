//
//  SPRewardDetailCustomCell.h
//  WarHorse
//
//  Created by Enterpi on 23/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPRewards;

@interface SPRewardDetailCustomCell : UITableViewCell

@property (nonatomic, strong) SPRewards *rewards;

- (void) updateHeaderInsection: (NSInteger) section;
- (void) updateViewAtIndexPath:(NSIndexPath *)indexPath;

@end
