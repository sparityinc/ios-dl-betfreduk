//
//  ZLRegistrationViewController.m
//  WarHorse
//
//  Created by Hiteshwar Vadlamudi on 21/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLRegistrationViewController.h"
#import "ZLAdwRegistrationViewController.h"
#import "ZLAPIWrapper.h"
#import "LeveyHUD.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "SPRegistrationVC.h"

@interface ZLRegistrationViewController ()<UIGestureRecognizerDelegate>
{
    BOOL enableInfo;
    BOOL isaNewUser;
    
}

@property (strong, nonatomic) IBOutlet UILabel *typeOfRegistrationLbl;

@property (strong, nonatomic) IBOutlet UIButton *accountBtn;
@property (strong, nonatomic) IBOutlet UIButton *oneDayPassBtn;
@property (strong, nonatomic) IBOutlet UIButton *paperLessBtn;
@property (strong,nonatomic) IBOutlet  UIView *infoPopView;
@property (weak, nonatomic) IBOutlet UILabel *adwLbl;
@property (weak, nonatomic) IBOutlet UILabel *adwDisLbl;
@property (weak, nonatomic) IBOutlet UILabel *odpLbl;
@property (weak, nonatomic) IBOutlet UILabel *odpDisLbl;

@property (assign,readwrite) BOOL isRegisterAppConfigEnable;

@property (nonatomic,strong) NSDictionary *registrationAppConfigDict;

@property (strong, nonatomic) UITapGestureRecognizer *infoTapRecognizer;

@property (strong, nonatomic) IBOutlet UIImageView *popUpBox;

@end

@implementation ZLRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - ViewLifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    enableInfo = YES;
    if ([[[WarHorseSingleton sharedInstance] isAdwEnable] isEqualToString:@"false"]){
        [self.adwLbl setHidden:YES];
        [self.adwDisLbl setHidden:YES];
        [self.odpLbl setFrame:CGRectMake(self.adwLbl.frame.origin.x, self.adwLbl.frame.origin.y, self.adwLbl.frame.size.width, self.adwLbl.frame.size.height)];
        [self.odpDisLbl setFrame:CGRectMake(self.adwDisLbl.frame.origin.x, self.adwDisLbl.frame.origin.y, self.adwDisLbl.frame.size.width, self.adwDisLbl.frame.size.height)];
        [self.popUpBox setFrame:CGRectMake(self.popUpBox.frame.origin.x, self.popUpBox.frame.origin.y, self.popUpBox.frame.size.width, 100)];
        
    }
    
    if ([[[WarHorseSingleton sharedInstance] isOntEnable] isEqualToString:@"false"]){
        [self.odpLbl setHidden:YES];
        [self.odpDisLbl setHidden:YES];
        [self.popUpBox setFrame:CGRectMake(self.popUpBox.frame.origin.x, self.popUpBox.frame.origin.y, self.popUpBox.frame.size.width, 120)];
        
    }

    
    //[self.infoPopView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"popupbox.png"]]];
    [self.typeOfRegistrationLbl setTextColor:[UIColor whiteColor]];
    [self.typeOfRegistrationLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:24]];
    [self.typeOfRegistrationLbl setLineBreakMode:NSLineBreakByWordWrapping];
    
    
    [self.adwLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
    [self.adwDisLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.odpLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
    [self.odpDisLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    
    
    [self.accountBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:20]];
    [self.oneDayPassBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:20]];
    [self.paperLessBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:20]];
    [self prepareView];
    if (!IS_IPHONE5) {
        [self.accountBtn setFrame:CGRectMake(10, 210, 300, 80)];
        [self.oneDayPassBtn setFrame:CGRectMake(10, 300, 300, 80)];
        [self.paperLessBtn setFrame:CGRectMake(10, 390, 300, 80)];
        [self.typeOfRegistrationLbl setFrame:CGRectMake(0, 165, 320, 45)];
    }
    
    if ([[[WarHorseSingleton sharedInstance] isOntEnable] isEqualToString:@"false"]){
        self.odpLbl.hidden = YES;
        self.odpDisLbl.hidden = YES;
        
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self registrationConfig];
    [super viewWillAppear:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)registrationConfig
{
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading..."];
    
    //appRegistrationsConfig
    [apiWrapper appRegistrationsConfig:nil success:^(NSDictionary *registrationInfo){
        [[LeveyHUD sharedHUD] disappear];
        
        if ([[registrationInfo valueForKey:@"response-status"] isEqualToString:@"success"]){
            self.registrationAppConfigDict = [registrationInfo valueForKey:@"response-content"];
            self.isRegisterAppConfigEnable = YES;
            
        }else{
            self.isRegisterAppConfigEnable = NO;
            
        }
        
    }failure:^(NSError *error){
        [[LeveyHUD sharedHUD] disappear];
        self.isRegisterAppConfigEnable = NO;
        [self alertViewMethod:error.description];
        
        
        
    }];
    
}

