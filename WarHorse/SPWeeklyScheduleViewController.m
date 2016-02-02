//
//  SPWeeklyScheduleViewController.m
//  WarHorse
//
//  Created by EnterPi on 22/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPWeeklyScheduleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SPSchedule.h"
#import "SPSchedulesCell.h"
#import "SPScrollableWeeklyView.h"
#import "ZLPreLoginAPIWrapper.h"
#import "ZLAppDelegate.h"
#import "SPSettingPopOverView.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"

static NSString *const kcustomScheduleCellIdentifier = @"customScheduleCellIdentifier";
static NSString *const kcustomScheduleCellNib = @"SPSchedulesCell";

@interface SPWeeklyScheduleViewController () <UIScrollViewDelegate,SPSettingPopOverDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView *weeklySchedulerTable;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIToolbar *pickerToolBar;
@property int pageIndex;
@property (strong, nonatomic) NSMutableArray *scheduleObjectsArry;
@property (strong, nonatomic) NSMutableArray *colorsArray;
@property (nonatomic, strong) UITapGestureRecognizer *settingTapRecognizer;

@property (strong, nonatomic) NSMutableArray *weekDaysDataArry;
@property (strong, nonatomic) NSMutableArray *weekDaysDataObjectsArray;

@property (weak, nonatomic) IBOutlet UILabel *noDataAvailableLable;
@property (strong, nonatomic) SPSettingPopOverView *popOverView;
@property (strong, nonatomic) UIView *tappedView;

@property (strong, nonatomic) NSMutableArray *scheduleObjectsArryCopy;
@property (strong, nonatomic) SPSchedule *scheduleObj;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDateComponents *components;

@property (strong,nonatomic)  UIActionSheet *actionSheet;
@property (strong, nonatomic) IBOutlet UIButton *settingsBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *trackContainerScrollView;
@property (strong, nonatomic) IBOutlet SPScrollableWeeklyView *scrollableWeeklyView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property  (strong, nonatomic) NSMutableArray *filteredScheduleObjectsArry;
//raceParkArray
@property (strong, nonatomic) NSMutableArray *raceParkArray;

@property (assign) BOOL popFalg;
@property (strong, nonatomic) NSMutableArray* datesInScheduleObjectsArray;
@property (assign, nonatomic) BOOL isTableListSortedByAlphabet;
@property (nonatomic,retain) NSMutableArray *tracksArray;
- (IBAction)backToHome;
- (IBAction)settingsBtnToChangeOrder;

@end

@implementation SPWeeklyScheduleViewController

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
    
    [self.weeklySchedulerTable registerNib:[UINib nibWithNibName:kcustomScheduleCellNib bundle:nil] forCellReuseIdentifier:kcustomScheduleCellIdentifier];
    
    
    self.tracksArray = [[NSMutableArray alloc]initWithCapacity:0];

    
    self.colorsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.weekDaysDataArry = [[NSMutableArray alloc] initWithCapacity:0];
    self.weekDaysDataObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.scheduleObjectsArryCopy = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.pageIndex = 0;
    self.popFalg = YES;
    self.isTableListSortedByAlphabet = NO;
    
    self.headerLabel.text = @"Today's Schedule";
    [self.headerLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
    
    [self.noDataAvailableLable setFont:[UIFont fontWithName:@"Roboto-Medium" size:18]];
    [self.noDataAvailableLable setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f   blue:30.0/255.0f alpha:1.0]];
    
    [self.trackContainerScrollView setClipsToBounds:NO];
    self.trackContainerScrollView.delegate = self;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.trackContainerScrollView addGestureRecognizer:singleTap];
    
    self.selectedDate = [NSDate date];
    
    [self loadDataForSelectedDate:[NSDate date]];
    
    [self loadTracks];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.tappedView removeFromSuperview];
    self.popFalg = YES;
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[LeveyHUD sharedHUD] disappear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    self.raceParkArray=nil;
    [self setNoDataAvailableLable:nil];
    [super viewDidUnload];
}





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
        //[self sortByAlphabet];
        [self.weeklySchedulerTable reloadData];
        //[[LeveyHUD sharedHUD] disappear];
        
    }failure:^(NSError *error){
        
        [[LeveyHUD sharedHUD] disappear];
        
    }];
    
}


#pragma mark - Private API

