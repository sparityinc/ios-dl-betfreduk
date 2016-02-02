//
//  ZLCurrentBetTypeViewController.m
//  WarHorse
//
//  Created by Sparity on 7/11/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLCurrentBetTypeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AKMTPControl.h"
#import "ZLAppDelegate.h"
#import "ZLAPIWrapper.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"
#import "ZLCurrentBetCustomCell.h"
#import "ZLMyBetsSettingsViewController.h"

//#import "ZLBetTransaction.h"
//#import "ZLMyBets.h"
//#import "ZLMyBetTrackDetails.h"
//#import "ZLMyBetRaceDetails.h"

#define LabelHeight 20

static NSString *const kcurrentBetCustomCellIdentifier = @"currentBetCustomCellIdentifier";
static NSString *const kcurrentBetCustomCellNib = @"ZLCurrentBetCustomCell";

@interface ZLCurrentBetTypeViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (assign) BOOL inPlay;

@property (nonatomic, strong) NSDate * selectedDate;

@property (nonatomic, strong) NSMutableDictionary * selectedRaceDetail;

@property (nonatomic, strong) NSMutableArray * resultLabels;

@property (nonatomic, strong) NSMutableArray * dollarLabels;

@property (nonatomic, strong) AKMTPControl *mtpControl;
@property (nonatomic, strong) NSMutableArray *backgroundImagesArray;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIToolbar *pickerToolBar;


@property (strong, nonatomic) UIWebView *webview;
@property (strong, nonatomic) UIButton *closeMediaPlayerButton;
@property (strong, nonatomic) IBOutlet UILabel *noRaceLabel;

@property (strong, nonatomic) NSMutableDictionary *myBetsDataDic;

@property (strong, nonatomic) NSMutableArray *myTransactionsArray;

@property (assign, nonatomic) NSInteger selectedPage;

@property (assign, nonatomic) NSInteger currentRace;

@property (strong, nonatomic) NSDateFormatter *myBetsDateFormatter;

@property (strong, nonatomic) NSIndexPath *deleteBetIndexpath;

@property (strong, nonatomic) IBOutlet UIButton *home_Button;

@property (strong, nonatomic) UITapGestureRecognizer *singleTapGestureRecognizer;

@property (assign, nonatomic) NSInteger totalBets;

@property (assign, nonatomic) double totalAmount;

@property(assign) BOOL inPlaySortMTP;

@property(assign) BOOL menuShowing;

@property (strong, nonatomic) UILabel *mtpLabel;

@property (nonatomic, weak) IBOutlet UIView *scrollViewContainer;

@property (nonatomic, weak) IBOutlet UIImageView *lineImageView;

@property (strong, nonatomic) NSTimer * myBetsRefreshTimer;

@property (nonatomic, strong) UITapGestureRecognizer *singletapGestureRecognizer;

@property(nonatomic, retain) ZLMyBetsSettingsViewController * trackSettingsView;
@property (nonatomic,strong) NSString *dateStr;
@property (nonatomic,strong) IBOutlet UIButton *startWageringBtn;
@property (strong, nonatomic) UIView *datePickerView;
- (IBAction)goToHome:(id)sender;

@end

@implementation ZLCurrentBetTypeViewController
@synthesize wagerTableView=_wagerTableView;
@synthesize moviePlayer=_moviePlayer;
@synthesize currentBetCustomCell=_currentBetCustomCell;
@synthesize _scrollView;
@synthesize backGroundView=_backGroundView;
@synthesize tagButton=_tagButton;
@synthesize resultButton=_resultButton;
@synthesize replayButton=_replayButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.inPlay = YES;
        self.menuShowing = NO;
        self.totalAmount = 0.0;
        self.totalBets = 0;
        self.inPlaySortMTP = NO;
        self.selectedDate = [NSDate date];
        self.dollarLabels = [NSMutableArray array];
        self.resultLabels = [NSMutableArray array];
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceUpdated:) name:@"BalanceUpdated" object:nil];
    }
    return self;
}

#pragma mark - ViewLifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.startWageringBtn.layer.borderWidth = 0.5;
    self.startWageringBtn.layer.borderColor = [UIColor colorWithRed:2.0/255 green:55.0/255 blue:84.0/255 alpha:1.0].CGColor;

    self.calenderBtn.enabled = NO;
    self.calenderBtn.userInteractionEnabled = NO;
    
    self.trackSettingsView = [[ZLMyBetsSettingsViewController alloc] init];
    self.trackSettingsView.view.frame = CGRectMake(0.0, 0, 114.0, 83);
    [self.trackSettingsView.sortByMTPButton addTarget:self action:@selector(toggleInPlaySortClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.trackSettingsView.sortByMTPButton.tag = 1;
    
    [self.trackSettingsView.sortByBetTime addTarget:self action:@selector(toggleInPlaySortClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.trackSettingsView.sortByBetTime.tag = 2;
    
    self.singletapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingsButtonSelected:)];
    [self.singletapGestureRecognizer setEnabled:NO];
    [self.view addGestureRecognizer:self.singletapGestureRecognizer];
    
    self.backgroundImagesArray=[[NSMutableArray alloc] initWithCapacity:0];

    self.myBetsDataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.myTransactionsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.deleteBetIndexpath = [[NSIndexPath alloc] init];
    
    self.selectedPage = 0;
    self.currentRace = 0;
    self.wagerTableView.tag = 1001;
    
    self.navigationController.navigationBarHidden = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    self.dateStr = [formatter stringFromDate:[NSDate date]];
    
    
    
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                        [self prepareTopView];
                   });
    
    _tagButton=[[UIButton alloc] init];
    
    [self.inPlayBtn setTitle:@"IN-PLAY" forState:UIControlStateNormal];
    
    [self.resultButton setImage:[UIImage imageNamed:@"myBetsReplay.png"] forState:UIControlStateNormal];
    [self.resultButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.view addSubview:self.resultButton];
    [self.resultButton setHidden:YES];

    [self.replayButton setImage:[UIImage imageNamed:@"myBetsResults.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.replayButton];
    [self.replayButton setHidden:YES];
    
    self.inPlayBtn.layer.borderWidth = 1;
    self.inPlayBtn.layer.borderColor = [UIColor colorWithRed:6.0/255 green:55.0/255 blue:86.0/255 alpha:1.0].CGColor;
    
    self.finalBtn.layer.borderWidth = 1;
    self.finalBtn.layer.borderColor = [UIColor colorWithRed:126.0/255 green:126.0/255 blue:126.0/255 alpha:1.0].CGColor;
    
    self.mtpControl = [[AKMTPControl alloc] initWithFrame:CGRectMake(0, 109, 320, 47)];
    self.mtpControl.currentBetTypeDelegate = self;
    [self.mtpControl setMTPSelectedForPage:1];
    [self.view addSubview:self.mtpControl];
    
     self.mtpLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, 114, 34, 16)];
    [self.mtpLabel setTransform:CGAffineTransformMakeRotation(-M_PI_2 )];
    [self.mtpLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.mtpLabel setText:@"MTP"];
    [self.mtpLabel setTextAlignment:NSTextAlignmentCenter];
    [self.mtpLabel setTextColor:[UIColor whiteColor]];

    [self.mtpLabel setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.mtpLabel];
    
    [self.noRaceLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15.0]];
    
    _backGroundView=[[UIView alloc]initWithFrame:CGRectMake(self.wagerTableView.frame.origin.x, self.wagerTableView.frame.origin.y, self.wagerTableView.frame.size.width, self.wagerTableView.frame.size.height)];
    
    _scrollView.tag = 10001;
    _scrollView.delegate = self;
    _scrollView.clipsToBounds = NO;
    _scrollView.pagingEnabled = YES;
	_scrollView.showsHorizontalScrollIndicator = NO;
    
    self.singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [_scrollView addGestureRecognizer:self.singleTapGestureRecognizer];
    
    [self.wagerTableView.layer setBorderColor:[[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0] CGColor]];
    [self.wagerTableView.layer setBorderWidth:1.0];

    [self.wagerTableView registerNib:[UINib nibWithNibName:kcurrentBetCustomCellNib bundle:nil] forCellReuseIdentifier:kcurrentBetCustomCellIdentifier];
    
    [self playClicked:self.inPlayBtn];
    
    //[self loadDataForDate:[NSDate date] withHud:YES];
   
    self.mtpLabel.hidden = YES;
    self.mtpControl.hidden = YES;
    self.video_Button.enabled = NO;
//    self.lineImageView.hidden = YES;
    self.mtp_Label.hidden = YES;
}

