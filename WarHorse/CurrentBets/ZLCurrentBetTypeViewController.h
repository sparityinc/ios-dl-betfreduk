//
//  ZLCurrentBetTypeViewController.h
//  WarHorse
//
//  Created by Sparity on 11/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class ZLCurrentBetCustomCell;

@protocol ZLCurrentBetTypeViewControllerProtocol <NSObject>

@optional
- (void)filterTracksBasedonMTPValueofSelectedPage:(NSInteger)selectedPage;
- (void)cancelBetForSender:(id)sender;

@end

@interface ZLCurrentBetTypeViewController : UIViewController <UIScrollViewDelegate,ZLCurrentBetTypeViewControllerProtocol,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) IBOutlet UITableView *wagerTableView;
@property(strong,nonatomic)  MPMoviePlayerController *moviePlayer;
@property(nonatomic,retain) IBOutlet UIButton *wager_Button;
@property(nonatomic,retain) IBOutlet UIButton *wagerBtn;
@property(nonatomic,retain) IBOutlet UIButton *video_Button;
@property(nonatomic,retain) IBOutlet UIButton *cancel_Button;
@property(nonatomic,retain) IBOutlet ZLCurrentBetCustomCell *currentBetCustomCell;
@property(nonatomic,retain) NSMutableArray *wagerArray;
@property(nonatomic,retain) IBOutlet UIButton *back_Button;
@property(nonatomic,retain) IBOutlet UIButton *settings_Button;
@property (strong, nonatomic) IBOutlet UIButton * settingsButton;
@property(nonatomic,retain) IBOutlet UIScrollView *_scrollView;
//@property(nonatomic,retain) IBOutlet UILabel *currentbet_Label;
@property(nonatomic,retain) UIView *backGroundView;

//colorviewLabels
@property(nonatomic,retain)  UILabel *totalBetLabel;
@property(nonatomic,retain)  UILabel *resultLabel;
@property(nonatomic,retain)  UILabel *amountLabel;
@property(nonatomic,retain)  UILabel *dollarLabel;
@property(nonatomic,retain) UILabel *mtp_Label;
@property(nonatomic,retain) UILabel *yearLable;

@property (nonatomic, strong) IBOutlet UIButton *amountButton;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton *toggleButton;
@property(nonatomic,retain) IBOutlet UIButton *inPlayBtn;
@property(nonatomic,retain)IBOutlet UIButton *finalBtn;
@property(nonatomic,retain)UIButton *tagButton;
@property(nonatomic,retain)  IBOutlet UIButton *resultButton;
@property(nonatomic,retain)  IBOutlet UIButton *replayButton;

@property (nonatomic,retain) IBOutlet UIButton *calenderBtn;
@property (nonatomic,strong) IBOutlet UIButton *refreshBtn;

-(IBAction)playClicked:(UIButton *)button;
-(IBAction)rePlayClicked:(UIButton *)button;

- (IBAction)amountButtonClicked:(id)sender;
- (IBAction)wagerButtonClicked:(id)sender;

-(IBAction)settings_Clicked:(id)sender;
-(IBAction)video_Clicked:(id)sender;
-(IBAction)cancel_Clicked:(id)sender;
-(IBAction)back_Clicked:(id)sender;
-(IBAction)refresh_Clicked:(id)sender;
-(IBAction)toggleInPlaySortClicked:(id)sender;


@end
