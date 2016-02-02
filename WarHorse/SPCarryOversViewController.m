//
//  SPCarryOversViewController.m
//  WarHorse
//
//  Created by Ramya on 8/20/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPCarryOversViewController.h"
#import "SPCarryOver.h"
#import "SPScrollableWeeklyView.h"
#import "SPSchedule.h"
#import "ZLPreLoginAPIWrapper.h"
#import "SPCarryOverCustomCell.h"
#import "SPSettingPopOverView.h"
#import "ZLAppDelegate.h"
#import "SPDateEntry.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"

static NSString *const kcustomCarryOverCellIdentifier = @"customCarryOverCellIdentifier";
static NSString *const kCustomCarryOverCellNib = @"SPCarryOverCustomCell";

@interface SPCarryOversViewController () <SPSettingPopOverDelegate,UISearchBarDelegate,UIScrollViewDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIToolbar *toolBar;

@property (strong, nonatomic) NSMutableArray *carryOversTracksDataArray;
@property (strong, nonatomic) NSMutableArray *carryOversTracksDataObjetsArray;
@property (strong,  nonatomic) NSMutableArray *carryOversTracklistDataArray;

@property (assign) BOOL popFlag;
@property (strong, nonatomic) SPSettingPopOverView *popOverView;
@property (strong, nonatomic) UIView *tappedView;
@property (strong, nonatomic) NSMutableArray *sortArry;
@property (strong, nonatomic) NSMutableArray *carryOverTrackListObjectsArrayCopy;
@property (nonatomic, assign) int pageIndex;
@property (strong, nonatomic) IBOutlet UITableView *carryOverTableView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) SPCarryOver *carryOver;

@property (nonatomic, strong) UITapGestureRecognizer *settingTapRecognizer;
@property (strong, nonatomic) NSMutableArray *carryOverDataObjArray;
@property (strong, nonatomic) NSMutableArray *carryOverTrackListObjectsArray;
@property (strong, nonatomic) IBOutlet UIButton *settingBtn;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *filteredCarryOverTrackListObjectsArray;

@property (strong, nonatomic) IBOutlet UIScrollView *trackContainerScrollView;
@property (strong, nonatomic) IBOutlet SPScrollableWeeklyView *scrollableWeeklyView;
@property (strong, nonatomic) NSMutableArray* datesInCarryOverObjectsArray;

@property (strong, nonatomic) NSMutableArray *colorsArray;
@property (assign, nonatomic) BOOL isTableListSortedByAlphabet;
@property (assign, nonatomic) BOOL isDateSelected;
@property (weak, nonatomic) IBOutlet UILabel *noDataAvailableLable;

- (IBAction)backToHome:(id)sender;
- (IBAction)settingOnClick:(id)sender;

@end

@implementation SPCarryOversViewController

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
    
    [self.carryOverTableView registerNib:[UINib nibWithNibName:kCustomCarryOverCellNib bundle:nil] forCellReuseIdentifier:kcustomCarryOverCellIdentifier];
   
    self.carryOverDataObjArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.carryOversTracksDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.carryOversTracksDataObjetsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.pageIndex = 0;
    self.popFlag = YES;
    self.isTableListSortedByAlphabet = NO;
    self.isDateSelected = NO;
    
    self.trackContainerScrollView.clipsToBounds = NO;
    self.colorsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Do any additional setup after loading the view from its nib.
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 106, 300, 16)];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"EEEE MMM dd, YYYY"];
    
    UILabel *carryoverText = [[UILabel alloc]initWithFrame:CGRectMake(47, 14, 300, 19)];
    [carryoverText setBackgroundColor:[UIColor clearColor]];
    [carryoverText setText:@"Carryovers"];
    [carryoverText setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
    [carryoverText setTextColor:[UIColor colorWithRed:55.0/255.0f green:67.0/255.0f   blue:77.0/255.0f alpha:1.0]];
    [self.headerImageView addSubview:carryoverText];
    [self.carryOverTableView setSeparatorColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]];
    
    [self.noDataAvailableLable setFont:[UIFont fontWithName:@"Roboto-Medium" size:18]];
    [self.noDataAvailableLable setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f   blue:30.0/255.0f alpha:1.0]];

    [self loadDataForSelectedDate:[NSDate date]];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.trackContainerScrollView addGestureRecognizer:singleTap];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.tappedView removeFromSuperview];
    self.popFlag = YES;
    
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.tappedView removeFromSuperview];
    
    [[LeveyHUD sharedHUD] disappear];

    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [self setCarryOverTableView:nil];    
    [self setHeaderImageView:nil];
    [self setSettingBtn:nil];
    [self setSearchBar:nil];
    [self setNoDataAvailableLable:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)loadDataForSelectedDate:(NSDate *)selectedDate