- (IBAction)refresh_Clicked:(id)sender
{
    
    [self.mtpControl setMTPSelectedForPage:1];
    [self loadDataForDate:self.selectedDate withHud:YES flagStr:@"final"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


-(void)viewDidUnload
{
    self.wagerTableView=nil;
    self.moviePlayer=nil;
    self.backGroundView=nil;
    self.wager_Button=nil;
    self.video_Button=nil;
    self.cancel_Button=nil;
    self.currentBetCustomCell=nil;
    self.back_Button=nil;
    self.settings_Button=nil;
    self._scrollView=nil;
    self.amountButton=nil;
    self.currentBetCustomCell.amountDollar_Label=nil;
    self.currentBetCustomCell.betDollar_Label=nil;
    self.currentBetCustomCell.betType_Label=nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) toggleInPlaySortClicked:(UIButton*)sender{
    
    if( sender.tag == 1 && self.inPlaySortMTP){
        return;
    }
    else if( sender.tag == 2 && !self.inPlaySortMTP){
        return;
    }
    self.inPlaySortMTP = !self.inPlaySortMTP;
    if( !self.inPlaySortMTP ){
        self.trackSettingsView.sortByBetTime.selected = YES;
        self.trackSettingsView.sortByMTPButton.selected = NO;
        NSSortDescriptor * MTPSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tpasTimestamp" ascending:NO];
        NSArray *MTPDescriptor = [NSArray arrayWithObject:MTPSortDescriptor];
        self.myTransactionsArray = [NSMutableArray arrayWithArray:[self.myTransactionsArray sortedArrayUsingDescriptors:MTPDescriptor]];
        
        
        self.mtpLabel.hidden = YES;
        self.mtpControl.hidden = YES;
        self.lineImageView.hidden = YES;
        self.mtp_Label.hidden = YES;
        
    }
    else {
        
        self.mtpLabel.hidden = NO;
        self.mtpControl.hidden = NO;
        self.lineImageView.hidden = NO;
        self.mtp_Label.hidden = NO;

        self.trackSettingsView.sortByMTPButton.selected = YES;
        self.trackSettingsView.sortByBetTime.selected = NO;
        NSSortDescriptor * MTPSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"MTP" ascending:YES];
        NSArray *MTPDescriptor = [NSArray arrayWithObject:MTPSortDescriptor];
        self.myTransactionsArray = [NSMutableArray arrayWithArray:[self.myTransactionsArray sortedArrayUsingDescriptors:MTPDescriptor]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self prepareViewForFilteredTracks:self.myTransactionsArray];
        if (self.selectedPage != 0) {
            [self filterTracksBasedonMTPValueofSelectedPage:self.selectedPage];
        }
    });
    [self settingsButtonSelected:nil];
}

- (IBAction)settingsButtonSelected:(id)sender
{
    
    if(!self.menuShowing) {
        self.menuShowing = YES;

        [self.settingsButton setBackgroundColor:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
        [self.view addSubview:self.trackSettingsView.view];
        self.trackSettingsView.view.frame = CGRectMake(215.0, 100.0, 109.0, 1.0);
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.trackSettingsView.view.frame = CGRectMake(215.0, 100.0,114, 83);
        } completion:^(BOOL finished) {
            
        }];
        
        [self.singletapGestureRecognizer setEnabled:YES];
    }
    else{
        [self.settingsButton setBackgroundColor:[UIColor clearColor]];
        [self.trackSettingsView.view removeFromSuperview];
        [self.singletapGestureRecognizer setEnabled:NO];
        self.menuShowing = NO;

    }
    //self.menuShowing = !self.menuShowing;
}

#pragma mark - Private API

-(void) setupViewAfterDataLoad{
    
    
    self.dollarLabels = [NSMutableArray array];
    self.resultLabels = [NSMutableArray array];
    
    self.myTransactionsArray = nil;
    if( self.inPlay == YES ){
        self.myTransactionsArray = [self.myBetsDataDic mutableArrayValueForKey:@"inPlay"];
        if( self.myTransactionsArray == nil ){
            self.myTransactionsArray = [NSMutableArray array];
        }
        NSMutableArray * myBets = [NSMutableArray array];
        
        for( NSDictionary * raceDetail in self.myTransactionsArray){
            NSMutableDictionary * race = [NSMutableDictionary dictionaryWithDictionary:raceDetail];
            if( [[race objectForKey:@"MTP"] isEqualToString:@"-1"] ){
                [race setObject:@"999" forKey:@"MTP"];
            }
            NSArray * bets = [race objectForKey:@"bets"];
            if( bets && [bets count] > 0 ){
                for( NSMutableDictionary * bet in bets ){
                    if( [race objectForKey:@"tpasTimestamp"] != nil){
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HHmmssZZ"];
                        
                        NSString *currentDateString = [[race objectForKey:@"tpasTimestamp"] stringByReplacingOccurrencesOfString:@":" withString:@""];
                        NSDate *currentObjectdate = [dateFormatter dateFromString:currentDateString];
                        
                        NSString *newDateString = [[bet objectForKey:@"tpasTimestamp"] stringByReplacingOccurrencesOfString:@":" withString:@""];
                        NSDate *newObjectdate = [dateFormatter dateFromString:newDateString];
                        
                        if([newObjectdate compare:currentObjectdate] == NSOrderedDescending){
                            [race setValue:[bet objectForKey:@"tpasTimestamp"] forKey:@"tpasTimestamp"];
                        }
                    }
                    else{
                        [race setValue:[bet objectForKey:@"tpasTimestamp"] forKey:@"tpasTimestamp"];
                    }
                    
                }
            }
            [myBets addObject:race];
        }
        self.myTransactionsArray = myBets;
        

        if( [self.myTransactionsArray count] <= 0){
            self.video_Button.enabled = NO;
            
            self.settingsButton.enabled = NO;
            self.settings_Button.userInteractionEnabled = NO;
            
            [self.settingsButton setBackgroundColor:[UIColor clearColor]];
            [self.singletapGestureRecognizer setEnabled:NO];

        }
        else{
            self.video_Button.enabled = YES;
            
            self.settingsButton.enabled = YES;
            self.settings_Button.userInteractionEnabled = YES;
            
            [self.settingsButton setBackgroundColor:[UIColor clearColor]];
            [self.singletapGestureRecognizer setEnabled:YES];

        }
        
        if (self.trackSettingsView.sortByBetTime.selected == NO) {
            self.mtpLabel.hidden = NO;
            self.mtpControl.hidden = NO;
            //self.lineImageView.hidden = NO;
            self.mtp_Label.hidden = NO;
            
        }
        else {
            self.mtpLabel.hidden = YES;
            self.mtpControl.hidden = YES;
//            self.lineImageView.hidden = YES;
            self.mtp_Label.hidden = YES;
            
        }

        
        if( !self.inPlaySortMTP ){
            
            NSSortDescriptor * MTPSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tpasTimestamp" ascending:NO];
            NSArray *MTPDescriptor = [NSArray arrayWithObject:MTPSortDescriptor];
            self.myTransactionsArray = [NSMutableArray arrayWithArray:[self.myTransactionsArray sortedArrayUsingDescriptors:MTPDescriptor]];

        }
        else{
            NSSortDescriptor * MTPSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"MTP" ascending:YES];
            NSArray *MTPDescriptor = [NSArray arrayWithObject:MTPSortDescriptor];
            self.myTransactionsArray = [NSMutableArray arrayWithArray:[self.myTransactionsArray sortedArrayUsingDescriptors:MTPDescriptor]];
        }
    }
    else{

        self.myTransactionsArray = [self.myBetsDataDic mutableArrayValueForKey:@"final"];
        /*
        for( NSDictionary * raceDetail in self.myTransactionsArray){
            NSLog(@"myTransactionsArray %@",raceDetail);
            
        }*/
        
        if( [self.myTransactionsArray count] <= 0){
            self.replayButton.enabled = NO;
        }
        else{
            self.replayButton.enabled = YES;
        }
        
        //NSSortDescriptor *MTPDescriptor = [[NSSortDescriptor alloc] initWithKey:@"trackName" ascending:YES] ;
        //[self.myTransactionsArray sortUsingDescriptors:[NSArray arrayWithObject:MTPDescriptor]];
    }
/*
    if ([self.myTransactionsArray count]) {
        [self.wagerTableView setHidden:NO];
        [_scrollView setHidden:NO];
    }
    */
    

    dispatch_async(dispatch_get_main_queue(), ^{
        [self prepareViewForFilteredTracks:self.myTransactionsArray];
        if (self.selectedPage != 0) {
            [self filterTracksBasedonMTPValueofSelectedPage:self.selectedPage];
        }
    });
        
}

