//
//  SPTodaysTrackCell.h
//  WarHorse
//
//  Created by Sparity on 22/01/14.
//  Copyright (c) 2014 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPTodaysTrackCell : UITableViewCell


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
