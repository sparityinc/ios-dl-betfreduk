//
//  SPLiveVideoTableCell.h
//  WarHorse
//
//  Created by Ramya on 10/1/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SPLiveVideoTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIButton *playVideoBtn;

- (void) updateViewAtIndexPath: (NSIndexPath *)indexPath;

@end