- (void)prepareViewForFilteredTracks:(NSMutableArray *)myTransactionTracks
{

    self.selectedRaceDetail = nil;
    
    [self.backgroundImagesArray removeAllObjects];
    
    for( UIView * subview in [_scrollView subviews]){
        [subview removeFromSuperview];
    }
    
    for (int i = 0; i <= [myTransactionTracks count]/9; i++) {
     
        [self.backgroundImagesArray addObject:[UIImage imageNamed:@"51.png"]];
        [self.backgroundImagesArray addObject:[UIImage imageNamed:@"52.png"]];
        [self.backgroundImagesArray addObject:[UIImage imageNamed:@"53.png"]];
        [self.backgroundImagesArray addObject:[UIImage imageNamed:@"54.png"]];
        [self.backgroundImagesArray addObject:[UIImage imageNamed:@"55.png"]];
        [self.backgroundImagesArray addObject:[UIImage imageNamed:@"56.png"]];
        [self.backgroundImagesArray addObject:[UIImage imageNamed:@"57.png"]];
        [self.backgroundImagesArray addObject:[UIImage imageNamed:@"58.png"]];
        [self.backgroundImagesArray addObject:[UIImage imageNamed:@"59.png"]];
    }
    
    CGFloat x = 5.0f;
    
    int i = 0;
    
    for( NSMutableDictionary *transactionTrack in myTransactionTracks){

        
        self.totalBets = 0;
        self.totalAmount = 0.0;
        double winnings = 0.0;

        for (NSMutableDictionary *bets in [transactionTrack mutableArrayValueForKey:@"bets"]) {
            

            if( [[bets valueForKey:@"betAmount"] intValue] != 0 ){

                self.totalBets = [[transactionTrack mutableArrayValueForKey:@"bets"] count];//[[bets valueForKey:@"debit"] integerValue] / [[bets valueForKey:@"betAmount"] integerValue];
            }
            else{
                self.totalBets = 0;
            }
            self.totalAmount += [[bets valueForKey:@"debit"] doubleValue];
            
            if(!self.inPlay){
                winnings += [[bets valueForKey:@"winningAmount"] doubleValue];
            }
            
            


        }
        //UIImageView *flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 12, 15, 15)];

        UIImageView *flagImageView = [[UIImageView alloc] init];

        CGRect containerViewFrame = CGRectMake(x, 0.0f,  220,  _scrollView.frame.size.height);
        
        UIImageView *containerImageView = [[UIImageView alloc] initWithFrame:containerViewFrame];
        flagImageView.tag = i;
        [containerImageView addSubview:flagImageView];
        
        if ([[transactionTrack valueForKey:@"trackCountry"] isEqualToString:@"UK"]){
            flagImageView.image = [UIImage imageNamed:@"uk.png"];
        }else if ([[transactionTrack valueForKey:@"trackCountry"] isEqualToString:@"US"]){
            flagImageView.image = [UIImage imageNamed:@"us.png"];
            
        }

        [containerImageView setImage:[self.backgroundImagesArray objectAtIndex:[myTransactionTracks indexOfObject:transactionTrack]]];
        containerImageView.tag = i;

        i++;


    
        //UILabel *raceNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, 10, 120, 20)];
        UILabel *raceNameLabel=[[UILabel alloc]init];
        
        [raceNameLabel setTextColor:[UIColor whiteColor]];
        [raceNameLabel setBackgroundColor:[UIColor clearColor]];
        [raceNameLabel setText:[transactionTrack valueForKey:@"trackName"]];
        [raceNameLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
        [containerImageView addSubview:raceNameLabel];
        
        
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 22, 120, 20)];
        [dateLabel setTextColor:[UIColor whiteColor]];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd,yyy"];
        
        NSString *temp = [formatter stringFromDate:self.selectedDate];
        
        
        
        [dateLabel setText:[formatter stringFromDate:self.selectedDate]];
        [dateLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
        dateLabel.hidden = YES;
        [containerImageView addSubview:dateLabel];
        

        
        
        
        //UILabel *raceNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(raceNameLabel.frame.size.width+25, 6, 35, 30)];
        UILabel *raceNumLabel=[[UILabel alloc]init];
        [raceNumLabel setTextColor:[UIColor blackColor]];
        [raceNumLabel setBackgroundColor:[UIColor whiteColor]];
        [raceNumLabel setText:[NSString stringWithFormat:@"Race\n%@", [transactionTrack valueForKey:@"currentRaceNumber"]]];
        raceNumLabel.layer.borderWidth = 1.0;
        raceNumLabel.layer.borderColor = [[UIColor blackColor] CGColor];

        [raceNumLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:11]];
        [raceNumLabel setNumberOfLines:2];
        [raceNumLabel setTextAlignment:NSTextAlignmentCenter];

        [containerImageView addSubview:raceNumLabel];
        
        if (!self.inPlay)
        {
            //Final UI
            raceNameLabel.frame = CGRectMake(25, 4, 120, 20);
            flagImageView.frame = CGRectMake(6, 6, 15, 15);
            dateLabel.hidden = NO;
            
            self.mtp_Label.hidden = YES;
            raceNumLabel.frame = CGRectMake(raceNameLabel.frame.size.width+60, 6, 35, 30);
            
        }else{
            //inPlay UI
            self.mtp_Label=[[UILabel alloc]init];
            [self.mtp_Label setTextColor:[UIColor whiteColor]];
            [self.mtp_Label setBackgroundColor:[UIColor redColor]];
            [self.mtp_Label setNumberOfLines:2];
            self.mtp_Label.layer.borderWidth = 1.0;
            self.mtp_Label.layer.borderColor = [[UIColor blackColor] CGColor];
            [self.mtp_Label setTextAlignment:NSTextAlignmentCenter];
            [self.mtp_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:11]];
            dateLabel.hidden = YES;
            
            raceNameLabel.frame = CGRectMake(25, 10, 120, 20);
            flagImageView.frame = CGRectMake(6, 12, 15, 15);

            raceNumLabel.frame = CGRectMake(raceNameLabel.frame.size.width+25, 6, 35, 30);
            
            self.mtp_Label.frame = CGRectMake(raceNameLabel.frame.size.width+60, 6, 35, 30);
            self.mtp_Label.hidden = NO;
            [containerImageView addSubview:self.mtp_Label];

        }
        
        //                if( components.minute <= 5 && self.inPlay){
        //self.mtp_Label=[[UILabel alloc]initWithFrame:CGRectMake(raceNameLabel.frame.size.width+60, 6, 35, 30) ];
        
