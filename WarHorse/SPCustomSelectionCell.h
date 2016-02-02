//
//  SPCustomSelectionCell.h
//  WarHorse
//
//  Created by Ramya on 8/22/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPSelections;

@interface SPCustomSelectionCell : UITableViewCell

@property (strong, nonatomic) SPSelections *selections;

- (void) updateViewIndex : (NSIndexPath *)indexPath;

@end
