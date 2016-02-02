//
//  SPRedeemViewController.m
//  WarHorse
//
//  Created by Ramya on 1/24/14.
//  Copyright (c) 2014 Zytrix Labs. All rights reserved.
//

#import "SPRedeemViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLAPIWrapper.h"
#import "ZLAppDelegate.h"
#import "ZUUIRevealController.h"
#import "LeveyHUD.h"
#import "WarHorseSingleton.h"

@interface SPRedeemViewController ()

@property (strong, nonatomic) IBOutlet UITextField *amountTxtFld;
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGestureRecognize;
@property (strong, nonatomic) IBOutlet UILabel *subHeaderTitle;

@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *amountRedemptionLbl;
@property (strong, nonatomic) IBOutlet UILabel *sucessullLbl;
@property (strong, nonatomic) IBOutlet UILabel *redeemLabel;

@property (strong, nonatomic) IBOutlet UIButton *homeBtnClicked;
@property (strong,nonatomic) NSString *rewardsAvailableBalance;
@property (nonatomic, assign) BOOL isRedeemCalculated;
@property (nonatomic, strong) IBOutlet UILabel *rewardsLabel;

@property (nonatomic,strong) IBOutlet UIButton *redeemBtn;
@property (nonatomic,strong) IBOutlet UIButton *submitBtn;

- (IBAction)homeClicked:(id)sender;
- (IBAction)myBetsClicked:(id)sender;
- (IBAction)submitBtnClicked:(id)sender;
- (IBAction)wagerClicked:(id)sender;



@end

@implementation SPRedeemViewController
@synthesize isWalletView;

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

    if ([isWalletView isEqualToString:@"Yes"]){
        self.homeBtnClicked.hidden = NO;
    }else{
        self.homeBtnClicked.hidden = YES;

    }
    self.isRedeemCalculated = NO;
    //
    //[self prepareTopView];

    // Do any additional setup after loading the view from its nib.
     self.navigationController.navigationBarHidden = YES;
    NSString *placeHoder = [NSString stringWithFormat:@"%@0.00",[[WarHorseSingleton sharedInstance] currencySymbel]];
    self.amountTxtFld.placeholder = placeHoder;
    [self.amountTxtFld.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.amountTxtFld.layer setBorderWidth:1.0];
    
    [self.amountRedemptionLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    
    [self.submitBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    [self.rewardsLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.subHeaderTitle setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];

    
    [self.label1 setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    //
    NSString *text = [NSString stringWithFormat:@"%@1 = 400 Points redemption\n(Minimum amount for conversion is %@10) ",[[WarHorseSingleton sharedInstance] currencySymbel],[[WarHorseSingleton sharedInstance] currencySymbel]];
    [self.label1 setText:text];
    [self.sucessullLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    
    [self.redeemLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];

    
    self.singleTapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    self.singleTapGestureRecognize.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTapGestureRecognize];
    
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.amountTxtFld.leftView = paddingView;
    self.amountTxtFld.rightView = paddingView;
    self.amountTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.amountTxtFld.rightViewMode = UITextFieldViewModeAlways;
    
    
    
    [self prepareTopView];
    
 
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    [self rewardsPontsCheekingCall];

}


- (void)prepareTopView
{

    UIButton *backButton = [[UIButton alloc] init];
    [backButton setFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"toggle.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    backButton = nil;
    
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

- (void)balanceUpdated:(NSNotification *)notification
{
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    
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



- (void)resignKeyBoard
{
    [self.amountTxtFld resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)rewardsPontsCheekingCall
{
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    
    
    [[LeveyHUD sharedHUD] appearWithText:@"Reward Points Loading..."];
    
    [apiWrapper getCurrentBalanceForAccount:nil success:^(NSDictionary *_userInfo)
     {
         [[LeveyHUD sharedHUD] disappear];
         NSString *succesMes = [_userInfo valueForKey:@"response-status"];
         if ([succesMes isEqualToString:@"success"]){
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 self.rewardsAvailableBalance =[NSString stringWithFormat:@"%@",[[_userInfo valueForKey:@"response-content"]valueForKey:@"rewards_available_balance"]];
                 
                 if ([self.rewardsAvailableBalance isEqualToString:@"(null)"])
                 {
                     self.rewardsLabel.text =@"-";
                 }else{
                     self.rewardsLabel.text = [NSString stringWithFormat:@"Available Points:%@",self.rewardsAvailableBalance];
                 }
                 
                 
             });
         }else{
             [[LeveyHUD sharedHUD] disappear];

             //             amountLabel.text = @"$0.00";
             //             onHoldAmountLbl.text = @"$0.00";
             //             rewardAmountLbl.text = @"0";
             //             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"The server could not process your request at this time,please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             //             [alert show];
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



- (IBAction)submitBtnClicked:(id)sender
{
    
    [self.amountTxtFld resignFirstResponder];
    
    
    pointsInt = [self.amountTxtFld.text intValue];
    
    
    if ([self.rewardsAvailableBalance intValue] > (pointsInt * 400)) {
        
        pointsInt = [self.amountTxtFld.text intValue];
        
        if (pointsInt<10){
            
            NSString *title = [NSString stringWithFormat:@"Minimum amount for converstion is %@10",[[WarHorseSingleton sharedInstance] currencySymbel]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information!" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        pointsInt = pointsInt*400;
        NSString *str = [NSString stringWithFormat:@"%d Points will be Redeemed.",pointsInt];
        self.sucessullLbl.text = str;
        
        
        self.redeemBtn.enabled = NO;
        self.isRedeemCalculated = NO;
        [self.amountTxtFld resignFirstResponder];
        ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
        NSDictionary *argumentsDict = @{@"amount": self.amountTxtFld.text};
        //WH-210
        
        
        [[LeveyHUD sharedHUD] appearWithText:@"Loading..."];
        
        [apiWrapper redeemRewardsServiceCall:argumentsDict success:^(NSDictionary *userInfo)
         {
             NSLog(@"userInfo %@",userInfo);
             [[LeveyHUD sharedHUD] disappear];
             if ([[userInfo valueForKey:@"response-status"] isEqualToString:@"success"])
             {
                 //NSString *mesAlert = [[userInfo valueForKey:@"response-content"] valueForKey:@"Reward Points Cost"];
//                 NSString *mes = [NSString stringWithFormat:@"$%@.00 worth %d points shall be credited to your account.",self.amountTxtFld.text,pointsInt];
                 NSString *mes = [NSString stringWithFormat:@"Credited %d points of %@%@.00 worth credited to your account",pointsInt,[[WarHorseSingleton sharedInstance] currencySymbel],self.amountTxtFld.text];

                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success" message:mes delegate:self cancelButtonTitle:@"CONTINUE" otherButtonTitles:nil];
                 [alert show];
                 
                 self.amountTxtFld.text = @"";
                 
             }else{
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Information" message:@"The server could not process your request at this time, please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
             //$12 worth x.xx points shall be credited to your account
             
         }failure:^(NSError *error){
             [[LeveyHUD sharedHUD] disappear];

             NSLog(@"error %@",error);
         }];
        
        

    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You don't have enough reward points." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
    
}


- (IBAction)homeClicked:(id)sender
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardHome]forKey:@"viewNumber"]];
}

- (IBAction)myBetsClicked:(id)sender
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardMyBets]forKey:@"viewNumber"]];
}

- (IBAction)wagerClicked:(id)sender
{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardWager]forKey:@"viewNumber"]];
}
- (IBAction)backBtnClicked:(id)sender
{
    
    NSLog(@"ViewControllers = %@", [self.navigationController viewControllers]);

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----
#pragma alert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}





@end