//        NSLog(@"MTP === %@",[transactionTrack valueForKey:@"MTP"]);
       /*
        
        if( [[transactionTrack valueForKey:@"MTP"] intValue] != 999 && [[transactionTrack valueForKey:@"MTP"] intValue] >= 0 )
            [self.mtp_Label setText:[NSString stringWithFormat:@"MTP\n%@",[transactionTrack valueForKey:@"MTP"]]];
        else
            [self.mtp_Label setText:@"MTP\n-"];
        
        */
        
        
        if( [[transactionTrack valueForKey:@"MTP"] intValue] >= 0){
            [self.mtp_Label setText:[NSString stringWithFormat:@"MTP\n%@",[transactionTrack valueForKey:@"MTP"]]];
            
        }
        else{
            [self.mtp_Label setText:@"MTP\n-"];
            
        }
        
        if([[transactionTrack valueForKey:@"MTP"] intValue] <= 5){
            [self.mtp_Label setBackgroundColor:[UIColor colorWithRed:245.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
            [self.mtp_Label setTextColor:[UIColor whiteColor]];
        }
        else if([[transactionTrack valueForKey:@"MTP"] intValue] <= 20){
            [self.mtp_Label setBackgroundColor:[UIColor colorWithRed:250.0/255 green:228.0/255 blue:48.0/255 alpha:1.0]];
            [self.mtp_Label setTextColor:[UIColor blackColor]];
        }
        else{
            [self.mtp_Label setBackgroundColor:[UIColor colorWithRed:2.0/255 green:143.0/255 blue:26.0/255 alpha:1.0]];
            [self.mtp_Label setTextColor:[UIColor whiteColor]];
            
        }

        
        self.totalBetLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 45, 100, LabelHeight)];
        [ self.totalBetLabel setTextColor:[UIColor whiteColor]];
        [ self.totalBetLabel setBackgroundColor:[UIColor clearColor]];
        if( self.inPlay){
            [ self.totalBetLabel setText:@"Total Bets"];
        }
        else{
            [ self.totalBetLabel setText:@"Bet Amount"];
        }
        [ self.totalBetLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
        [containerImageView addSubview: self.totalBetLabel];
        
        
        self.resultLabel=[[UILabel alloc]initWithFrame:CGRectMake(8,  self.totalBetLabel.frame.size.height+ self.totalBetLabel.frame.origin.y, 150, LabelHeight)];
        [self.resultLabels addObject:self.resultLabel];
        [self.resultLabel setTextColor:[UIColor whiteColor]];
        [self.resultLabel setBackgroundColor:[UIColor clearColor]];
        
        
        if( self.inPlay){
            
//                [self.resultLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)[[self.selectedRaceDetail valueForKey:@"bets"] count]]];

            [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.totalBets]];
        }
        else{
            [self.resultLabel setText:[NSString stringWithFormat:@"%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],self.totalAmount]];
            }
        [self.resultLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
        [containerImageView addSubview:self.resultLabel];
        
        
        self.amountLabel=[[UILabel alloc]initWithFrame:CGRectMake( 116,45, 100, LabelHeight)];
        [self.amountLabel setTextAlignment:NSTextAlignmentRight];
        [self.amountLabel setTextColor:[UIColor whiteColor]];
        [self.amountLabel setBackgroundColor:[UIColor clearColor]];
        if( self.inPlay){
            [self.amountLabel setText:@"Total Amount"];
        }
        else{
            [self.amountLabel setText:@"Winnings"];
            self.amountLabel.frame = CGRectMake(118,45, 100, LabelHeight);

        }
        [self.amountLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
        [containerImageView addSubview:self.amountLabel];
        
        self.dollarLabel=[[UILabel alloc]initWithFrame:CGRectMake( 116,self.amountLabel.frame.size.height+self.amountLabel.frame.origin.y, 100, LabelHeight)];
        [self.dollarLabel setTextAlignment:NSTextAlignmentRight];

        self.dollarLabel.adjustsFontSizeToFitWidth = YES;
        [self.dollarLabels addObject:self.dollarLabel];
        [self.dollarLabel setTextColor:[UIColor whiteColor]];
        [self.dollarLabel setBackgroundColor:[UIColor clearColor]];
        if( self.inPlay){
            [self.dollarLabel setText:[NSString stringWithFormat:@"%@%.2f",[[WarHorseSingleton sharedInstance] currencySymbel],self.totalAmount]];
        }
        else{
            [self.dollarLabel setText:[NSString stringWithFormat:@"%@%.2f",[[WarHorseSingleton sharedInstance] currencySymbel],(winnings/100.0)]];
        }
        [self.dollarLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
        [containerImageView addSubview:self.dollarLabel];
        
        [ _scrollView addSubview:containerImageView];

        if(x == 5.0){
            [self selectRace:0];
        }
        
        x += _scrollView.frame.size.width;
        _scrollView.contentSize = CGSizeMake(x,  _scrollView.frame.size.height);
    }
    
    if (self.selectedRaceDetail == nil) {
        _scrollView.hidden = YES;
        self.singleTapGestureRecognizer.enabled = NO;
        self.wagerTableView.hidden =YES;
        self.noRaceLabel.hidden = NO;
        self.video_Button.enabled = NO;
        
        if(self.inPlay){
            self.startWageringBtn.hidden = NO;

        }else{
            self.startWageringBtn.hidden = YES;

        }
    }
    
}

-(void) recalculateAmountAndUpdateLabel {
    
    if (self.inPlay) {
        [self.wagerTableView setFrame:CGRectMake(self.wagerTableView.frame.origin.x, self.wagerTableView.frame.origin.y, self.wagerTableView.frame.size.width, (IS_IPHONE5)?(self.wagerTableView.contentSize.height <= 270)?self.wagerTableView.contentSize.height:270:(self.wagerTableView.contentSize.height <= 181)?self.wagerTableView.contentSize.height:181)];

    }
    else
    {
        [self.wagerTableView setFrame:CGRectMake(self.wagerTableView.frame.origin.x, self.wagerTableView.frame.origin.y, self.wagerTableView.frame.size.width, (IS_IPHONE5)?(self.wagerTableView.contentSize.height <= 312)?self.wagerTableView.contentSize.height:312:(self.wagerTableView.contentSize.height <= 224)?self.wagerTableView.contentSize.height:224)];

    }
    //self.wagerTableView.backgroundColor = [UIColor redColor];
    
    if( [[self.selectedRaceDetail valueForKey:@"bets"] count] == 0){
        
        
        
        NSArray * transactionsArray = [self.myBetsDataDic mutableArrayValueForKey:@"inPlay"];
        NSMutableArray * myBets = [NSMutableArray array];
        
        for( NSDictionary * raceDetail in transactionsArray){
            if( [[raceDetail valueForKey:@"raceNumber"] isEqualToString:[self.selectedRaceDetail valueForKey:@"raceNumber"]] &&
               [[raceDetail valueForKey:@"perf"] isEqualToString:[self.selectedRaceDetail valueForKey:@"perf"]] &&
               [[raceDetail valueForKey:@"meet"] isEqualToString:[self.selectedRaceDetail valueForKey:@"meet"]]){
                
                
            }
            else{
                [myBets addObject:raceDetail];
            }

        }
        self.myTransactionsArray = myBets;
        [self.myBetsDataDic setValue:myBets forKey:@"inPlay"];
                
        [self setupViewAfterDataLoad];
        return;
    }
    
    double totalAmount = 0.0;
    int totalBets = 0;
    for( NSMutableArray * myBetTransactions in [self.selectedRaceDetail valueForKey:@"bets"]){
       // NSLog(@"bet type %@",[myBetTransactions valueForKey:@"selection"]);
        if( [[myBetTransactions valueForKey:@"selection"] rangeOfString:@"Cancelled"].location == NSNotFound){
            totalBets =(int) [[self.selectedRaceDetail valueForKey:@"bets"] count];//[[myBetTransactions valueForKey:@"debit"] doubleValue] / [[myBetTransactions valueForKey:@"betAmount"] doubleValue];
            totalAmount += [[myBetTransactions valueForKey:@"debit"] doubleValue];
        }
    }
    
    CGFloat pageWidth = self._scrollView.frame.size.width;
    float fractionalPage = self._scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
    
    if ([self.dollarLabels count]) {
        UILabel * lblDollar = [self.dollarLabels objectAtIndex:page];
        [lblDollar setText:[NSString stringWithFormat:@"%@%.2f",[[WarHorseSingleton sharedInstance] currencySymbel],totalAmount]];
    }
    
    if ([self.resultLabels count]) {
        UILabel * lblResults = [self.resultLabels objectAtIndex:page];
        [lblResults setText:[NSString stringWithFormat:@"%d",totalBets]];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        int currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self selectRace:currentPage];
    }
    
}


- (void)selectRace:(int) index{
    
    self.selectedRaceDetail = nil;
    self.currentRace = index;
    
    [self removeMediaPlayerFromSuperView];
    NSMutableDictionary * raceDetail;
    if ([self.myTransactionsArray count]) {
        raceDetail = [self.myTransactionsArray objectAtIndex:index];
        //NSLog(@"raceDetail %@",raceDetail);
    }
    
    
    if( raceDetail != nil){
        
        self.selectedRaceDetail = [[NSMutableDictionary alloc] initWithDictionary:raceDetail];
        
        for (int i = 0; i < [[raceDetail mutableArrayValueForKey:@"bets"] count]; i++) {
            NSMutableDictionary *myBetTransactions = [[raceDetail mutableArrayValueForKey:@"bets"] objectAtIndex:i];
            
            if(!([[myBetTransactions valueForKey:@"selection"] rangeOfString:@"Cancelled"].location == NSNotFound)){
                
                [[self.selectedRaceDetail mutableArrayValueForKey:@"bets"] removeObjectAtIndex:[[self.selectedRaceDetail mutableArrayValueForKey:@"bets"] indexOfObject:myBetTransactions]];
            }
            

        }
        //NSLog(@"after.selectedRaceDetail %@",self.selectedRaceDetail);
        if (self.selectedRaceDetail == nil) {
            _scrollView.hidden = YES;
            self.singleTapGestureRecognizer.enabled = NO;
            self.noRaceLabel.hidden = NO;
            self.startWageringBtn.hidden = NO;

            self.video_Button.enabled = NO;
            self.wagerTableView.hidden =YES;
            
            
        }
        else
        {
            self.singleTapGestureRecognizer.enabled = YES;
            _scrollView.hidden = NO;
            self.noRaceLabel.hidden = YES;
            self.startWageringBtn.hidden = YES;

            self.video_Button.enabled = YES;
            self.wagerTableView.hidden = NO;
            [self.wagerTableView reloadData];
            
            if (self.inPlay) {
                [self.wagerTableView setFrame:CGRectMake(self.wagerTableView.frame.origin.x, self.wagerTableView.frame.origin.y, self.wagerTableView.frame.size.width, (IS_IPHONE5)?(self.wagerTableView.contentSize.height <= 270)?self.wagerTableView.contentSize.height:270:(self.wagerTableView.contentSize.height <= 181)?self.wagerTableView.contentSize.height:198)];
                
            }
            else
            {
                [self.wagerTableView setFrame:CGRectMake(self.wagerTableView.frame.origin.x, self.wagerTableView.frame.origin.y, self.wagerTableView.frame.size.width, (IS_IPHONE5)?(self.wagerTableView.contentSize.height <= 312)?self.wagerTableView.contentSize.height:312:(self.wagerTableView.contentSize.height <= 224)?self.wagerTableView.contentSize.height:241)];
                
            }        }
    }
}

- (void) prepareTopView
{
    
    [self.toggleButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.titleLabel setText:@"My Bets"];
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    if ([[[WarHorseSingleton sharedInstance] localCountry] isEqualToString:@"en_UK"]){
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"pound.png"] forState:UIControlStateNormal];
        
    }else{
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"symbol.png"] forState:UIControlStateNormal];
        
    }
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    [self.amountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    
}

-(void)balanceUpdated:(NSNotification *)notification{
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    
}

- (void)amountButtonClicked:(id)sender
{
    /*CGRect rect = ((UIButton *)sender).frame;
    
    if ([self.amountButton isSelected])
    {
        [self.amountButton setSelected:NO];
        
        rect.origin.x += 30;
        rect.size.width -= 30;
        [self.amountButton setFrame:rect];
        
    }
    else{
        [self.amountButton setSelected:YES];
        
        rect.origin.x -= 30;
        rect.size.width += 30;
        [self.amountButton setFrame:rect];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
    }*/
    
    CGRect rect = ((UIButton *)sender).frame;
    
    if ([self.amountButton isSelected])
    {
        [self.amountButton setSelected:NO];
        
        rect.origin.x += 30;
        rect.size.width -= 30;
        [self.amountButton setFrame:rect];
        
    }
    else{
        [self.amountButton setTitle:[NSString stringWithFormat:@"Loading.."] forState:UIControlStateSelected];
        
        if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [[ZLAppDelegate getApiWrapper] refreshBalance:YES success:^(NSDictionary* _userInfo){
            [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
        }failure:^(NSError *error){
        }];
        [self.amountButton setSelected:YES];
        
        rect.origin.x -= 30;
        rect.size.width += 30;
        [self.amountButton setFrame:rect];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
    }
}

- (IBAction)wagerButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardWager]forKey:@"viewNumber"]];
}

- (void)timerMethod:(NSTimer *)timer
{
    if ([self.amountButton isSelected])
    {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(272, 17, 44, 44)];
    }
}

- (void)loadDataForDate:(NSDate *)date withHud:(BOOL) hud flagStr:(NSString *)flagStr
{
    
    self.noRaceLabel.hidden = YES;
    self.startWageringBtn.hidden = YES;

    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //flag = @"inPlay";
    //flag = @"final";

    ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
    NSString *fromDateStr;
    NSString *toDateStr;
    
    if( hud ){
        if (self.inPlay) {
            [[LeveyHUD sharedHUD] appearWithText:@"Loading Current Bets..."];
            fromDateStr = [self.myBetsDateFormatter stringFromDate:[NSDate date]];
            toDateStr = [self.myBetsDateFormatter stringFromDate:[NSDate date]];
            self.dateStr =fromDateStr;
        }
        else {
            [[LeveyHUD sharedHUD] appearWithText:@"Loading Bets..."];
            fromDateStr = [self.myBetsDateFormatter stringFromDate:date];
            toDateStr = [self.myBetsDateFormatter stringFromDate:date];
            self.dateStr =fromDateStr;

        }
        [self.wagerTableView setHidden:YES];
        [_scrollView setHidden:YES];
    }
    //NSString *fromDateStr = [self.myBetsDateFormatter stringFromDate:[self numberOfDays:-1 fromDate:date]];
    //NSString *toDateStr = [self.myBetsDateFormatter stringFromDate:[self numberOfDays:-1 fromDate:date]];
    
    
    [apiWrapper loadMyBetsDataFromDate:fromDateStr betsFlag:flagStr toDate:toDateStr
                      success:^(NSDictionary* _userInfo) {
                          NSLog(@"_userInfo %@",_userInfo);
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              [[LeveyHUD sharedHUD] disappear];

                              if ([[_userInfo valueForKey:@"response-status"] isEqualToString:@"success"]) {
                                  [self.myBetsDataDic setDictionary:[_userInfo valueForKey:@"response-content"]];
                                  [self setupViewAfterDataLoad];

                              }
                              else {
                                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"The server could not process your request at this time, please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                  [alert show];
                              }
 
                          });
                          
                      }failure:^(NSError *error) {
                          
                          UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"The server could not process your request at this time, please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                          [alert show];
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                                  [[LeveyHUD sharedHUD] disappear];
                                  if( hud ){
                                      [self.wagerTableView setHidden:YES];
                                      [_scrollView setHidden:YES];
                                  }
                              });
                          
                      }];

}

