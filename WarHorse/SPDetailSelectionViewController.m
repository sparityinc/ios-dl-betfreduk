//
//  SPDetailSelectionViewController.m
//  WarHorse
//
//  Created by Ramya on 8/22/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPDetailSelectionViewController.h"
#import "SPDetailSelection.h"
#import "SPScrollTrackView.h"
#import "SPTrackDetails.h"
#import "SPCustomDetailSelectionCell.h"
#import "SPSelections.h"
#import <stdlib.h>
#import "ZLPreLoginAPIWrapper.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"

static NSString *const kcustomDetailSelectionCellIdentifier = @"CustomDetailSelectionCellIdentifier";
static NSString *const kcustomDetailSelectionCell = @"SPCustomDetailSelectionCell";

@interface SPDetailSelectionViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *trackContainerScrollView;
@property (strong, nonatomic) NSMutableArray *trackObjectsArray;
@property (strong, nonatomic) IBOutlet UITableView *selectionDetailTableView;
@property (strong, nonatomic) NSMutableDictionary *foreCastDict;
@property (strong, nonatomic) NSMutableDictionary *scheduledetailRacesListDictionary;
@property (strong, nonatomic) NSMutableArray *scheduleDetailRacesListObjectsArray;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) SPTrackDetails *trackDetails;
@property (nonatomic, strong) SPDetailSelection *detailSelection;

@property (assign, nonatomic) int pageIndex;

@property (strong, nonatomic) NSMutableArray *filteredDetailSelectionTracksArray;
@property (strong, nonatomic) SPSelections *selections;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableDictionary *raceParkDic;
@property (strong, nonatomic) NSMutableArray *raceParkArray;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) NSMutableArray *scheduleDetailTracksDataArray;
@property (strong, nonatomic) NSMutableArray *colorsArray;

@property (strong, nonatomic) IBOutlet UILabel *noSelectionsDataAvailableLabel;

- (IBAction)backToSelections:(id)sender;
- (IBAction)showCalendar:(id)sender;
- (IBAction)backToHome:(id)sender;

@end

