//
//  SPRewardsViewController.m
//  WarHorse
//
//  Created by Enterpi on 23/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPRewardsViewController.h"
#import "SPSCRChanges.h"
#import "SPSCRChangesCustomCell.h"
#import "SPRewardsDetailViewController.h"

#define krewardsCustomCellIdentifier @"rewardsCustomCellIdentifier"

@interface SPRewardsViewController ()

@property (strong) UINib *rewardsCustomCellNib;
@property (strong) NSMutableDictionary *rewardsDataDic;
@property (strong) IBOutlet UITableView *rewardsTableView;
@property (strong) IBOutlet UIImageView *headerImageView;
@property (strong) SPSCRChanges *rewards;
@property (strong) NSMutableArray *rewardsDataArray;
@property (strong) NSMutableArray *rewardsObjectsArray;
@property (strong) SPSCRChangesCustomCell *rewardsCustomCell;

// Present calendar View
@property (strong) UIDatePicker *datePicker;
@property (strong) UIActionSheet *actionSheet;
@property (strong) UIToolbar *pickerToolBar;

@property (strong) UILabel *dateLabel;
@property (strong) IBOutlet UISearchBar *searchBar;
@property (strong) NSMutableArray *filteredRewardsObjectsArray;
@property (assign) BOOL isFinished;

- (IBAction)backToHome:(id)sender;

@end

@implementation SPRewardsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - ViewLifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.filteredRewardsObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.rewardsDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.rewardsObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 106, 300, 16)];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.backgroundColor = [UIColor clearColor];
    
    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // or this format to show day of the week Sat,11-12-2011 23:27:09
    
    [dateFormatter setDateFormat:@"EEEE MMM dd, YYYY"];
    
    // Get the date time in NSString
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
    [self.dateLabel setText:dateInStringFormated];
    
    CGSize maximumDateLabelSize = CGSizeMake(299,9999);
    
        
    CGSize expectedDateLabelSize = [self.dateLabel.text boundingRectWithSize:maximumDateLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.dateLabel.font} context:nil].size;
    
    
    //Deprecations method
    //CGSize expectedDateLabelSize = [self.dateLabel.text sizeWithFont:self.dateLabel.font constrainedToSize:maximumDateLabelSize lineBreakMode:self.dateLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect dateLabelNewFrame = self.dateLabel.frame;
    dateLabelNewFrame.size.width = expectedDateLabelSize.width;
    dateLabelNewFrame.origin.x = (self.view.frame.size.width - dateLabelNewFrame.size.width)/2;
    self.dateLabel.frame = dateLabelNewFrame;
    
    [self.dateLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.dateLabel setTextColor:[UIColor colorWithRed:14.0/255.0f green:78.0/255.0f   blue:113.0/255.0f alpha:1.0]];
    [self.view addSubview:self.dateLabel];
    UILabel *carryoverText = [[UILabel alloc]initWithFrame:CGRectMake(47, 14, 300, 19)];
    [carryoverText setBackgroundColor:[UIColor clearColor]];
    [carryoverText setText:@"Rewards"];
    [carryoverText setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
    [carryoverText setTextColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f   blue:255.0/255.0f alpha:1.0]];
    [self.headerImageView addSubview:carryoverText];
    [self.rewardsTableView setSeparatorColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]];
    [self loadData];
    
    self.rewardsCustomCellNib = [UINib nibWithNibName:@"SPSCRChangesCustomCell" bundle:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    self.rewardsObjectsArray = nil;
    self.filteredRewardsObjectsArray = nil;
    [self setSearchBar:nil];
    [super viewDidUnload];
}