- (NSDate *)numberOfDays:(NSInteger)days fromDate:(NSDate *)from {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:+days];
    
    return [gregorian dateByAddingComponents:offsetComponents toDate:from options:0];
    
}

- (IBAction)goToHome:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardHome]forKey:@"viewNumber"]];
}

- (IBAction)goToResults:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardResults]forKey:@"viewNumber"]];
}


-(IBAction)video_Clicked:(id)sender
{
    if( self.selectedRaceDetail == nil){
        return;
    }
    
    //NSDictionary * meetMapping = @{@"FINGER LAKES":@"FIM",@"WESTERN FAIR RACEWAY":@"LWN",@"MOUNTAINEER":@"MNE",@"CALDER":@"CRM",@"DOVER DOWNS":@"DOT",@"THE MEADOWS":@"MEE",@"BEULAH":@"BXM",@"HARRAHS PHILADELPHIA":@"VCD",@"GULFSTREAM":@"GPM",@"NORTHFIELD PARK":@"NPN",@"POMPANO PARK":@"PKN",@"PHILADELPHIA PARK":@"PHD",@"TURF PARADISE":@"TUD",@"SUNLAND PARK":@"SND",@"BEULAH PARK":@"BXM",@"PARX RACING":@"PHD",@"PARX":@"PHD",@"FINKER LKS":@"FIM",@"HRRAHS PHL":@"VCD",@"WESTERN FA":@"LWN",@"MOUNTAINEE":@"MNE",@"DOVER":@"DOT",@"POMPANO":@"PKN",@"POMPANO":@"PKN",@"NORTHFIELD":@"NPN",@"SUNLAND":@"SND",@"TAMPA BAY":@"TAM", @"LAUREL":@"LRM",@"HAWTHORNE":@"HAN",@"PORTLANDS MEADOWS":@"POR",@"WESTERN FAIR":@"LWN"};
    
    /*
    if( [meetMapping objectForKey:[[self.selectedRaceDetail objectForKey:@"trackName"] uppercaseString]] == nil){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Video is not available for the selected race!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    */
    
    
    
    //NSLog(@"Track No %@",[NSString stringWithFormat:@"%@",[self.selectedRaceDetail objectForKey:@"raceNumber"]]);
    
    NSDictionary *argumentsDic = @{@"client_id": @"BetFred",
                                   @"videoType": @"live",
                                   @"format": @"stream",
                                   @"track_code": [[[self.selectedRaceDetail objectForKey:@"bets"] objectAtIndex:0] valueForKey:@"eventCode"],
                                   @"race_number": [NSString stringWithFormat:@"%@",[self.selectedRaceDetail objectForKey:@"raceNumber"]],
                                   @"meet": [[[self.selectedRaceDetail objectForKey:@"bets"] objectAtIndex:0] valueForKey:@"meet"]
                                   };
    //NSLog(@"bet video %@",argumentsDic);
    
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Video..."];
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    [apiWrapper getLiveVideoUrlForParameters:argumentsDic success:^(NSDictionary* _responseDic) {
        [[LeveyHUD sharedHUD] disappear];

        NSString *urlStr = [_responseDic valueForKey:@"response-content"];
        if( urlStr.length > 0 && [urlStr hasPrefix:@"http"] ){
            NSURL *url = [NSURL URLWithString:urlStr];
            
            [self.video_Button setSelected:YES];
            
            [self.wagerTableView setFrame:CGRectMake(self.wagerTableView.frame.origin.x, self.wagerTableView.frame.origin.y, self.wagerTableView.frame.size.width, (IS_IPHONE5)?270:181)];
            
            
            
            self.backGroundView.frame = CGRectMake(0 , 0, self.wagerTableView.frame.size.width, self.wagerTableView.frame.size.height);
            
            //    [self.backGroundView setAutoresizingMask: UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleLeftMargin];
            
            [self.backGroundView setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
            UIColor *uicolor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
            CGColorRef color = [uicolor CGColor];
            [self.backGroundView.layer setBorderWidth:1.0];
            [self.backGroundView.layer setMasksToBounds:YES];
            [self.backGroundView.layer setBorderColor:color];
            [self.wagerTableView addSubview:self.backGroundView];
            
            self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
            
            // Register to receive a notification when the movie has finished playing.
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayexitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:self.moviePlayer];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:self.moviePlayer];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidEnterFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:self.moviePlayer];
            
            
            [self.backGroundView addSubview:self.moviePlayer.view];
            [self.moviePlayer setFullscreen:YES animated:NO];
            [self.moviePlayer play];
            
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Live video is not available for the selected race" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
                                  
        
    } failure:^(NSError* error) {
        [[LeveyHUD sharedHUD] disappear];
    }];
    
}

- (IBAction)rePlayClicked:(UIButton *)button
{
    

    
    if( self.selectedRaceDetail == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Replay video is currently unavailable for this race" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    /*
    NSDictionary * meetMapping = @{@"FINGER LAKES":@"FIM",@"WESTERN FAIR RACEWAY":@"LWN",@"MOUNTAINEER":@"MNE",@"CALDER":@"CRM",@"DOVER DOWNS":@"DOT",@"THE MEADOWS":@"MEE",@"BEULAH":@"BXM",@"HARRAHS PHILADELPHIA":@"VCD",@"GULFSTREAM":@"GPM",@"NORTHFIELD PARK":@"NPN",@"POMPANO PARK":@"PKN",@"PHILADELPHIA PARK":@"PHD",@"TURF PARADISE":@"TUD",@"SUNLAND PARK":@"SND",@"BEULAH PARK":@"BXM",@"PARX RACING":@"PHD",@"PARX":@"PHD",@"FINKER LKS":@"FIM",@"HRRAHS PHL":@"VCD",@"WESTERN FA":@"LWN",@"MOUNTAINEE":@"MNE",@"DOVER":@"DOT",@"POMPANO":@"PKN",@"POMPANO":@"PKN",@"NORTHFIELD":@"NPN",@"SUNLAND":@"SND",@"TAMPA BAY":@"TAM", @"LAUREL":@"LRM",@"HAWTHORNE":@"HAN",@"PORTLANDS MEADOWS":@"POR",@"WESTERN FAIR":@"LWN"};
     
     if( [meetMapping objectForKey:[[self.selectedRaceDetail objectForKey:@"trackName"] uppercaseString]] == nil){
     
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Video is not available for the selected race" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     [alert show];
     return;
     }
    */
    //NSLog(@"selectedRaceDetail %@",self.selectedRaceDetail);
    
    
    NSString *eventCode = [NSString stringWithFormat:@"%@",[self.selectedRaceDetail objectForKey:@"eventCode"]];
    //NSLog(@"eventCode %@",eventCode);
    
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSLog(@"Video selectedRaceDetail %@",self.selectedRaceDetail);
    NSDictionary *argumentsDic = @{@"client_id": @"BetFred",
                                   @"videoType": @"replay",
                                   @"format": @"mobile",
                                   @"track_code": eventCode,
                                   @"race_number": [NSString stringWithFormat:@"%@",[self.selectedRaceDetail objectForKey:@"raceNumber"]],
                                   @"video_date":self.dateStr,
                                   @"meet":[NSString stringWithFormat:@"%@",[self.selectedRaceDetail objectForKey:@"meet"]]
                                   };
    //NSLog(@"Mybet Replay Video %@",argumentsDic);
    
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Video..."];
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    [apiWrapper getLiveVideoUrlForParameters:argumentsDic success:^(NSDictionary* _responseDic) {
        [[LeveyHUD sharedHUD] disappear];
        NSString * status = [_responseDic valueForKey:@"response-status"];
        //NSLog(@"status %@",status);
        if( [status isEqualToString:@"success"] ){
            NSString *urlStr = [_responseDic valueForKey:@"response-content"];
            //NSLog(@"urlStr %@",urlStr);
            if( urlStr.length > 0 && [urlStr hasPrefix:@"http"] ){
                
                NSURL *url = [NSURL URLWithString:urlStr];
                
                [self.video_Button setSelected:YES];
                
                //[self.wagerTableView setFrame:CGRectMake(self.wagerTableView.frame.origin.x, self.wagerTableView.frame.origin.y, self.wagerTableView.frame.size.width, (IS_IPHONE5)?270:181)];
                
                
                
                self.backGroundView.frame = CGRectMake(0 , 0, self.wagerTableView.frame.size.width, self.wagerTableView.frame.size.height);
                
                //    [self.backGroundView setAutoresizingMask: UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleLeftMargin];
                
                [self.backGroundView setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
                UIColor *uicolor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
                CGColorRef color = [uicolor CGColor];
                [self.backGroundView.layer setBorderWidth:1.0];
                [self.backGroundView.layer setMasksToBounds:YES];
                [self.backGroundView.layer setBorderColor:color];
                
                self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
                
                // Register to receive a notification when the movie has finished playing.
                
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayexitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:self.moviePlayer];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification
                                                           object:self.moviePlayer];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidEnterFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:self.moviePlayer];
                
                
                [self.backGroundView addSubview:self.moviePlayer.view];
                [self.view addSubview:self.backGroundView];

                [self.moviePlayer setFullscreen:YES animated:NO];
                [self.moviePlayer play];
                
            }
            else{
                NSLog(@"Error Http");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Replay video is currently unavailable for this race" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }//final
        else{
            
            NSDictionary *argumentsDic = @{@"client_id": @"BetFred",
                                           @"videoType": @"replay",
                                           @"format": @"mobile",
                                           @"track_code": eventCode,
                                           @"race_number": [NSString stringWithFormat:@"%@",[self.selectedRaceDetail objectForKey:@"raceNumber"]],
                                           @"video_date":self.dateStr,
                                           @"meet":[NSString stringWithFormat:@"%@",[self.selectedRaceDetail objectForKey:@"meet"]]

                                           };
            
            [[LeveyHUD sharedHUD] appearWithText:@"Loading Video..."];
            
            ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
            [apiWrapper getLiveVideoUrlForParameters:argumentsDic success:^(NSDictionary* _responseDic) {
                //NSLog(@"Replay responseDic %@",_responseDic);
                [[LeveyHUD sharedHUD] disappear];
                NSString * status = [_responseDic valueForKey:@"response-status"];
                if( [status isEqualToString:@"success"] ){
                    NSString *urlStr = [_responseDic valueForKey:@"response-content"];
                    if( urlStr.length > 0 && [urlStr hasPrefix:@"http"] ){
                        NSURL *url = [NSURL URLWithString:urlStr];
                        
                        [self.video_Button setSelected:YES];
                        
                        //[self.wagerTableView setFrame:CGRectMake(self.wagerTableView.frame.origin.x, self.wagerTableView.frame.origin.y, self.wagerTableView.frame.size.width, (IS_IPHONE5)?270:181)];
                        
                        
                        
                        self.backGroundView.frame = CGRectMake(0 , 0, self.wagerTableView.frame.size.width, self.wagerTableView.frame.size.height);
                        
                        //    [self.backGroundView setAutoresizingMask: UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleLeftMargin];
                        
                        [self.backGroundView setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
                        UIColor *uicolor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
                        CGColorRef color = [uicolor CGColor];
                        [self.backGroundView.layer setBorderWidth:1.0];
                        [self.backGroundView.layer setMasksToBounds:YES];
                        [self.backGroundView.layer setBorderColor:color];
                        [self.view addSubview:self.backGroundView];
                        
                        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
                        
                        // Register to receive a notification when the movie has finished playing.
                        
                        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayexitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:self.moviePlayer];
                        
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification
                                                                   object:self.moviePlayer];
                        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidEnterFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:self.moviePlayer];
                        
                        
                        [self.backGroundView addSubview:self.moviePlayer.view];
                        [self.moviePlayer setFullscreen:YES animated:NO];
                        [self.moviePlayer play];
                    }
                    else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Replay video is currently unavailable for this race" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Replay video is currently unavailable for this race" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
                
            } failure:^(NSError* error) {
                [[LeveyHUD sharedHUD] disappear];
            }];
            
            
        }
        
        
    } failure:^(NSError* error) {
        [[LeveyHUD sharedHUD] disappear];
    }];
    
}

