//
//  SPAlertsViewController.m
//  WarHorse
//
//  Created by Veeru on 28/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "SPAlertsViewController.h"
#import "SPAlertsCell.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"

static NSString *const kcustomAlertCellIdentifier = @"customAlertCellIdentifier";
static NSString *const kcustomAlertCellNib = @"SPAlertsCell";

@interface SPAlertsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *toggleButton;
@property (retain, nonatomic) IBOutlet UITableView *alertTableView;
@property (strong,nonatomic) NSArray *alertArray;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@end

@implementation SPAlertsViewController

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
    self.navigationController.navigationBarHidden = YES;
    
     [self.alertTableView registerNib:[UINib nibWithNibName:kcustomAlertCellNib bundle:nil] forCellReuseIdentifier:kcustomAlertCellIdentifier];
    [self prepareTopView];
    [self.titleLabel setText:@"Alerts"];
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/NotificationAlert.plist",NSHomeDirectory()];
    self.alertArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    
    if ([self.alertArray count]) {
        self.noDataLabel.hidden = YES;
        self.alertTableView.hidden = NO;
    }
    else {
        self.noDataLabel.hidden = NO;
        self.alertTableView.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareTopView
{
    
    
    [self.toggleButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.amountButton = [[UIButton alloc] initWithFrame:CGRectMake(276, 20, 44, 44)];
    [self.amountButton setBackgroundImage:[UIImage imageNamed:@"symbol.png"] forState:UIControlStateNormal];
    [self.amountButton setBackgroundImage:[UIImage imageNamed:@"balancebg@2x.png"] forState:UIControlStateSelected];
    [self.amountButton setTitle:@"" forState:UIControlStateNormal];
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n$%0.2f",[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    [self.amountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.amountButton.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.amountButton addTarget:self action:@selector(amountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.amountButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceUpdated:) name:@"BalanceUpdated" object:nil];

}



- (void)balanceUpdated:(NSNotification *)notification
{
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n$%0.2f",[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    //amountLabel.text = [NSString stringWithFormat:@"$%0.2f",[ZLAppDelegate getAppData].balanceAmount];
    
}
- (void)amountButtonClicked:(id)sender
{
    if ([self.amountButton isSelected]) {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(276, 20, 44, 44)];
        
    }
    else{
        [self.amountButton setTitle:[NSString stringWithFormat:@"Loading.."] forState:UIControlStateSelected];
        
        if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [[ZLAppDelegate getApiWrapper] refreshBalance:YES success:^(NSDictionary* _userInfo){
            [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n$%0.2f",[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
        }failure:^(NSError *error){
        }];
        [self.amountButton setSelected:YES];
        [self.amountButton setFrame:CGRectMake(230, 20, 71, 44)];
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




#pragma mark -TableView Dalagate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [self.alertArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SPAlertsCell *customCell = [tableView dequeueReusableCellWithIdentifier:kcustomAlertCellIdentifier forIndexPath:indexPath];
    
    customCell.titleLabel.adjustsFontSizeToFitWidth = YES;
    customCell.titleLabel.text = [[self.alertArray valueForKey:@"alert"]objectAtIndex:indexPath.row];
    
    return customCell;
}

#pragma mark - TableView Delagate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Private API

- (IBAction)goToHome:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardHome]forKey:@"viewNumber"]];
}

- (IBAction)goToMyBets:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardMyBets]forKey:@"viewNumber"]];
}

- (IBAction)wagerButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardWager]forKey:@"viewNumber"]];
    
}
@end
