//
//  ZLWagerViewController.m
//  WarHorse
//
//  Created by Sparity on 7/5/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLWagerViewController.h"
#import "ZLLeftSideMenuViewController.h"
#import "ZLSideMenu.h"
#import "ZLSelectedValues.h"
#import "ZLRunnersViewController.h"
#import "ZLConformationViewController.h"
#import "ZLTrackViewController.h"
#import "ZLRaceViewController.h"
#import "ZLAmountViewController.h"
#import "ZLRunnersViewController.h"
#import "ZLBetTypeViewController.h"
#import "ZLAmountView.h"
#import "ZLPlaceWagerResultsViewController.h"
#import "ZLOddsBoardViewController.h"
#import "ZLAppDelegate.h"
#import "ZLWager.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"
#import "ZLAPIWrapper.h"
#import "NSNotificationCenter+MainThread.h"

#define SIDE_MENU_WIDTH 83

@interface ZLWagerViewController ()

@property (nonatomic, strong) UILabel * lblWagerAmount;

@property (assign) BOOL placeWagerLoading;

@property (nonatomic, retain) NSTimer * wagerDataRefreshTimer;
@end

@implementation ZLWagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.lblWagerAmount = nil;
        self.placeWagerLoading = NO;
    }
    return self;
}

- (id) init
{
    self = [super init];
    if (!self) return nil;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(HandleTopRightButtons:)
                                                 name:@"HandleTopRightButtons"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadWagerView:)
                                                 name:@"LoadWagerView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadOddsView:)
                                                 name:@"loadOddsView"
                                               object:nil];
    
    return self;
}

- (void) loadOddsView:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"loadOddsView"])
    {
        ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
        if( _race_card.currentRaceNumber == [ZLAppDelegate getAppData].currentWager.selectedRaceId){
            ZLOddsBoardViewController *objOdds = [[ZLOddsBoardViewController alloc] init];
            [self.navigationController presentViewController:objOdds animated:YES completion:nil];
            objOdds = nil;
        }
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Live WILL PAY is available only for the current race in the selected track" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void) refreshWagerData{
    
    [[ZLAppDelegate getApiWrapper] loadRaceCards:NO success:^(NSDictionary* _userInfo){
        
        if( [ZLAppDelegate getAppData].currentWager.selectedTrackId != -1){
            
            ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
            
            [ZLAppDelegate getAppData].currentWager.selectedTrack = _race_card;
            
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"ZLWagerTracksDidLoad" object:nil userInfo:nil];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy/MM/dd"];
            
            
            NSDictionary *argumentsDic = @{@"date":[formatter stringFromDate:[NSDate date]],
                                           @"detailsFlag":@"true",
                                           @"cardId":[NSString stringWithFormat:@"%d",[ZLAppDelegate getAppData].currentWager.selectedTrackId]};
            
            [[ZLAppDelegate getApiWrapper] loadTrackDetails:argumentsDic alert:NO
                                 success:^(NSDictionary* _userInfo) {
                                     
                                     if(_race_card && [ZLAppDelegate getAppData].currentWager.selectedRaceId != -1){
                                         
                                         ZLRaceDetails * raceDetails = [_race_card findRaceDeatilsByRaceId:[ZLAppDelegate getAppData].currentWager.selectedRaceId];
                                         if( raceDetails ){
                                             if( ![raceDetails.status isEqualToString:@"BETTING_ON"]){
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Selected Race is unavailable for betting at this time. Please select a different race." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                 [alert show];
                                                 [self gotoTracks];
                                                 //[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"ZLWagerRacesDidLoad" object:nil userInfo:nil];
                                                 return;
                                             }
                                             if( [ZLAppDelegate getAppData].currentWager.selectedRaceId < _race_card.currentRaceNumber ){
                                                 
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Selected Race is unavailable for betting at this time. Please select a different race." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                 [alert show];
                                                 [self gotoTracks];
                                                 //[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"ZLWagerRacesDidLoad" object:nil userInfo:nil];
                                                 return;
                                             }
                                             else{
                                                  [ZLAppDelegate getAppData].currentWager.selectedRace = raceDetails;
                                                 [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"ZLWagerRacesDidLoad" object:nil userInfo:nil];
                                             }
                                         }
                                     }
                                     [self.sideMenu reloadTiles];
                                     
                                 }failure:^(NSError *error){
                                     
                                 }];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"ZLWagerTracksDidLoad" object:nil userInfo:nil];
        }
    [self.sideMenu reloadTiles];
    }failure:^(NSError *error){
        

        
    }];
}