- (NSDate *)numberOfDays:(NSInteger)days fromDate:(NSDate *)from {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:+days];
    
    return [gregorian dateByAddingComponents:offsetComponents toDate:from options:0];
    
}

- (void)loadDataForSelectedDate:(NSDate *)selectedDate
{
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    //[ZLAppDelegate showLoadingView];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Schedules..."];
    
    self.datesInScheduleObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    ZLPreLoginAPIWrapper *preloginapiwrapper = [[ZLPreLoginAPIWrapper alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMM dd, YYYY"];
    
    NSDate *toDate = [self numberOfDays:5 fromDate:selectedDate];
    
    NSString *fromDateStr = [dateFormatter stringFromDate:selectedDate];
    NSString *toDateStr = [dateFormatter stringFromDate:toDate];
    
    NSString *dateInputString = [NSString stringWithFormat:@"DateEntries[?(@.date == '%@-%@')]",fromDateStr,toDateStr];
    NSDictionary *argumentsDic = @{@"queryName":@"framework_json_data",
        @"filterParam":dateInputString,
                                   @"queryParams":@{@"json_data_id":@"Schedules"}};
    
    [preloginapiwrapper loadPreLoginDataForParameterType:argumentsDic success:^(NSDictionary *_userInfo) {
        
        self.pageIndex = 0;
        //[ZLAppDelegate hideLoadingView];
        [[LeveyHUD sharedHUD] disappear];
        self.noDataAvailableLable.hidden = YES;
        self.weeklySchedulerTable.hidden = NO;
        self.trackContainerScrollView.hidden = NO;
        
        if ([[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"] count]) {
            
            self.weekDaysDataArry = (NSMutableArray *)[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"];
            
            for (int i = 0; i <= [self.weekDaysDataArry count]/5; i++) {
                [self.colorsArray addObject:[UIColor colorWithRed:69.0/255.0f green:138.0/255.0f blue:242/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:164.0/255.0f green:99.0/255.0f blue:165.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:113.0/255.0f green:170.0/255.0f blue:0.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:178.0/255.0f green:0.0/255.0f blue:36.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:237.0/255.0f green:106.0/255.0f blue:62.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:69.0/255.0f green:138.0/255.0f blue:242/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:164.0/255.0f green:99.0/255.0f blue:165.0/255.0f alpha:1.0]];
            }
            
            [self.weekDaysDataArry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SPSchedule *schedule = [[SPSchedule alloc] init];
                schedule.timeStr = [obj valueForKey:@"date"];
                schedule.viewBgColor = [self.colorsArray objectAtIndex:idx];
                [self.datesInScheduleObjectsArray addObject:schedule];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createScrollContainer];
                [self updateTableData];
            });

        }
        else {
            [[LeveyHUD sharedHUD] disappear];
            self.noDataAvailableLable.hidden = NO;
            self.weeklySchedulerTable.hidden = YES;
            self.trackContainerScrollView.hidden = YES;
            
            return;
        }

    }failure:^(NSError *error) {
        
        //[ZLAppDelegate hideLoadingView];
        [[LeveyHUD sharedHUD] disappear];
        self.noDataAvailableLable.hidden = NO;
        self.weeklySchedulerTable.hidden = YES;
        self.trackContainerScrollView.hidden = YES;
        
    }];
    
}
- (void)updateTableData
{
    
    self.raceParkArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.scheduleObjectsArry = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.raceParkArray = [[self.weekDaysDataArry objectAtIndex:self.pageIndex] valueForKey:@"TrackList"];
    
    for (int i = 0; i < [self.raceParkArray count] ; i++) {
        self.scheduleObj = [[SPSchedule alloc] init];
        self.scheduleObj.timeStr = [[self.raceParkArray objectAtIndex:i] valueForKey:@"time"];
        self.scheduleObj.trackNameStr = [[self.raceParkArray objectAtIndex:i] valueForKey:@"trackname"];
        [self.scheduleObjectsArry addObject:self.scheduleObj];
    }
    [self.scheduleObjectsArryCopy addObjectsFromArray:self.scheduleObjectsArry];
    
    if(self.isTableListSortedByAlphabet == YES)
    {
        [self sortArray];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.weeklySchedulerTable reloadData];
        
    });
    
    
    
}

- (IBAction)backToHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


// PopOver View Created Here
- (IBAction)settingsBtnToChangeOrder
{
    if ([self.searchDisplayController isActive]) {
        [self.searchDisplayController setActive:NO];
    }
    
    if (self.popFalg == YES){
        if(!self.popOverView){
            self.popOverView = [[SPSettingPopOverView alloc] init];
            self.popOverView.popOverDelegate = self;
            [self.popOverView setGlobalOrderBy:@"WeeklyOrderBy"];
            self.popOverView.layer.masksToBounds = YES;
            self.popOverView.userInteractionEnabled = YES;
            self.popOverView.frame=CGRectMake(106, 46, 168, 94);//(162, 47, 168, 94)
            self.popOverView.backgroundColor = [UIColor clearColor];
            self.tappedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
            [self.tappedView setBackgroundColor:[UIColor clearColor]];
        }
        [self.view addSubview:self.popOverView];
        [self.view addSubview:self.tappedView];
        [self.view bringSubviewToFront:self.popOverView];
        [self.popOverView tableReloadDataInTable:@"Schedule"];
        if (!self.settingTapRecognizer){
            self.settingTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBtnTap:)];
            [self.tappedView addGestureRecognizer:self.settingTapRecognizer];
        }
        self.popFalg=NO;
        self.settingTapRecognizer.enabled = YES;
        [_settingsBtn setSelected:YES];
    }else{
        self.popFalg=YES;
        [self.popOverView removeFromSuperview];
        [self.tappedView removeFromSuperview];
        [self.settingsBtn setSelected:NO];
    }
    
    
    
}

