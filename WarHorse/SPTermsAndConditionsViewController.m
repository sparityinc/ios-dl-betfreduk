//
//  SPTermsAndConditionsViewController.m
//  WarHorse
//
//  Created by Veeru on 15/10/13.
//  Copyright (c) 2013 Northalley. All rights reserved.
//

#import "SPTermsAndConditionsViewController.h"
#import "LeveyHUD.h"
#import "ZLPreLoginAPIWrapper.h"
#import "SPConstant.h"




@interface SPTermsAndConditionsViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *headerNameLabel;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong ,nonatomic) IBOutlet UIButton *homeBtn;
@end

@implementation SPTermsAndConditionsViewController
@synthesize isRegistrationFlag;

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
    // [self.accountInfoBtn setUserInteractionEnabled:YES];

    [self.webView setOpaque:NO];
    
    
    if (isRegistrationFlag == YES){
        [self.homeBtn setBackgroundImage:[UIImage imageNamed:@"adwRegisterBack@2x.png"] forState:UIControlStateNormal];
        
    }else{
        [self.homeBtn setBackgroundImage:[UIImage imageNamed:@"backarrow.png"] forState:UIControlStateNormal];
        
    }
    [self loadData];
    [self.headerNameLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    
    
}


- (void)loadData
{
    ZLPreLoginAPIWrapper *preloginapiwrapper = [[ZLPreLoginAPIWrapper alloc] init];
    
    NSDictionary *argumentsDic = @{@"queryName":@"framework_json_data",
                                   @"queryParams":@{@"json_data_id":@"TermsAndConditions"}};
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Terms & Conditions..."];
    
    [preloginapiwrapper loadPreLoginDataForParameterType:argumentsDic success:^(NSDictionary *_userInfo){
        [[LeveyHUD sharedHUD] disappear];
        
        NSString *responsecode = [[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-code"];
        if ([responsecode isEqualToString:@"WH-200"])
        {
            NSString *termsConditionsStr = [[[[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"] objectAtIndex:0]valueForKey:@"Json_Data"] valueForKey:@"fileurl"];
            
            NSString *urlStr =[NSString stringWithFormat:@"%@%@",kDownLoadedBaseCMSUrl,termsConditionsStr];
            
            NSURL *url = [NSURL URLWithString:urlStr];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:requestObj];
            self.webView.scalesPageToFit=YES;
        }else{
            [[LeveyHUD sharedHUD] disappear];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Information" message:@"Unable to connect to the server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        
        
    }failure:^(NSError *error) {
        [[LeveyHUD sharedHUD] disappear];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error Code:%ld", (long)error.code] message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private API

- (IBAction)backToHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --
#pragma mark UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[LeveyHUD sharedHUD] disappear];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[LeveyHUD sharedHUD] disappear];
}
@end