- (void) loadWagerView:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"LoadWagerView"])
    {
        NSNumber *viewIndex = [[notification userInfo] objectForKey:@"currentLoadedIndex"];
        [self loadViewInWager:[viewIndex integerValue]];
        viewIndex=nil;
    }
}

- (void) loadViewInWager:(Wager)index
{
    [self.sideMenu nextViewLoaded];

    
    UIViewController *viewController = nil;
    index++;
    switch (index)
    {
        case WagerTrack:
            viewController = [[ZLTrackViewController alloc] init];
            break;
            
        case WagerRace:
            viewController = [[ZLRaceViewController alloc] init];
            break;
            
        case WagerAmount:
            viewController = [[ZLAmountViewController alloc] init];
            break;
            
        case WagerBetType:
            viewController = [[ZLBetTypeViewController alloc] init];
            
            break;
            
        case WagerRunners:
            viewController = [[ZLRunnersViewController alloc] init];
            break;
            
        default:
            break;
    }
    
    if (viewController)
    {
        [self.wagerNavigationCoontroller pushViewController:viewController animated:NO];
    }
}


- (void) HandleTopRightButtons:(NSNotification *) notification
{
    if (self.listGridButton.hidden)
    {
        self.listGridButton.hidden = NO;
        self.homeButton.hidden = NO;
        self.amountButton.hidden = YES;
    }
    else
    {
        self.listGridButton.hidden = YES;
        self.homeButton.hidden = YES;
        self.amountButton.hidden = NO;
    }
}

//- (void) loadSideMenu:(NSNotification *) notification
//{
//    if (self.listGridButton.hidden)
//    {
//        self.listGridButton.hidden = NO;
//        self.homeButton.hidden = NO;
//        self.amountButton.hidden = YES;
//    }
//    else
//    {
//        self.listGridButton.hidden = YES;
//        self.homeButton.hidden = YES;
//        self.amountButton.hidden = NO;
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.amountsArray = [[NSMutableArray alloc] init];
    
    
    [self clearSelectedValuesWithIndex:-1];
    
    
    self.navigationController.navigationBarHidden = YES;
    
    [self prepareTopView];
    
    [self.topLeftImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width - SIDE_MENU_WIDTH, 64)];
    
    [self.topRightImageView setFrame:CGRectMake(self.topLeftImageView.frame.size.width, 0, SIDE_MENU_WIDTH, 64)];

    
    [self.wagerNavigationCoontroller.view setFrame:CGRectMake(0, 64, self.view.frame.size.width - SIDE_MENU_WIDTH, self.view.frame.size.height - 64)];
    [self.view addSubview:self.wagerNavigationCoontroller.view];
    
    self.sideMenu = [[ZLSideMenu alloc] initWithFrame:CGRectMake(self.view.frame.size.width - SIDE_MENU_WIDTH, 64, SIDE_MENU_WIDTH, self.view.frame.size.height-64)];
    [self.sideMenu setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.sideMenu.delegate = self;
    
    [self.view addSubview:self.sideMenu];
    
    [self loadData];
    [[ZLAppDelegate getAppData] clearCurrentWager];
}
- (void) prepareTopView
{
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"toggle.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    backButton = nil;
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, 50, 21)];
    [title setText:@"Wager"];
    [title setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [title setTextColor:[UIColor whiteColor]];
    [title setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:title];
    title=nil;
    
    
    self.amountButton = [[UIButton alloc] initWithFrame:CGRectMake(237, 20, 83, 46)];
   //[self.amountButton setTitle:[[WarHorseSingleton sharedInstance] currencySymbel] forState:UIControlStateNormal];
    //self.amountButton.titleLabel.text = [[WarHorseSingleton sharedInstance] currencySymbel];

    
    [self.amountButton setTitle:[[WarHorseSingleton sharedInstance] currencySymbel] forState:UIControlStateNormal];

    //[self.amountButton setBackgroundImage:[UIImage imageNamed:@"dollarEmptyBg"] forState:UIControlStateNormal];
//    [self.amountButton setTitle:@"" forState:UIControlStateNormal];
    //[self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:22]];
    [self.amountButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self.amountButton.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.amountButton addTarget:self action:@selector(amountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.amountButton];
    
    [self.view bringSubviewToFront:self.amountButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceUpdated:) name:@"BalanceUpdated" object:nil];
    
}



