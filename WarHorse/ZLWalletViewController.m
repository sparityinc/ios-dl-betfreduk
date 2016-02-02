//
//  ZLWalletViewController.m
//  WarHorse
//
//  Created by Sparity on 18/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLWalletViewController.h"
#import "ZLAddFundsViewController.h"
#import "ZUUIRevealController.h"
#import "SPWalletViewAllViewController.h"
#import "ZLAppDelegate.h"
#import "ZLAPIWrapper.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"
#import "SPWithDrawalViewController.h"
#import "ZLQRCodeViewController.h"
#import "SPRedeemViewController.h"
#import "SPOndayPassVC.h"
#import "SPDepositVC.h"


#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@interface ZLWalletViewController ()
{
    
}
@property (strong, nonatomic) IBOutlet UIButton *toggleButton;
@property (strong, nonatomic) IBOutlet UIButton *redeemBtn;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSString *ontAndCplHeaderStr;
@property (weak, nonatomic) IBOutlet UIImageView *firstVerticalImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondVerticalImg;
@property (weak,nonatomic) IBOutlet UILabel *rewardsBackGrdLbl;
@property (weak,nonatomic) IBOutlet UILabel *balanceBackGrdLbl;
@property (weak,nonatomic) IBOutlet UILabel *onHoldBackGrdLbl;


@end

@implementation ZLWalletViewController


@synthesize balanceLabel;
@synthesize amountLabel;
@synthesize AddFundsBtn;
@synthesize withDrawalBtn;
@synthesize accountActivityLabel;
@synthesize viewBtn;

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
    
    objectArray = [[NSMutableArray alloc] init];
    
    [balanceLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [amountLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    //amountLabel.text = @"Loading..";
    
    [rewardPointsLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [rewardAmountLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    
    [self.redeemBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    [onHoldLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [onHoldAmountLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    [rewardAmountLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    
    [accountActivityLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:18]];
    accountActivityLabel.textColor = [UIColor colorWithRed:30.0/255.0 green:(30.0/255.0) blue:30.0/255.0 alpha:1.0];
    
    [AddFundsBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:16]];
    [withDrawalBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:16]];
    [redeemButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:16]];
    
    [viewBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    
    [self prepareTopView];
    
    

    
    self.accountActivityArry = [[NSMutableArray alloc]initWithCapacity:0];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, 100, 21)];
    [title setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [title setTextColor:[UIColor whiteColor]];
    [title setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:title];
    
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
        [title setText:@"Wallet"];
        self.redeemBtn.hidden = NO;

        self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        self.userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        self.AddFundsBtn.hidden = NO;
        self.firstVerticalImg.hidden = NO;

        if ([[[WarHorseSingleton sharedInstance] isAdwFundingEnable] isEqualToString:@"false"]){
            [self fundingDisableAction];
            
        }
        if([[WarHorseSingleton sharedInstance] isRewordsEnable] == NO){
            [self setRedeemFrames];

        }
    }else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ODP"]){
        
        [title setText:@"Wallet"];
        self.ontAndCplHeaderStr = @"Oneday Pass Account";
        rewardPointsLbl.text = @"Rewards ID";
        
        [self setRedeemFrames];

        self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccountID"];
        self.userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPin"];
        if([[[WarHorseSingleton sharedInstance] isOntFundingEnable] isEqualToString:@"false"]){
            [self fundingDisableAction];
        }else{
            self.AddFundsBtn.hidden = NO;
        }
    }else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"DV"]){
        [title setText:@"Digital Voucher"];
        rewardPointsLbl.text = @"Rewards ID";
        [self setRedeemFrames];

        self.ontAndCplHeaderStr = @"Digital Voucher Account";
        self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CplUserName"];
        self.userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"CplUserName"];
        
        if([[[WarHorseSingleton sharedInstance] isCplFundingEnable] isEqualToString:@"false"]){
            [self fundingDisableAction];
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceUpdated:) name:@"BalanceUpdated" object:nil];
    
}

