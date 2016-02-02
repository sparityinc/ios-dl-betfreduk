//
//  SPAboutWarhorseViewController.m
//  WarHorse
//
//  Created by PVnarasimham on 15/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "SPAboutWarhorseViewController.h"
#import "ZLPreLoginAPIWrapper.h"
#import "LeveyHUD.h"
#import "SPConstant.h"


@interface SPAboutWarhorseViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *headerNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *descTextView;
@property (strong, nonatomic) IBOutlet UILabel *allRightsLabel;
@property (strong, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation SPAboutWarhorseViewController

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
    [self.webView setOpaque:NO];
    [self.headerNameLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.descTextView setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.allRightsLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private API

- (IBAction)backToHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loadData
{
    ZLPreLoginAPIWrapper *preloginapiwrapper = [[ZLPreLoginAPIWrapper alloc] init];
    
    NSDictionary *argumentsDic = @{@"queryName":@"framework_json_data",
                                   @"queryParams":@{@"json_data_id":@"About"}};
    [[LeveyHUD sharedHUD] appearWithText:@"Loading AboutTotepool..."];
    
    [preloginapiwrapper loadPreLoginDataForParameterType:argumentsDic success:^(NSDictionary *_userInfo){
        
        
        NSString *responsecode = [[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-code"];
        if ([responsecode isEqualToString:@"WH-200"])
        {
            NSString *termsConditionsStr = [[[[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"] objectAtIndex:0]valueForKey:@"Json_Data"] valueForKey:@"fileurl"];
            
            NSString *urlStr =[NSString stringWithFormat:@"%@%@",kDownLoadedBaseCMSUrl,termsConditionsStr];
            
            NSURL *url = [NSURL URLWithString:urlStr];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:requestObj];
            [self.webView setOpaque:NO];
            self.webView.scalesPageToFit=YES;
        }else{
            [[LeveyHUD sharedHUD] disappear];

            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Information" message:@"Unable to connect to the server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        
        
    }failure:^(NSError *error) {
        [[LeveyHUD sharedHUD] disappear];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error Code:%d", error.code] message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }];
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