- (void)checkWhetherUserRegisteredOrNot
{
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{@"consumerType":@"ODP",
                                       @"accountType":@"0"}];
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading..."];
    
    
    [apiWrapper accountClosedValidationForOdp:jsonDict success:^(NSDictionary *userDict){
        
        NSLog(@"userdict%@",userDict);
        [[LeveyHUD sharedHUD] disappear];
        
        if ([[userDict valueForKey:@"response-status"] isEqualToString:@"success"]){
            
            NSString *isClosedStr = [NSString stringWithFormat:@"%@",[[userDict valueForKey:@"response-content"]valueForKey:@"isClosed"]];;
            if ([isClosedStr isEqualToString:@"0"]){
                
                //                isaNewUser = YES;
                [self alertViewMethod:@"This device is already linked to an One Day Pass, please try again after cashing out"];
                return;
                
            }else{
                //isaNewUser = NO;
                [self adwRegistrationVC];
                
            }
            
        }else{
            [self alertViewMethod:@"The server could not process your request at this time, please try later"];
            return;
        }
        
    }failure:^(NSError *error){
        NSLog(@"device Checking %@",error.description);
        [[LeveyHUD sharedHUD] disappear];
        [self alertViewMethod:error.description];
        
        
    }];
}

#pragma mark - Private API

- (void)prepareView
{
    if ([[[WarHorseSingleton sharedInstance] isAdwEnable] isEqualToString:@"false"]){
        [self.accountBtn setEnabled:NO];
        [self.accountBtn setUserInteractionEnabled:NO];
        [self.accountBtn setHidden:YES];
        [self.oneDayPassBtn setFrame:CGRectMake(self.accountBtn.frame.origin.x, self.accountBtn.frame.origin.y, self.accountBtn.frame.size.width, self.accountBtn.frame.size.height)];
        [self.accountBtn.titleLabel setTextColor:[UIColor colorWithRed:136/255.0 green:178/255.0 blue:215/255.0 alpha:1.0]];
        
        
    }
    if ([[[WarHorseSingleton sharedInstance] isOntEnable] isEqualToString:@"false"]){
        [self.oneDayPassBtn setHidden:YES];
        [self.oneDayPassBtn setEnabled:NO];
        
        [self.oneDayPassBtn setUserInteractionEnabled:NO];
        [self.oneDayPassBtn.titleLabel setTextColor:[UIColor colorWithRed:136/255.0 green:178/255.0 blue:215/255.0 alpha:1.0]];
        
    }
    if ([[[WarHorseSingleton sharedInstance] isCplEnable] isEqualToString:@"false"]){
        [self.paperLessBtn setHidden:YES];
        [self.paperLessBtn setEnabled:NO];
        [self.paperLessBtn setUserInteractionEnabled:NO];
        [self.paperLessBtn.titleLabel setTextColor:[UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1.0]];
        
    }
    
}

