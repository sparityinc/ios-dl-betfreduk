//
//  ZLTrackViewController.m
//  WarHorse
//
//  Created by Sparity on 09/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLTrackViewController.h"
#import "ZLRaceViewController.h"
#import "ZLSelectedValues.h"
#import "ZLAppDelegate.h"
#import "ZLAPIWrapper.h"
#import "ZLRaceCard.h"
#import "ZLTrackSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"
@interface ZLTrackViewController ()

@property(nonatomic, retain) ZLTrackSettingsViewController * trackSettingsView;

@property (assign) BOOL menuShowing;

@property(nonatomic, retain) NSArray * tracks;


@property (nonatomic, strong) NSMutableArray *videoObjArray;

@property (nonatomic, strong) UIButton *closeMediaPlayerButton;

@property (nonatomic, strong) UIView *transparentView;

@property (nonatomic, strong) UIWebView *webview;

@property (strong, atomic) NSMutableArray *filteredArray;

@property (assign) BOOL isOrderBySelected;

@property (assign) BOOL isFilterBySelected;

@property (nonatomic, strong) UITapGestureRecognizer *singletapGestureRecognizer;


@end

@implementation ZLTrackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.isOrderBySelected = NO; //Default
    self.isFilterBySelected = NO;
    
    self.filteredArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.trackSettingsView = [[ZLTrackSettingsViewController alloc] init];
    self.trackSettingsView.view.frame = CGRectMake(9.0, 25.0, 228.0, 116.0);
    [self.trackSettingsView.filterByThoruoghbred addTarget:self action:@selector(filterTheTracks:) forControlEvents:UIControlEventTouchUpInside];
    self.trackSettingsView.filterByThoruoghbred.tag = 5;
    //[self.trackSettingsView.filterByHarness addTarget:self action:@selector(filterTheTracks:) forControlEvents:UIControlEventTouchUpInside];
    //self.trackSettingsView.filterByHarness.tag = 6;
    [self.trackSettingsView.filterByFavoriteButton addTarget:self action:@selector(filterTheTracks:) forControlEvents:UIControlEventTouchUpInside];
    self.trackSettingsView.filterByFavoriteButton.tag = 7;
    [self.trackSettingsView.filterByAll addTarget:self action:@selector(filterTheTracks:) forControlEvents:UIControlEventTouchUpInside];
    self.trackSettingsView.filterByAll.tag = 8;
    
    [self.trackSettingsView.sortByAlphabetButton addTarget:self action:@selector(orderTheTracks:) forControlEvents:UIControlEventTouchUpInside];
    self.trackSettingsView.sortByAlphabetButton.tag = 9;
    [self.trackSettingsView.sortByMTPButton addTarget:self action:@selector(orderTheTracks:) forControlEvents:UIControlEventTouchUpInside];
    self.trackSettingsView.sortByMTPButton.tag = 10;
    self.singletapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingsButtonSelected:)];
    [self.singletapGestureRecognizer setEnabled:NO];
    [self.view addGestureRecognizer:self.singletapGestureRecognizer];
    
    
    self.tracks = [NSArray array];
    self.menuShowing = NO;
    
    [self.selectTrackLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    if ([[[WarHorseSingleton sharedInstance] localCountry] isEqualToString:@"en_UK"]){
        self.selectTrackLabel.text = @"Select Course";
    }else{
        self.selectTrackLabel.text = @"Select Track";
    }
    
    //selectTrackLabel
    [self.navigationController setNavigationBarHidden:YES];
    self.isFavourite=YES;
    
    
    ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Tracks..."];
    
    [apiWrapper loadRaceCards:YES success:^(NSDictionary* _userInfo){
        
        if( [[ZLAppDelegate getAppData].raceCards count] == 0){
            self.settingsButton.enabled = NO;
        }
        else{
            self.settingsButton.enabled = YES;
        }
        
        self.filteredArray = (NSMutableArray *)[ZLAppDelegate getAppData].raceCards;
        
        self.trackSettingsView.sortByMTPButton.selected = YES;
        self.trackSettingsView.sortByAlphabetButton.selected = NO;
        
        self.trackSettingsView.filterByAll.selected = YES;
        self.trackSettingsView.filterByHarness.selected = NO;
        self.trackSettingsView.filterByThoruoghbred.selected = NO;
        self.trackSettingsView.filterByFavoriteButton.selected = NO;
        
        [self loadTracksAfterFilterAndOrderBy];
        [self.wagerTableView reloadData];
        
        [[LeveyHUD sharedHUD] disappear];
        
    }failure:^(NSError *error){
        
        [[LeveyHUD sharedHUD] disappear];
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTracksFromServer) name:@"ZLWagerTracksDidLoad" object:nil];
    [self reloadTracksFromServer];
    
}

