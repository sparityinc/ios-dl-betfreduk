//
//  ZLResultsRootViewController.m
//  WarHorse
//
//  Created by Sparity on 01/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLResultsRootViewController.h"
#import "ZLResultTrackDetialViewController.h"
#import "ZLAppDelegate.h"
#import "ZLAPIWrapper.h"
#import "ZLCalendarScrollView.h"
#import "ZLTrackResults.h"
#import "ZLBetResult.h"
#import "ZLLoadCardTracks.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"

#define kCellIdentifier @"ResultTableCustomCellIdentifier"

@interface ZLResultsRootViewController ()

@property(nonatomic,retain) IBOutlet UITableView *resultTableView;
@property(nonatomic,retain) IBOutlet UILabel * noResultsLabel;
@property(nonatomic,retain) NSMutableArray *resultArray;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet ZLCalendarScrollView * calendarScrollView;
@property(strong) UINib *customResultDetailCellNib;
@property (strong) ZLResultTableCustomCell *resultCustomCell;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIToolbar *pickerToolBar;
@property (strong ,nonatomic) NSString *dateStr;
@property (strong, nonatomic) UIView *datePickerView;
@end

@implementation ZLResultsRootViewController

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
    [_resultTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _resultArray=[[NSMutableArray alloc]init];
    
    [self loadResultsForDate:[NSDate date]];
    self.noResultsLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
    
    self.scrollView.clipsToBounds = NO;
    self.scrollView.pagingEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
    self.calendarScrollView.selectedDate = [NSDate date];
    [self.calendarScrollView setUpSubView];
    
    self.calendarScrollView.delegate = self;
	
    CGFloat contentOffset = 0.0f;
    
    for (int i=0;i<3; i++)
    {
        CGRect imageViewFrame = CGRectMake(contentOffset, 0.0f,  _scrollView.frame.size.width - 5,  _scrollView.frame.size.height);
        UILabel *label = [[UILabel alloc] initWithFrame:imageViewFrame];
        [label setText:[NSString stringWithFormat:@"Text %d",i]];
        contentOffset += label.frame.size.width + 5;
		[self.scrollView addSubview:label];
        self.scrollView.contentSize = CGSizeMake(contentOffset,  _scrollView.frame.size.height);
	}
    self.customResultDetailCellNib = [UINib nibWithNibName:@"ZLResultTableCustomCell" bundle:nil];
    self.noResultsLabel.hidden = YES;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void) dateDidChange{
    
    [self loadResultsForDate:self.calendarScrollView.selectedDate];
}

- (void)loadResultsForDate:(NSDate*) date
{
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];

    
    self.dateStr = [formatter stringFromDate:date];
//    NSMutableArray * tracks = [[ZLAppDelegate getAppData].dictTrackResultsByDate objectForKey:[formatter stringFromDate:date]];
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Results..."];
    ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
    [apiWrapper getTracksResultsForDate:date
                                success:^(NSDictionary* _userInfo){
                                    NSLog(@"Results Dicti === %@",_userInfo);
                                    [[LeveyHUD sharedHUD] disappear];
                                    
                                    NSMutableArray * tracks =[[ZLAppDelegate getAppData].dictTrackResultsByDate objectForKey:[formatter stringFromDate:[self.calendarScrollView selectedDate]]];
                                    
                                    
                                    if(tracks && [tracks count] > 0){
                                        self.noResultsLabel.hidden = YES;
                                    }
                                    else {
                                        self.noResultsLabel.hidden = NO;
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Results are not available for this date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alert show];
                                    }
                                    [self.resultTableView reloadData];
                                    
                                }failure:^(NSError *error){
                                    [[LeveyHUD sharedHUD] disappear];
                                    if( [self.calendarScrollView selectedDate] == date){
                                        self.noResultsLabel.hidden = NO;
                                    }
                                }];
    
    /*
    if( tracks == nil) {
     
        [self.resultTableView reloadData];
        
        if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [[LeveyHUD sharedHUD] appearWithText:@"Loading Results..."];
        ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
        [apiWrapper getTracksResultsForDate:date
                                  success:^(NSDictionary* _userInfo){
                                      //NSLog(@"Results Dicti === %@",_userInfo);
                                      [[LeveyHUD sharedHUD] disappear];
                                      NSMutableArray * tracks = [[ZLAppDelegate getAppData].dictTrackResultsByDate objectForKey:[formatter stringFromDate:[self.calendarScrollView selectedDate]]];
                                      if(tracks && [tracks count] > 0){
                                          self.noResultsLabel.hidden = YES;
                                      }
                                      else {
                                          self.noResultsLabel.hidden = NO;
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Results are not available for this date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                          [alert show];
                                      }
                                      [self.resultTableView reloadData];
                                      
                                  }failure:^(NSError *error){
                                      [[LeveyHUD sharedHUD] disappear];
                                      if( [self.calendarScrollView selectedDate] == date){
                                          self.noResultsLabel.hidden = NO;
                                      }
                                  }];
        
    }
    else {
        if( tracks && [tracks count] > 0) {
            self.noResultsLabel.hidden = YES;
            [self.resultTableView reloadData];
        }
        else {
            self.noResultsLabel.hidden = NO;
            [self.resultTableView reloadData];
        }
        
    }*/

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark----
#pragma UIButton Actions

- (IBAction)wagerBtnClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardWager]forKey:@"viewNumber"]];
}

- (IBAction)goToHome:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardHome]forKey:@"viewNumber"]];
}

- (IBAction)goToMyBets:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardMyBets]forKey:@"viewNumber"]];
}



