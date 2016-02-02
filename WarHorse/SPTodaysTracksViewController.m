//
//  SPTodaysTracksViewController.m
//  WarHorse
//
//  Created by Sparity on 22/01/14.
//  Copyright (c) 2014 Zytrix Labs. All rights reserved.
//

#import "SPTodaysTracksViewController.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "SPSchedule.h"
#import "SPSchedulesCell.h"
#import "LeveyHUD.h"
#import "ZLRaceCard.h"
#import "SPTodaysTrackCell.h"
#import "ZLRaceCard.h"


static NSString *const kcustomScheduleCellIdentifier = @"customScheduleCellIdentifier";
static NSString *const kcustomScheduleCellNib = @"SPTodaysTrackCell";

@interface SPTodaysTracksViewController () <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (nonatomic, strong) NSMutableArray *tracksArray;
@property (nonatomic, strong) NSMutableArray *filteredTracksArray;
@property (strong, nonatomic) IBOutlet UITableView *todaySchedulerTable;
@property (strong, nonatomic) SPTodaysTrackCell *wagerCustomCell;


@property (nonatomic, strong) UIView *transparentView;

- (IBAction)backToHome;

@end

@implementation SPTodaysTracksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
    if ([[[WarHorseSingleton sharedInstance] localCountry] isEqualToString:@"en_UK"]){
        self.headerLabel.text = @"Today's Courses";
    }else{
        self.headerLabel.text = @"Today's Track";
    }

    
    [self.headerLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:16]];
    
    self.tracksArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.todaySchedulerTable registerNib:[UINib nibWithNibName:kcustomScheduleCellNib bundle:nil] forCellReuseIdentifier:kcustomScheduleCellIdentifier];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"EEEE, MMM dd, YYYY"];
    NSString *currentDateStr = [dateFormater stringFromDate:currentDate];
    [self.dateLabel setBackgroundColor:[UIColor colorWithRed:125/255.0f green:125/255.0f blue:125/255.0f alpha:1.0]];
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.text = currentDateStr;
    
    
    
    [self loadTracks];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backToHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark
#pragma API Call

- (void)loadTracks
{
    ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Tracks..."];
    
    [apiWrapper loadRaceCards:YES success:^(NSDictionary* _userInfo){
        self.tracksArray = (NSMutableArray *)[ZLAppDelegate getAppData].raceCards;
        [self.todaySchedulerTable reloadData];
        [[LeveyHUD sharedHUD] disappear];
        
    }failure:^(NSError *error){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Information" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [[LeveyHUD sharedHUD] disappear];
        
    }];
    
}



#pragma mark - DataSources

#pragma mark Tableview DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredTracksArray count];
    }
    else {
        return [self.tracksArray count];

    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    self.wagerCustomCell = (SPTodaysTrackCell *)[tableView dequeueReusableCellWithIdentifier:kcustomScheduleCellIdentifier forIndexPath:indexPath];
    self.wagerCustomCell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    
    [self.wagerCustomCell.raceTrack_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.wagerCustomCell.information_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:10]];
    [self.wagerCustomCell.raceNumber_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    [self.wagerCustomCell.mtp_TimeLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.wagerCustomCell.mtp_TimeLabel setBackgroundColor:[UIColor clearColor]];
    [self.wagerCustomCell.mtpNewLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.wagerCustomCell.rankLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    ZLRaceCard * _race_card;
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        _race_card = [self.filteredTracksArray objectAtIndex:indexPath.row];
    }
    else {
        _race_card = [self.tracksArray objectAtIndex:indexPath.row];
    }

    [self.wagerCustomCell.raceTrack_Label setText:_race_card.ticketName];
    if( _race_card.purseUsa == nil || [_race_card.purseUsa length] <= 0){
        [self.wagerCustomCell.information_Label setText:[NSString stringWithFormat:@"%@ | %@",_race_card.distance != nil ? _race_card.distance : @"", _race_card.trackType != nil ? _race_card.trackType : @""]];
    }
    else{
        [self.wagerCustomCell.information_Label setText:[NSString stringWithFormat:@"%@ | %@ \nPurse %@%@",_race_card.distance != nil ? _race_card.distance : @"", _race_card.trackType != nil ? _race_card.trackType : @"", [[WarHorseSingleton sharedInstance] currencySymbel],_race_card.purseUsa != nil ? _race_card.purseUsa : @"N/A"]];
    }
    if( [self.wagerCustomCell.information_Label.text isEqualToString:@" | "]){
        self.wagerCustomCell.information_Label.text = @"";
    }
    
    
    
    if ([_race_card.trackCountry isEqualToString:@"UK"]){
        self.wagerCustomCell.countryFlagImg.image = [UIImage imageNamed:@"uk.png"];

        [self.wagerCustomCell.raceNumber_Label setText:[NSString stringWithFormat:@"Race\n%@", _race_card.currentRace]];
        
    }else {
        self.wagerCustomCell.countryFlagImg.image = [UIImage imageNamed:@"us.png"];

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
    
    if([[WarHorseSingleton sharedInstance] isVideoSteamingEnable] == YES)
    {
        [self.wagerCustomCell.videoButton setHidden:NO];
    }
    else{
        [self.wagerCustomCell.videoButton setHidden:YES];

    }
    
    [self.wagerCustomCell.videoButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    self.wagerCustomCell.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    return self.wagerCustomCell;
    
    
    
    
    
}

#pragma mark - Delegates

#pragma mark - TableView Delagate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
    
    // If you are not using ARC:
    // return [[UIView new] autorelease];
}


#pragma mark - UISearchDisplayController Delegate Methods
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:kcustomScheduleCellNib bundle:nil] forCellReuseIdentifier:kcustomScheduleCellIdentifier];
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	// Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
	[self.filteredTracksArray removeAllObjects];
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    self.filteredTracksArray = [NSMutableArray arrayWithArray:[self.tracksArray filteredArrayUsingPredicate:predicate]];
}


- (void)videoButtonAction:(id)sender
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please Login/Signup to view Video Stream" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
}


@end