//{
//    
//    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    
//    //[ZLAppDelegate showLoadingView];
//    [[LeveyHUD sharedHUD] appearWithText:@"Loading..."];
//    ZLPreLoginAPIWrapper *preloginapiwrapper = [[ZLPreLoginAPIWrapper alloc] init];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"EEEE, MMM dd, YYYY"];
//    
//    NSDate *toDate = [self numberOfDays:7 fromDate:selectedDate];
//    
//    NSString *fromDateStr = [dateFormatter stringFromDate:selectedDate];
//    NSString *toDateStr = [dateFormatter stringFromDate:toDate];
//    
//    NSString *dateInputString = [NSString stringWithFormat:@"Json_Data.DateEntries[?(@.Date == '%@-%@')]",fromDateStr,toDateStr];
//    
//    
//    NSDictionary *argumentsDic = @{@"queryName":@"framework_json_data",
//                                   @"filterParam":dateInputString,
//                                   @"queryParams":@{@"json_data_id":@"CarryOver"}};
//    
//    [preloginapiwrapper loadCarryOverDataForParameterType:argumentsDic success:^(NSDictionary *_userInfo) {
//        
//        //[ZLAppDelegate hideLoadingView];
//        [[LeveyHUD sharedHUD] disappear];
//        self.noDataAvailableLable.hidden = YES;
//        self.carryOverTableView.hidden = NO;
//        self.trackContainerScrollView.hidden = NO;
//
//        if ([[[ZLAppDelegate getAppData] carryOverDateEntries] count]) {
//            
//            self.carryOverDataObjArray = (NSMutableArray *)[ZLAppDelegate getAppData].carryOverDateEntries;
//            for (int i = 0; i <= [self.carryOverDataObjArray count]/5; i++) {
//                
//                [self.colorsArray addObject:[UIColor colorWithRed:69.0/255.0f green:138.0/255.0f blue:242/255.0f alpha:1.0]];
//                [self.colorsArray addObject:[UIColor colorWithRed:164.0/255.0f green:99.0/255.0f blue:165.0/255.0f alpha:1.0]];
//                [self.colorsArray addObject:[UIColor colorWithRed:113.0/255.0f green:170.0/255.0f blue:0.0/255.0f alpha:1.0]];
//                [self.colorsArray addObject:[UIColor colorWithRed:178.0/255.0f green:0.0/255.0f blue:36.0/255.0f alpha:1.0]];
//                [self.colorsArray addObject:[UIColor colorWithRed:237.0/255.0f green:106.0/255.0f blue:62.0/255.0f alpha:1.0]];
//                [self.colorsArray addObject:[UIColor colorWithRed:69.0/255.0f green:138.0/255.0f blue:242/255.0f alpha:1.0]];
//                [self.colorsArray addObject:[UIColor colorWithRed:164.0/255.0f green:99.0/255.0f blue:165.0/255.0f alpha:1.0]];
//                
//            }
//            
//            self.datesInCarryOverObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
//            
//            [self.carryOverDataObjArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                
//                SPDateEntry *dateEntry = [[ZLAppDelegate getAppData].carryOverDateEntries objectAtIndex:idx];
//                SPSchedule *schedule = [[SPSchedule alloc] init];
//                schedule.timeStr = dateEntry.date;
//                schedule.viewBgColor = [self.colorsArray objectAtIndex:idx];
//                [self.datesInCarryOverObjectsArray addObject:schedule];
//                
//            }];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self createScrollContainer];
//                [self updateTableData];
//            });
//            
//
//        }
//        else {
//            [[LeveyHUD sharedHUD] disappear];
//            self.noDataAvailableLable.hidden = NO;
//            self.carryOverTableView.hidden = YES;
//            self.trackContainerScrollView.hidden = YES;
//            return;
//
//        }
//        
//    } failure:^(NSError *error) {
//        
//        //[ZLAppDelegate hideLoadingView];
//        [[LeveyHUD sharedHUD] disappear];
//        self.noDataAvailableLable.hidden = NO;
//        self.carryOverTableView.hidden = YES;
//        self.trackContainerScrollView.hidden = YES;
//        
//    }];
//    
//}
//
//- (void)updateTableData
//{
//    self.carryOverTrackListObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
//    self.carryOverTrackListObjectsArrayCopy = [[NSMutableArray alloc] initWithCapacity:0];
//            
//    SPDateEntry *dateEntry = [[ZLAppDelegate getAppData].carryOverDateEntries objectAtIndex:self.pageIndex];
//        
//    [self.carryOverTrackListObjectsArray addObjectsFromArray:dateEntry.trackList];
//
//    [self.carryOverTrackListObjectsArrayCopy addObjectsFromArray:self.carryOverTrackListObjectsArray];
//    
//    if (self.isTableListSortedByAlphabet == YES) {
//        [self sortArray];
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//       
//        [self.carryOverTableView reloadData];
//        
//    });
//    
//}