- (void)settingBtnTap:(UITapGestureRecognizer*)recognizer
{
    // Do Your thing.
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        self.popFalg=YES;
        self.settingTapRecognizer.enabled = NO;
        [self.popOverView removeFromSuperview];
        [self.tappedView removeFromSuperview];
        [self.settingsBtn setSelected:NO];
    }
    
}

- (void)createScrollContainer
{
    CGFloat x = 5.0f;
    
    for (UIView *view in [self.trackContainerScrollView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < [self.datesInScheduleObjectsArray count]; i++) {
        
        CGRect scrollableTrackTitleViewFrame = CGRectMake(x, 0, 220, self.trackContainerScrollView.frame.size.height);
        
        NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"SPScrollableWeeklyView" owner:self options:nil];
        _scrollableWeeklyView = nil;
        for (id xibObject in xibArray) {
            //Loop through array, check for the object we're interested in.
            if ([xibObject isKindOfClass:[SPScrollableWeeklyView class]]) {
                //Use casting to cast (id) to (MyCustomView *)
                _scrollableWeeklyView = (SPScrollableWeeklyView *)xibObject;
            }
        }
        
        self.scrollableWeeklyView.frame = scrollableTrackTitleViewFrame;
        
        [self.trackContainerScrollView addSubview:self.scrollableWeeklyView];
        [self.scrollableWeeklyView setSchedule:[self.datesInScheduleObjectsArray objectAtIndex:i]];
        [self.scrollableWeeklyView updateView];
        x = x + _trackContainerScrollView.frame.size.width;
        
    }
    
    [self.trackContainerScrollView setContentOffset:CGPointMake(0, 0)];
    [self.trackContainerScrollView setContentSize:CGSizeMake(x, self.trackContainerScrollView.frame.size.height)];
}

- (IBAction)calendarForSetDate
{
    if ([self.searchDisplayController isActive]) {
        [self.searchDisplayController setActive:NO];
    }
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select time" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    self.pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
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
    [self.searchBar resignFirstResponder];

}