-(void)balanceUpdated:(NSNotification *)notification{
//    [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];

    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    
}

- (void)amountButtonClicked:(id)sender
{
    if ([self.amountButton isSelected])
    {
        [self.amountButton setSelected:NO];
        [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:22]];
        [self.amountButton setFrame:CGRectMake(237,20, 83, 46)];
        
    }
    else{
        [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];

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
        [self.amountButton setFrame:CGRectMake(237, 20, 83, 46)];
    }
}

- (void)timerMethod:(NSTimer *)timer
{
    if ([self.amountButton isSelected])
    {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(237, 20, 83, 46)];
    }
}

- (void) loadData
{
    self.sideMenuDetailsArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"TRACK" forKey:@"title"];
    [dic setValue:@"track.png" forKey:@"imageName"];
    [dic setValue:@"track_selected.png" forKey:@"imageSelected"];
    [dic setObject:[NSNumber numberWithInt:WagerTrack] forKey:@"tag"];
    [self.sideMenuDetailsArray addObject:dic];
    
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setValue:@"RACE" forKey:@"title"];
    [dic1 setValue:@"race.png" forKey:@"imageName"];
    [dic1 setValue:@"race_selected.png" forKey:@"imageSelected"];
    [dic1 setObject:[NSNumber numberWithInt:WagerRace] forKey:@"tag"];
    [self.sideMenuDetailsArray addObject:dic1];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setValue:@"AMOUNT" forKey:@"title"];
    [dic2 setValue:@"Amount.png" forKey:@"imageName"];
    [dic2 setValue:@"Amount_selected.png" forKey:@"imageSelected"];
    [dic2 setObject:[NSNumber numberWithInt:WagerAmount] forKey:@"tag"];
    [self.sideMenuDetailsArray addObject:dic2];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setValue:@"BET TYPE" forKey:@"title"];
    [dic3 setValue:@"betype.png" forKey:@"imageName"];
    [dic3 setValue:@"betType_selected.png" forKey:@"imageSelected"];
    [dic3 setObject:[NSNumber numberWithInt:WagerBetType] forKey:@"tag"];
    [self.sideMenuDetailsArray addObject:dic3];
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    [dic4 setValue:@"RUNNERS" forKey:@"title"];
    [dic4 setValue:@"runners.png" forKey:@"imageName"];
    [dic4 setValue:@"runners_selected.png" forKey:@"imageSelected"];
    [dic4 setObject:[NSNumber numberWithInt:WagerRunners] forKey:@"tag"];
    [self.sideMenuDetailsArray addObject:dic4];
    
    
    [self sortItemsArray];
}

- (void) sortItemsArray
{
    [self.sideMenuDetailsArray sortUsingComparator:
     ^(id obj1, id obj2)
     {
         int value1 = [[obj1 objectForKey:@"tag"] integerValue];
         int value2 = [[obj2 objectForKey:@"tag"] integerValue];
         if (value1 > value2)
         {
             return (NSComparisonResult)NSOrderedDescending;
         }
         
         if (value1 < value2)
         {
             return (NSComparisonResult)NSOrderedAscending;
         }
         return (NSComparisonResult)NSOrderedSame;
     }];
}