@implementation SPDetailSelectionViewController

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
    self.colorsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.trackObjectsArray =[[NSMutableArray alloc] initWithCapacity:0];
    
    self.scheduleDetailTracksDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.pageIndex = 0;
    self.filteredDetailSelectionTracksArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.trackContainerScrollView.clipsToBounds = NO;
    self.trackContainerScrollView.pagingEnabled = YES;
	self.trackContainerScrollView.showsHorizontalScrollIndicator = NO;
    
    [self.noSelectionsDataAvailableLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18]];
    [self.noSelectionsDataAvailableLabel setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f   blue:30.0/255.0f alpha:1.0]];
    
    UILabel *selectionsText = [[UILabel alloc]initWithFrame:CGRectMake(47, 14, 300, 19)];
    [selectionsText setBackgroundColor:[UIColor clearColor]];
    [selectionsText setText:@"Selections"];
    [selectionsText setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
    [selectionsText setTextColor:[UIColor colorWithRed:55.0/255.0f green:67.0/255.0f   blue:77.0/255.0f alpha:1.0]];
    [self.headerImageView addSubview:selectionsText];
    [self.selectionDetailTableView setSeparatorColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]];
    
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.trackContainerScrollView addGestureRecognizer:singleTap];
    
    [self.selectionDetailTableView registerNib:[UINib nibWithNibName:kcustomDetailSelectionCell bundle:nil] forCellReuseIdentifier:kcustomDetailSelectionCellIdentifier];
    
    [self loadDataForSelectedDate:[NSDate date]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[LeveyHUD sharedHUD] disappear];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTrackContainerScrollView:nil];
    [self setSelectionDetailTableView:nil];
    [self setHeaderImageView:nil];
    [super viewDidUnload];
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
    
    self.trackObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //[ZLAppDelegate showLoadingView];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Selections..."];
    
    ZLPreLoginAPIWrapper *preloginapiwrapper = [[ZLPreLoginAPIWrapper alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMM dd, YYYY"];
    
    NSDate *toDate = [self numberOfDays:7 fromDate:selectedDate];
    
    NSString *fromDateStr = [dateFormatter stringFromDate:selectedDate];
    NSString *toDateStr = [dateFormatter stringFromDate:toDate];
    
    NSString *dateInputString = [NSString stringWithFormat:@"Json_Data.TrackList[?(@.date == '%@-%@')]",fromDateStr,toDateStr];
    NSDictionary *argumentsDic = @{@"queryName":@"framework_json_data",
                                   @"filterParam":dateInputString,
                                   @"queryParams":@{@"json_data_id":@"Selections"}};
    
    [preloginapiwrapper loadPreLoginDataForParameterType:argumentsDic success:^(NSDictionary *_userInfo){
        
        //[ZLAppDelegate hideLoadingView];
        [[LeveyHUD sharedHUD] disappear];
        self.pageIndex = 0;
        self.noSelectionsDataAvailableLabel.hidden = YES;
        self.selectionDetailTableView.hidden  = NO;
        self.trackContainerScrollView.hidden = NO;
        
        if ([[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"] count]) {
            self.scheduleDetailTracksDataArray = (NSMutableArray *)[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"];
            
            for (int i = 0; i <= [self.scheduleDetailTracksDataArray count]/5; i++) {
                [self.colorsArray addObject:[UIColor colorWithRed:69.0/255.0f green:138.0/255.0f blue:242/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:164.0/255.0f green:99.0/255.0f blue:165.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:113.0/255.0f green:170.0/255.0f blue:0.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:178.0/255.0f green:0.0/255.0f blue:36.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:237.0/255.0f green:106.0/255.0f blue:62.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:69.0/255.0f green:138.0/255.0f blue:242/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:164.0/255.0f green:99.0/255.0f blue:165.0/255.0f alpha:1.0]];
            }
            
            
            [self.scheduleDetailTracksDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                self.trackDetails = [[SPTrackDetails alloc]init];
                self.trackDetails.trackname = [obj valueForKey:@"trackname"];
                self.trackDetails.date = [obj valueForKey:@"date"];
                self.trackDetails.bgColor = [self.colorsArray objectAtIndex:idx];
                [self.trackObjectsArray addObject:self.trackDetails];
            }];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self createScrollContainer];
                [self updateTableData];
                
            });
        }
        else
        {
            [[LeveyHUD sharedHUD] disappear];
            self.noSelectionsDataAvailableLabel.hidden = NO;
            self.selectionDetailTableView.hidden  = YES;
            self.trackContainerScrollView.hidden = YES;
            return;
            
        }
        
        
    }failure:^(NSError *error) {
        [[LeveyHUD sharedHUD] disappear];
        self.trackContainerScrollView.hidden = YES;
        self.noSelectionsDataAvailableLabel.hidden = NO;
        self.selectionDetailTableView.hidden  = YES;
    }];
    
}

- (void)updateTableData
{
    
    self.scheduledetailRacesListDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.scheduleDetailRacesListObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.scheduledetailRacesListDictionary = [self.scheduleDetailTracksDataArray objectAtIndex:self.pageIndex];
    
    [[self.scheduledetailRacesListDictionary valueForKey:@"RaceList"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        self.detailSelection = [[SPDetailSelection alloc] init];
        self.detailSelection.horseName1 = [[[obj valueForKey:@"Positions"] objectAtIndex:0] valueForKey:@"horsename"];
        self.detailSelection.horseName2 = [[[obj valueForKey:@"Positions"] objectAtIndex:1] valueForKey:@"horsename"];
        self.detailSelection.horseName3 = [[[obj valueForKey:@"Positions"] objectAtIndex:2] valueForKey:@"horsename"];
        self.detailSelection.race = [obj valueForKey:@"racenumber"];
        self.detailSelection.horseNumber1 = [[[obj valueForKey:@"Positions"] objectAtIndex:0] valueForKey:@"horsenumber"];
        self.detailSelection.horseNumber2 = [[[obj valueForKey:@"Positions"] objectAtIndex:1] valueForKey:@"horsenumber"];
        self.detailSelection.horseNumber3 = [[[obj valueForKey:@"Positions"] objectAtIndex:2] valueForKey:@"horsenumber"];
        [self.scheduleDetailRacesListObjectsArray addObject:self.detailSelection];
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.selectionDetailTableView reloadData];
        
    });
    
}