-(void)moviePlayBackDidFinish:(NSNotification*) notif
{
    MPMoviePlayerController *moviePlayer = [notif object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isOrientation = NO;
    [self.moviePlayer stop];
    [moviePlayer.view removeFromSuperview];
    [self.backGroundView removeFromSuperview];
    
    NSNumber* reason = [[notif userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"Playback Ended");
            [self performSelector:@selector(playBackEnded) withObject:nil afterDelay:1.0];
            
            break;
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"Playback Error");
            [self performSelector:@selector(corruptVideoAlertView) withObject:nil afterDelay:1.0];
            break;
        case MPMovieFinishReasonUserExited:
            NSLog(@"User Exited");
            break;
        default:
            break;
    }
    
    


    
    
}

- (void)corruptVideoAlertView
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Information!" message:@"The video is currently unavailable" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)playBackEnded
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Information!" message:@"The Video Playback is Ended" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}



-(void) moviePlayexitFullscreen:(NSNotification*) notif
{
    MPMoviePlayerController *moviePlayer = [notif object];
    
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isOrientation = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerWillExitFullscreenNotification
                                                  object:moviePlayer];
    [moviePlayer.view removeFromSuperview];
    [self.moviePlayer stop];

    [self.backGroundView removeFromSuperview];

    

}
-(void)playerDidEnterFullscreen:(NSNotification*) notif
{
    MPMoviePlayerController *moviePlayer = [notif object];
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isOrientation = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidEnterFullscreenNotification
                                                  object:moviePlayer];
    
    
    
}

- (void)removeMediaPlayerFromSuperView
{
    [self.moviePlayer stop];
    [self.closeMediaPlayerButton removeFromSuperview];
    [self.webview removeFromSuperview];
    [self.backGroundView removeFromSuperview];


    [self.video_Button setSelected:NO];
    if (self.inPlay) {
        [self.wagerTableView setFrame:CGRectMake(self.wagerTableView.frame.origin.x, self.wagerTableView.frame.origin.y, self.wagerTableView.frame.size.width, (IS_IPHONE5)?(self.wagerTableView.contentSize.height <= 270)?self.wagerTableView.contentSize.height:270:(self.wagerTableView.contentSize.height <= 181)?self.wagerTableView.contentSize.height:181)];
        
    }
    else
    {
        [self.wagerTableView setFrame:CGRectMake(self.wagerTableView.frame.origin.x, self.wagerTableView.frame.origin.y, self.wagerTableView.frame.size.width, (IS_IPHONE5)?(self.wagerTableView.contentSize.height <= 312)?self.wagerTableView.contentSize.height:312:(self.wagerTableView.contentSize.height <= 224)?self.wagerTableView.contentSize.height:224)];
        
    }
    self.closeMediaPlayerButton = nil;
    self.webview = nil;
}

-(IBAction)cancel_Clicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardLogOut]forKey:@"viewNumber"]];
}

-(IBAction)back_Clicked:(id)sender{
   // [self.navigationController popViewControllerAnimated:YES];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardHome]forKey:@"viewNumber"]];
}

-(IBAction)settings_Clicked:(id)sender{
    
}

- (void)cancelBetForSender:(id)sender
{
    UITableViewCell *cell;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        cell =  (UITableViewCell *)[[sender superview] superview];
        
    }else{
        cell =  (UITableViewCell *)[[[sender superview] superview] superview];
        
    }
    
    NSIndexPath *indexPath = [self.wagerTableView indexPathForCell:cell];
    self.deleteBetIndexpath = indexPath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel Bet" message:@"Are you sure you want to cancel this bet?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [alert show];
    
}

-(void)cancelBet:(NSIndexPath *)indexPath
{
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary * transaction = [[[self.selectedRaceDetail mutableArrayValueForKey:@"bets"] objectAtIndex:indexPath.row] mutableCopy];
    if(transaction){
        [ZLAppDelegate showLoadingView];
        [[ZLAppDelegate getApiWrapper] cancelWager:transaction
                          success:^(NSDictionary* _userInfo) {
                              
                              [transaction setObject:[NSString stringWithFormat:@"%@ %@",[transaction valueForKey:@"selection"],@"(Cancelled)"] forKey:@"selection"];
                              UITableViewCell *cell = [self.wagerTableView cellForRowAtIndexPath:self.deleteBetIndexpath];
                              
                              UIButton *cancelBtn = (UIButton *)[cell.contentView viewWithTag:20+self.deleteBetIndexpath.row];
                              
                              if ([[self.selectedRaceDetail mutableArrayValueForKey:@"bets"] count] == 1) {
                                  [cancelBtn removeFromSuperview];
                              }
                              
                              [[self.selectedRaceDetail mutableArrayValueForKey:@"bets"] removeObjectAtIndex:self.deleteBetIndexpath.row];
                              [self.myTransactionsArray replaceObjectAtIndex:self.currentRace withObject:self.selectedRaceDetail];
                              
                              
                              
                              
                              self.deleteBetIndexpath = nil;
                              [self recalculateAmountAndUpdateLabel];
                              [self.wagerTableView reloadData];
                              
                              [ZLAppDelegate hideLoadingView];
                              
                          }failure:^(NSError *error) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [ZLAppDelegate hideLoadingView];
                                  if( error && error.userInfo){
                                      NSString * message = [[error.userInfo objectForKey:@"response"] objectForKey:@"response-message"];
                                      if( message ){
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                          [alert show];
                                      }
                                  }
                              });
                              
                          }];
    }
}