- (void)tapDetectingView:(id)view
{
    ZLSideMenuTile *tile = (ZLSideMenuTile *)view;
    NSLog(@"WagerAmount %d",WagerAmount);
    NSLog(@"[ZLAppDelegate getAppData].currentWager.amount %f",[ZLAppDelegate getAppData].currentWager.amount);
    
    
    if (tile.tag == WagerTrack){
        [ZLAppDelegate getAppData].currentWager.selectedRace = nil;
        [ZLAppDelegate getAppData].currentWager.selectedRaceId = -1;
        [ZLAppDelegate getAppData].currentWager.selectedBetType = @"";
        [ZLAppDelegate getAppData].currentWager.raceTimeRange = @"";

        [ZLAppDelegate getAppData].currentWager.amount = 0.0;
        [self clearRunnerSelection];
        [amountView removeFromSuperview];
        UIViewController *viewController = [self.wagerNavigationCoontroller.viewControllers objectAtIndex:tile.tag];
        [self.wagerNavigationCoontroller popToViewController:viewController animated:NO];
    }
    else if(tile.tag == WagerRace ){
        [ZLAppDelegate getAppData].currentWager.selectedBetType = @"";
        [ZLAppDelegate getAppData].currentWager.raceTimeRange = @"";
        [ZLAppDelegate getAppData].currentWager.amount = 0.0;
        [self clearRunnerSelection];
        [amountView removeFromSuperview];
        UIViewController *viewController = [self.wagerNavigationCoontroller.viewControllers objectAtIndex:tile.tag];
        [self.wagerNavigationCoontroller popToViewController:viewController animated:NO];
    }
    else if(tile.tag == WagerBetType ){
//        [ZLAppDelegate getAppData].currentWager.selectedRace = nil;
//        [ZLAppDelegate getAppData].currentWager.selectedRaceId = -1;
        [ZLAppDelegate getAppData].currentWager.selectedBetType = @"";
        [ZLAppDelegate getAppData].currentWager.raceTimeRange = @"";

        [ZLAppDelegate getAppData].currentWager.amount = 0.0;
        [self clearRunnerSelection];
        UIViewController *viewController = [self.wagerNavigationCoontroller.viewControllers objectAtIndex:tile.tag];
        [self.wagerNavigationCoontroller popToViewController:viewController animated:NO];
    }
    //&& ([ZLAppDelegate getAppData].currentWager.amount > 0)
    else if(tile.tag == WagerAmount  ){

        [self clearRunnerSelection];
        int IndexValu;
        
        if ([[[WarHorseSingleton sharedInstance] betType] isEqualToString:@"MultiBetsType"]){
            IndexValu =WagerAmount+1;
        }else{
            [ZLAppDelegate getAppData].currentWager.amount = 0.0;

            IndexValu =WagerAmount;
        }
        
        ZLAmountViewController *amountViewController =  [self.wagerNavigationCoontroller.viewControllers objectAtIndex:IndexValu];
        
        [self.wagerNavigationCoontroller popToViewController:amountViewController animated:NO];
    }
    
    
    else if (tile.tag == WagerRunners && [self isRunnersSelected])
    {
        
        
        if( self.placeWagerLoading )
            return;
        
        if( [[ZLAppDelegate getAppData].currentWager calculateTotalBetAmount] == 0){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Select runner(s) to complete the wagering process" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        
        self.placeWagerLoading = YES;
        [[LeveyHUD sharedHUD] appearWithText:@"Creating Wager..."];
        [[ZLAppDelegate getApiWrapper] refreshBalance:YES success:^(NSDictionary* _userInfo){
            
            if ([[[ZLAppDelegate getAppData] currentWager] calculateTotalBetAmount] > [[ZLAppDelegate getAppData] balanceAmount]) {
                
                [[LeveyHUD sharedHUD] disappear];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Not enough funds to place the wager." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                self.placeWagerLoading = NO;
                return;
                
            }
            
            self.objZLConformationViewController = [[ZLConformationViewController alloc]init];
            self.objZLConformationViewController.view.frame = self.view.bounds;
            self.objZLConformationViewController.delegate = self;
            [self.view addSubview:self.objZLConformationViewController.view];
            
        }failure:^(NSError *error){
            [[LeveyHUD sharedHUD] disappear];
            self.placeWagerLoading = NO;
            
        }];
        
        
    }
    else
    {
        //[self clearRunnerSelection];
        [amountView removeFromSuperview];
        int IndexValu;
        
        if ([[[WarHorseSingleton sharedInstance] betType] isEqualToString:@"MultiBetsType"]){
            IndexValu =tile.tag+1;
        }else{
            
            IndexValu =tile.tag;
        }
        UIViewController *viewController = [self.wagerNavigationCoontroller.viewControllers objectAtIndex:IndexValu];
        [self.wagerNavigationCoontroller popToViewController:viewController animated:NO];
    }
    
}

-(void)clearRunnerSelection
{
    [ZLAppDelegate getAppData].currentWager.selectedRunners = [NSMutableDictionary dictionary];
    ZLRunnersViewController *runners = [[ZLRunnersViewController alloc] init];
    [runners reloadViews];
    
}

- (CGFloat) yValueToStart
{
    if (self.wagerNavigationCoontroller.view.frame.origin.y <=0) {
        return ((self.wagerNavigationCoontroller.view.frame.size.height + 45)/5) * WagerAmount;
    }
    else{
        return (self.wagerNavigationCoontroller.view.frame.size.height/5) * WagerAmount;
    }
}

- (BOOL) isAmoutViewLoaded
{
    NSArray *suvViewArray = [self.wagerNavigationCoontroller.view subviews];
    if([suvViewArray containsObject:amountView]) {
        return YES;
    }
    else{
        return NO;
    }
}

- (NSUInteger) indexOfSelectedAmount
{
    int counter = 0;
    for (NSMutableDictionary *dic in self.amountsArray) {
        NSString *amount = [dic valueForKey:@"amountNumber"];
        NSString *selectedAmount = [[ZLSelectedValues sharedInstance] selectedAmount];
        if ([selectedAmount isEqualToString:amount]) {
            return counter;
        }
        counter ++;
    }
    return 0;
}

#pragma mark -  Amount View Delegate Methods

- (NSUInteger) numberOfItems
{
    return self.amountsArray.count;
}

- (NSString *) titleForItem:(int) index
{
    return [[self.amountsArray objectAtIndex:index] valueForKey:@"amountNumber"];
}

- (void) selectedRowWithIndex:(int)index
{
}


#pragma mark - Conformation delegate methods

- (void) cancelWager:(id)sender{

    self.placeWagerLoading = NO;
}

- (void) confirmWager:(id)sender
{
    self.placeWagerLoading = NO;
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[LeveyHUD sharedHUD] appearWithText:@"Submitting Wager..."];
    
        [[ZLAppDelegate getApiWrapper] placeWager:[ZLAppDelegate getAppData].currentWager
                                          success:^(NSDictionary* _userInfo){
                                              //NSLog(@"Place Bet Class %@",_userInfo);
                                              
                                              self.objResult = [[ZLPlaceWagerResultsViewController alloc] init];
                                              [self.objResult setDelegate:self];
                                              self.objResult.view.frame = self.view.bounds;
                                              [self.view addSubview:self.objResult.view];
                                              [self.objZLConformationViewController.view removeFromSuperview];
                                              [[LeveyHUD sharedHUD] disappear];
                                              
                                          }failure:^(NSError *error){
                                              [self.objZLConformationViewController.view removeFromSuperview];
                                              [[LeveyHUD sharedHUD] disappear];
                                              NSString * message = @"Sorry, we couldn't place the wager.";
                                              if( error ){
                                                  message = [NSString stringWithFormat:@"Sorry, we couldn't place the wager. \nError Code:%@", [error.userInfo objectForKey:@"response-message"]];
                                              }
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                              [alert show];
                                              
                                          }];
    
}