-(void) viewDidDisappear:(BOOL)animated{
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) loadTracksAfterFilterAndOrderBy{
    //[_race_card.trackCountry isEqualToString:@"UK"]
    NSArray * tracks = nil;
    if( self.trackSettingsView.filterByAll.selected ){
        tracks = [ZLAppDelegate getAppData].raceCards;
    }
    else if( self.trackSettingsView.filterByThoruoghbred.selected ){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.trackCountry == %@",@"UK"];
        tracks = [[ZLAppDelegate getAppData].raceCards filteredArrayUsingPredicate:predicate];
    }/*
    else if( self.trackSettingsView.filterByHarness.selected ){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.breedType != %@",@"TB"];
        tracks = [[ZLAppDelegate getAppData].raceCards filteredArrayUsingPredicate:predicate];
    }*/
    else if( self.trackSettingsView.filterByFavoriteButton.selected ){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.favorite == YES"];
        tracks = [[ZLAppDelegate getAppData].raceCards filteredArrayUsingPredicate:predicate];
    }
    else{
        tracks = [ZLAppDelegate getAppData].raceCards;
    }
    
    if( self.trackSettingsView.sortByAlphabetButton.selected ){
        NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ticketName" ascending:YES]; //Fix for https://sparity.atlassian.net/browse/WAR-99
        
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"currentRaceStatus" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,nil];
        self.filteredArray = (NSMutableArray *)[tracks sortedArrayUsingDescriptors:sortDescriptors];
    }
    else if( self.trackSettingsView.sortByMTPButton.selected ){
        NSSortDescriptor * sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"minutesToPost" ascending:YES];
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"ticketName" ascending:YES];
        NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"currentRaceStatus" ascending:YES];//Fix for https://sparity.atlassian.net/browse/WAR-99
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor3, sortDescriptor1,sortDescriptor2, nil];
        self.filteredArray = (NSMutableArray *)[tracks sortedArrayUsingDescriptors:sortDescriptors];
    }
//    NSLog(@"self.filteredArray %@",self.filteredArray);
}

- (void)filterTheTracks:(UIButton *)sender
{
    switch (sender.tag) {
        case 5: // filter By Thoroughbred
        {
            if (self.trackSettingsView.filterByThoruoghbred.selected == NO) {
                
                self.trackSettingsView.filterByAll.selected = NO;
                self.trackSettingsView.filterByHarness.selected = NO;
                self.trackSettingsView.filterByThoruoghbred.selected = YES;
                self.trackSettingsView.filterByFavoriteButton.selected = NO;
                
            }
            else{
                return;
            }
        }
            break;
            /*
        case 6: // filter By Harness
        {
            
            if (self.trackSettingsView.filterByHarness.selected == NO) {
                self.trackSettingsView.filterByAll.selected = NO;
                self.trackSettingsView.filterByHarness.selected = YES;
                self.trackSettingsView.filterByThoruoghbred.selected = NO;
                self.trackSettingsView.filterByFavoriteButton.selected = NO;
            }
            else{
                return;
            }
        }
            
            break;*/
        case 7: // filter By Favorite
        {
            
            if (self.trackSettingsView.filterByFavoriteButton.selected == NO) {
                self.trackSettingsView.filterByAll.selected = NO;
                self.trackSettingsView.filterByHarness.selected = NO;
                self.trackSettingsView.filterByThoruoghbred.selected = NO;
                self.trackSettingsView.filterByFavoriteButton.selected = YES;
            }
            else{
                return;
            }
            
        }
            
            break;
        case 8: // filter By Default
        {
            if (self.trackSettingsView.filterByAll.selected == NO) {
                self.trackSettingsView.filterByAll.selected = YES;
                self.trackSettingsView.filterByHarness.selected = NO;
                self.trackSettingsView.filterByThoruoghbred.selected = NO;
                self.trackSettingsView.filterByFavoriteButton.selected = NO;
            }
            else{
                return;
            }
        }
            
            break;
            
        default:
            break;
            
    }
    [self loadTracksAfterFilterAndOrderBy];
    [self.wagerTableView reloadData];
    [self settingsButtonSelected:nil];
    
}

