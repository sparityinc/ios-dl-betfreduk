//
//  SPSCRChangesDetailCustomCell.h
//  WarHorse
//
//  Created by Enterpi on 23/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPSCRChangesDetail;

@interface SPSCRChangesDetailCustomCell : UITableViewCell

@property (strong, nonatomic) SPSCRChangesDetail *scrChangesDetail;
@property (assign, nonatomic) NSInteger trackIndex;


- (CGFloat) calculateHeightForRowAtIndexPath: (NSIndexPath *)indexPath;
- (void)updateViewAtIndexPath:(NSIndexPath *) indexPath;

@end