#pragma mark - Place Wager Result delegate methods

- (void) repeatWager{
    
}

-(void) gotoTracks{
    
    [ZLAppDelegate getAppData].currentWager.selectedRace = nil;
    [ZLAppDelegate getAppData].currentWager.selectedRaceId = -1;
    [ZLAppDelegate getAppData].currentWager.selectedBetType = @"";
    [ZLAppDelegate getAppData].currentWager.amount = 0.0;
    [self clearRunnerSelection];
    
    [self.sideMenu clearAllData];
    UIViewController *viewController = [self.wagerNavigationCoontroller.viewControllers objectAtIndex:WagerRace];
    [self.wagerNavigationCoontroller popToViewController:viewController animated:NO];
}

- (void) repeatWagerOnSameRace{
    
    [ZLAppDelegate getAppData].currentWager.selectedBetType = @"";
    [ZLAppDelegate getAppData].currentWager.amount = 0.0;
    [self clearRunnerSelection];
    ZLBetTypeViewController *viewController = (ZLBetTypeViewController*)[self.wagerNavigationCoontroller.viewControllers objectAtIndex:WagerBetType];
    [viewController.betType_CollectionView reloadData];
    [self.wagerNavigationCoontroller popToViewController:viewController animated:NO];
    [self.sideMenu selectTileWithTag:WagerBetType];
}