- (void)orderTheTracks:(UIButton *)sender
{
    
    switch (sender.tag) {
        case 9: // Order by alphabet
        {
            if (self.trackSettingsView.sortByAlphabetButton.selected == NO) {
                self.trackSettingsView.sortByAlphabetButton.selected = YES;
                self.trackSettingsView.sortByMTPButton.selected = NO;
            }
            else
            {
                return;
                
            }
        }
            break;
            
        case 10: // Order by MTP
        {
            
            if (self.trackSettingsView.sortByMTPButton.selected == NO) {
                self.trackSettingsView.sortByMTPButton.selected = YES;
                self.trackSettingsView.sortByAlphabetButton.selected = NO;
            }
            else
            {
                return;
                
            }
            
        }
            break;
        default:
            break;
    }
    
    [self loadTracksAfterFilterAndOrderBy];
    [self.wagerTableView reloadData];
    [self settingsButtonSelected:nil];
    
}

-(void) reloadTracksFromServer{
    
    [self loadTracksAfterFilterAndOrderBy];
    [self.wagerTableView reloadData];
    
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
    
    // Return the number of rows in the section.
    
    return [self.filteredArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    self.wagerCustomCell  = (ZLTrackCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.wagerCustomCell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ZLTrackCustomCell" owner:self options:nil];
    }

    
    [self.wagerCustomCell.favButton addTarget:self action:@selector(favoriteTrackSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.wagerCustomCell.favButton setTag:indexPath.row];
    
    [self.wagerCustomCell.raceTrack_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.wagerCustomCell.information_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:10]];
    [self.wagerCustomCell.raceNumber_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    [self.wagerCustomCell.mtp_TimeLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.wagerCustomCell.mtp_TimeLabel setBackgroundColor:[UIColor clearColor]];
    [self.wagerCustomCell.mtpNewLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.wagerCustomCell.rankLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    
    ZLRaceCard * _race_card = [self.filteredArray objectAtIndex:indexPath.row];
    
    if ([_race_card.trackCountry isEqualToString:@"UK"]){
        self.wagerCustomCell.countryFlagImg.image = [UIImage imageNamed:@"uk.png"];
    }else if ([_race_card.trackCountry isEqualToString:@"US"]){
        self.wagerCustomCell.countryFlagImg.image = [UIImage imageNamed:@"us.png"];

    }
    
    [self.wagerCustomCell.raceTrack_Label setText:_race_card.ticketName];
    //NO Video Track Name Label Frame Change
    if ([_race_card.isVideoAvailable boolValue]){
        self.wagerCustomCell.videoButton.hidden = NO;
        
    }else{
        self.wagerCustomCell.raceTrack_Label.frame = CGRectMake(CGRectGetMinX(self.wagerCustomCell.raceTrack_Label.frame), CGRectGetMinY(self.wagerCustomCell.raceTrack_Label.frame), CGRectGetWidth(self.wagerCustomCell.raceTrack_Label.frame)+22, CGRectGetHeight(self.wagerCustomCell.raceTrack_Label.frame));
        self.wagerCustomCell.videoButton.hidden = YES;
        
    }

    
    if( _race_card.purseUsa == nil || [_race_card.purseUsa length] <= 0){
        [self.wagerCustomCell.information_Label setText:[NSString stringWithFormat:@"%@ | %@",_race_card.distance != nil ? _race_card.distance : @"", _race_card.trackType != nil ? _race_card.trackType : @""]];
    }
    else{
        [self.wagerCustomCell.information_Label setText:[NSString stringWithFormat:@"%@ | %@ \nPurse %@%@",_race_card.distance != nil ? _race_card.distance : @"", _race_card.trackType != nil ? _race_card.trackType : @"",[[WarHorseSingleton sharedInstance] currencySymbel], _race_card.purseUsa != nil ? _race_card.purseUsa : @"N/A"]];
    }
    if( [self.wagerCustomCell.information_Label.text isEqualToString:@" | "]){
        self.wagerCustomCell.information_Label.text = @"";
    }
    
    if (![[WarHorseSingleton sharedInstance] isSpFavName]){
        [[WarHorseSingleton sharedInstance] setIsSpFavName:_race_card.spFavName];
        [[WarHorseSingleton sharedInstance] setIsTFShortName:_race_card.spFavShortName];
        [[WarHorseSingleton sharedInstance] setIsSpFavDescription:_race_card.spFavDescription];
    }
    //kLegBetting
    if (![[WarHorseSingleton sharedInstance] kLegBetting]){
        [[WarHorseSingleton sharedInstance] setKLegBetting:_race_card.kLegBetting];
    }
    if ([_race_card.trackCountry isEqualToString:@"UK"]){
        [self.wagerCustomCell.raceNumber_Label setText:[NSString stringWithFormat:@"Race\n%@", _race_card.currentRace]];

    }else {
        [self.wagerCustomCell.raceNumber_Label setText:[NSString stringWithFormat:@"Race\n%d", _race_card.currentRaceNumber]];

    }

    
    
    if( ![_race_card.currentRaceStatus isEqualToString:@"OFFICIAL"]){
        
        if ([_race_card.currentRaceStatus isEqualToString:@"BETTING_OFF"]) {
            [self.wagerCustomCell.mtp_Label setText:@"OFF"];
            [self.wagerCustomCell.mtp_Label setTextColor:[UIColor whiteColor]];
            [self.wagerCustomCell.mtp_Label setBackgroundColor:[UIColor colorWithRed:245.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
        }
        else
        {
            [self.wagerCustomCell.mtp_Label setText:[NSString stringWithFormat:@"MTP\n %d",_race_card.minutesToPost]];
            if(_race_card.minutesToPost <= 5){
                [self.wagerCustomCell.mtp_Label setBackgroundColor:[UIColor colorWithRed:245.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
                [self.wagerCustomCell.mtp_Label setTextColor:[UIColor whiteColor]];
            }
            else if(_race_card.minutesToPost <= 20){
                [self.wagerCustomCell.mtp_Label setBackgroundColor:[UIColor colorWithRed:250.0/255 green:228.0/255 blue:48.0/255 alpha:1.0]];
                [self.wagerCustomCell.mtp_Label setTextColor:[UIColor blackColor]];
            }
            else{
                [self.wagerCustomCell.mtp_Label setBackgroundColor:[UIColor colorWithRed:2.0/255 green:143.0/255 blue:26.0/255 alpha:1.0]];
                [self.wagerCustomCell.mtp_Label setTextColor:[UIColor whiteColor]];
            }
        }
    }
    else{
        [self.wagerCustomCell.mtp_Label setText:@"FIN"];
        [self.wagerCustomCell.mtp_Label setTextColor:[UIColor whiteColor]];
        [self.wagerCustomCell.mtp_Label setBackgroundColor:[UIColor colorWithRed:245.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
    }    self.wagerCustomCell.backgroundImage.image = [UIImage imageNamed:@"Track_Cell_Bg.png"];
    [self.wagerCustomCell.favButton setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
    [self.wagerCustomCell.favButton setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateHighlighted];
    
    //[self.wagerCustomCell.videoButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //self.wagerCustomCell.videoButton
    
    [self.wagerCustomCell.videoButton setTag:indexPath.row];
    [self.wagerCustomCell.videoButton addTarget:self action:@selector(playVideoBtAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[WarHorseSingleton sharedInstance] isVideoSteamingEnable] == YES){
        if ([_race_card.isVideoAvailable boolValue]){
            self.wagerCustomCell.videoButton.hidden = NO;
            
        }else{
            self.wagerCustomCell.videoButton.hidden = YES;
            
        }
        
    }
    else{
        self.wagerCustomCell.videoButton.hidden = YES;
    }

//     NSLog(@"isVideo = %d %@", [_race_card.isVideoAvailable boolValue], _race_card.name);
    
    
    //self.wagerCustomCell.videoButton.hidden = YES;
    //    NSMutableArray * favoriteTracks = [[ZLAppDelegate getAppData].dictFavorites objectForKey:@"Tracks"];
    
    if (_race_card.favorite) {
        [self.wagerCustomCell.favButton setSelected:YES];
    }
    
    if( [ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber == _race_card.meetNumber && [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber == _race_card.performanceNumber){
        self.wagerCustomCell.backgroundImage.image = [UIImage imageNamed:@"black_bg.png"];
        self.wagerCustomCell.raceTrack_Label.textColor = [UIColor whiteColor];
        self.wagerCustomCell.raceNumber_Label.textColor = [UIColor whiteColor];
        self.wagerCustomCell.information_Label.textColor = [UIColor whiteColor];
        [self.wagerCustomCell.favButton setImage:[UIImage imageNamed:@"whitestar.png"] forState:UIControlStateNormal];
        [self.wagerCustomCell.favButton setImage:[UIImage imageNamed:@"star_back_select.png"] forState:UIControlStateSelected];
        [self.wagerCustomCell.favButton setImage:[UIImage imageNamed:@"star_back_select.png"] forState:UIControlStateHighlighted];
    }
    
    return self.wagerCustomCell;
}

- (IBAction)settingsButtonSelected:(id)sender{
    
    
    if(!self.menuShowing){
        [self.settingsButton setBackgroundColor:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
        [self.view addSubview:self.trackSettingsView.view];
        self.trackSettingsView.view.frame = CGRectMake(9.0, 42.0, 228.0, 1.0);
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.trackSettingsView.view.frame = CGRectMake(9.0, 42.0, 228.0, 117.0);
        } completion:^(BOOL finished) {
            
        }];
        
        [self.singletapGestureRecognizer setEnabled:YES];
    }
    else{
        [self.settingsButton setBackgroundColor:[UIColor clearColor]];
        [self.trackSettingsView.view removeFromSuperview];
        [self.singletapGestureRecognizer setEnabled:NO];
    }
    self.menuShowing = !self.menuShowing;
}


- (void)playVideoBtAction:(id)sender
{
    [self playVideo:[sender tag]];
}
- (void)playVideo:(int)selectedRow
{
    
    //veeru
    
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    ZLRaceCard * _race_card = [self.filteredArray objectAtIndex:selectedRow];
    
    
    NSString *eventCodeStr = [NSString stringWithFormat:@"%@", _race_card.eventCode];
    
    
    NSString *raceNoStr = [NSString stringWithFormat:@"%d",_race_card.currentRaceNumber];
    NSString *meetNo = [NSString stringWithFormat:@"%d",_race_card.meetNumber];
    
    
    NSDictionary *argumentsDic = @{@"client_id": @"BetFred",
                                   @"videoType": @"live",
                                   @"format":    @"stream",
                                   @"track_code": eventCodeStr,
                                   @"race_number":raceNoStr,
                                   @"meet":meetNo
                                   };
    
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Video..."];
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    [apiWrapper getLiveVideoUrlForParameters:argumentsDic success:^(NSDictionary* _responseDic) {
        [[LeveyHUD sharedHUD] disappear];
        
        
        if ([[_responseDic valueForKey:@"response-status"] isEqualToString:@"success"])
        {
            appDelegate.isOrientation = YES;
            
            self.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 46, self.wagerTableView.frame.size.width, self.wagerTableView.frame.size.height)];
            
            [self.transparentView setBackgroundColor:[UIColor blackColor]];
            [self.transparentView setAlpha:0.6];
            [self.view addSubview:self.transparentView];
            
            NSString *urlStr = [_responseDic valueForKey:@"response-content"];
            
            NSURL *url = [NSURL URLWithString:urlStr];
            self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
            
            // Register to receive a notification when the movie has finished playing.
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerWillExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:self.moviePlayer];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidEnterFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:self.moviePlayer];
            
            [self.transparentView addSubview:self.moviePlayer.view];
            [self.moviePlayer setFullscreen:YES animated:NO];
            [self.moviePlayer play];
            
            //self.repalyVideo = [_responseDic valueForKey:@"response-content"];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No live video available now" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        
    } failure:^(NSError* error) {
        [[LeveyHUD sharedHUD] disappear];
    }];
    

}




- (void)moviePlayBackDidFinish:(NSNotification*) notif
{
    MPMoviePlayerController *aMoviePlayer = [notif object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:aMoviePlayer];
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isOrientation = NO;
    [self.moviePlayer stop];

    [self.transparentView removeFromSuperview];
    [self.moviePlayer.view removeFromSuperview];
    
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


- (void)playerWillExitFullscreen:(NSNotification*) notif
{
    MPMoviePlayerController *aMoviePlayer = [notif object];
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isOrientation = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerWillExitFullscreenNotification
                                                  object:aMoviePlayer];
    [self.moviePlayer stop];

    [self.transparentView removeFromSuperview];
}
- (void)playerDidEnterFullscreen:(NSNotification*) notif
{
    MPMoviePlayerController *aMoviePlayer = [notif object];
    NSLog(@"My first Test player entered");

    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isOrientation = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidEnterFullscreenNotification
                                                  object:aMoviePlayer];
    [self.transparentView removeFromSuperview];
    
}


-(void)favoriteTrackSelected:(UIButton *)sender
{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.wagerTableView];
    NSIndexPath *indexPath = [self.wagerTableView indexPathForRowAtPoint:buttonPosition];
    
    ZLRaceCard * raceCard = [self.filteredArray objectAtIndex:indexPath.row];
    
    NSMutableArray * favoriteTracks = [[ZLAppDelegate getAppData].dictFavorites objectForKey:@"Tracks"];

    
    
    NSString * favoriteTrackId = @"";
    NSString *isFavTrack = @"";
    if ([favoriteTracks containsObject:[NSNumber numberWithInt:raceCard.favTrackCode]]) {
        [sender setSelected:NO];
        raceCard.favorite = NO;
        int idx = (int)[favoriteTracks indexOfObject:[NSNumber numberWithInt:raceCard.favTrackCode]];
        [favoriteTracks removeObjectAtIndex:idx];
        isFavTrack =@"false";

    }else{
        [favoriteTracks addObject:[NSNumber numberWithInt:raceCard.favTrackCode]];
        [sender setSelected:YES];
        raceCard.favorite = YES;
        isFavTrack =@"true";
    }
    
    favoriteTrackId =[NSString stringWithFormat:@"%d",raceCard.favTrackCode];
    sender.enabled = NO;
    ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
     NSMutableDictionary *jsonQueryParams = [NSMutableDictionary dictionaryWithDictionary:@{@"favTrackCode":favoriteTrackId,@"favStatus":isFavTrack}];
    
    /*
    NSString * favoriteTrackIds = @"";
    for( NSNumber * favoriteTrackId in favoriteTracks){
        if( favoriteTrackIds.length > 0)
            favoriteTrackIds = [NSString stringWithFormat:@"%@,%d",favoriteTrackIds,[favoriteTrackId intValue]];
        else
            favoriteTrackIds = [NSString stringWithFormat:@"%d",[favoriteTrackId intValue]];
    }*/
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    [apiWrapper updateFavoriteTracks:jsonQueryParams
                             success:^(NSDictionary* _userInfo){
                                 
                                 sender.enabled = YES;
                                 [self.wagerTableView reloadData];
                             }failure:^(NSError *error){
                                 sender.enabled = YES;
                             }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 73;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
    
    
    
    
    ZLRaceCard * _race_card = [self.filteredArray objectAtIndex:indexPath.row];
    
    
    [ZLAppDelegate getAppData].currentWager.selectedTrackId = _race_card.cardId;
    [ZLAppDelegate getAppData].currentWager.selectedRaceId = (int)_race_card.currentRaceNumber;
    [ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber = _race_card.meetNumber;
    [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber = _race_card.performanceNumber;
    [ZLAppDelegate getAppData].currentWager.selectedTrack = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
    
    [[WarHorseSingleton sharedInstance] setIsFavTF:[_race_card.spFavTrack boolValue]];
    
    

    [[WarHorseSingleton sharedInstance] setSelectTrackCountry:_race_card.trackCountry];
    [[WarHorseSingleton sharedInstance] setSelectTrackName:_race_card.ticketName];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadWagerView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:WagerTrack] forKey:@"currentLoadedIndex"]];
    
}

-(void)viewDidUnload{
    self.wagerTableView=nil;
    self.wagerCustomCell=nil;
    self.wagerCustomCell.raceTrack_Label=nil;
    self.wagerCustomCell.backgroundImage=nil;
    self.wagerCustomCell.raceNumber_Label=nil;
    self.wagerCustomCell.backgroundImage=nil;
    self.wagerCustomCell.information_Label=nil;
    self.wagerCustomCell.raceNumber_Label=nil;
    self.wagerCustomCell.favButton=nil;
    self.wagerCustomCell.mtp_Label=nil;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