- (void)updateTableDataForSelectedDate
{
    
    self.carryOversTracklistDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.carryOverTrackListObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.carryOverTrackListObjectsArrayCopy = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.carryOversTracklistDataArray = [[self.carryOversTracksDataArray objectAtIndex:self.pageIndex] valueForKey:@"TrackList"];
    
    
    for (int i = 0; i < [self.carryOversTracklistDataArray count] ; i++) {
        self.carryOver = [[SPCarryOver alloc] init];
        self.carryOver.trackname = [[self.carryOversTracklistDataArray objectAtIndex:i] valueForKey:@"Trackname"];
        self.carryOver.poolType = [[self.carryOversTracklistDataArray objectAtIndex:i] valueForKey:@"PoolType"];
        self.carryOver.carryOver = [[self.carryOversTracklistDataArray objectAtIndex:i] valueForKey:@"CarryOver"];
        [self.carryOverTrackListObjectsArray addObject:self.carryOver];
    }
    
    [self.carryOverTrackListObjectsArrayCopy addObjectsFromArray:self.carryOverTrackListObjectsArray];
    
    if (self.isTableListSortedByAlphabet == YES) {
        [self sortArray];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.carryOverTableView reloadData];
        
    });

    
}


- (void)loadDataForSelectedDate:(NSDate *)selectedDate
{
    
    self.datesInCarryOverObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //[ZLAppDelegate showLoadingView];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Carryovers..."];
    ZLPreLoginAPIWrapper *preloginapiwrapper = [[ZLPreLoginAPIWrapper alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMM dd, YYYY"];
    
    NSDate *toDate = [self numberOfDays:7 fromDate:selectedDate];
    
    NSString *fromDateStr = [dateFormatter stringFromDate:selectedDate];
    NSString *toDateStr = [dateFormatter stringFromDate:toDate];
    
    NSString *dateInputString = [NSString stringWithFormat:@"Json_Data.DateEntries[?(@.Date == '%@-%@')]",fromDateStr,toDateStr];
    
    
    NSDictionary *argumentsDic = @{@"queryName":@"framework_json_data",
                                   @"filterParam":dateInputString,
                                   @"queryParams":@{@"json_data_id":@"CarryOver"}};
    
    
    [preloginapiwrapper loadPreLoginDataForSelectedDate:argumentsDic success:^(NSDictionary *_userInfo) {
        
        [[LeveyHUD sharedHUD] disappear];
        self.pageIndex = 0;
        self.noDataAvailableLable.hidden = YES;
        self.carryOverTableView.hidden = NO;
        self.trackContainerScrollView.hidden = NO;
        
        
        if ([[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"] count]) {
            self.carryOversTracksDataArray = (NSMutableArray *)[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"];
            
            for (int i = 0; i <= [self.carryOverDataObjArray count]/5; i++) {
                
                [self.colorsArray addObject:[UIColor colorWithRed:69.0/255.0f green:138.0/255.0f blue:242/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:164.0/255.0f green:99.0/255.0f blue:165.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:113.0/255.0f green:170.0/255.0f blue:0.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:178.0/255.0f green:0.0/255.0f blue:36.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:237.0/255.0f green:106.0/255.0f blue:62.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:69.0/255.0f green:138.0/255.0f blue:242/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:164.0/255.0f green:99.0/255.0f blue:165.0/255.0f alpha:1.0]];
                
            }
            
            [self.carryOversTracksDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                SPSchedule *schedule = [[SPSchedule alloc] init];
                schedule.timeStr = [obj valueForKey:@"Date"];
                schedule.viewBgColor = [self.colorsArray objectAtIndex:idx];
                
                [self.datesInCarryOverObjectsArray addObject:schedule];
            }];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self createScrollContainer];
                
            });
            
            [self updateTableDataForSelectedDate];
        }
        else
        {
            //[ZLAppDelegate hideLoadingView];
            [[LeveyHUD sharedHUD] disappear];
            self.noDataAvailableLable.hidden = NO;
            self.carryOverTableView.hidden = YES;
            self.trackContainerScrollView.hidden = YES;
        }
        
        
        
    } failure:^(NSError *error) {
        [ZLAppDelegate hideLoadingView];
        [[LeveyHUD sharedHUD] disappear];
        
        self.noDataAvailableLable.hidden = NO;
        self.carryOverTableView.hidden = YES;
        self.trackContainerScrollView.hidden = YES;
    }];
    
}

- (NSDate *)numberOfDays:(NSInteger)days fromDate:(NSDate *)from {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:+days];
    
    return [gregorian dateByAddingComponents:offsetComponents toDate:from options:0];
    
}

