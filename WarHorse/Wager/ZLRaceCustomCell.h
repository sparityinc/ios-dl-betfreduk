//
//  ZLRaceCustomCell.h
//  WarHorse
//
//  Created by Sparity on 7/8/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLRaceCustomCell : UITableViewCell
@property(nonatomic,retain) IBOutlet UILabel *raceNumberLabel;
@property(nonatomic,retain) IBOutlet UILabel *trackLabel;
@property(nonatomic,retain) IBOutlet UILabel *furlongLabel;
@property(nonatomic,retain) IBOutlet UILabel *mtpLabel;
@property(nonatomic,retain) IBOutlet UILabel *amountLabel;
@property(nonatomic,retain) IBOutlet UILabel *statusLabel;
@property(nonatomic,retain) IBOutlet UIImageView *backgroundImage;

@end