- (void)setRedeemFrames
{
    self.redeemBtn.hidden = YES;
    self.firstVerticalImg.hidden = NO;
    self.secondVerticalImg.hidden = YES;
    
    // Reward ID and Player id hiden in ODP Users
    self.rewardsBackGrdLbl.hidden = YES;
    rewardAmountLbl.hidden = YES;
    rewardPointsLbl.hidden = YES;
    
    
    self.firstVerticalImg.frame = CGRectMake(160, self.firstVerticalImg.frame.origin.y, self.firstVerticalImg.frame.size.width, self.firstVerticalImg.frame.size.height);
    self.AddFundsBtn.frame = CGRectMake(self.AddFundsBtn.frame.origin.x, self.AddFundsBtn.frame.origin.y, 150, 40);

    self.withDrawalBtn.frame = CGRectMake(150, self.withDrawalBtn.frame.origin.y, 150, 40);

    
    self.balanceLabel.frame = CGRectMake(self.balanceLabel.frame.origin.x, self.balanceLabel.frame.origin.y+10, self.balanceLabel.frame.size.width, self.balanceLabel.frame.size.height);
    onHoldLbl.frame = CGRectMake(onHoldLbl.frame.origin.x, onHoldLbl.frame.origin.y+20, onHoldLbl.frame.size.width, onHoldLbl.frame.size.height);
    
    self.amountLabel.frame = CGRectMake(self.amountLabel.frame.origin.x, self.amountLabel.frame.origin.y+10, self.amountLabel.frame.size.width, self.amountLabel.frame.size.height);
    
    onHoldAmountLbl.frame = CGRectMake(onHoldAmountLbl.frame.origin.x, onHoldAmountLbl.frame.origin.y+20, onHoldAmountLbl.frame.size.width, self.amountLabel.frame.size.height);
    
    self.balanceBackGrdLbl.frame = CGRectMake(self.balanceBackGrdLbl.frame.origin.x, self.balanceBackGrdLbl.frame.origin.y+10, self.balanceBackGrdLbl.frame.size.width, self.balanceBackGrdLbl.frame.size.height);
    
    self.onHoldBackGrdLbl.frame = CGRectMake(self.onHoldBackGrdLbl.frame.origin.x, self.onHoldBackGrdLbl.frame.origin.y+20, self.onHoldBackGrdLbl.frame.size.width, self.onHoldBackGrdLbl.frame.size.height);
    
    
}

- (void)fundingDisableAction
{
    self.AddFundsBtn.hidden = YES;
    self.firstVerticalImg.hidden = YES;
    self.secondVerticalImg.hidden = YES;
    self.AddFundsBtn.frame = CGRectMake(self.AddFundsBtn.frame.origin.x, self.AddFundsBtn.frame.origin.y, 150, 40);

    self.withDrawalBtn.frame = CGRectMake(0, self.withDrawalBtn.frame.origin.y, 300, 40);

    self.redeemBtn.enabled = NO;
    self.redeemBtn.userInteractionEnabled = NO;
    [self.redeemBtn.titleLabel setTextColor:[UIColor colorWithRed:83/255.0 green:147/255.0 blue:244/255.0 alpha:1.0]];
}


- (void)viewWillAppear:(BOOL)animated
{
    //[self performSelector:@selector(getUserBalance) withObject:nil afterDelay:1.0];
    [self getUserBalance];
    
    pageSize = 20;
    indexPage = 0;
    
    page = 1;
    self.walletTableView.contentOffset = CGPointMake(0, 0);
    //[self getUserTranstionActivity];
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    
    [self performSelector:@selector(getUserTranstionActivity) withObject:nil afterDelay:1.0];
    [super viewWillAppear:YES];
    
}

- (IBAction)refreshClicked:(id)sender{
    
    [[LeveyHUD sharedHUD] appearWithText:@"Refreshing Account Activity..."];
    objectArray = [[NSMutableArray alloc] init];
    pageSize = 20;
    indexPage = 0;
    page = 1;
    [self getUserTranstionActivity];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[LeveyHUD sharedHUD] disappear];
    [super viewWillDisappear:YES];
}

-(void)balanceUpdated:(NSNotification *)notification
{
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    
}

