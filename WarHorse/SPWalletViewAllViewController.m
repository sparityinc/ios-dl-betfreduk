//
//  SPWalletViewAllViewController.m
//  WarHorse
//
//  Created by Ramya on 8/29/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPWalletViewAllViewController.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"

@interface SPWalletViewAllViewController ()

@end

@implementation SPWalletViewAllViewController
@synthesize walletTableView = _walletTableView;
@synthesize walletCustomCell =_walletCustomCell;
@synthesize walletArray = _walletArray;
@synthesize amountButton = _amountButton;
@synthesize accountActivityArray;
@synthesize userActivityArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.userActivityArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _walletArray = [[NSMutableArray alloc]init];
    accountActivityArray = [[NSMutableArray alloc]init];
    objectArray = [[NSMutableArray alloc] init];
    
    [self prepareTopView];
    
    [_walletTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    pageSize = 20;
    indexPage = 0;
    page = 1;

    self.walletTableView.contentOffset = CGPointMake(0, 0);
    [self getUserTranstionActivity];
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[LeveyHUD sharedHUD] disappear];
   [super viewWillDisappear:YES];
}


- (void)prepareTopView
{
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"toggle.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    backButton = nil;
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, 100, 21)];
    [title setText:@"Wallet"];
    [title setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [title setTextColor:[UIColor whiteColor]];
    [title setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:title];
    title=nil;
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 75, 200, 21)];
    [title1 setText:@"Account Activity"];
    [title1 setFont:[UIFont fontWithName:@"Roboto-Light" size:18]];
    [title1 setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0]];
    [title1 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:title1];
    title1=nil;
    
    
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

- (IBAction)refreshBtnClicked:(id)sender
{    
    [[LeveyHUD sharedHUD] appearWithText:@"Refreshing Account Activity..."];

    self.userActivityArray = [[NSMutableArray alloc] initWithCapacity:0];
    pageSize = 20;
    indexPage = 0;
    page = 1;
    [self getUserTranstionActivity];
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



- (void)getUserTranstionActivity
{
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self pageNumber];
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    NSString *userName;
    NSString *userPassword;
    NSDictionary *userDetailsDict;
    NSString *pageIndexstring = [NSString stringWithFormat:@"%d",indexPage];
    
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
        userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        
        userDetailsDict = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"account_id",userPassword,@"user_pin",@"20",@"pageSize",pageIndexstring,@"startIndex", nil];
        
    }else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ODP"]){
        userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccountID"];
        userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPin"];
        
        userDetailsDict = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"user_id",userPassword,@"user_password",@"20",@"pageSize",pageIndexstring,@"startIndex", nil];
        
    }else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"DV"]){
        userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CplUserName"];
        userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"CplUserName"];
        userDetailsDict = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"account_id",userPassword,@"user_pin",@"20",@"pageSize",pageIndexstring,@"startIndex", nil];
    }
    
    
    [[LeveyHUD sharedHUD] appearWithText:@"Refreshing Account Activity..."];
    
    [apiWrapper getAcountActivityDetails:userDetailsDict success:^(NSDictionary *_userInfo)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [[LeveyHUD sharedHUD] disappear];
             NSString *successStr = [_userInfo valueForKey:@"response-status"];
             if ([successStr isEqualToString:@"success"]){
                 
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
                     [self.userActivityArray addObjectsFromArray:objectArray];
                     [self.walletTableView reloadData];
                 }

                 
             }else{
                 [[LeveyHUD sharedHUD] disappear];
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"The server could not process your request at this time, please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
         });
         
         
     }failure:^(NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [[LeveyHUD sharedHUD] disappear];
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"The server could not process your request at this time, please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         });

     }];
    
}

// First 20 objects loading here and next 20 objects server hits
- (void)loadMore:(NSIndexPath *)indexPath
{
    //[objectArray count]!= 0
    if ([objectArray count] < 20 ) {
        loadMoreLabel.text =@"No More Activity";
        [activityIndicator stopAnimating];
        return;
    }
    
    indexPage = page*20;
    page = page + 1;
    //indexPage = indexPage + 1;
    [self getUserTranstionActivity];
    
}

// if page count is equal to 1 then to remove all objects in array
- (void)pageNumber
{
    if (indexPage == 0) {
        [self.userActivityArray removeAllObjects];
        return;
    }
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
    return [self.userActivityArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([indexPath row] == [userActivityArray count] ) {
        //loadMore cell loading in tableview
        static NSString *CellIdentifier1 = @"loadMore";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(98, 9, 32, 32)];
            activityIndicator.tag = 1002;
            [cell.contentView addSubview:activityIndicator];
            
            loadMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 30)];
            loadMoreLabel.tag = 1001;
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:(153.0/255.0) green:(153.0/255.0) blue:(153.0/255.0) alpha:0]];
            
            [loadMoreLabel setTextColor:[UIColor grayColor]];
            [loadMoreLabel setHighlightedTextColor:[UIColor lightGrayColor]];
            [loadMoreLabel setTextAlignment:NSTextAlignmentCenter];
            [loadMoreLabel setBackgroundColor:[UIColor colorWithRed:(153.0/255.0) green:(153.0/255.0) blue:(153.0/255.0) alpha:0]];
            [loadMoreLabel setFont:[UIFont fontWithName:@"Gotham" size:15]];
            
            [cell.contentView addSubview:loadMoreLabel];
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 306, 1)];
            [v setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
            [cell.contentView addSubview:v];
            
        }
        
        activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:1002];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        loadMoreLabel = (UILabel *)[cell.contentView viewWithTag:1001];
        if ([self.userActivityArray count]>0){
            loadMoreLabel.text = @"       Loading....";
            [activityIndicator startAnimating];
        }
        
        if ([objectArray count] == indexPath.row) {
            
            cell.userInteractionEnabled = NO;
        }
        if ([self.userActivityArray count]){
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
        UIImageView *lineImg =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320,1)] ;
        lineImg.tag = 202;
        [self.walletCustomCell.contentView addSubview:lineImg];
        
    }
    self.walletCustomCell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *lineImg =(UIImageView *)[self.walletCustomCell.contentView viewWithTag:202];
    lineImg.image = [UIImage imageNamed:@"line.png"];
    
    [self.walletCustomCell.dateLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.walletCustomCell.cashLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.walletCustomCell.titleLable setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.walletCustomCell.detailLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.walletCustomCell.amountLable setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.walletCustomCell.titleLable setNumberOfLines:2];
    [self.walletCustomCell.dateLabel setNumberOfLines:2];
    //differentiate between Cash and BETS
    NSString *cashStr;
    //NSMutableDictionary *dic = [self.userActivityArray objectAtIndex:indexPath.row];
    //NSString *transactionType = [dic valueForKey:@"transactionType"];
    
    //NSString *creditAmount;
    if ([self.userActivityArray count]>0){
        NSMutableDictionary *dic = [self.userActivityArray objectAtIndex:indexPath.row];
        
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

- (IBAction)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setWalletTableView:nil];
    [super viewDidUnload];
}

@end