#pragma mark - Private API

- (IBAction)showCalendar:(id)sender {
    
    if ([self.searchDisplayController isActive]) {
        [self.searchDisplayController setActive:NO];
    }
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select time" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.toolBar.barStyle = UIBarStyleBlackOpaque;
    [self.toolBar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datecancelbuttonClicked:)];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donebuttonClicked:)];
    [barItems addObject:flexSpace];
    [barItems addObject:doneBtn];
    [self.toolBar setItems:barItems animated:YES];
    
    if(self.datePicker)
    {
        self.datePicker=nil;
    }
    
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, 320, 260)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    [self.actionSheet addSubview:self.toolBar];
    [self.actionSheet addSubview:self.datePicker];
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0,0,320, 464)];
    
    
}
- (void)donebuttonClicked:(id) sender
{
    
    self.isDateSelected = YES;
    [self loadDataForSelectedDate:self.datePicker.date];
    [self.actionSheet dismissWithClickedButtonIndex:2 animated:YES];
    
}
- (void)datecancelbuttonClicked:(id) sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)createScrollContainer
{
    CGFloat x = 5.0f;
    
    for (UIView *view in [self.trackContainerScrollView subviews]) {
        [view removeFromSuperview];
    }
    
    
    for (int i = 0; i < [self.datesInCarryOverObjectsArray count]; i++) {
        
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
        [self.scrollableWeeklyView setSchedule:[self.datesInCarryOverObjectsArray objectAtIndex:i]];
        [self.scrollableWeeklyView updateView];
        x = x + _trackContainerScrollView.frame.size.width;
        
    }
    
    [self.trackContainerScrollView setContentOffset:CGPointMake(0, 0)];
    [self.trackContainerScrollView setContentSize:CGSizeMake(x, self.trackContainerScrollView.frame.size.height)];
}


- (IBAction)backToHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)settingOnClick:(id)sender {
    
    if ([self.searchDisplayController isActive]) {
        [self.searchDisplayController setActive:NO];
    }
    
    if (self.popFlag == YES){
        if(!self.popOverView){
            self.popOverView = [[SPSettingPopOverView alloc] init];
            self.popOverView.popOverDelegate = self;
            [self.popOverView setGlobalOrderBy:@"carryOverOrderBy"];
            // popOverView.layer.masksToBounds = YES;
            self.popOverView.userInteractionEnabled = YES;
            self.popOverView.frame=CGRectMake(105, 47, 168, 94);//(104, 46, 168, 94)
            self.popOverView.backgroundColor = [UIColor clearColor];
            self.tappedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
            [self.tappedView setBackgroundColor:[UIColor clearColor]];
        }
        [self.view addSubview:self.popOverView];
        [self.view addSubview:self.tappedView];
        [self.view bringSubviewToFront:self.popOverView];
        [self.popOverView tableReloadDataInTable:@"CarryOvers"];
        if (!self.settingTapRecognizer){
            self.settingTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBtnTap:)];
            [self.tappedView addGestureRecognizer:self.settingTapRecognizer];
        }
        self.popFlag=NO;
        self.settingTapRecognizer.enabled = YES;
        [self.settingBtn setSelected:YES];
    }else{
        self.popFlag=YES;
        [self.popOverView removeFromSuperview];
        [self.tappedView removeFromSuperview];
        [self.settingBtn setSelected:NO];
    }
    
}

