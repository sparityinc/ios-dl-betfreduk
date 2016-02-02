//
//  SPSCRChangesDetailViewController.m
//  WarHorse
//
//  Created by Enterpi on 22/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPSCRChangesDetailViewController.h"
#import "SPScrollableTrackTitleView.h"
#import "SPSCRChangesDetail.h"
#import "SPSCRChangesDetailCustomCell.h"
#import "SPSCRChanges.h"
#import "ZLPreLoginAPIWrapper.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"


static NSString *const kcustomScrChangesDetailCellIdentifier = @"customScrChangesDetailCellIdentifier";
static NSString *const kscrChangesDetailCustomCell = @"SPSCRChangesDetailCustomCell";

@interface SPSCRChangesDetailViewController () 

//Race Objects
@property (strong, nonatomic) NSMutableArray *scrChangesDetailTracksArray;
@property (strong, nonatomic) NSMutableArray *scrChangesDetailTracksObjectsArray;
@property (strong, nonatomic) NSMutableArray *scrollViewDataObjectsArray;
@property (strong, nonatomic) IBOutlet UILabel *noSCRChangesAvailableLabel;

@property (strong, nonatomic) NSMutableArray *colorsArray;
@property (strong, nonatomic) NSMutableArray *filteredScrChangesDetailTracksObjectsArray;

@property (strong, nonatomic) NSMutableArray *scrChangesDetailObjectsArray;

@property (strong, nonatomic) IBOutlet UITableView *scrChangesDetailTableView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) SPSCRChanges *scrChanges;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property  (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, assign) int pageIndex;

//Park Objects
@property (strong, nonatomic) IBOutlet UIScrollView *trackContainerScrollView;

@property (strong, nonatomic) SPSCRChangesDetail *scrChangesDetail;

// Present calendar View
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong,nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIToolbar *pickerToolBar;
@property (strong,nonatomic) IBOutlet UIButton *homeBtn;
@property (strong, nonatomic) UIButton *amountButton;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *myBetsBtn;
@property (strong, nonatomic) IBOutlet UIButton *wagerBtn;

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;

- (IBAction)goToHome:(id)sender;
- (IBAction)goToMyBets:(id)sender;
- (IBAction)wagerBtnclicked:(id)sender;

@end