- (IBAction)showCalendar:(id)sender
{
    if(!self.datePicker)
    {
        self.datePickerView = [[UIView alloc]init];
        self.datePicker = [[UIDatePicker alloc]init];
        self.pickerToolBar = [[UIToolbar alloc] init];
    }
    
    if (IS_IPHONE5)
    {
        self.datePickerView.frame = CGRectMake(0, 0, 320, 568);
        self.datePicker.frame = CGRectMake(0, 310, 320, 260);
        self.pickerToolBar.frame = CGRectMake(0, 265, 320, 44);
    }else{
        self.datePickerView.frame = CGRectMake(0, 0, 320, 480);
        self.datePicker.frame = CGRectMake(0, 221, 320, 260);
        self.pickerToolBar.frame = CGRectMake(0, 176, 320, 44);
    }
    

    self.datePickerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.pickerToolBar.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
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
   
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-3 * 365 * 24 * 60 * 60]; // 3 years
    self.datePicker.maximumDate = [NSDate date];
    self.datePicker.date = self.calendarScrollView.selectedDate;
   [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
   [self.datePickerView addSubview:self.pickerToolBar];
   [self.datePickerView addSubview:self.datePicker];
    [self.view addSubview:self.datePickerView];

    
}


- (void) dateChanged:(id)sender{
    
    
}

- (void)doneButtonClicked:(id) sender
{
    self.calendarScrollView.selectedDate = self.datePicker.date;
    [self.calendarScrollView setUpSubView];
    self.noResultsLabel.hidden = YES;
    
    [self dateDidChange];
    [self.datePickerView removeFromSuperview];
    
 }

- (void)dateCancelbuttonClicked:(id) sender
{
    [self.datePickerView removeFromSuperview];
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSMutableArray * tracks = [[ZLAppDelegate getAppData].dictTrackResultsByDate objectForKey:[formatter stringFromDate:[self.calendarScrollView selectedDate]]];
    
    
    if( tracks == nil){
        return 0;
    }
    else{
        return [tracks count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    NSMutableArray * tracks = [[ZLAppDelegate getAppData].dictTrackResultsByDate objectForKey:[formatter stringFromDate:[self.calendarScrollView selectedDate]]];
    //NSLog(@"Cell is %@",tracks);
    [tableView registerNib:self.customResultDetailCellNib forCellReuseIdentifier:kCellIdentifier];
    self.resultCustomCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if( tracks != nil){
        
        ZLLoadCardTracks * trackResult = [tracks objectAtIndex:indexPath.row];
        if( trackResult){
            
            [self.resultCustomCell.trackName_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
            [self.resultCustomCell.address_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
            [self.resultCustomCell.trackName_Label setTextColor:[UIColor colorWithRed:30.0/255 green:30.0/255 blue:30.0/255 alpha:1.0]];
            [self.resultCustomCell.address_Label setTextColor:[UIColor colorWithRed:136.0/255 green:136.0/255 blue:136.0/255 alpha:1.0]];
            self.resultCustomCell.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
            
            /*
            if (trackResult.meet == 0 || trackResult.perf == 0 ){
                
                NSLog(@"Meet no zeor ==== %d Track name %@ pref %d",trackResult.meet,trackResult.trackName,trackResult.perf);

            }else{
                NSLog(@"Meet no %d Track name %@ pref %d",trackResult.meet,trackResult.trackName,trackResult.perf);

                self.resultCustomCell.trackName_Label.text = trackResult.trackName;

            }*/
            if ([trackResult.trackCountry isEqualToString:@"UK"]){
                self.resultCustomCell.countryFlag.image = [UIImage imageNamed:@"uk.png"];
            }else if ([trackResult.trackCountry isEqualToString:@"US"]){
                self.resultCustomCell.countryFlag.image = [UIImage imageNamed:@"us.png"];
                
            }
            self.resultCustomCell.trackName_Label.text = trackResult.trackName;
            self.resultCustomCell.address_Label.text = @"";//trackResult.trackCountry;
             
        
        }
    }
    

    
    return self.resultCustomCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    NSMutableArray * tracks = [[ZLAppDelegate getAppData].dictTrackResultsByDate objectForKey:[formatter stringFromDate:[self.calendarScrollView selectedDate]]];
    if( tracks != nil){
        
        ZLLoadCardTracks * resultsForTrack = [tracks objectAtIndex:indexPath.row];
        
       
        if( resultsForTrack != nil){
            static NSString *CellIdentifier = @"Cell";
            self.resultCustomCell  = (ZLResultTableCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            [self.resultCustomCell.contentView setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]];
            
            ZLResultTrackDetialViewController *trackDetialViewController=[[ZLResultTrackDetialViewController alloc]init];
            trackDetialViewController.resultDate = self.calendarScrollView.selectedDate;
            trackDetialViewController.track = resultsForTrack;
            trackDetialViewController.trackCode = resultsForTrack.trackId;
            trackDetialViewController.meet = resultsForTrack.meet;
            trackDetialViewController.perf = resultsForTrack.perf;
            trackDetialViewController.breedType = resultsForTrack.breedType;
            //NSLog(@"trackResult.trackName %@",resultsForTrack.track_Code);
            trackDetialViewController.trackCode = resultsForTrack.track_Code;
            trackDetialViewController.trackCountryFlag = resultsForTrack.trackCountry;

            trackDetialViewController.dateStr = self.dateStr;//resultsForTrack.raceDate;
            [trackDetialViewController setup];
            [self.navigationController pushViewController:trackDetialViewController animated:YES];
        }

    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.datePickerView removeFromSuperview];
}



@end
