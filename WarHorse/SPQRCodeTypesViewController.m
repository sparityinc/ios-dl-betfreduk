//
//  SPQRCodeTypesViewController.m
//  WarHorse
//
//  Created by sekhar on 25/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "SPQRCodeTypesViewController.h"
#import "ZLQRCodeViewController.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "SPConstant.h"

@interface SPQRCodeTypesViewController ()<UIGestureRecognizerDelegate>
{
    BOOL enableInfo;

}

@property (nonatomic, strong) IBOutlet UIButton *amountButton;
@property (strong, nonatomic) IBOutlet UILabel *typeOfTransactionLbl;
@property (strong, nonatomic) IBOutlet UIButton *withdrawBtn;
@property (strong, nonatomic) IBOutlet UIButton *addfundsBtn;
@property (strong, nonatomic) IBOutlet UIButton *transferBalanceBtn;
@property (nonatomic, strong) IBOutlet UIButton *toggleButton;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UIButton *backButton;

@property (strong,nonatomic) IBOutlet  UIView *infoPopView;

@property (nonatomic,weak) IBOutlet UILabel *withdrawalLbl;
@property (nonatomic,weak) IBOutlet UILabel *withdrawalDisLbl;

@property (weak, nonatomic) IBOutlet UILabel *closedLbl;
@property (weak, nonatomic) IBOutlet UILabel *closedDisLbl;
@property (nonatomic,weak) IBOutlet UILabel *terminalLbl;
@property (nonatomic,weak) IBOutlet UILabel *terminalDisLbl;
@property (nonatomic,strong) IBOutlet UIButton *infoBtn;
@property (strong, nonatomic) UITapGestureRecognizer *infoTapRecognizer;

- (IBAction)amountButtonClicked:(id)sender;

@end

@implementation SPQRCodeTypesViewController

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
    enableInfo = YES;
    [self.withdrawalLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
    [self.withdrawalDisLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.terminalLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
    [self.terminalDisLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.closedLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
    [self.closedDisLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    
    [self.navigationController setNavigationBarHidden:YES];
    if ([self.isWalletScreen isEqualToString:@"Yes"]){
        
    }else{
        self.backButton.hidden = YES;
    }
    [self prepareView];
    [self.amountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    if([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
        [self.addfundsBtn setHidden:YES];
    }else{
        [self.addfundsBtn setHidden:NO];

    }
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceUpdated:) name:@"BalanceUpdated" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)balanceUpdated:(NSNotification *)notification{
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    
}


- (IBAction)amountButtonClicked:(id)sender
{

    
    if ([self.amountButton isSelected])
    {
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
        
        [self.amountButton setFrame:CGRectMake(237, 20, 71, 44)];

        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
    }
}

- (void)timerMethod:(NSTimer *)timer
{
    if ([self.amountButton isSelected]) {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(272, 20, 45, 45)];
    }
}

- (void)prepareView;
{
    if ([[[WarHorseSingleton sharedInstance] localCountry] isEqualToString:@"en_UK"]){
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"pound.png"] forState:UIControlStateNormal];
        
    }else{
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"symbol.png"] forState:UIControlStateNormal];
        
    }
    
    [self.toggleButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleLabel setText:@"Digital Link"];
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    
    [self.typeOfTransactionLbl setText:@"Type Of Transaction"];
    [self.typeOfTransactionLbl setTextColor:[UIColor colorWithRed:30/255.0f green:30/255.0f blue:30/255.0f alpha:1.0]];
    [self.typeOfTransactionLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:20]];
    
       
    [self.withdrawBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:24]];
    [self.addfundsBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:24]];
    [self.transferBalanceBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:24]];
    
    if (IS_IPHONE5) {
        [self.withdrawBtn setFrame:CGRectMake(10, 140, 300, 80)];
        [self.transferBalanceBtn setFrame:CGRectMake(10, 230, 300, 80)];
        [self.addfundsBtn setFrame:CGRectMake(10, 320, 300, 80)];
        [self.typeOfTransactionLbl setFrame:CGRectMake(10, 85, 300, 36)];
        [self.backButton setFrame:CGRectMake(15, 81, 43, 43)];
        [self.infoBtn setFrame:CGRectMake(268, 82, 44, 44)];
        [self.infoPopView setFrame:CGRectMake(10, 117, 300, 478)];
        

    }
    
    
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    
}

- (IBAction)withdrawlBtnAction:(UIButton *)sender
{
    ZLQRCodeViewController *qrcodeViewController = [[ZLQRCodeViewController alloc] initWithNibName:@"ZLQRCodeViewController" bundle:nil];
    
    switch (sender.tag) {
            
        case 1:
        {
            qrcodeViewController.actionStr = @"withdraw";
            [self.navigationController pushViewController:qrcodeViewController animated:YES]
            ;
        }
            break;
            
            
        case 2:
        {
            qrcodeViewController.actionStr = @"transfer";
            [self.navigationController pushViewController:qrcodeViewController animated:YES];
        }
            break;
        case 3:
        {
            qrcodeViewController.actionStr = @"closedaccount";
            
            if([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Cash Out feature is available for One Day Pass users only" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                return;
                
            }
            [self.navigationController pushViewController:qrcodeViewController animated:YES];
            
        }
            break;
        default:
            break;
    }
}

- (IBAction)backView:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)wagerButtonClicked:(id)sender
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

//info button action
- (IBAction)infoBtnAction:(id)sender
{
    if([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
        self.closedLbl.hidden = YES;
        self.closedDisLbl.hidden = YES;
    }
    
    if (enableInfo == YES){
        self.infoPopView.hidden = NO;
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.infoPopView.alpha = 1;
                             //self.view.alpha = 0.3;
                         }
                         completion:^(BOOL finished){
//                             self.view.alpha = 1;

                         }];
        
        if (!self.infoTapRecognizer){
            self.infoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [self.infoPopView addGestureRecognizer:self.infoTapRecognizer];
        }
        enableInfo = NO;
        
        self.infoTapRecognizer.enabled = YES;
        
    }else{
        self.infoPopView.hidden = YES;
        
        enableInfo = YES;
        self.view.alpha = 1;
        self.infoPopView.alpha = 0;
        
    }
}
- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    // Do Your thing.
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        self.infoPopView.alpha = 0;
        self.view.alpha = 1;

        self.infoPopView.hidden = YES;
        enableInfo = YES;
        self.infoTapRecognizer.enabled = NO;
        
    }
}



@end