@implementation SPSCRChangesDetailViewController
@synthesize isPostLoginFlag;
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
    self.navigationController.navigationBarHidden = YES;

    self.pageIndex = 0;
    
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor clearColor];

    
    [self.headerLabel setText:@"Non Runners"];
    
    
    if ([[[WarHorseSingleton sharedInstance] localCountry] isEqualToString:@"en_UK"]){
        //self.selectTrackLabel.text = @"Select Course";
        self.searchBar.placeholder = @"Search Course";
    }else{
        self.searchBar.placeholder = @"Search Track";
    }

    
    if (isPostLoginFlag == YES){
        [self.headerLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];

        [self.homeBtn setImage:[UIImage imageNamed:@"toggle.png"] forState:UIControlStateNormal];
        [self.homeButton setHidden:NO];
        [self.myBetsBtn setHidden:NO];
        [self.wagerBtn setHidden:NO];
        [self prepareTopView];

    }else{
        [self.headerLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];

        [self.homeBtn setBackgroundImage:[UIImage imageNamed:@"backarrow.png"] forState:UIControlStateNormal];
        [self.homeBtn addTarget:nil action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];
        self.scrChangesDetailTableView.frame = CGRectMake(self.scrChangesDetailTableView.frame.origin.x, self.scrChangesDetailTableView.frame.origin.y, self.scrChangesDetailTableView.frame.size.width, self.scrChangesDetailTableView.frame.size.height+40);
        [self.homeButton setHidden:YES];
        [self.myBetsBtn setHidden:YES];
        [self.wagerBtn setHidden:YES];
    }
    

    
    
    [self.scrChangesDetailTableView setSeparatorColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    self.trackContainerScrollView.clipsToBounds = NO;
    
    [self loadDataForSelectedDate:[NSDate date]];
    
    [self.scrChangesDetailTableView registerNib:[UINib nibWithNibName:kscrChangesDetailCustomCell bundle:nil] forCellReuseIdentifier:kcustomScrChangesDetailCellIdentifier];
    
    [self.noSCRChangesAvailableLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:18.0]];
    [self.noSCRChangesAvailableLabel setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.trackContainerScrollView addGestureRecognizer:singleTap];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    ZLPreLoginAPIWrapper *preloginapiwrapper = [[ZLPreLoginAPIWrapper alloc] init];
    
    self.scrChangesDetailObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.scrollViewDataObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    //self.filteredScrChangesDetailTracksObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.colorsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //[ZLAppDelegate showLoadingView];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading SCR & Changes..."];

    [preloginapiwrapper loadSCRChangesDataForSelectedDate:nil success:^(NSDictionary *_userInfo) {
        
        //[ZLAppDelegate hideLoadingView];
        [[LeveyHUD sharedHUD] disappear];

        self.noSCRChangesAvailableLabel.hidden = YES;
        self.scrChangesDetailTableView.hidden = NO;

        
        if ([[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"] count]) {
            self.scrChangesDetailObjectsArray = (NSMutableArray *)[[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"] mutableArrayValueForKey:@"trackItem"];
            
            
            for (int i = 0; i <= [self.scrChangesDetailObjectsArray count]/9; i++) {
                
                [self.colorsArray addObject:[UIColor colorWithRed:255.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:0.0/255.0f green:153.0/255.0f blue:188.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:212.0/255.0f green:5.0/255.0f blue:63.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:117.0/255.0f green:114.0/255.0f blue:216.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:221.0/255.0f green:144.0/255.0f blue:34.0/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:160.0/255.0f green:17.0/255.0f blue:182/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:39.0/255.0f green:209.0/255.0f blue:26.0/255.0f alpha:1.0]];
                
                [self.colorsArray addObject:[UIColor colorWithRed:1.0/255.0f green:71.0/255.0f blue:185/255.0f alpha:1.0]];
                [self.colorsArray addObject:[UIColor colorWithRed:229.0/255.0f green:30.0/255.0f blue:133.0/255.0f alpha:1.0]];

            }
            
            [self.scrChangesDetailObjectsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                self.scrChanges = [[SPSCRChanges alloc] init];
                self.scrChanges.trackname = [obj valueForKey:@"trackName"];
                self.scrChanges.viewBgColor = [self.colorsArray objectAtIndex:idx];
                [self.scrollViewDataObjectsArray addObject:self.scrChanges];
                
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self createScrollContainer];
                [self updateTableData];
                
            });
            
        }
        else {
            [[LeveyHUD sharedHUD] disappear];

            self.noSCRChangesAvailableLabel.hidden = NO;
            self.scrChangesDetailTableView.hidden = YES;
            return;
        }
        
    } failure:^(NSError *error) {

        [[LeveyHUD sharedHUD] disappear];

        self.noSCRChangesAvailableLabel.hidden = NO;
        self.scrChangesDetailTableView.hidden = YES;

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error Code:%ld", (long)error.code] message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
    
}

- (void)updateTableData
{
    self.scrChangesDetail.changesArray  = nil;
    self.scrChangesDetailTracksArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.scrChangesDetailTracksObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];

    self.scrChangesDetailTracksArray = [[[self.scrChangesDetailObjectsArray objectAtIndex:self.pageIndex] valueForKey:@"cardChanges"] valueForKey:@"raceChangesArray"];
    NSLog(@"self.scrChangesDetailTracksArray %@",self.scrChangesDetailTracksArray);
    
    [self.scrChangesDetailTracksArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        self.scrChangesDetail = [[SPSCRChangesDetail alloc] init];
        [self.scrChangesDetail setRace:[obj valueForKey:@"race"]];
        [self.scrChangesDetail setChangesArray:[obj valueForKey:@"changesArray"]];
        [self.scrChangesDetailTracksObjectsArray addObject:self.scrChangesDetail];
        
    }];
    
    if ([self.scrChangesDetail.changesArray count]) {
        
        self.noSCRChangesAvailableLabel.hidden = YES;
        self.scrChangesDetailTableView.hidden = NO;

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.scrChangesDetailTableView reloadData];
        });
    }
    else
    {
        self.noSCRChangesAvailableLabel.hidden = NO;
        self.scrChangesDetailTableView.hidden = YES;
    }
    
   
    
}