- (IBAction)playClicked:(UIButton *)button
{
//    [self.mtpControl setMTPSelectedForPage:1];


    if(button.tag == 1) // INPLAY
    {
        

        [self loadDataForDate:[NSDate date] withHud:YES flagStr:@"inPlay"];

        self.wagerTableView.hidden = YES;
        self.inPlay = YES;
        self.mtpLabel.hidden = YES;
        self.mtpControl.hidden = YES;
//        self.lineImageView.hidden = NO;
        self.mtp_Label.hidden = NO;
        
        self.settingsButton.enabled = YES;
        self.settings_Button.userInteractionEnabled = YES;
        
        [self.trackSettingsView.view removeFromSuperview];
                
        
        [self.settingsButton setBackgroundColor:[UIColor clearColor]];
        [self.singletapGestureRecognizer setEnabled:NO];

        self.calenderBtn.enabled = NO;
        self.calenderBtn.userInteractionEnabled = NO;
        
        
        [self.scrollViewContainer setFrame:CGRectMake(self.scrollViewContainer.frame.origin.x, 160, self.scrollViewContainer.frame.size.width, self.scrollViewContainer.frame.size.height)];
        [_scrollView setFrame:CGRectMake(_scrollView.frame.origin.x, 160, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        
        if (IS_IPHONE5) {
            
            [self.wagerTableView setFrame:CGRectMake(5, 261, 310, 265)];
            
        }
        else
        {
            [self.wagerTableView setFrame:CGRectMake(5, 261, 310, 177)];
            
        }
        self.backGroundView.frame = self.wagerTableView.frame;

        
        self.inPlayBtn.layer.borderColor = [UIColor colorWithRed:126.0/255 green:126.0/255 blue:126.0/255 alpha:1.0].CGColor;
        self.finalBtn.layer.borderColor = [UIColor colorWithRed:6.0/255 green:55.0/255 blue:86.0/255 alpha:1.0].CGColor;

        [self.finalBtn setBackgroundColor:[UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0]];
        [self.inPlayBtn setBackgroundColor:[UIColor colorWithRed:35.0/255 green:108.0/255 blue:142.0/255 alpha:1.0]];

        [self.inPlayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.finalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];


        self.tagButton.tag=button.tag;
        [self.video_Button setHidden:NO];
        [self.cancel_Button setHidden:NO];
        [self.home_Button setHidden:NO];
        [self.resultButton setHidden:YES];
        [self.replayButton setHidden:YES];
        if([[WarHorseSingleton sharedInstance] isVideoSteamingEnable] == YES)
        {
            [self.video_Button setHidden:NO];
            
        }
        else{
            [self.home_Button setFrame:CGRectMake(60, self.home_Button.frame.origin.y, self.home_Button.frame.size.width, 29)];
            
            [self.wagerBtn setFrame:CGRectMake(160,self.wagerBtn.frame.origin.y, self.home_Button.frame.size.width, 29)];
            
            
            [self.video_Button setHidden:YES];
            
        }

        [self.wagerTableView setFrame:CGRectMake(self.wagerTableView.frame.origin.x, self.wagerTableView.frame.origin.y, self.wagerTableView.frame.size.width, (IS_IPHONE5)?(self.wagerTableView.contentSize.height <= 270)?self.wagerTableView.contentSize.height:270:(self.wagerTableView.contentSize.height <= 181)?self.wagerTableView.contentSize.height:181)];

     }
    else // FINAL
    {
        

        [self loadDataForDate:[NSDate date] withHud:YES flagStr:@"final"];

        [self.trackSettingsView.view removeFromSuperview];
        
        [self.settingsButton setBackgroundColor:[UIColor clearColor]];
        
        self.settingsButton.enabled = NO;
        self.settings_Button.userInteractionEnabled = NO;
        
        self.calenderBtn.enabled = YES;
        self.calenderBtn.userInteractionEnabled = YES;
        
        
        
        self.mtp_Label.hidden = YES;

        self.wagerTableView.hidden = YES;
        self.inPlay = NO;
        self.mtpLabel.hidden = YES;
        //self.lineImageView.hidden = YES;

        self.mtpControl.hidden = YES;
        
        [_scrollView setFrame:CGRectMake(_scrollView.frame.origin.x, 109, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        
        [self.scrollViewContainer setFrame:CGRectMake(self.scrollViewContainer.frame.origin.x, 109, self.scrollViewContainer.frame.size.width, self.scrollViewContainer.frame.size.height)];
        
        if (IS_IPHONE5) {
                    
            [self.wagerTableView setFrame:CGRectMake(5, 263 - 47, 310, 265 + 47)];
        }
        else
        {            
            [self.wagerTableView setFrame:CGRectMake(5, 263 - 47, 310, 177 + 47)];
        }
       
        self.backGroundView.frame = self.wagerTableView.frame;

        self.inPlayBtn.layer.borderColor = [UIColor colorWithRed:6.0/255 green:55.0/255 blue:86.0/255 alpha:1.0].CGColor;
        self.finalBtn.layer.borderColor = [UIColor colorWithRed:126.0/255 green:126.0/255 blue:126.0/255 alpha:1.0].CGColor;

        [self.inPlayBtn setBackgroundColor:[UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0]];

        [self.finalBtn setBackgroundColor:[UIColor colorWithRed:35.0/255 green:108.0/255 blue:142.0/255 alpha:1.0]];
        //[self.inPlayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.inPlayBtn.titleLabel setTextColor:[UIColor blackColor]];
        [self.finalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self.resultButton setHidden:NO];
        [self.video_Button setHidden:YES];
        [self.home_Button setHidden:YES];
        [self.cancel_Button setHidden:YES];
        [self.replayButton setHidden:NO];
        
        self.tagButton.tag=button.tag;
        if([[WarHorseSingleton sharedInstance] isVideoSteamingEnable] == YES)
        {
            [self.resultButton setHidden:NO];
            
        }
        else{
            
            [self.replayButton setFrame:CGRectMake(60, self.replayButton.frame.origin.y, self.replayButton.frame.size.width, 29)];
            
            NSLog(@" %@",NSStringFromCGRect(self.replayButton.frame));
            
            [self.wagerBtn setFrame:CGRectMake(160,self.wagerBtn.frame.origin.y,self.wagerBtn.frame.size.width, 29)];
            
            
            [self.resultButton setHidden:YES];
            
        }

        
        [self.wagerTableView setFrame:CGRectMake(self.wagerTableView.frame.origin.x, self.wagerTableView.frame.origin.y, self.wagerTableView.frame.size.width, (IS_IPHONE5)?(self.wagerTableView.contentSize.height <= 312)?self.wagerTableView.contentSize.height:312:(self.wagerTableView.contentSize.height <= 224)?self.wagerTableView.contentSize.height:224)];

        
        //[self colorViewData];
    }
    
    [self.wagerTableView setContentOffset:CGPointMake(0, 0)];
       
    //[self setupViewAfterDataLoad];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    
    CGPoint touchPoint=[gesture locationInView:_scrollView];
    
    int currentPage = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    
    if (touchPoint.x > _scrollView.contentOffset.x + _scrollView.frame.size.width && touchPoint.x < _scrollView.contentSize.width - _scrollView.frame.size.width/2) {
        
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * (currentPage + 1);
        [_scrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
        NSMutableDictionary * raceDetail = [self.myTransactionsArray objectAtIndex:(currentPage + 1)];
        if( raceDetail != nil){
            [self selectRace:(currentPage + 1)];
        }
        [self.wagerTableView setContentOffset:CGPointMake(0, 0)];
        
    }
    else if(_scrollView.contentOffset.x >= _scrollView.frame.size.width && touchPoint.x < _scrollView.contentOffset.x)
    {
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * (currentPage - 1);
        [_scrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
        NSMutableDictionary * raceDetail = [self.myTransactionsArray objectAtIndex:(currentPage - 1)];
        if( raceDetail != nil){
            [self selectRace:(currentPage - 1)];
        }
        [self.wagerTableView setContentOffset:CGPointMake(0, 0)];

    }
    
}

- (void)filterTracksBasedonMTPValueofSelectedPage:(NSInteger)selectedPage
{

    NSArray *filteredMyTransactionsArray = nil;
    
    while (filteredMyTransactionsArray == nil && selectedPage <= 7) {
        
        self.selectedPage = selectedPage;
        
        NSPredicate *predicate;
        if (selectedPage == 7) {
            
            predicate = [NSPredicate predicateWithFormat:@"%@ < SELF.MTP OR SELF.MTP == '-1'", [NSString stringWithFormat:@"%d",(10 * (selectedPage - 1))]];
        }
        else
        {
            
            predicate = [NSPredicate predicateWithFormat:@"self.MTP BETWEEN { %@ , %@ }", [NSString stringWithFormat:@"%d",(10 * (selectedPage - 1))], [NSString stringWithFormat:@"%d",(10 * selectedPage)]];
        }
        if ([self.myTransactionsArray count]){
        
        filteredMyTransactionsArray = [self.myTransactionsArray filteredArrayUsingPredicate:predicate];
            
        }
        selectedPage++;
    }
    
    if ([filteredMyTransactionsArray count]) {
        int index = [self.myTransactionsArray indexOfObject:[filteredMyTransactionsArray objectAtIndex:0]];
        
        if(index == 0)
        {
            [_scrollView setContentOffset:CGPointMake(0, 0)];
        }
        else
        {
            [_scrollView setContentOffset:CGPointMake((220 * index) + 30, 0)]; // 220 is the Imageview Width and 30 (45 - 15). 45 is the x value of ScrollView   
        }
        
        [self selectRace:index];
    }
    else{
        
    }
    
    
}

#pragma mark - Calendar Methods

- (IBAction)calendarForSetDate
{
    if(!self.datePicker)
    {
        self.datePickerView = [[UIView alloc]init];
        self.datePicker = [[UIDatePicker alloc]init];
        self.pickerToolBar = [[UIToolbar alloc] init];
    }
    
    if (IS_IPHONE5)
    {
        self.datePickerView.frame = CGRectMake(0, 0, 320, 568);
        self.datePicker.frame = CGRectMake(0, 374, 320, 260);
        self.pickerToolBar.frame = CGRectMake(0, 329, 320, 44);
    }else{
        self.datePickerView.frame = CGRectMake(0, 0, 320, 480);
        self.datePicker.frame = CGRectMake(0, 285, 320, 260);
        self.pickerToolBar.frame = CGRectMake(0, 240, 320, 44);
    }

    self.datePickerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.pickerToolBar.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;

    self.pickerToolBar.barStyle = UIBarStyleBlackOpaque;
    [self.pickerToolBar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dateCancelbuttonClicked:)];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
    [barItems addObject:flexSpace];
    [barItems addObject:doneBtn];
    [self.pickerToolBar setItems:barItems animated:YES];
    
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
    [self.datePickerView addSubview:self.pickerToolBar];
    [self.datePickerView addSubview:self.datePicker];
    [self.view addSubview:self.datePickerView];

    
}

- (void)doneButtonClicked:(id) sender
{
    self.selectedDate = self.datePicker.date;
    //flag = @"inPlay";
    //flag = @"final";

    [self loadDataForDate:self.selectedDate withHud:YES flagStr:@"final"];
    [self.datePickerView removeFromSuperview];

}

- (void)dateCancelbuttonClicked:(id) sender
{
    [self.datePickerView removeFromSuperview];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pointInTableView = [gestureRecognizer locationInView:self.wagerTableView];
        NSIndexPath *indexPath = [self.wagerTableView indexPathForRowAtPoint:pointInTableView];
        if (indexPath) {
                ZLCurrentBetCustomCell *currentBetCell = (ZLCurrentBetCustomCell *)[self.wagerTableView cellForRowAtIndexPath:indexPath];
                if (currentBetCell.isHighlighted) {
                    [self shakeEffect:currentBetCell];
                }
        }
    }
}


- (void)shakeEffect:(UIView*)itemView
{
    CAAnimation *translationYAnimation = [self wiggleTranslationYAnimation];
    [itemView.layer addAnimation:translationYAnimation forKey:@"wiggleTranslationY"];
    CAAnimation *rotationAnimation = [self wiggleRotationAnimation];
    [itemView.layer addAnimation:rotationAnimation forKey:@"wiggleRotation"];
}


// Wiggling Animations for Images When LongPressed
#pragma mark - Delete Animations

- (CAAnimation *)wiggleRotationAnimation
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-0.02f], [NSNumber numberWithFloat:0.025f], nil];
    anim.duration = 0.14f;
    anim.autoreverses = YES;
    anim.repeatCount = HUGE_VALF;
    return anim;
}

- (CAAnimation *)wiggleTranslationYAnimation
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-0.4f], [NSNumber numberWithFloat:0.5f], nil];
    anim.duration = 0.08f;
    anim.autoreverses = YES;
    anim.repeatCount = HUGE_VALF;
    anim.additive = YES;
    return anim;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ( self.selectedRaceDetail == nil) {
        return 0;
    }
    
    // Return the number of rows in the section.
    if([[self.selectedRaceDetail valueForKey:@"bets"] count] == 0){
        return 1;
    }
    return [[self.selectedRaceDetail valueForKey:@"bets"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZLCurrentBetCustomCell *currentBetCustomCell  = (ZLCurrentBetCustomCell *)[tableView dequeueReusableCellWithIdentifier:kcurrentBetCustomCellIdentifier];
    
    [currentBetCustomCell updateViewAtIndexPath:indexPath];

    //NSLog(@"cellForRowAtIndexPath Bets %d",[[self.selectedRaceDetail valueForKey:@"bets"] count]);
    
    if ([[self.selectedRaceDetail valueForKey:@"bets"] count] == 0) {
        
        currentBetCustomCell.betType_Label.text = @"No Bets";
        currentBetCustomCell.amountDollar_Label.text = @"";
        currentBetCustomCell.betDollar_Label.text = @"";
        return currentBetCustomCell;
        
    }
    currentBetCustomCell.cancelBetButton.hidden = NO;
    [currentBetCustomCell.amountDollar_Label setFrame:CGRectMake(208, 11, 60, 21)];
    

    NSMutableDictionary * _transaction = [[self.selectedRaceDetail valueForKey:@"bets"] objectAtIndex:indexPath.row];
    
    //NSLog(@"self.selectedRaceDetail %@",self.selectedRaceDetail);
    //NSLog(@"trasactions %@",_transaction);

    
    
    //currentBetCustomCell.betDollar_Label.text = [NSString stringWithFormat:@"%@%.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[[_transaction valueForKey:@"betAmount"] floatValue]];
    
   
    
    
    NSString * amountStr = [_transaction valueForKey:@"betAmount"];
    
    
//    NSString *tempStr = [NSString stringWithFormat:@"%@%@",[[WarHorseSingleton sharedInstance] currencySymbel],_runner.probablePay];
    
    float amountInt = [amountStr floatValue];
    if (1<=amountInt){
        currentBetCustomCell.betDollar_Label.text = [NSString stringWithFormat:@"%@%.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[[_transaction valueForKey:@"betAmount"] floatValue]];

        
    }else{
        int amount2 = amountInt*100;
        currentBetCustomCell.betDollar_Label.text = [NSString stringWithFormat:@"%d%@",amount2,@"p"];
        
    }
    
    
    currentBetCustomCell.betType_Label.text = [NSString stringWithFormat:@"%@ - %@",[_transaction valueForKey:@"betType"], [_transaction valueForKey:@"selection"]];
    currentBetCustomCell.amountDollar_Label.text = [NSString stringWithFormat:@"%@%.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[[_transaction valueForKey:@"debit"] floatValue]];
    currentBetCustomCell.currentBetTypeDelegate = self;
    
    if( !self.inPlay || [[_transaction valueForKey:@"selection"] rangeOfString:@"Cancelled"].location != NSNotFound){
        if(!self.inPlay){

            currentBetCustomCell.cancelBetButton.hidden = YES;
            [currentBetCustomCell.betType_Label setFrame:CGRectMake(57, 11, 165, 21)];
            [currentBetCustomCell.amountDollar_Label setFrame:CGRectMake(240, 11, 60, 21)];
            
            if([[_transaction valueForKey:@"result"] isEqualToString:@"WON"]){
                currentBetCustomCell.amountDollar_Label.backgroundColor = [UIColor clearColor];
                currentBetCustomCell.amountDollar_Label.text = [NSString stringWithFormat:@"%@%.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[[_transaction valueForKey:@"winningAmount"] floatValue]/100.0];
                currentBetCustomCell.amountDollar_Label.textColor = [UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0];

            }
            else{
                currentBetCustomCell.amountDollar_Label.backgroundColor = [UIColor clearColor];
                currentBetCustomCell.amountDollar_Label.text = [NSString stringWithFormat:@"-%@%.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[[_transaction valueForKey:@"debit"] floatValue]];
                currentBetCustomCell.amountDollar_Label.textColor = [UIColor redColor];
                
            }
        }
        else{
            
            
        }
        
    }
    else
    {
        
    }
    
    
    CGSize maximumBetTypeLabelSize;
    maximumBetTypeLabelSize = CGSizeMake(135,9999);

    if (!self.inPlay) {
        maximumBetTypeLabelSize = CGSizeMake(165,9999);

    }
    
//    CGSize maximumLabelSize = CGSizeMake(180, 999);
//    CGSize expectedBetTypeLabelSize=  [currentBetCustomCell.betType_Label.text boundingRectWithSize:maximumLabelSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:currentBetCustomCell.betType_Label.font } context:nil].size;
    
//Deprecated sizeWithFont
    CGSize expectedBetTypeLabelSize = [currentBetCustomCell.betType_Label.text sizeWithFont:currentBetCustomCell.betType_Label.font constrainedToSize:maximumBetTypeLabelSize lineBreakMode:currentBetCustomCell.betType_Label.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect betTypeLabelLabelNewFrame = currentBetCustomCell.betType_Label.frame;
    betTypeLabelLabelNewFrame.size.height = expectedBetTypeLabelSize.height;
    currentBetCustomCell.betType_Label.frame = betTypeLabelLabelNewFrame;
    
    currentBetCustomCell.separatorLine.frame = CGRectMake(0, currentBetCustomCell.betType_Label.frame.size.height + 26, 310, 1);
    
    return currentBetCustomCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[self.selectedRaceDetail valueForKey:@"bets"] count] == 0) {
        return 44;
    }
        
    ZLCurrentBetCustomCell *currentBetCustomCell  = (ZLCurrentBetCustomCell *)[tableView dequeueReusableCellWithIdentifier:kcurrentBetCustomCellIdentifier];
    
    [currentBetCustomCell updateViewAtIndexPath:indexPath];
    
    NSMutableDictionary * _transaction = [[self.selectedRaceDetail valueForKey:@"bets"] objectAtIndex:indexPath.row];
    currentBetCustomCell.betType_Label.text = [NSString stringWithFormat:@"%@ - %@",[_transaction valueForKey:@"betType"], [_transaction valueForKey:@"selection"]];
    
    
    CGSize maximumBetTypeLabelSize;
    
    maximumBetTypeLabelSize = CGSizeMake(135,9999);
    
    if (!self.inPlay) {
        maximumBetTypeLabelSize = CGSizeMake(165,9999);
   
    }
    
//    CGSize maximumLabelSize = CGSizeMake(180, 999);
//    CGSize expectedBetTypeLabelSize=  [currentBetCustomCell.betType_Label.text boundingRectWithSize:maximumLabelSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:currentBetCustomCell.betType_Label.font } context:nil].size;
    
//Deprecated sizeWithFont
    CGSize expectedBetTypeLabelSize = [currentBetCustomCell.betType_Label.text sizeWithFont:currentBetCustomCell.betType_Label.font constrainedToSize:maximumBetTypeLabelSize lineBreakMode:currentBetCustomCell.betType_Label.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect betTypeLabelLabelNewFrame = currentBetCustomCell.betType_Label.frame;
    betTypeLabelLabelNewFrame.size.height = expectedBetTypeLabelSize.height;
    currentBetCustomCell.betType_Label.frame = betTypeLabelLabelNewFrame;
    
    CGFloat cellHeight = currentBetCustomCell.betType_Label.frame.size.height + 27;
            
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.selectedRaceDetail valueForKey:@"bets"] count] == 0 || self.selectedRaceDetail == nil) {
        return NO;
    }
    
    return NO;
}
// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Bet" message:@"Are you sure you want to cancel this bet?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    
    [alert show];
    
    self.deleteBetIndexpath = indexPath;

}

#pragma mark - Property Overridden methods

- (NSDateFormatter *)myBetsDateFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    });
    
    return dateFormatter;
}

#pragma mark - Alertview Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self cancelBet:self.deleteBetIndexpath];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.datePickerView removeFromSuperview];
}


@end