- (IBAction)registerUser:(UIButton *)sender
{
    
    
    if (![[[WarHorseSingleton sharedInstance] isAdwEnable] isEqualToString:@"false"]){
        
        
        switch (sender.tag) {
            case 1:
            {
                
                [[WarHorseSingleton sharedInstance] setUserType:@"ADW"];
                [[WarHorseSingleton sharedInstance] setSelectedIndexFromRegister:0];
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Secure Registration" message:@"Do you already have an account with Totepool?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                [alertView show];
                
            }
                break;
                
            case 2:
            {
                [[WarHorseSingleton sharedInstance] setUserType:@"ODP"];
                [[WarHorseSingleton sharedInstance] setSelectedIndexFromRegister:1];
                NSLog(@"selectedregister ====%ld",(long)[[WarHorseSingleton sharedInstance] selectedIndexFromRegister]);
                
                [self checkWhetherUserRegisteredOrNot];
                
            }
                break;
                
            case 3:
            {
                [[WarHorseSingleton sharedInstance] setUserType:@"DV"];
                [[WarHorseSingleton sharedInstance] setSelectedIndexFromRegister:2];
                
                [self adwRegistrationVC];
            }
                break;
                
                
                
            default:
                break;
        }
        
    }else{
        switch (sender.tag) {
            case 2:
            {
                [[WarHorseSingleton sharedInstance] setUserType:@"ODP"];
                [[WarHorseSingleton sharedInstance] setSelectedIndexFromRegister:0];
                NSLog(@"selectedregister ====%ld",(long)[[WarHorseSingleton sharedInstance] selectedIndexFromRegister]);
                
                [self checkWhetherUserRegisteredOrNot];
                
            }
                break;
                
            case 3:
            {
                [[WarHorseSingleton sharedInstance] setUserType:@"DV"];
                [[WarHorseSingleton sharedInstance] setSelectedIndexFromRegister:1];
                
                [self adwRegistrationVC];
            }
                break;
                
                
                
            default:
                break;
        }
    }
    
    
    
    
    
}
- (void)adwRegistrationVC
{
    if (self.isRegisterAppConfigEnable){
        ZLAdwRegistrationViewController *registrationViewCntr = [[ZLAdwRegistrationViewController alloc] initWithNibName:@"ZLAdwRegistrationViewController" bundle:nil];
        registrationViewCntr.registerAppConfigDict =self.registrationAppConfigDict;
        [self.navigationController pushViewController:registrationViewCntr animated:YES];
    }else{
        [self alertViewMethod:@"The server could not process your request at this time, please try later"];
        
    }
}
- (void)alertViewMethod:(NSString *)mess
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Information!" message:mess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self adwRegistrationVC];
        
    }
    else{
        if (self.isRegisterAppConfigEnable){
            SPRegistrationVC *registrationVC = [[SPRegistrationVC alloc]initWithNibName:@"SPRegistrationVC" bundle:nil];
            registrationVC.registerAppConfigDict = self.registrationAppConfigDict;
            [self.navigationController pushViewController:registrationVC animated:YES];
        }else{
            [self alertViewMethod:@"The server could not process your request at this time, please try later"];
            
        }
        
    }
}
- (IBAction)backToHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)infoBtnAction:(id)sender
{
    if (enableInfo == YES){
        self.infoPopView.hidden = NO;
        
        enableInfo = NO;
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.infoPopView.alpha = 1;
                             
                         }
                         completion:^(BOOL finished){
                             //infoBtn.enabled = YES;
                         }];
        
        if (!self.infoTapRecognizer){
            self.infoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [self.infoPopView addGestureRecognizer:self.infoTapRecognizer];
        }
        self.infoTapRecognizer.enabled = YES;
        
    }else{
        self.infoPopView.hidden = YES;
        
        enableInfo = YES;
        self.infoPopView.alpha = 0;
        
    }
}
- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    // Do Your thing.
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        self.infoPopView.alpha = 0;
        self.infoPopView.hidden = YES;
        enableInfo = YES;
        self.infoTapRecognizer.enabled = NO;
        
    }
}

@end