- (void) createScrollContainer
{
    CGFloat x = 5.0f;
    
    for (UIView *view in [self.trackContainerScrollView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < [self.scrollViewDataObjectsArray count]; i++) {
        
        CGRect scrollableTrackTitleViewFrame = CGRectMake(x, 0, 220, self.trackContainerScrollView.frame.size.height);
        
        NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"SPScrollableTrackTitleView" owner:self options:nil];
        
        SPScrollableTrackTitleView *scrollableTrackTitleView = nil;
        for (id xibObject in xibArray) {
            //Loop through array, check for the object we're interested in.
            if ([xibObject isKindOfClass:[SPScrollableTrackTitleView class]]) {
                //Use casting to cast (id) to (MyCustomView *)
                scrollableTrackTitleView = (SPScrollableTrackTitleView *)xibObject;
            }
        }
        
        scrollableTrackTitleView.frame = scrollableTrackTitleViewFrame;
        [scrollableTrackTitleView setIsSCRChanges:YES];
        [scrollableTrackTitleView setScrChanges:[self.scrollViewDataObjectsArray objectAtIndex:i]];
        [scrollableTrackTitleView updateView];
        
        [self.trackContainerScrollView addSubview:scrollableTrackTitleView];
        
        x = x + self.trackContainerScrollView.frame.size.width;
        
    }
    
    [self.trackContainerScrollView setContentOffset:CGPointMake(0, 0)];
    [self.trackContainerScrollView setContentSize:CGSizeMake(x, self.trackContainerScrollView.frame.size.height)];
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

- (void)backToHome:(id)sender
{
    [self.trackContainerScrollView removeFromSuperview];
    
    if (isPostLoginFlag == YES){

    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    
}
- (void)prepareTopView
{
    [self.homeBtn addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.amountButton = [[UIButton alloc] initWithFrame:CGRectMake(276, 20, 44, 44)];
    if ([[[WarHorseSingleton sharedInstance] localCountry] isEqualToString:@"en_UK"]){
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"pound.png"] forState:UIControlStateNormal];
        
    }else{
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"symbol.png"] forState:UIControlStateNormal];
        
    }
    [self.amountButton setBackgroundImage:[UIImage imageNamed:@"balancebg@2x.png"] forState:UIControlStateSelected];
    [self.amountButton setTitle:@"" forState:UIControlStateNormal];
    [self.amountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.amountButton.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.amountButton addTarget:self action:@selector(amountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.amountButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceUpdated:) name:@"BalanceUpdated" object:nil];
    
}
-(void)balanceUpdated:(NSNotification *)notification
{
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
}
- (void)amountButtonClicked:(id)sender
{
    if ([self.amountButton isSelected]) {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(272, 20, 44, 44)];
        
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
        [self.amountButton setFrame:CGRectMake(237, 20, 71, 44)];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
    }
}

- (void)timerMethod:(NSTimer *)timer
{
    if ([self.amountButton isSelected]) {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(276, 20, 44, 44)];
    }
}

- (IBAction)backToScrChangeView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [self loadDataForSelectedDate:self.datePicker.date];    
    [self.actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

-(void)datecancelbuttonClicked:(id) sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
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
        [self.scrChangesDetailTableView setContentOffset:CGPointMake(0, 0)];
        
    }
    else if(self.trackContainerScrollView.contentOffset.x >= self.trackContainerScrollView.frame.size.width && touchPoint.x < self.trackContainerScrollView.contentOffset.x)
    {
        self.pageIndex = currentPage - 1;
        
        CGRect frame = self.trackContainerScrollView.frame;
        frame.origin.x = frame.size.width * (currentPage - 1);
        [self.trackContainerScrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
        [self updateTableData];
        [self.scrChangesDetailTableView setContentOffset:CGPointMake(0, 0)];
    }
    
}

#pragma mark - DataSources

#pragma mark - TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [self.scrChangesDetailTracksObjectsArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SPSCRChangesDetailCustomCell *scrChangesDetailCustomCell  = [tableView dequeueReusableCellWithIdentifier:kcustomScrChangesDetailCellIdentifier forIndexPath:indexPath];
    
    
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
     //_race_card = [self.filteredTracksArray objectAtIndex:indexPath.row];
     }
     else {
     //_race_card = [self.tracksArray objectAtIndex:indexPath.row];
     }
    

    [scrChangesDetailCustomCell setScrChangesDetail:[self.scrChangesDetailTracksObjectsArray objectAtIndex:indexPath.row]];
    [scrChangesDetailCustomCell setTrackIndex:self.pageIndex + 1];
    [scrChangesDetailCustomCell updateViewAtIndexPath: indexPath];
    scrChangesDetailCustomCell.backgroundColor = [UIColor clearColor];
    return scrChangesDetailCustomCell;
}


#pragma mark - Delegates