- (void) newWager
{
    [self.wagerNavigationCoontroller.view setFrame:CGRectMake(0, 64, self.view.frame.size.width - SIDE_MENU_WIDTH, self.view.frame.size.height - 64)];
    [self removeAllData];
}

- (void) removeAllData
{
    [[ZLAppDelegate getAppData] clearCurrentWager];
    
    [self.sideMenu clearAllData];
    [self.wagerNavigationCoontroller popToRootViewControllerAnimated:NO];
}

- (void) loadCurrentBets
{
    [self.wagerNavigationCoontroller popToRootViewControllerAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardMyBets] forKey:@"viewNumber"]];
}
- (NSString *) selectedValuesForIndex:(NSUInteger)index
{
    
    if (WagerRace == index)
    {
        return [[ZLSelectedValues sharedInstance] selectedRace];
    }
    else if(WagerAmount == index && ![self isAmoutViewLoaded])
    {
        return [[ZLSelectedValues sharedInstance] selectedAmount];
    }
    else if(WagerBetType == index){
        return [[ZLSelectedValues sharedInstance] selectedBetType];
    }
    else if(WagerTrack == index){
        return [[ZLSelectedValues sharedInstance] selectedTrack];
    }
    return nil;
}

- (UIImage *) imageForIndex:(NSUInteger)index
{
    NSMutableDictionary *dic = [self.sideMenuDetailsArray objectAtIndex:index];
    
    if ([self isRunnersSelected] && index == WagerRunners && [[ZLAppDelegate getAppData].currentWager calculateTotalBetAmount] != 0) {
        return nil;
    }
    else if(index == WagerAmount && [self isAmoutViewLoaded]){
        return nil;
    }
    else if (index == WagerTrack && [ZLAppDelegate getAppData].currentWager.selectedTrack != nil) {
        return nil;
    }
    else if (index == WagerRace && [ZLAppDelegate getAppData].currentWager.selectedRace != nil) {
        return nil;
    }
    else if (index == WagerBetType && ([ZLAppDelegate getAppData].currentWager.selectedBetType != nil && [[ZLAppDelegate getAppData].currentWager.selectedBetType length] > 0)) {
        return nil;
    }

    return [UIImage imageNamed:[dic valueForKey:@"imageName"]];
}