- (void)doneButtonClicked:(id) sender
{
    [self loadDataForSelectedDate:self.datePicker.date];
    [self.actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

- (void)dateCancelbuttonClicked:(id) sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark Array Sorting

//sorting array with string key.
- (void)sortArray
{
    
    NSArray *sortedArray;
    if (self.isTableListSortedByAlphabet == YES) {
        sortedArray = [self.scheduleObjectsArry sortedArrayUsingComparator:^NSComparisonResult(SPSchedule *a, SPSchedule *b) {
            NSString *first = [a trackNameStr];
            NSString *second = [b trackNameStr];
            return [first compare:second];
        }];
    }
   else
   {
       sortedArray = [self.scheduleObjectsArry sortedArrayUsingComparator:^NSComparisonResult(SPSchedule *a, SPSchedule *b) {
           NSString *first = [a timeStr];
           NSString *second = [b timeStr];
           return [first compare:second];
       }];
   }
    
    [self.scheduleObjectsArry removeAllObjects];
    [self.scheduleObjectsArry addObjectsFromArray:sortedArray];
    [self.weeklySchedulerTable reloadData];
    
    
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	// Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
	[self.filteredScheduleObjectsArry removeAllObjects];
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.trackNameStr contains[c] %@ OR SELF.timeStr contains[c] %@",searchText, searchText];
    self.filteredScheduleObjectsArry = [NSMutableArray arrayWithArray:[self.scheduleObjectsArry filteredArrayUsingPredicate:predicate]];
}


#pragma mark - DataSources

#pragma mark Tableview DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [self.tracksArray count];
    /*
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return [self.filteredScheduleObjectsArry count];
    else
        return [self.scheduleObjectsArry count];
     */
    //return [scheduleSunDataArry count]; [weekDaysDataArry objectAtIndex:1]
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // custom cell add to tableview
    //    [tableView registerNib:[UINib nibWithNibName:kcustomScheduleCellNib bundle:nil] forCellReuseIdentifier:kcustomScheduleCellIdentifier];
    
    SPSchedulesCell *customScheduleCell = [tableView dequeueReusableCellWithIdentifier:kcustomScheduleCellIdentifier forIndexPath:indexPath];
    
    self.scheduleObj = [self.tracksArray objectAtIndex:indexPath.row];
    [customScheduleCell setSchedule:self.scheduleObj];
    [customScheduleCell updateViewAtIndexPath:indexPath];
    /*
    if(tableView == self.searchDisplayController.searchResultsTableView)
        self.scheduleObj = [self.filteredScheduleObjectsArry objectAtIndex:indexPath.row];
    else
        self.scheduleObj = [self.scheduleObjectsArry objectAtIndex:indexPath.row];
    
    [customScheduleCell setSchedule:self.scheduleObj];
    [customScheduleCell updateViewAtIndexPath:indexPath];
    */
    return customScheduleCell;
}


#pragma mark - Delegates

#pragma mark - TableView Delagate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
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

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.trackContainerScrollView) {
        self.pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self updateTableData];
        [self.weeklySchedulerTable setContentOffset:CGPointMake(0, 0)];
        
    }
    
}

#pragma mark - Settings PopOverDelegate Methods

- (void)didChangeComboBoxValue:(SPSettingPopOverView *)popOverViewClass selectedIndexPath:(NSInteger)selectedIndexPath
{
    
    if (selectedIndexPath == 1){
        
        self.isTableListSortedByAlphabet = YES;
        [self sortArray];
    }else{
        
        self.isTableListSortedByAlphabet = NO;
        [self sortArray];
    }
    
    [self.weeklySchedulerTable reloadData];
    self.popFalg = YES;
    [self.tappedView removeFromSuperview];
    [self.popOverView removeFromSuperview];
    [self.settingsBtn setSelected:NO];
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

#pragma mark - Gesture Recognizer Methods

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:self.trackContainerScrollView];
    
    int currentPage = self.trackContainerScrollView.contentOffset.x / self.trackContainerScrollView.frame.size.width;
    
    if (touchPoint.x > self.trackContainerScrollView.contentOffset.x + self.trackContainerScrollView.frame.size.width && touchPoint.x < self.trackContainerScrollView.contentSize.width - self.trackContainerScrollView.frame.size.width/2) {
        
        self.pageIndex = currentPage + 1;
        
        CGRect frame = self.trackContainerScrollView.frame;
        frame.origin.x = frame.size.width * (currentPage + 1);
        [self.trackContainerScrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
        [self updateTableData];
        [self.weeklySchedulerTable setContentOffset:CGPointMake(0, 0)];
        
    }
    else if(self.trackContainerScrollView.contentOffset.x >= self.trackContainerScrollView.frame.size.width && touchPoint.x < self.trackContainerScrollView.contentOffset.x)
    {
        self.pageIndex = currentPage - 1;
        
        CGRect frame = self.trackContainerScrollView.frame;
        frame.origin.x = frame.size.width * (currentPage - 1);
        [self.trackContainerScrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
        [self updateTableData];
        [self.weeklySchedulerTable setContentOffset:CGPointMake(0, 0)];
    }
    
    
}


@end