- (void)internetChecking
{
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
}
- (void)getUserBalance
{
    [self internetChecking];
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    [apiWrapper getCurrentBalanceForAccount:nil success:^(NSDictionary *_userInfo)
     {
         [[LeveyHUD sharedHUD] disappear];
         NSString *succesMes = [_userInfo valueForKey:@"response-status"];
         if ([succesMes isEqualToString:@"success"]){
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"response %@",_userInfo);

                 NSString *amountStr = [NSString stringWithFormat:@"%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],([[[_userInfo valueForKey:@"response-content"]valueForKey:@"available_balance"] doubleValue]) / 100.0];
                 
                 NSString *onHoldAmountStr = [NSString stringWithFormat:@"%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],([[[_userInfo valueForKey:@"response-content"]valueForKey:@"hold_balance"] doubleValue]) / 100.0];
                 
                 NSString *rewardsAvailableBalance =[NSString stringWithFormat:@"%@",[[_userInfo valueForKey:@"response-content"]valueForKey:@"rewards_available_balance"]];
                 
                 //NSLog(@"onHoldAmountStr %@",onHoldAmountStr);
                 NSString *rewardsID =[[_userInfo valueForKey:@"response-content"]valueForKey:@"playerID"];
                 NSLog(@"rewardsID %@",rewardsID);
                 onHoldAmountLbl.text = onHoldAmountStr;
                 amountLabel.text = amountStr;
                 
                 if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
                     if ([rewardsAvailableBalance isEqualToString:@"(null)"]){
                         rewardAmountLbl.text = @"-";
                     }else{
                         rewardAmountLbl.text = rewardsAvailableBalance;
                     }
                 }else{
                     if (!rewardsID.length){
                         rewardAmountLbl.text =@"--";
                     }else{
                     rewardAmountLbl.text =rewardsID;
                     }
                 }
                 
                 
             });
         }else{
             amountLabel.text = @"$0.00";
             onHoldAmountLbl.text = @"$0.00";
             rewardAmountLbl.text = @"0";
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"The server could not process your request at this time, please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
         
         
         
     }failure:^(NSError *error)
     {
         [[LeveyHUD sharedHUD] disappear];
         dispatch_async(dispatch_get_main_queue(), ^{
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error Code:%ld", (long)error.code] message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             
             
         });
         
     }];
}

- (void)getUserTranstionActivity
{
    [self pageNumber];
    
    [self internetChecking];
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    
    NSString *pageIndexstring = [NSString stringWithFormat:@"%d",indexPage];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Wallet..."];
    
    NSDictionary *userDetailsDict;
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ODP"]){
        userDetailsDict = [NSDictionary dictionaryWithObjectsAndKeys:self.userName,@"user_id",self.userPassword,@"user_password",@"20",@"pageSize",pageIndexstring,@"startIndex", nil];
        
    }else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
        userDetailsDict = [NSDictionary dictionaryWithObjectsAndKeys:self.userName,@"account_id",self.userPassword,@"user_pin",@"20",@"pageSize",pageIndexstring,@"startIndex", nil];
        
        
    }else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"DV"]){
        userDetailsDict = [NSDictionary dictionaryWithObjectsAndKeys:self.userName,@"account_id",self.userPassword,@"user_pin",@"20",@"pageSize",pageIndexstring,@"startIndex", nil];
    }
    
    [apiWrapper getAcountActivityDetails:userDetailsDict success:^(NSDictionary *_userInfo)
     {
         [[LeveyHUD sharedHUD] disappear];
         dispatch_async(dispatch_get_main_queue(), ^{
             
             
             NSString *successStr = [_userInfo valueForKey:@"response-status"];
             if ([successStr isEqualToString:@"success"]) {
                 
                 if ([[WarHorseSingleton sharedInstance] isWithDrawalSuccess] == YES) {
                     
                     //NSLog(@"%s %d", __FUNCTION__, [[WarHorseSingleton sharedInstance] isWithDrawalSuccess]);
                     [self getUserBalance];
                 }
                 else {
                     //NSLog(@"%s %d", __FUNCTION__, [[WarHorseSingleton sharedInstance] isWithDrawalSuccess]);
                     
                     [[WarHorseSingleton sharedInstance] setIsWithDrawalSuccess:NO];
                 }
                 
                 NSString *str;
                 objectArray = [_userInfo valueForKey:@"response-content"];
                 if (objectArray.count>0){
                     str = [NSString stringWithFormat:@"%@",[objectArray objectAtIndex:0]];
                     
                 }
                 if ([str isEqualToString:@"<null>"]||[objectArray count]==0){
                     [activityIndicator stopAnimating];
                     loadMoreLabel.text =@"No More Activity";
                     return ;
                     
                 }else{
                     [self.accountActivityArry addObjectsFromArray:objectArray];
                     [self.walletTableView reloadData];
                 }
                 
             }else{
                 [[LeveyHUD sharedHUD] disappear];
                 //NSLog(@"The server could not process your request at this time, please try later");
             }
             
         });
         
         
     }failure:^(NSError *error)
     {
         [[LeveyHUD sharedHUD] disappear];
         dispatch_async(dispatch_get_main_queue(), ^{
             [[LeveyHUD sharedHUD] disappear];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error Code:%ld", error.code] message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             
             
         });
     }];
    
}


