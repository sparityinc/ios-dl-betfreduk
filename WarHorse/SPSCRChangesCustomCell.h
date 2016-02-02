//
//  SPSCRChangesCustomCell.h
//  WarHorse
//
//  Created by Enterpi on 22/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPSCRChanges;

@interface SPSCRChangesCustomCell : UITableViewCell

@property (strong, nonatomic) SPSCRChanges *scrChanges;

- (void) updateViewAtIndexPath: (NSIndexPath *)indexPath;

@end
