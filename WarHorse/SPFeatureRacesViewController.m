//
//  SPFeatureRacesViewController.m
//  WarHorse
//
//  Created by Ramya on 8/24/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPFeatureRacesViewController.h"
#import "SPCustomFeatureRacesCell.h"
#import "SPfeatureRaces.h"
#import "SPDate.h"
#import "SPScrollView.h"
#import "ZLPreLoginAPIWrapper.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"


static NSString *const kcustomFeatureRaceCellIdentifier = @"customFeatureRaceCellIdentifier";
static NSString *const kcustomFeatureRaceCell = @"SPCustomFeatureRacesCell";

@interface SPFeatureRacesViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate, NSURLConnectionDelegate>

@property (strong) IBOutlet UITableView *featureRacesTableView;
@property (strong) NSMutableDictionary *raceTrackDic;
@property (strong) NSMutableArray *raceTrackArray;
@property (strong) SPfeatureRaces *featureRaces;

@property (strong, nonatomic) NSMutableArray *featureRacesObjectArray;

@property (strong) NSMutableArray *featureRacesTrackListObjectArray;
@property (strong) IBOutlet UIScrollView *trackContainerScrollView;

@property (strong) NSMutableArray *colorsArray;
@property (strong) SPDate *date;
@property (strong) NSMutableArray *dateObjectArray;

@property (strong) IBOutlet UIImageView *headerImageView;
@property (strong) UIDatePicker *datePicker;
@property (strong) UIToolbar *toolBar;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSDateComponents *components;
@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic)UIView *datePickerView;

@property (assign, nonatomic) int pageIndex;

@property (weak, nonatomic) IBOutlet UILabel *noDataAvailableLable;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;

- (IBAction)showCalendar:(id)sender;
- (IBAction)homeButtonAction:(id)sender;

@end

@implementation SPFeatureRacesViewController

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
    self.dateObjectArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.featureRacesObjectArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.trackContainerScrollView.clipsToBounds = NO;
    self.trackContainerScrollView.bounces = NO;
    self.trackContainerScrollView.pagingEnabled = YES;
	self.trackContainerScrollView.showsHorizontalScrollIndicator = NO;
    
    self.components = [[NSDateComponents alloc] init];
    self.calendar = [NSCalendar currentCalendar];
    self.pageIndex = 0;
    
    [self.noDataAvailableLable setFont:[UIFont fontWithName:@"Roboto-Light" size:18]];
    [self.noDataAvailableLable setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f   blue:30.0/255.0f alpha:1.0]];
    
    [self.headerLbl setText:@"Feature Races"];
    [self.headerLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:16]];
    [self.featureRacesTableView setSeparatorColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]];
    
    [self createScrollContainer];
    
    [self.featureRacesTableView registerNib:[UINib nibWithNibName:kcustomFeatureRaceCell bundle:nil] forCellReuseIdentifier:kcustomFeatureRaceCellIdentifier];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.trackContainerScrollView addGestureRecognizer:singleTap];
    
    [self loadDataForSelectedDate:[NSDate date]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [self setFeatureRacesTableView:nil];
    //[self setTrackContainerScrollView:nil];
    [self setHeaderImageView:nil];
    [self setFeatureRacesTableView:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[LeveyHUD sharedHUD] disappear];
    [self.datePickerView removeFromSuperview];

    [super viewWillDisappear:animated];
}

#pragma mark - Private API