// First 20 objects loading here and next 20 objects server hits
- (void)loadMore:(NSIndexPath *)indexPath
{
    if ([objectArray count] < 20 ) {
        loadMoreLabel.text =@"No More Activity";
        [activityIndicator stopAnimating];
        return;
    }
    
    //you just increment page every time ,, page  =  page +1
    indexPage = page*20;
    //NSLog(@"Page index is %d",indexPage);
    page = page + 1;
    //NSLog(@"Page index is incremented %d",page);
    [self getUserTranstionActivity];
    
}

// if page count is equal to 1 then to remove all objects in array
- (void)pageNumber
{
    if (indexPage == 0) {
        [self.accountActivityArry removeAllObjects];
        return;
    }
}


- (IBAction)wagerButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardWager]forKey:@"viewNumber"]];
}


- (void)prepareTopView
{
    
    [self.toggleButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.amountButton = [[UIButton alloc] initWithFrame:CGRectMake(276, 20, 44, 44)];
    if ([[[WarHorseSingleton sharedInstance] localCountry] isEqualToString:@"en_UK"]){
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"pound.png"] forState:UIControlStateNormal];

    }else{
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"symbol.png"] forState:UIControlStateNormal];
  
    }
    
    [self.amountButton setBackgroundImage:[UIImage imageNamed:@"balancebg@2x.png"] forState:UIControlStateSelected];
    [self.amountButton setTitle:@"" forState:UIControlStateNormal];
    
    
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    [self.amountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.amountButton.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.amountButton addTarget:self action:@selector(amountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.amountButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceUpdated:) name:@"BalanceUpdated" object:nil];
    
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
            [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
            //amountLabel.text = [NSString stringWithFormat:@"$%0.2f",[ZLAppDelegate getAppData].balanceAmount];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
        }failure:^(NSError *error){
        }];
        
        [self.amountButton setSelected:YES];
        [self.amountButton setFrame:CGRectMake(237, 20, 71, 44)];
    }
}

- (void)timerMethod:(NSTimer *)timer
{
    if ([self.amountButton isSelected]) {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(272, 20, 44, 44)];
    }
}


- (IBAction)viewClicked:(id)sender
{
    SPWalletViewAllViewController *walletViewAll = [[SPWalletViewAllViewController alloc]initWithNibName:@"SPWalletViewAllViewController" bundle:nil];
    [self.navigationController pushViewController:walletViewAll animated:YES];
    
    
}

- (IBAction)addFundsClicked:(id)sender
{
//    SPDepositVC *depositVC = [[SPDepositVC alloc] init];
//    [self.navigationController pushViewController:depositVC animated:YES];
//    return;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"achEnableKey"] boolValue] == NO && [[[NSUserDefaults standardUserDefaults] objectForKey:@"cardEnabledKey"] boolValue] == NO) {
        NSString *alertMes;
        if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
            alertMes = @"The server could not process your request at this time, please try later";
        }else{
            alertMes = @"This feature only for ADW users only";

        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information!" message:alertMes delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];

    }else{
        SPDepositVC *depositVC = [[SPDepositVC alloc] init];
        [self.navigationController pushViewController:depositVC animated:YES];
        
//        ZLAddFundsViewController *addFundsViewController=[[ZLAddFundsViewController alloc]init];
//        [self.navigationController pushViewController:addFundsViewController animated:YES];
    }

    
    
    
}
- (IBAction)withDrawalClicked:(id)sender
{
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
        SPWithDrawalViewController *withdrawalViewController = [[SPWithDrawalViewController alloc]initWithNibName:@"SPWithDrawalViewController" bundle:nil];
        [self.navigationController pushViewController:withdrawalViewController animated:YES];
    }else{
        ZLQRCodeViewController *qrcodeViewController = [[ZLQRCodeViewController alloc] initWithNibName:@"ZLQRCodeViewController" bundle:nil];
        qrcodeViewController.actionStr = @"withdraw";
        [self.navigationController pushViewController:qrcodeViewController animated:YES];
        /*
        SPQRCodeTypesViewController *qrCodeView = [[SPQRCodeTypesViewController alloc]initWithNibName:@"SPQRCodeTypesViewController" bundle:nil];
        qrCodeView.isWalletScreen = @"Yes";
        [self.navigationController pushViewController:qrCodeView animated:YES];*/
        
    }
    
}