-(void)loadData
{
    self.rewardsDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.rewardsDataDic setValue:@"Albuquerque" forKey:@"raceTrackTitle"];
    [self.rewardsDataDic setValue:@"Albuquerque, New Mexico" forKey:@"trackVenueLabel"];
    [self.rewardsDataDic setObject:[UIColor colorWithRed:69.0/255.0f green:138.0/255.0f blue:242/255.0f alpha:1.0] forKey:@"viewBgColor"];
    [self.rewardsDataArray addObject:self.rewardsDataDic];
    
    self.rewardsDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.rewardsDataDic setValue:@"Arapahoe" forKey:@"raceTrackTitle"];
    [self.rewardsDataDic setValue:@"Aurora, Colorado" forKey:@"trackVenueLabel"];
    [self.rewardsDataDic setObject:[UIColor colorWithRed:164.0/255.0f green:99.0/255.0f blue:165.0/255.0f alpha:1.0] forKey:@"viewBgColor"];
    [self.rewardsDataArray addObject:self.rewardsDataDic];
    
    self.rewardsDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.rewardsDataDic setValue:@"Arlington Park" forKey:@"raceTrackTitle"];
    [self.rewardsDataDic setValue:@"Arlington, Illinois" forKey:@"trackVenueLabel"];
    [self.rewardsDataDic setObject:[UIColor colorWithRed:113.0/255.0f green:170.0/255.0f blue:0.0/255.0f alpha:1.0] forKey:@"viewBgColor"];
    [self.rewardsDataArray addObject:self.rewardsDataDic];
    
    self.rewardsDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.rewardsDataDic setValue:@"Assiniboia" forKey:@"raceTrackTitle"];
    [self.rewardsDataDic setValue:@"Winnipeg, Manitoba" forKey:@"trackVenueLabel"];
    [self.rewardsDataDic setObject:[UIColor colorWithRed:178.0/255.0f green:0.0/255.0f blue:36.0/255.0f alpha:1.0] forKey:@"viewBgColor"];
    [self.rewardsDataArray addObject:self.rewardsDataDic];
    
    self.rewardsDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.rewardsDataDic setValue:@"Calder" forKey:@"raceTrackTitle"];
    [self.rewardsDataDic setValue:@"Miami, Florida" forKey:@"trackVenueLabel"];
    [self.rewardsDataDic setObject:[UIColor colorWithRed:237.0/255.0f green:106.0/255.0f blue:62.0/255.0f alpha:1.0] forKey:@"viewBgColor"];
    [self.rewardsDataArray addObject:self.rewardsDataDic];
    
    self.rewardsDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.rewardsDataDic setValue:@"Canterbury Park" forKey:@"raceTrackTitle"];
    [self.rewardsDataDic setValue:@"Shakopee, Minnesota" forKey:@"trackVenueLabel"];
    [self.rewardsDataDic setObject:[UIColor colorWithRed:69.0/255.0f green:138.0/255.0f blue:242/255.0f alpha:1.0] forKey:@"viewBgColor"];
    [self.rewardsDataArray addObject:self.rewardsDataDic];
    
    self.rewardsDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.rewardsDataDic setValue:@"Cassia Fair" forKey:@"raceTrackTitle"];
    [self.rewardsDataDic setValue:@"Bhurely, Idaho" forKey:@"trackVenueLabel"];
    [self.rewardsDataDic setObject:[UIColor colorWithRed:164.0/255.0f green:99.0/255.0f blue:165.0/255.0f alpha:1.0] forKey:@"viewBgColor"];
    [self.rewardsDataArray addObject:self.rewardsDataDic];
    
    self.rewardsDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.rewardsDataDic setValue:@"Arapahoe" forKey:@"raceTrackTitle"];
    [self.rewardsDataDic setValue:@"Aurora, Colorado" forKey:@"trackVenueLabel"];
    [self.rewardsDataDic setObject:[UIColor colorWithRed:113.0/255.0f green:170.0/255.0f blue:0.0/255.0f alpha:1.0] forKey:@"viewBgColor"];
    [self.rewardsDataArray addObject:self.rewardsDataDic];
    
    self.rewardsDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.rewardsDataDic setValue:@"Arlington Park" forKey:@"raceTrackTitle"];
    [self.rewardsDataDic setValue:@"Arlington, Illinois" forKey:@"trackVenueLabel"];
    [self.rewardsDataDic setObject:[UIColor colorWithRed:178.0/255.0f green:0.0/255.0f blue:36.0/255.0f alpha:1.0] forKey:@"viewBgColor"];
    [self.rewardsDataArray addObject:self.rewardsDataDic];
    
    self.rewardsDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.rewardsDataDic setValue:@"Assiniboia" forKey:@"raceTrackTitle"];
    [self.rewardsDataDic setValue:@"Winnipeg, Manitoba" forKey:@"trackVenueLabel"];
    [self.rewardsDataDic setObject:[UIColor colorWithRed:237.0/255.0f green:106.0/255.0f blue:62.0/255.0f alpha:1.0] forKey:@"viewBgColor"];
    [self.rewardsDataArray addObject:self.rewardsDataDic];
    
    self.rewardsDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.rewardsDataDic setValue:@"Calder" forKey:@"raceTrackTitle"];
    [self.rewardsDataDic setValue:@"Miami, Florida" forKey:@"trackVenueLabel"];
    [self.rewardsDataDic setObject:[UIColor colorWithRed:69.0/255.0f green:138.0/255.0f blue:242/255.0f alpha:1.0] forKey:@"viewBgColor"];
    [self.rewardsDataArray addObject:self.rewardsDataDic];
    
    self.rewardsDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.rewardsDataDic setValue:@"Canterbury Park" forKey:@"raceTrackTitle"];
    [self.rewardsDataDic setValue:@"Shakopee, Minnesota" forKey:@"trackVenueLabel"];
    [self.rewardsDataDic setObject:[UIColor colorWithRed:164.0/255.0f green:99.0/255.0f blue:165.0/255.0f alpha:1.0] forKey:@"viewBgColor"];
    [self.rewardsDataArray addObject:self.rewardsDataDic];
    
    self.rewardsDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.rewardsDataDic setValue:@"Cassia Fair" forKey:@"raceTrackTitle"];
    [self.rewardsDataDic setValue:@"Bhurely, Idaho" forKey:@"trackVenueLabel"];
    [self.rewardsDataDic setObject:[UIColor colorWithRed:113.0/255.0f green:170.0/255.0f blue:0.0/255.0f alpha:1.0] forKey:@"viewBgColor"];
    [self.rewardsDataArray addObject:self.rewardsDataDic];
    
    for (int i = 0; i < [self.rewardsDataArray count]; i++) {
        
        self.rewards = [[SPSCRChanges alloc] init];
        self.rewards.trackname = [[self.rewardsDataArray objectAtIndex:i] valueForKey:@"raceTrackTitle"];
        self.rewards.date = [[self.rewardsDataArray objectAtIndex:i] valueForKey:@"trackVenueLabel"];
        self.rewards.viewBgColor = [[self.rewardsDataArray objectAtIndex:i] valueForKey:@"viewBgColor"];
        [_rewardsObjectsArray addObject:self.rewards];
        
    }
    
}

