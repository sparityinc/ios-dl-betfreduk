//
//  SPSelectionsViewController.m
//  WarHorse
//
//  Created by Ramya on 8/22/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPSelectionsViewController.h"
#import "SPSelections.h"
#import "SPDetailSelectionViewController.h"
#import "SPCustomSelectionCell.h"

#define kcustomSelectionCellIdentifier @"CustomSelectionCellIdentifier"

@interface SPSelectionsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    UIButton *cancelButton;
}

@property (strong, nonatomic) UINib *customSelectionCellNib;
@property (strong, nonatomic) IBOutlet UITableView *selectionsTableView;
@property (strong, nonatomic) NSMutableDictionary *raceParkDic;
@property (strong, nonatomic) NSMutableArray *raceParkArray;
@property (strong, nonatomic) IBOutlet SPCustomSelectionCell *customselectionCell;
@property (strong, nonatomic) SPSelections *selections;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) NSMutableArray *selectionsObjectsArray;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong,nonatomic) UIToolbar *pickerToolBar;
@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *filteredSelectionsObjectsArray;

- (IBAction)showCalendar:(id)sender;
- (IBAction)backToHome:(id)sender;

@end

@implementation SPSelectionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.raceParkArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectionsObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.filteredSelectionsObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, 300, 16)];
    [self.dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.dateLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.dateLabel setTextColor:[UIColor colorWithRed:14.0/255.0f green:78.0/255.0f   blue:113.0/255.0f alpha:1.0]];
    [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // or this format to show day of the week Sat,11-12-2011 23:27:09
    
    [dateFormatter setDateFormat:@"EEEE MMM dd, YYYY"];
    
    // Get the date time in NSString
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
    //    NSLog(@"%@", dateInStringFormated);
     [self.dateLabel setText:dateInStringFormated];
     [self.view addSubview:self.dateLabel];
    
    UILabel *selectionsText = [[UILabel alloc]initWithFrame:CGRectMake(47, 14, 300, 19)];
    [selectionsText setBackgroundColor:[UIColor clearColor]];
    [selectionsText setText:@"Selections"];
    [selectionsText setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
    [selectionsText setTextColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f   blue:255.0/255.0f alpha:1.0]];
    [self.headerImageView addSubview:selectionsText];
    [self.selectionsTableView setSeparatorColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]];

    [self loadData];
    
    self.customSelectionCellNib = [UINib nibWithNibName:@"SPCustomSelectionCell" bundle:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSelectionsTableView:nil];
    [self setCustomselectionCell:nil];
    self.raceParkArray = nil;
    [self setHeaderImageView:nil];
    [super viewDidUnload];
}

- (void)loadData
{
   
    self.raceParkDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.raceParkDic setValue:@"Albuquerque" forKey:@"raceTrackTitle"];
    [self.raceParkDic setValue:@"Albuquerque, New Mexico" forKey:@"racePlace"];
    [self.raceParkArray addObject:self.raceParkDic];
    
    self.raceParkDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.raceParkDic setValue:@"Arapahoe" forKey:@"raceTrackTitle"];
    [self.raceParkDic setValue:@"Aurora, Colorado" forKey:@"racePlace"];
    [self.raceParkArray addObject:self.raceParkDic];
    
    self.raceParkDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.raceParkDic setValue:@"Arlington park" forKey:@"raceTrackTitle"];
    [self.raceParkDic setValue:@"Arlington, Illinois" forKey:@"racePlace"];
    [self.raceParkArray addObject:self.raceParkDic];
    
    self.raceParkDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.raceParkDic setValue:@"Arlington park" forKey:@"raceTrackTitle"];
    [self.raceParkDic setValue:@"Arlington, Illinois" forKey:@"racePlace"];
    [self.raceParkArray addObject:self.raceParkDic];
    
    self.raceParkDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.raceParkDic setValue:@"Assiniboia" forKey:@"raceTrackTitle"];
    [self.raceParkDic setValue:@"Winnipeg, Manitoba" forKey:@"racePlace"];
    [self.raceParkArray addObject:self.raceParkDic];
    
    self.raceParkDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.raceParkDic setValue:@"Calder" forKey:@"raceTrackTitle"];
    [self.raceParkDic setValue:@"Miami, Florida" forKey:@"racePlace"];
    [self.raceParkArray addObject:self.raceParkDic];
    
    self.raceParkDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.raceParkDic setValue:@"Canterbury Park" forKey:@"raceTrackTitle"];
    [self.raceParkDic setValue:@"Shakopee, Minnesota" forKey:@"racePlace"];
    [self.raceParkArray addObject:self.raceParkDic];
    
    self.raceParkDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.raceParkDic setValue:@"Cassia Fair" forKey:@"raceTrackTitle"];
    [self.raceParkDic setValue:@"Bhurely Idaho, Manitoba" forKey:@"racePlace"];
    [self.raceParkArray addObject:self.raceParkDic];
    
    self.raceParkDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.raceParkDic setValue:@"Calder" forKey:@"raceTrackTitle"];
    [self.raceParkDic setValue:@"Miami, Florida" forKey:@"racePlace"];
    [self.raceParkArray addObject:self.raceParkDic];

    
    for (int i = 0; i < [self.raceParkArray count]; i++)
    {
        self.selections = [[SPSelections alloc] init];
        self.selections.raceTrackTitle = [[self.raceParkArray objectAtIndex:i] valueForKey:@"raceTrackTitle"];
        self.selections.racePlace = [[self.raceParkArray objectAtIndex:i] valueForKey:@"racePlace"];
        [self.selectionsObjectsArray addObject:self.selections];
    }
    
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	// Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
	[self.filteredSelectionsObjectsArray removeAllObjects];
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.raceTrackTitle contains[c] %@ OR SELF.racePlace contains[c] %@",searchText, searchText];
    self.filteredSelectionsObjectsArray = [NSMutableArray arrayWithArray:[self.selectionsObjectsArray filteredArrayUsingPredicate:predicate]];
}


#pragma mark - Private API

- (IBAction)backToHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

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
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, 320, 260)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    [self.actionSheet addSubview:self.pickerToolBar];
    [self.actionSheet addSubview:self.datePicker];
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0,0,320, 464)];
    
}

- (void)donebuttonClicked:(id) sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE MMM dd, YYYY"];
    NSString *str = [dateFormatter stringFromDate:self.datePicker.date];
    self.dateLabel.text = str;
    [self.actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

- (void)datecancelbuttonClicked:(id) sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - DataSources

#pragma mark - TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
       return [self.filteredSelectionsObjectsArray count];
    }
    else
    {
        return [self.selectionsObjectsArray count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView registerNib:self.customSelectionCellNib forCellReuseIdentifier:kcustomSelectionCellIdentifier];

    self.customselectionCell  = (SPCustomSelectionCell *)[tableView dequeueReusableCellWithIdentifier:kcustomSelectionCellIdentifier];
    
    SPSelections *selectionsObj;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        selectionsObj = [self.filteredSelectionsObjectsArray objectAtIndex:indexPath.row];
    }
    else
    {
         selectionsObj = [self.selectionsObjectsArray objectAtIndex:indexPath.row];
    }
    
    [self.customselectionCell setSelections:selectionsObj];
    [self.customselectionCell updateViewIndex:indexPath];
    
    return self.customselectionCell;
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
    
    SPDetailSelectionViewController *detailSelection = [[SPDetailSelectionViewController alloc] init];
    
//    [detailSelection setSelectionsObjectsArray:self.selectionsObjectsArray];
    [self.navigationController pushViewController:detailSelection animated:YES];
    
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
