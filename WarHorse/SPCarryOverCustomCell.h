//
//  SPCarryOverCustomCell.h
//  WarHorse
//
//  Created by Ramya on 8/20/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPCarryOver;

@interface SPCarryOverCustomCell : UITableViewCell

@property (strong, nonatomic) SPCarryOver *carryOver;

- (void) updateViewAtIndexPath: (NSIndexPath *)indexPath;


@end
