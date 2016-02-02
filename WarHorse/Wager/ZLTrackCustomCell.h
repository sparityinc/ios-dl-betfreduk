//
//  ZLWagerCustomCell.h
//  WarHorse
//
//  Created by Sparity on 7/8/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLTrackCustomCell : UITableViewCell
@property(nonatomic,retain) IBOutlet UILabel *raceTrack_Label;
@property(nonatomic,retain) IBOutlet UILabel *information_Label;
@property(nonatomic,retain) IBOutlet UILabel *raceNumber_Label;
@property(nonatomic,retain) IBOutlet UILabel *mtp_Label;
@property(nonatomic,retain) IBOutlet UILabel *mtp_TimeLabel;
@property (nonatomic,retain) IBOutlet UILabel *mtpNewLabel;
@property(nonatomic,retain) IBOutlet UIButton *favButton;
@property(nonatomic,retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic,retain) IBOutlet UILabel *rankLbl;
@property (nonatomic, retain) IBOutlet UIButton *videoButton;

@property (nonatomic,retain) IBOutlet UIImageView *countryFlagImg;
@end