- (void)loadDataForSelectedDate:(NSDate *)selectedDate
{
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //[ZLAppDelegate showLoadingView];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Feature Races..."];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMM dd, YYYY"];
    
    NSDate *toDate = [self numberOfDays:5 fromDate:selectedDate];
    //NSLog(@"toDate %@",toDate);
    NSString *fromDateStr = [dateFormatter stringFromDate:selectedDate];
    //NSLog(@"fromDateStr %@",fromDateStr);
    NSString *toDateStr = [dateFormatter stringFromDate:toDate];
    //NSLog(@"toDateStr %@",toDateStr);
    NSString *dateInputString = [NSString stringWithFormat:@"Json_Data.DateEntries[?(@.Date == '%@-%@')]",fromDateStr,toDateStr];
    //NSLog(@"dateInputString %@",dateInputString);
    NSDictionary *argumentsDic = @{@"queryName":@"framework_json_data",
                                   @"filterParam":dateInputString,
                                   @"queryParams":@{@"json_data_id":@"FeatureRaces"}};
    
    
    ZLPreLoginAPIWrapper *preloginapiwrapper = [[ZLPreLoginAPIWrapper alloc] init];
    
    [preloginapiwrapper loadPreLoginDataForParameterType:argumentsDic success:^(NSDictionary *_userInfo) {
        
        //[ZLAppDelegate hideLoadingView];
        [[LeveyHUD sharedHUD] disappear];
        self.pageIndex = 0;
        self.noDataAvailableLable.hidden = YES;
        self.featureRacesTableView.hidden = NO;
        
        if ([[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"] count]) {
            [self.trackContainerScrollView setHidden:NO];

            self.featureRacesObjectArray = (NSMutableArray *)[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"];
            //NSLog(@"featureRacesObjectArray %@",self.featureRacesObjectArray);
            
            for (int i = 0; i <= [self.featureRacesObjectArray count]/5; i++) {
                [self.colorsArray addObject:[UIColor colorWithRed:69.0/255.0f green:138.0/255.0f blue:242/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:164.0/255.0f green:99.0/255.0f blue:165.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:113.0/255.0f green:170.0/255.0f blue:0.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:178.0/255.0f green:0.0/255.0f blue:36.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:237.0/255.0f green:106.0/255.0f blue:62.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:69.0/255.0f green:138.0/255.0f blue:242/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:164.0/255.0f green:99.0/255.0f blue:165.0/255.0f alpha:1.0]];
            }
            
            [self.featureRacesObjectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                self.date = [[SPDate alloc] init];
                
                self.components.day = idx;
                self.date.dateWiseDetails = [obj valueForKey:@"Date"];
                self.date.bgColor = [self.colorsArray objectAtIndex:idx];
                [self.dateObjectArray addObject:self.date];
            }];
            NSLog(@"dateObjectArray %@",self.dateObjectArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createScrollContainer];
                [self updateTableData];
            });
            
        }
        else
        {
            [[LeveyHUD sharedHUD] disappear];
            self.noDataAvailableLable.hidden = NO;
            self.featureRacesTableView.hidden = YES;
            [self.trackContainerScrollView setHidden:YES];
            return;
            
        }
        
    } failure:^(NSError *error) {
        
        [[LeveyHUD sharedHUD] disappear];
        self.noDataAvailableLable.hidden = NO;
        self.featureRacesTableView.hidden = YES;
        
    }];
    
}


- (NSDate *)numberOfDays:(NSInteger)days fromDate:(NSDate *)from {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:+days];
    
    return [gregorian dateByAddingComponents:offsetComponents toDate:from options:0];
    
}

- (void)updateTableData
{
    
    self.featureRacesTrackListObjectArray = [[NSMutableArray alloc] initWithCapacity:0];

    
    if ([self.featureRacesObjectArray count]<=0)
    {
        return;
        
    }
    
    self.raceTrackArray = [[NSMutableArray alloc] initWithArray:(NSArray *)[[self.featureRacesObjectArray objectAtIndex:self.pageIndex] valueForKey:@"TrackList"]];
    
    [self.raceTrackArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        self.featureRaces = [[SPfeatureRaces alloc] init];
        self.featureRaces.trackname = [obj valueForKey:@"Trackname"];
        self.featureRaces.description = [obj valueForKey:@"Description"];
        self.featureRaces.poolTotal = [obj valueForKey:@"PoolTotal"];
        self.featureRaces.horseAge = [obj valueForKey:@"HorseAge"];
        self.featureRaces.distancePublished = [obj valueForKey:@"DistancePublished"];
        [self.featureRacesTrackListObjectArray addObject:self.featureRaces];
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.featureRacesTableView reloadData];
    });
    
}