#pragma mark - TableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SPSCRChangesDetailCustomCell *scrChangesDetailCustomCell  = [tableView dequeueReusableCellWithIdentifier:kcustomScrChangesDetailCellIdentifier];
    
    [scrChangesDetailCustomCell setScrChangesDetail:[self.scrChangesDetailTracksObjectsArray objectAtIndex:indexPath.row]];
    [scrChangesDetailCustomCell setTrackIndex:self.pageIndex + 1];

    
    return [scrChangesDetailCustomCell calculateHeightForRowAtIndexPath:indexPath];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSStringDrawingContext *ctx = [NSStringDrawingContext new];
    NSAttributedString *aString = [[NSAttributedString alloc] initWithString:@"The Cell's Text!"];
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:aString];
    CGRect textRect = [calculationView.text boundingRectWithSize:self.view.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:calculationView.font} context:ctx];
    return textRect.size.height;
}
*/

/*
 ////// Calculate the Height of Text from width
 */
- (float)calculateHeightOfTextFromWidth:(NSString *)text withFont:(UIFont *)font withWidth:(float)width withLineBreakMode:(NSLineBreakMode)lineBreakMode;
{
	CGSize suggestedSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:lineBreakMode];
	
    
    //CGSize *cellSize = [cell.textLabel.text sizeWithAttributes:@{NSFontAttributeName:[cell.text.font]}];

    
	return suggestedSize.height;
    
}


#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.trackContainerScrollView) {
        self.pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        //[self.scrChangesDetailTableView setContentOffset:CGPointMake(0, 0)];
        [self updateTableData];
        
    }
    
}


#pragma mark - UISearchDisplayController Delegate Methods

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self setCorrectFrames];

    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:kscrChangesDetailCustomCell bundle:nil] forCellReuseIdentifier:kcustomScrChangesDetailCellIdentifier];
    self.searchDisplayController.searchResultsTableView.contentInset = UIEdgeInsetsZero;
    
    self.searchDisplayController.searchResultsTableView.hidden = YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    self.searchDisplayController.searchResultsTableView.frame = CGRectMake(0, 60, 320, 460);
    return YES;
}



#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	// Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
	[self.filteredScrChangesDetailTracksObjectsArray removeAllObjects];
	// Filter the array using NSPredicate
    
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.raceTrackTitle contains[c] %@ OR SELF.trackVenueLabel contains[c] %@",searchText, searchText];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.trackName contains[c] %@",searchText];//Race   trackName
    
    NSLog(@"predicate %@",predicate);
    //NSLog(@"self.scrChangesDetailObjectsArray %@",self.scrChangesDetailObjectsArray);
    
    self.filteredScrChangesDetailTracksObjectsArray = [NSMutableArray arrayWithArray:[self.scrChangesDetailObjectsArray filteredArrayUsingPredicate:predicate]];
    
    //NSLog(@"veeru %@",self.filteredScrChangesDetailTracksObjectsArray);
    
    if ([self.filteredScrChangesDetailTracksObjectsArray count] > 0) {
        
        self.pageIndex = [self.scrChangesDetailObjectsArray indexOfObject:[self.filteredScrChangesDetailTracksObjectsArray objectAtIndex:0]];
        [self.trackContainerScrollView setContentOffset:CGPointMake(self.trackContainerScrollView.frame.size.width * self.pageIndex, 0)];
        
        [self updateTableData];
        
    }
    
}






///

- (void)setCorrectFrames
{
    // Here we set the frame to avoid overlay
    
    CGRect searchDisplayerFrame = self.searchDisplayController.searchResultsTableView.superview.frame;
    searchDisplayerFrame.origin.y = CGRectGetMaxY(self.searchDisplayController.searchBar.frame);
    searchDisplayerFrame.size.height -= searchDisplayerFrame.origin.y;
    self.searchDisplayController.searchResultsTableView.superview.frame = searchDisplayerFrame;
     
 
   
}



#pragma mark - Property Overridden methods

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *temporaryDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        temporaryDateFormatter = [[NSDateFormatter alloc] init];
        [temporaryDateFormatter setDateFormat:@"EEEE, MMM d, YYYY"];
    
    });
    
    return temporaryDateFormatter;
}

- (void)viewDidUnload {
    [self setNoSCRChangesAvailableLabel:nil];
    [super viewDidUnload];
}
- (IBAction)goToHome:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardHome]forKey:@"viewNumber"]];

}

- (IBAction)goToMyBets:(id)sender {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardMyBets]forKey:@"viewNumber"]];
}

- (IBAction)wagerBtnclicked:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardWager]forKey:@"viewNumber"]];
}
@end