- (void)settingBtnTap:(UITapGestureRecognizer*)recognizer
{
    // Do Your thing.
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        self.popFlag=YES;
        self.settingTapRecognizer.enabled = NO;
        [self.popOverView removeFromSuperview];
        [self.tappedView removeFromSuperview];
        [self.settingBtn setSelected:NO];
    }
}

//sorting array with string key.
- (void)sortArray
{
    
    NSArray *sortedArray;
    
    if (self.isTableListSortedByAlphabet == YES) {
        sortedArray = [self.carryOverTrackListObjectsArray sortedArrayUsingComparator:^NSComparisonResult(SPCarryOver *a, SPCarryOver *b) {
            NSString *first = [a trackname];
            NSString *second = [b trackname];
            return [first compare:second];
        }];
    }
    else
    {
        sortedArray = [self.carryOverTrackListObjectsArray sortedArrayUsingComparator:^NSComparisonResult(SPCarryOver *a, SPCarryOver *b) {
            NSString *first = [a carryOver];
            NSString *second = [b carryOver];
            return [first compare:second];
        }];
    }
    
    [self.carryOverTrackListObjectsArray removeAllObjects];
    [self.carryOverTrackListObjectsArray addObjectsFromArray:sortedArray];
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	// Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
	[self.filteredCarryOverTrackListObjectsArray removeAllObjects];
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.trackname contains[c] %@ OR SELF.poolType contains[c] %@ OR SELF.carryOver contains[c] %@",searchText, searchText,searchText];
    self.filteredCarryOverTrackListObjectsArray = [NSMutableArray arrayWithArray:[self.carryOverTrackListObjectsArray filteredArrayUsingPredicate:predicate]];
}


#pragma mark - DataSources

#pragma mark - TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount;
    if(tableView == self.searchDisplayController.searchResultsTableView)
        //rowCount = self.searchArray.count;
        return [self.filteredCarryOverTrackListObjectsArray count];
    else
        rowCount = self.carryOverTrackListObjectsArray.count;
    
    return rowCount;
    // Return the number of rows in the section.
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPCarryOverCustomCell *customCarryOverCell = [tableView dequeueReusableCellWithIdentifier:kcustomCarryOverCellIdentifier forIndexPath:indexPath];
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
        [customCarryOverCell setCarryOver:[self.filteredCarryOverTrackListObjectsArray objectAtIndex:indexPath.row]];
    else
        [customCarryOverCell setCarryOver:[self.carryOverTrackListObjectsArray objectAtIndex:indexPath.row]];
    
    [customCarryOverCell updateViewAtIndexPath: indexPath];
    return customCarryOverCell;
}

#pragma mark - Delegates

#pragma mark - TableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}


#pragma mark - PopOver Delegate Methods

- (void)didChangeComboBoxValue:(SPSettingPopOverView *)popOverViewClass selectedIndexPath:(NSInteger)selectedIndexPath
{
    if (selectedIndexPath == 1){
        
        self.isTableListSortedByAlphabet = YES;
        [self sortArray];
        
    }else{
        
        self.isTableListSortedByAlphabet = NO;
       [self sortArray];
        
    }
    
    [self.carryOverTableView reloadData];
    self.popFlag = YES;
    [self.tappedView removeFromSuperview];
    [self.popOverView removeFromSuperview];
    [self.settingBtn setSelected:NO];
}

#pragma mark - UISearchDisplayController Delegate Methods
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:kCustomCarryOverCellNib bundle:nil] forCellReuseIdentifier:kcustomCarryOverCellIdentifier];
  
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.trackContainerScrollView) {
        self.pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self updateTableDataForSelectedDate];
       
    }
    
}

- (void)shuffleArray:(NSMutableArray *)array
{
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [self.carryOverTrackListObjectsArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    [self.carryOverTableView reloadData];
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
            [self updateTableDataForSelectedDate];
        
        
        [self.carryOverTableView setContentOffset:CGPointMake(0, 0)];
        
    }
    else if(self.trackContainerScrollView.contentOffset.x >= self.trackContainerScrollView.frame.size.width && touchPoint.x < self.trackContainerScrollView.contentOffset.x)
    {
        self.pageIndex = currentPage - 1;
        
        CGRect frame = self.trackContainerScrollView.frame;
        frame.origin.x = frame.size.width * (currentPage - 1);
        [self.trackContainerScrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
       
            [self updateTableDataForSelectedDate];
        
        [self.carryOverTableView setContentOffset:CGPointMake(0, 0)];
    
    }
}


@end