- (void)keyboardWillShow {
    for( UIView *subview in self.view.subviews ) {
        if( [subview isKindOfClass:[UIControl class]] ) {
            UIControl *v = (UIControl*)subview;
            if (v.alpha < 1) {
                v.hidden = YES;
            }
        }
    }
}

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
    [self loadDataForSelectedDate:self.datePicker.date];
    [self.actionSheet dismissWithClickedButtonIndex:2 animated:YES];
    
}
- (void)datecancelbuttonClicked:(id) sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)backToHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) createScrollContainer
{
    CGFloat x = 5.0f;
    
    for (UIView *view in [self.trackContainerScrollView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < [self.trackObjectsArray count]; i++) {
        
        CGRect scrollableTrackTitleViewFrame = CGRectMake(x, 0, 220, 47);
        
        NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"SPScrollTrackView" owner:nil options:nil];
        
        SPScrollTrackView *scrollableTrackTitleView = nil;
        for (id xibObject in xibArray) {
            //Loop through array, check for the object we're interested in.
            if ([xibObject isKindOfClass:[SPScrollTrackView class]]) {
                //Use casting to cast (id) to (MyCustomView *)
                scrollableTrackTitleView = (SPScrollTrackView *)xibObject;
            }
        }
        scrollableTrackTitleView.frame = scrollableTrackTitleViewFrame;
        [self.trackContainerScrollView addSubview:scrollableTrackTitleView];
        
        [scrollableTrackTitleView setTrackDetails:[self.trackObjectsArray objectAtIndex:i]];
        [scrollableTrackTitleView updateView];
        x = x + self.trackContainerScrollView.frame.size.width;
        
    }
    
    [self.trackContainerScrollView setContentOffset:CGPointMake(0, 0)];
    [self.trackContainerScrollView setContentSize:CGSizeMake(x, self.trackContainerScrollView.frame.size.height)];
    
}


- (IBAction)backToSelections:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	// Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
	[self.filteredDetailSelectionTracksArray removeAllObjects];
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.trackname contains[c] %@",searchText];
    self.filteredDetailSelectionTracksArray = [NSMutableArray arrayWithArray:[self.trackObjectsArray filteredArrayUsingPredicate:predicate]];
    
    if ([self.filteredDetailSelectionTracksArray count] > 0) {
        
        self.pageIndex = [self.trackObjectsArray indexOfObject:[self.filteredDetailSelectionTracksArray objectAtIndex:0]];
        [self.trackContainerScrollView setContentOffset:CGPointMake(self.trackContainerScrollView.frame.size.width * self.pageIndex, 0)];
        
        [self updateTableData];
        
    }
    
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
        [self.selectionDetailTableView setContentOffset:CGPointMake(0, 0)];
        [self updateTableData];
        
    }
    else if(self.trackContainerScrollView.contentOffset.x >= self.trackContainerScrollView.frame.size.width && touchPoint.x < self.trackContainerScrollView.contentOffset.x)
    {
        
        self.pageIndex = currentPage - 1;
        
        CGRect frame = self.trackContainerScrollView.frame;
        frame.origin.x = frame.size.width * (currentPage - 1);
        [self.trackContainerScrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
        [self.selectionDetailTableView setContentOffset:CGPointMake(0, 0)];
        [self updateTableData];
        
    }
    
}

#pragma mark - DataSources

#pragma mark - TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.scheduleDetailRacesListObjectsArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SPCustomDetailSelectionCell *customDetailSelectionCell = [tableView dequeueReusableCellWithIdentifier:kcustomDetailSelectionCellIdentifier];
    
    SPDetailSelection *detailSelectionObj = [self.scheduleDetailRacesListObjectsArray objectAtIndex:indexPath.row];
    
    [customDetailSelectionCell setDetailSelectons:detailSelectionObj];
    
    [customDetailSelectionCell updateViewIndex:indexPath];
    
    
    return customDetailSelectionCell;
}

#pragma mark - Delegates

#pragma mark - TableView Delegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == self.trackContainerScrollView) {
        self.pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self.selectionDetailTableView setContentOffset:CGPointMake(0, 0)];
        [self updateTableData];
    }
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:kcustomDetailSelectionCell bundle:nil] forCellReuseIdentifier:kcustomDetailSelectionCellIdentifier];
    self.searchDisplayController.searchResultsTableView.hidden = YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
