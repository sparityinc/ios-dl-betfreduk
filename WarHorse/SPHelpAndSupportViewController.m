//
//  SPHelpAndSupportViewController.m
//  WarHorse
//
//  Created by sekhar on 25/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "SPHelpAndSupportViewController.h"
#import "ZLPreLoginAPIWrapper.h"
#import "LeveyHUD.h"
#import "SPConstant.h"

@interface SPHelpAndSupportViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UITextView *helpTextView;
@property (nonatomic,strong) IBOutlet UILabel *customerCare;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SPHelpAndSupportViewController

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

    [self.contentLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    [self.customerCare setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    self.contentLabel.text =@"Content to be published via CMS";
    
    [self.titleLabel setText:@"Help/Support"];
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.helpTextView setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    
    [self.customCareLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.techSuppLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.callTollFreeLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.callTollFreeLbl1 setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.emailLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.emailLbl1 setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    self.callBtn1.titleLabel.font  = [UIFont fontWithName:@"Roboto-Medium" size:15];
    self.callBtn2.titleLabel.font  = [UIFont fontWithName:@"Roboto-Medium" size:15];
    
    self.emailBtn1.titleLabel.font  = [UIFont fontWithName:@"Roboto-Medium" size:15];
    self.emailBtn2.titleLabel.font  = [UIFont fontWithName:@"Roboto-Medium" size:15];
    [self.askForTech setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];

    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loadData
{
    ZLPreLoginAPIWrapper *preloginapiwrapper = [[ZLPreLoginAPIWrapper alloc] init];
    
    NSDictionary *argumentsDic = @{@"queryName":@"framework_json_data",
                                   @"queryParams":@{@"json_data_id":@"HelpSupport"}};
    [[LeveyHUD sharedHUD] appearWithText:@"Loading HelpSupport..."];
    
    [preloginapiwrapper loadPreLoginDataForParameterType:argumentsDic success:^(NSDictionary *_userInfo){

        NSString *responsecode = [[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-code"];
        if ([responsecode isEqualToString:@"WH-200"])
        {
            NSString *helpSupportStr = [[[[[_userInfo valueForKey:@"Deposit_Status"] valueForKey:@"response-content"] objectAtIndex:0]valueForKey:@"Json_Data"] valueForKey:@"fileurl"];
            
            NSString *urlStr =[NSString stringWithFormat:@"%@%@",kDownLoadedBaseCMSUrl,helpSupportStr];
            
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

#pragma mark --
#pragma mark UIWebview Delegate

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

/*
- (IBAction)customerCallBtnClicked:(id)sender {
        
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        UIAlertView *callAlert = [[UIAlertView alloc]initWithTitle:@"Information" message:@"make a call or not" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil];
        callAlert.delegate = self;
        [callAlert show];
        
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Information" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}

- (IBAction)customerEmailBtnClicked:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        NSArray *toRecipents = [NSArray arrayWithObject:@"customercare@mywinners.com"];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    } else {
        
        // Handle the error
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ALERT!!!" message:@"Please login with atleast one email account." delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
        {
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failed" message:@"Your email has failed to send" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
            
        }
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark ----
#pragma alert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0){
        
    }else{
        
        NSURL *URL = [NSURL URLWithString:@"tel://1.800.468.2260"];
        [[UIApplication sharedApplication] openURL:URL];
    }



}
*/




@end
