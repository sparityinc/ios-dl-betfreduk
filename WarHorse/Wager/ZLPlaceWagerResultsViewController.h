//
//  ZLConformationViewController.h
//  WarHorse
//
//  Created by Sparity on 13/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZLPlaceWagerResultsViewControllerDelegate <NSObject>

- (void) newWager;
- (void) repeatWager;
- (void) loadCurrentBets;
- (void) repeatWagerOnSameRace;
- (void) gotoTracks;

@end

@interface ZLPlaceWagerResultsViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *raceNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *trackNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *leftPriseLabel;
@property (nonatomic, strong) IBOutlet UILabel *betTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel *runnersLabel;
@property (nonatomic, strong) IBOutlet UILabel *amountLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberOfBetsLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalAmountLabel;
@property (nonatomic, strong) IBOutlet UIButton *buttonRepeat;
@property (nonatomic, strong) IBOutlet UIButton *buttonNew;
@property (nonatomic, strong) IBOutlet UIButton *buttonBetSameRace;
@property (nonatomic, strong) IBOutlet UIButton *buttonGoToTrack;
@property (nonatomic, strong) IBOutlet UIButton *buttonVideo;
@property (nonatomic, strong) IBOutlet UIButton *buttonCurrentBets;

@property (nonatomic, strong) IBOutlet UILabel *totalLabel;
@property (nonatomic, strong) IBOutlet UILabel *bottomDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *idLabel;

@property (nonatomic, assign) id delegate;

- (IBAction)newWagerButtonClicked:(id)sender;
- (IBAction)repeatWagerButtonClicked:(id)sender;
- (IBAction)currentBetsButtonClicked:(id)sender;
- (IBAction)betSameRaceButtonClicked:(id)sender;
- (IBAction)goToTrackButtonClicked:(id)sender;
- (IBAction)videoButtonClicked:(id)sender;

@end