- (void)createScrollContainer
{
    CGFloat x = 5.0f;
    
    for (UIView *view in [self.trackContainerScrollView subviews]) {
        [view removeFromSuperview];
    }
    
    UINib *spscrollViewNib = [UINib nibWithNibName:@"SPScrollView" bundle:nil];
    
    for (int i = 0; i < [self.featureRacesObjectArray count]; i++) {
        
        CGRect scrollableTrackTitleViewFrame = CGRectMake(x, 0, 220, self.trackContainerScrollView.frame.size.height);
        NSArray *spScrollViewNibObjectsArray = [spscrollViewNib instantiateWithOwner:self options:nil];
        
        SPScrollView *scrollableTrackTitleView = nil;
        for (id nibObject in spScrollViewNibObjectsArray) {
            //Loop through array, check for the object we're interested in.
            if ([nibObject isKindOfClass:[SPScrollView class]]) {
                //Use casting to cast (id) to (MyCustomView *)
                scrollableTrackTitleView = (SPScrollView *)nibObject;
            }
        }
        scrollableTrackTitleView.frame = scrollableTrackTitleViewFrame;
        [self.trackContainerScrollView addSubview:scrollableTrackTitleView];
        [scrollableTrackTitleView setDate:[self.dateObjectArray objectAtIndex:i]];
        [scrollableTrackTitleView updateView];
        
        x = x + self.trackContainerScrollView.frame.size.width;
        
    }
    
    [self.trackContainerScrollView setContentOffset:CGPointMake(0, 0)];
    [self.trackContainerScrollView setContentSize:CGSizeMake(x, self.trackContainerScrollView.frame.size.height)];
}

- (IBAction)showCalendar:(id)sender
{
    if(!self.datePicker)
    {
        self.datePickerView = [[UIView alloc]init];
        self.datePicker = [[UIDatePicker alloc]init];
        self.toolBar = [[UIToolbar alloc] init];
    }
    
    if (IS_IPHONE5)
    {
        self.datePickerView.frame = CGRectMake(0, 0, 320, 568);
        self.datePicker.frame = CGRectMake(0, 374, 320, 260);
        self.toolBar.frame = CGRectMake(0, 329, 320, 44);
    }else{
        self.datePickerView.frame = CGRectMake(0, 0, 320, 480);
        self.datePicker.frame = CGRectMake(0, 285, 320, 260);
        self.toolBar.frame = CGRectMake(0, 242, 320, 44);
        
        
    }
    
    
    self.datePickerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.toolBar.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    
    self.toolBar.barStyle = UIBarStyleBlackOpaque;
    [self.toolBar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datecancelbuttonClicked:)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donebuttonClicked:)];
    [barItems addObject:flexSpace];
    [barItems addObject:doneBtn];
    [self.toolBar setItems:barItems animated:YES];
    
    
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    [self.datePickerView addSubview:self.toolBar];
    [self.datePickerView addSubview:self.datePicker];
    [self.view addSubview:self.datePickerView];
    

    
}

-(void)donebuttonClicked:(id) sender
{
    [self loadDataForSelectedDate:self.datePicker.date];
    [self.datePickerView removeFromSuperview];
}

-(void)datecancelbuttonClicked:(id) sender
{
    [self.datePickerView removeFromSuperview];
}

- (IBAction)homeButtonAction:(id)sender
{
    [self.trackContainerScrollView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
        [self.featureRacesTableView setContentOffset:CGPointMake(0, 0)];
    }
    else if(self.trackContainerScrollView.contentOffset.x >= self.trackContainerScrollView.frame.size.width && touchPoint.x < self.trackContainerScrollView.contentOffset.x)
    {
        
        self.pageIndex = currentPage - 1;
        
        CGRect frame = self.trackContainerScrollView.frame;
        frame.origin.x = frame.size.width * (currentPage - 1);
        [self.trackContainerScrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
        [self updateTableData];
        [self.featureRacesTableView setContentOffset:CGPointMake(0, 0)];
    }
    
}

#pragma mark - Datasources

#pragma mark - TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    
    return [self.featureRacesTrackListObjectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SPCustomFeatureRacesCell *customFeatureRaceCell  = [tableView dequeueReusableCellWithIdentifier:kcustomFeatureRaceCellIdentifier];
    
    [customFeatureRaceCell setFeatureRaces:[self.featureRacesTrackListObjectArray objectAtIndex:indexPath.row]];
    [customFeatureRaceCell updateViewIndex:indexPath];
    
    return customFeatureRaceCell;
}

#pragma mark - Delegates

#pragma mark - TableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.trackContainerScrollView) {
        self.pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        
        
        if ([self.dateObjectArray count]<=0)
        {
            return;
            
        }
       
        [self updateTableData];
        [self.featureRacesTableView setContentOffset:CGPointMake(0, 0)];
    }
    
}



@end