- (NSString *) titleForIndex:(NSUInteger)index
{
    NSMutableDictionary *dic = [self.sideMenuDetailsArray objectAtIndex:index];
    if ([self isRunnersSelected] && index == WagerRunners && [[ZLAppDelegate getAppData].currentWager calculateTotalBetAmount] != 0) {
        return @"";
    }
    else if (WagerTrack == index){
        if([ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber != -1){
            ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
            if(_race_card){
                return _race_card.name;
            }
        }
    }
    else if(index == WagerRace){
        if([ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber != -1){
            ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
            if(_race_card){
                ZLRaceDetails * _race_details = [_race_card findRaceDeatilsByRaceId:[ZLAppDelegate getAppData].currentWager.selectedRaceId];
                if(_race_details){
                    return  [NSString stringWithFormat:@"%d",_race_details.number];
                }
            }
        }
    }
    else if(index == WagerBetType){
        if([ZLAppDelegate getAppData].currentWager.selectedBetType != nil && [[ZLAppDelegate getAppData].currentWager.selectedBetType length] > 0){
            return [ZLAppDelegate getAppData].currentWager.selectedBetType;
        }
    }
    else if(index == WagerAmount){
        if([ZLAppDelegate getAppData].currentWager.amount != 0.0)
            return [NSString stringWithFormat:@"%@%.0f",[[WarHorseSingleton sharedInstance] currencySymbel], [ZLAppDelegate getAppData].currentWager.amount];
    }
    else {
        
    }
    
    return [dic valueForKey:@"title"];
}


- (UIImage *) backgroundImage:(NSUInteger)index
{
    if ([self isRunnersSelected] && index == WagerRunners && [[ZLAppDelegate getAppData].currentWager calculateTotalBetAmount] != 0) {
        
        if (1<=[[ZLAppDelegate getAppData].currentWager calculateTotalBetAmount]){
            return [self imageByDrawingTextOnImage:[UIImage imageNamed:@"placewagerbgutton"] withtext:[NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[ZLAppDelegate getAppData].currentWager calculateTotalBetAmount]]];
            
        }else{
            int amount  = [[ZLAppDelegate getAppData].currentWager calculateTotalBetAmount]*100;
            return [self imageByDrawingTextOnImage:[UIImage imageNamed:@"placewagerbgutton"] withtext:[NSString stringWithFormat:@"%d%@",amount,@"p"]];
        }

        
    }
    else if(index == WagerAmount && [self isAmoutViewLoaded]){
        return [UIImage imageNamed:@"arrow_black.png"];
    }
    else if (index == self.sideMenu.whichViewLoaded)
    {
        return [UIImage imageNamed:@"selectedsidemenu-4.png"];
    }
    else if (index < self.sideMenu.whichViewLoaded)
    {
        return [UIImage imageNamed:@"selectaafterbg.png"];
    }
    else
    {
        return [UIImage imageNamed:@"sidebar_bg_1field.png"];
    }

}

- (UIImage *)imageByDrawingTextOnImage:(UIImage *)image withtext:(NSString*) text
{
	// begin a graphics context of sufficient size
	UIGraphicsBeginImageContext(image.size);
    
	// draw original image into the context
	[image drawAtPoint:CGPointZero];
    
	// get the context for CoreGraphics
//	CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Roboto-Light" size:13]
                    constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                        lineBreakMode:NSLineBreakByWordWrapping];
    
    int x = (53.0 - size.width) / 2.0;
    
    [text drawAtPoint:CGPointMake(15 + x, 16.0) withFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
	// make image out of bitmap context
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
	// free the context
	UIGraphicsEndImageContext();
    
	return retImage;
}

- (BOOL) isRunnersSelected
{
    for (NSString * key in [ZLAppDelegate getAppData].currentWager.selectedRunners) {
        NSMutableArray * _arr = [[ZLAppDelegate getAppData].currentWager.selectedRunners objectForKey:key];
        if( !_arr || [_arr count] <= 0) {
            return NO;
        }
    }
    
    return YES;
}


- (void)clearSelectedValuesWithIndex:(NSInteger)index
{
    
    if (index < WagerBetType)
    {
        [ZLAppDelegate getAppData].currentWager.selectedBetType = @"";
    }
    
    if (index < WagerAmount) {
        [ZLAppDelegate getAppData].currentWager.amount = 0.0;
    }
    
    if (index < WagerRace) {
        [ZLAppDelegate getAppData].currentWager.selectedTrackId = -1;
        
    }
    
    if (index < WagerTrack) {
        [ZLAppDelegate getAppData].currentWager.selectedRaceId = -1;
    }
    
    if (index < WagerRunners) {
        
    }
}


- (IBAction)switchBetweenListAndGried:(id)sender
{
    if ([self.listGridButton isSelected])
    {
        [self.listGridButton setSelected:NO];
    }
    else{
        [self.listGridButton setSelected:YES];
    }
    
    NSArray *viewControllersArray = self.wagerNavigationCoontroller.viewControllers;
    if (viewControllersArray.count > WagerRunners)
    {
        ZLRunnersViewController *vc = (ZLRunnersViewController *)[viewControllersArray objectAtIndex:WagerRunners];
        [vc switchBetweenListAndGrid];
    }
}

- (IBAction)homeButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardHome] forKey:@"viewNumber"]];
}

-(void) viewDidAppear:(BOOL)animated{
    
    if( !self.wagerDataRefreshTimer )
        self.wagerDataRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 * 60 target:self selector:@selector(refreshWagerData) userInfo:nil repeats:YES];
    [super viewDidAppear:animated];


}

-(void) viewDidDisappear:(BOOL)animated{

    if( [self.wagerDataRefreshTimer isValid]){
        [self.wagerDataRefreshTimer invalidate];
        self.wagerDataRefreshTimer = nil;
    }
    [super viewDidDisappear:animated];
    
}

- (void) viewDidUnload
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.sideMenu=nil;
    self.sideMenuDetailsArray=nil;
    self.amountButton=nil;
    self.amountsArray=nil;
    self.homeButton=nil;
    self.listGridButton=nil;
    self.objZLConformationViewController=nil;
    self.sideMenu.itemsArray=nil;
    self.sideMenu.tilesArray=nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
