//
//  SPCustomDetailSelectionCell.h
//  WarHorse
//
//  Created by Ramya on 8/22/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPDetailSelection;

@interface SPCustomDetailSelectionCell : UITableViewCell

@property (strong, nonatomic) SPDetailSelection *detailSelectons;

- (void) updateViewIndex : (NSIndexPath *)indexPath;

@end
