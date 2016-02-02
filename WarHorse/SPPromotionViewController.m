//
//  SPPromotionViewController.m
//  WarHorse
//
//  Created by Ramya on 8/20/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPPromotionViewController.h"
#import "Communication.h"
#import "ZLMainScreenViewController.h"
#import "Reachability.h"
#import "LeveyHUD.h"
#import "Communication.h"
#import "SPPromotionTableCell.h"
#import "SPPromotionDetailViewController.h"
#import "ZLPreLoginAPIWrapper.h"
#import "SPPromotion.h"
#import "AsyncImageDownloader.h"
#import "SPConstant.h"

static NSString *const kcustomPromotionCellIdentifier = @"customPromotionCellIdentifier";
static NSString *const kcustomPromotionsCell = @"SPPromotionTableCell";
//static NSString *const ImagesBaseUrl = @"https://m.mywinners.com/mywinnerscms/file/";



@interface SPPromotionViewController () <UITableViewDelegate,UITableViewDataSource>
{
  
}
@property (strong, nonatomic) IBOutlet UITableView *promotionsTableview;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong,nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIToolbar *pickerToolBar;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (nonatomic,retain) NSMutableArray *prmotionBannersArray;
@property (nonatomic, strong) NSMutableArray *imageObjectArray;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, weak) IBOutlet UILabel *headerLbl;
@property (nonatomic,strong) UIImage *imageData;

- (IBAction)backToHome:(id)sender;
- (IBAction)showCalendar:(id)sender;

@end

@implementation SPPromotionViewController

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
    self.imagesArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.prmotionBannersArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.imageObjectArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.headerLbl setText:@"Promotions"];
    [self.headerLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self loadData];
    
    [self.promotionsTableview registerNib:[UINib nibWithNibName:kcustomPromotionsCell bundle:nil] forCellReuseIdentifier:kcustomPromotionCellIdentifier];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [self setPromotionsTableview:nil];
    [self setHeaderImageView:nil];
    [super viewDidUnload];
}

#pragma mark - Public API -

- (void)loadData
{
    ZLPreLoginAPIWrapper *preloginapiwrapper = [[ZLPreLoginAPIWrapper alloc] init];
    
    NSDictionary *argumentsDic = @{@"queryName":@"framework_json_data",
                                   @"queryParams":@{@"json_data_id":@"Promotions"}};
    
    
    /*
     {"queryName":"framework_json_data","queryParams":{"json_data_group":"Screens"}}
     */
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Promotions ..."];

    [preloginapiwrapper loadPreLoginDataForParameterType:argumentsDic success:^(NSDictionary *_userInfo){
        //NSLog(@"_userInfo %@",_userInfo);
        [[LeveyHUD sharedHUD] disappear];

        self.prmotionBannersArray = [(NSMutableArray *)[[[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"] objectAtIndex:0] valueForKey:@"Json_Data"] valueForKey:@"Banners"];
        
        [self imagesUrl:self.prmotionBannersArray];
        
//        [self.promotionsTableview reloadData];

        
        
    }failure:^(NSError *error) {
        [[LeveyHUD sharedHUD] disappear];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error Code:%ld", (long)error.code] message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }];
}

- (void)imagesUrl:(NSMutableArray *)bannersArray
{
    for (int i = 0; i < [self.prmotionBannersArray count] ; i++) {
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",kDownLoadedBaseCMSUrl,[[self.prmotionBannersArray valueForKey:@"Image"] objectAtIndex:i]];
        if ([urlString length]!=0)
        {
//            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 2);
//                 dispatch_async(queue, ^{
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
            NSURLResponse* response = nil;
            NSError* error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            // update the image and sent notification on the main thread
            self.imageData = [UIImage imageWithData:data];
            if (self.imageData){
                [self.imagesArray addObject:self.imageData];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.promotionsTableview reloadData];
                
            });
            
           // });
        }
        
        
        

        
        
        
    }
    
    
}


#pragma mark - Private API -

- (IBAction)backToHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showCalendar:(id)sender
{
    
    _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select time" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    _pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
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
    
    if(_datePicker)
    {
        _datePicker=nil;
    }
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, 320, 260)];
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
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    //    NSString *str = [dateFormatter stringFromDate:self.datePicker.date];
    [self.actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}
-(void)datecancelbuttonClicked:(id) sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark - DataSources

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    
    return [self.imagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
      SPPromotionTableCell *customPromotionsCell = [tableView dequeueReusableCellWithIdentifier:kcustomPromotionCellIdentifier];
    
    customPromotionsCell.selectionStyle =UITableViewCellSelectionStyleNone;
    //customPromotionsCell.promotionImage.image = self.imageData;

    NSLog(@"self.imagesArray %@",self.imagesArray);
    [customPromotionsCell.promotionImage setImage:[self.imagesArray objectAtIndex:indexPath.row]];

    
   
    return customPromotionsCell;
}
#pragma mark --
#pragma mark -- Table view delegate

-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.prmotionBannersArray count] > 0) {
        SPPromotionDetailViewController *detailView = [[SPPromotionDetailViewController alloc] initWithNibName:@"SPPromotionDetailViewController" bundle:nil];
        
        detailView.promationTitle = [[self.prmotionBannersArray objectAtIndex:indexPath.row] valueForKey:@"Name"];
        detailView.promationDescription = [[self.prmotionBannersArray objectAtIndex:indexPath.row]valueForKey:@"Description"];
        detailView.selectImage = [self.imagesArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailView animated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    UIImage *heightImage = [self.imagesArray objectAtIndex:indexPath.row];
    
    return heightImage.size.height/2+4;

}


@end