- (IBAction)redeemPointsClicked:(id)sender
{
    SPRedeemViewController *redeemViewCntr = [[SPRedeemViewController alloc] initWithNibName:@"SPRedeemViewController" bundle:nil];
    redeemViewCntr.isWalletView = @"Yes";
    [self.navigationController pushViewController:redeemViewCntr animated:YES];
    
}


- (IBAction)goToHome:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardHome]forKey:@"viewNumber"]];
}

- (IBAction)goToMyBets:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardMyBets]forKey:@"viewNumber"]];
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
    
    // Return the number of rows in the section.return [activityArray count]+1;
    return [self.accountActivityArry count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath row] == [self.accountActivityArry count] ) {
        //loadMore cell loading in tableview
        static NSString *CellIdentifier1 = @"loadMore";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(84, 9, 32, 32)];
            activityIndicator.tag = 1002;
            [cell.contentView addSubview:activityIndicator];
            
            loadMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 10, 304, 30)];
            loadMoreLabel.tag = 1001;
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:(153.0/255.0) green:(153.0/255.0) blue:(153.0/255.0) alpha:0]];
            
            [loadMoreLabel setTextColor:[UIColor grayColor]];
            [loadMoreLabel setHighlightedTextColor:[UIColor lightGrayColor]];
            [loadMoreLabel setTextAlignment:NSTextAlignmentCenter];
            [loadMoreLabel setBackgroundColor:[UIColor colorWithRed:(153.0/255.0) green:(153.0/255.0) blue:(153.0/255.0) alpha:0]];
            [loadMoreLabel setFont:[UIFont fontWithName:@"Gotham" size:15]];
            
            [cell.contentView addSubview:loadMoreLabel];
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            [v setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
            [cell.contentView addSubview:v];
            
        }
        activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:1002];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        loadMoreLabel = (UILabel *)[cell.contentView viewWithTag:1001];
        if ([self.accountActivityArry count]>0)
        {
            loadMoreLabel.text = @"Loading...";
            [activityIndicator startAnimating];
        }
        
        
        if ([objectArray count] == indexPath.row) {
            
            cell.userInteractionEnabled = NO;
        }
        if ([self.accountActivityArry count]){
            [self loadMore:indexPath];
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    self.walletCustomCell  = (ZLWalletCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    self.walletCustomCell.backgroundColor = [UIColor redColor];
    if (self.walletCustomCell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ZLWalletCustomCell" owner:self options:nil];
        UIImageView *lineImg =[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300,1)] ;
        lineImg.tag = 202;
        [self.walletCustomCell.contentView addSubview:lineImg];
        
    }
    
    
    self.walletCustomCell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *lineImg =(UIImageView *)[self.walletCustomCell.contentView viewWithTag:202];
    lineImg.image = [UIImage imageNamed:@"line.png"];
    
    [self.walletCustomCell.dateLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.walletCustomCell.cashLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self.walletCustomCell.titleLable setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.walletCustomCell.detailLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.walletCustomCell.amountLable setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self.walletCustomCell.titleLable setNumberOfLines:2];
    [self.walletCustomCell.dateLabel setNumberOfLines:2];
    //differentiate between Cash and BETS
    NSString *cashStr;
    if ([self.accountActivityArry count]>0){
        NSMutableDictionary *dic = [self.accountActivityArry objectAtIndex:indexPath.row];
        
        NSString *transactionType = [dic valueForKey:@"transactionType"];
        [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:153.0/255.0f blue:188.0/255.0f alpha:1.0]];
        NSString *creditAmount;
        if ([[dic valueForKey:@"betType"] isKindOfClass:[NSString class]]){
            //This is BetType
            [self.walletCustomCell.detailLabel setHidden:NO];
            cashStr = @"BETS";
            if ([transactionType isEqualToString:@"Ticket Sell"]){
                //NSLog(@"Ticket Sell");
                creditAmount = [NSString stringWithFormat:@"-%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"debit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor redColor]];
                
            }else if ([transactionType isEqualToString:@"Ticket Cancel Sell"]){
                //NSLog(@"Ticket Cancel Sell");
                creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                cashStr = @"CNCL";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:183.0/255.0f green:0.0/255.0f blue:164.0/255.0f alpha:1.0]];
            }else{
                
            }
            
            
            NSString * amount = [dic valueForKey:@"betAmount"];
            double amt = 0.0;
            if( amount != nil){
                amt = [amount floatValue];
            }
            
            NSString *betTypeAndRaceStr = [NSString stringWithFormat:@"Race %@ - %@ - %@%.02f",[dic valueForKey:@"race"],[dic valueForKey:@"betType"],[[WarHorseSingleton sharedInstance] currencySymbel],amt];
            [self.walletCustomCell.detailLabel setText:betTypeAndRaceStr];
            [self.walletCustomCell.detailLabel setTextColor:[UIColor colorWithRed:136.0/255 green:136.0/255 blue:136.0/255 alpha:1.0]];
            
        }else{
            
            // ach,withdraw,cash deposit,refunds
            if ([transactionType isEqualToString:@"Withdrawal"]){
                //NSLog(@"Withdrawal");
                creditAmount = [NSString stringWithFormat:@"-%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"debit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor redColor]];
                cashStr= @"WD";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:226.0/255.0f green:84.0/255.0f blue:48.0/255.0f alpha:1.0]];
                
            }else if ([transactionType isEqualToString:@"Withdrawal Cancel"]){
                creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                cashStr= @"WD";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:226.0/255.0f green:84.0/255.0f blue:48.0/255.0f alpha:1.0]];
            }
            
            else if ([transactionType isEqualToString:@"Cash Deposit "]){
                creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                cashStr= @"CASH";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:3.0/255.0f green:166.0/255.0f blue:45.0/255.0f alpha:1.0]];
                
            }else if ([transactionType isEqualToString:@"Check Deposit Pending "]){
                creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                cashStr= @"CASH";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:3.0/255.0f green:166.0/255.0f blue:45.0/255.0f alpha:1.0]];
            }
            //Deposit
            else if ([transactionType isEqualToString:@"Deposit "])
            {
                creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                cashStr= @"CASH";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:3.0/255.0f green:166.0/255.0f blue:45.0/255.0f alpha:1.0]];
            }
            else if ([transactionType isEqualToString:@"ACH Deposit "]||[transactionType isEqualToString:@"ACH Deposit Cleared"])
            {
                creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                cashStr= @"ACH";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:95.0/255.0f blue:25.0/255.0f alpha:1.0]];
            }else if ([transactionType isEqualToString:@"ACH Deposit Pending "])
            {
                //creditAmount = [NSString stringWithFormat:@"$%.02f",[[dic valueForKey:@"credit"] floatValue]];
                //[self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                cashStr= @"ACH";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:95.0/255.0f blue:25.0/255.0f alpha:1.0]];
            }
            
            else if ([transactionType isEqualToString:@"Refund"])
            {
                creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                cashStr= @"RFND";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:71.0/255.0f blue:185.0/255.0f alpha:1.0]];
            }
            
            
            //Balance Adjustment
            else if ([transactionType isEqualToString:@"Balance Adjustment"])
            {
                if (![[dic valueForKey:@"debit"]isEqualToString:@"0.0"])   {
                    creditAmount = [NSString stringWithFormat:@"-%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"debit"] floatValue]];
                    [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:178.0/255.0f green:0.0/255.0f blue:36.0/255.0f alpha:1.0]];
                    
                }
                else if (![[dic valueForKey:@"credit"]isEqualToString:@"0.0"])   {
                    creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                    [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                    
                }
                else{
                    creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                    [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                }
                // [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                
                cashStr= @"ADJ";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:106.0/255.0f green:0.0/255.0f blue:150.0/255.0f alpha:1.0]];
            }
            

            
            else if ([transactionType isEqualToString:@"Winning Ticket"]){
                
                
                //Winning Ticket;
                creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                cashStr= @"WINS";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:8.0/255.0f green:0.0/255.0f blue:119.0/255.0f alpha:1.0]];
            }else if ([transactionType isEqualToString:@"Reward Deposit "]){
                
                
                //NSLog(@"Reward Deposit");
                creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                cashStr= @"RWD";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:244.0/255.0f green:65.0/255.0f blue:10.0/255.0f alpha:1.0]];
            }
            //Deposit Pending
            else if ([transactionType isEqualToString:@"Deposit Pending "])
            {
                creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                cashStr= @"ACH";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:95.0/255.0f blue:25.0/255.0f alpha:1.0]];
            }
            //Deposit Pending Cleared which deposit pending
            
            else if ([transactionType isEqualToString:@"Status Changed"])
            {
                creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                cashStr= @"ASC";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:94.0/255.0f green:10.0/255.0f blue:8.0/255.0f alpha:1.0]];
            }else if ([transactionType isEqualToString:@"Winner IRS Hold"]||[transactionType isEqualToString:@"Winner IRS Clear"])
            {
                creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:60.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
                cashStr= @"IRS";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:174.0/256 green:114.0/256 blue:0.0/256 alpha:1.0]];
            }
            
            else{
                creditAmount = [NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[[dic valueForKey:@"credit"] floatValue]];
                [self.walletCustomCell.amountLable setTextColor:[UIColor colorWithRed:178.0/255.0f green:0.0/255.0f blue:36.0/255.0f alpha:1.0]];
                cashStr= @"UNK";
                [self.walletCustomCell.cashLabel setBackgroundColor:[UIColor colorWithRed:56.0/255.0f green:88.0/255.0f blue:149.0/255.0f alpha:1.0]];
            }
            
            
            [self.walletCustomCell.titleLable setFrame:CGRectMake(96, 1, 163, 42)];
            [self.walletCustomCell.titleLable setNumberOfLines:2];
            
            [self.walletCustomCell.detailLabel setHidden:NO];
            
            
        }
        
        [self.walletCustomCell.amountLable setText:creditAmount];
        
        if ([[dic valueForKey:@"description"]isEqualToString:@"New Account Created"]){
            self.walletCustomCell.amountLable.hidden = YES;
            self.walletCustomCell.dateLabel.hidden = YES;
            [self.walletCustomCell.amountLable setHidden:YES];
            [self.walletCustomCell.cashLabel setHidden:YES];
            loadMoreLabel.hidden = YES;
            
        }else{
            self.walletCustomCell.amountLable.hidden = NO;
            
            self.walletCustomCell.dateLabel.hidden = NO;
            [self.walletCustomCell.amountLable setHidden:NO];
            [self.walletCustomCell.cashLabel setHidden:NO];
            
            loadMoreLabel.hidden = NO;
        }
        
        if ([[dic valueForKey:@"meetName"] isKindOfClass:[NSString class]])
        {
            [self.walletCustomCell.titleLable setText:[dic valueForKey:@"meetName"]];
            
        }else{
            NSString *description = [[dic valueForKey:@"description"] stringByReplacingOccurrencesOfString:@"{POUND}" withString:[[WarHorseSingleton sharedInstance] currencySymbel]];

            [self.walletCustomCell.titleLable setText:description];
            
        }
        
        
        //changing dates format
        NSString *dateStr = [dic valueForKey:@"toteTimestamp"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss-SS:SS"];
        
        NSDate *date = [dateFormat dateFromString:dateStr];
        NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc]init];
        [newDateFormatter setDateFormat:@"ddMMM yyyy"];
        NSString *newString = [newDateFormatter stringFromDate:date];
        [self.walletCustomCell.dateLabel setText:newString];
        [self.walletCustomCell.dateLabel setTextColor:[UIColor colorWithRed:136.0/255 green:136.0/255 blue:136.0/255 alpha:1.0]];
        
        [self.walletCustomCell.cashLabel setText:cashStr];
        [self.walletCustomCell.cashLabel setTextColor:[UIColor whiteColor]];
    }
    return self.walletCustomCell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



-(void)viewDidUnload
{
    self.amountButton=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end