#pragma mark - Private API

- (IBAction)backToHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// Calendar Methods

- (IBAction)showCalendar:(id)sender {
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select time" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    self.pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.pickerToolBar.barStyle = UIBarStyleBlackOpaque;
    [self.pickerToolBar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datecancelbuttonClicked:)];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donebuttonClicked:)];
    [barItems addObject:flexSpace];
    [barItems addObject:doneBtn];
    [self.pickerToolBar setItems:barItems animated:YES];
    
    if(self.datePicker)
    {
        self.datePicker=nil;
    }
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, 320, 260)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    [self.actionSheet addSubview:self.pickerToolBar];
    [self.actionSheet addSubview:self.datePicker];
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0,0,320, 464)];
    
}

-(void)donebuttonClicked:(id) sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    [dateFormatter setDateFormat:@"EEEE MMM dd, YYYY"];
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:self.datePicker.date];
    
    [self.dateLabel setText:dateInStringFormated];
    
    [self.actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

-(void)datecancelbuttonClicked:(id) sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	// Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
	[self.filteredRewardsObjectsArray removeAllObjects];
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.raceTrackTitle contains[c] %@ OR SELF.trackVenueLabel contains[c] %@",searchText, searchText];
    self.filteredRewardsObjectsArray = [NSMutableArray arrayWithArray:[self.rewardsObjectsArray filteredArrayUsingPredicate:predicate]];
}


#pragma mark - DataSources

#pragma mark - TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return  self.filteredRewardsObjectsArray.count;
    else
        return  self.rewardsObjectsArray.count;
        // Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView registerNib:self.rewardsCustomCellNib forCellReuseIdentifier:krewardsCustomCellIdentifier];

    self.rewardsCustomCell = [tableView dequeueReusableCellWithIdentifier:krewardsCustomCellIdentifier];
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
        [self.rewardsCustomCell setScrChanges:[self.filteredRewardsObjectsArray objectAtIndex:indexPath.row]];
    else
        
        [self.rewardsCustomCell setScrChanges:[self.rewardsObjectsArray objectAtIndex:indexPath.row]];
    
    [self.rewardsCustomCell updateViewAtIndexPath: indexPath];
    return self.rewardsCustomCell;
}

#pragma mark - Delegates

#pragma mark - TableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    SPRewardsDetailViewController *rewardsViewController = [[SPRewardsDetailViewController alloc] init];
//    [rewardsViewController setRewardsTracksArray:self.rewardsObjectsArray];
    [self.navigationController pushViewController:rewardsViewController animated:YES];
    
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
