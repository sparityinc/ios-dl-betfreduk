//
//  SPWithDrawalViewController.m
//  WarHorse
//
//  Created by sparity on 17/11/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPWithDrawalViewController.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "ZLQRCodeViewController.h"
#import "LeveyHUD.h"
#import "ZLAPIWrapper.h"
#import "ZLAppDelegate.h"

@interface SPWithDrawalViewController ()<UIWebViewDelegate, UITextFieldDelegate>


@property (nonatomic,strong) IBOutlet UITextField *amountTxtField;
@property (nonatomic,strong) IBOutlet UITextField *descriptionTxtField;
@property (nonatomic,strong) IBOutlet UIButton *submitBtn;
@property (nonatomic,strong) IBOutlet UILabel *amountLbl;
@property (nonatomic,strong) IBOutlet UILabel *descriptionLbl;
@property (nonatomic,strong) IBOutlet UILabel *descriptionLabel;

@property (strong,nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (strong,nonatomic) IBOutlet UIButton *qrCodeBtn;
@property (strong,nonatomic) IBOutlet UIButton *checkBtn;

@property (strong,nonatomic) IBOutlet UILabel *signatureLabel;
@property (strong ,nonatomic) IBOutlet UITextField *signatureTF;

//- (IBAction)qrcodeButtonAct:(id)sender;
- (IBAction)checkBtnAct:(id)sender;
- (IBAction)submitButton:(id)sender;
//@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SPWithDrawalViewController

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
    NSString *placeHolder = [NSString stringWithFormat:@"%@0.00",[[WarHorseSingleton sharedInstance] currencySymbel]];
    self.amountTxtField.placeholder = placeHolder;
    
    self.submitBtn.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
    [self.titleLabel setText:@"Withdrawal"];
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.titleLabel setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.amountTxtField.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.amountTxtField.layer setBorderWidth:1.0];
    
    [self.descriptionTxtField.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.descriptionTxtField.layer setBorderWidth:1.0];
    
    [self.signatureTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.signatureTF.layer setBorderWidth:1.0];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    
    [self.amountLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    
    [self.descriptionLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    [self.descriptionLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];

    
    [self.signatureLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    
    [self prepareTopView];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UIView *leftPaddingView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, self.amountTxtField.frame.size.height)];
    self.amountTxtField.leftView = leftPaddingView;
    self.amountTxtField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightPaddingView  = [[UIView alloc] initWithFrame:CGRectMake(self.amountTxtField.frame.size.width-6, 0, 6, self.amountTxtField.frame.size.height)];
    self.amountTxtField.rightView = rightPaddingView;
    self.amountTxtField.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *leftPaddingView1  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, self.descriptionTxtField.frame.size.height)];
    self.descriptionTxtField.leftView = leftPaddingView1;
    self.descriptionTxtField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightPaddingView2 = [[UIView alloc] initWithFrame:CGRectMake(self.descriptionTxtField.frame.size.width-6, 0, 6, self.descriptionTxtField.frame.size.height)];
    self.signatureTF.leftView = rightPaddingView2;
    self.signatureTF.leftViewMode = UITextFieldViewModeAlways;
    
        

    
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
- (IBAction)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];

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

/*
- (IBAction)qrcodeButtonAct:(id)sender
{
    self.amountTxtField.hidden = YES;
    self.submitBtn.hidden = YES;
    
    self.descriptionLbl.hidden = YES;
    self.descriptionTxtField.hidden = YES;
    self.amountLbl.hidden = YES;
    
    ZLQRCodeViewController *qrcodeViewCntr = [[ZLQRCodeViewController alloc] initWithNibName:@"ZLQRCodeViewController" bundle:nil];
    qrcodeViewCntr.actionStr = @"withdraw";

    [self.navigationController pushViewController:qrcodeViewCntr animated:YES];
}
 */
- (IBAction)checkBtnAct:(id)sender
{

    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"user_type"] isEqualToString:@"ADW"]){
        self.amountTxtField.hidden = NO;
        self.submitBtn.hidden = NO;
        
        self.descriptionLbl.hidden = NO;
        self.descriptionTxtField.hidden = NO;
        self.amountLbl.hidden = NO;
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"This feature is only for New Acount Type users." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
}
- (IBAction)submitButton:(id)sender
{
    [self.signatureTF resignFirstResponder];
    [self.amountTxtField resignFirstResponder];
    
    
    if ([self.amountTxtField.text length] == 0){
        
        [self aleatViewShowing:@"Please enter amount"];
        return;
    }
    if ([self.signatureTF.text length] == 0){
        
        [self aleatViewShowing:@"Please provide signature"];
        return;
    }
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    
    NSMutableDictionary *checkDetailsDict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{@"amount":self.amountTxtField.text,
                                       @"withdrawalDescription":@"Veeru",
                                       @"type":@"CHK",
                                       @"signature":self.signatureTF.text
                                     }];
    
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[LeveyHUD sharedHUD] appearWithText:@"Withdrawal in process…"];
    [apiWrapper withdrawalRequest:checkDetailsDict success:^(NSDictionary *_userInfo) {
        
        NSString *responseMes;
        [[LeveyHUD sharedHUD] disappear];
        
        if ([[_userInfo valueForKey:@"response-status"] isEqualToString:@"success"]) {
            responseMes =  [NSString stringWithFormat:@"Your withdrawal was successful and your current available balance is %@%@",[[WarHorseSingleton sharedInstance] currencySymbel],[[_userInfo valueForKey:@"response-content"] valueForKey:@"availableBalance"]];
            
            UIAlertView *alertView;
            alertView = [[UIAlertView alloc] initWithTitle:@"Wallet" message:responseMes delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            
            [alertView show];
            //[self aleatViewShowing:responseMes];
            self.amountTxtField.text = @"";
            self.signatureTF.text = @"";
        }
        else
        {
            [[LeveyHUD sharedHUD] disappear];
            responseMes =  [NSString stringWithFormat:@"%@",[_userInfo valueForKey:@"response-message"] ];
            [self aleatViewShowing:responseMes];
            self.amountTxtField.text = @"";
            self.signatureTF.text = @"";
        }
        
    } failure:^(NSError *error) {
        [[LeveyHUD sharedHUD] disappear];
        self.amountTxtField.text = @"";
        self.signatureTF.text = @"";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Exception on server " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }];
    
}
- (void)resignKeyBoard
{
    [self.amountTxtField resignFirstResponder];
    [self.descriptionTxtField resignFirstResponder];
    [self.signatureTF resignFirstResponder];
    [self.tapGestureRecognizer setEnabled:NO];
}

- (void)aleatViewShowing:(NSString *)mesText
{
    UIAlertView *alertView;
    alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:mesText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - TextField Delegate Methods
// became first responder
/*
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self.tapGestureRecognizer setEnabled:YES];
    
	CGRect textViewRect = [self.view.window convertRect:textField.bounds fromView:textField];
	CGFloat bottomEdge = textViewRect.origin.y + textViewRect.size.height;
	if (bottomEdge >= 140) {//250
        CGRect viewFrame = self.view.frame;
        self.shiftForKeyboard = bottomEdge - 165;//165
        viewFrame.origin.y -= self.shiftForKeyboard;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
		
	} else {
		self.shiftForKeyboard = 0.0f;
	}
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    
    [self.tapGestureRecognizer setEnabled:NO];
    
        if (self.view.frame.origin.y == 0) {
        [textField resignFirstResponder];
    }
    else{
     	// Resign first responder
        [textField resignFirstResponder];
        
        
        // Make a CGRect for the view (which should be positioned at 0,0 and be 320px wide and 480px tall)
        CGRect viewFrame = self.view.frame;
        if(viewFrame.origin.y!=0)
        {
            // Adjust the origin back for the viewFrame CGRect
            viewFrame.origin.y += self.shiftForKeyboard;
            // Set the shift value back to zero
            self.shiftForKeyboard = 0.0f;
            
            // As above, the following animation setup just makes it look nice when shifting
            // Again, we don't really need the animation code, but we'll leave it in here
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3];
            // Apply the new shifted vewFrame to the view
            [self.view setFrame:viewFrame];
            // More animation code
            [UIView commitAnimations];
        }
    }
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.descriptionTxtField) {
        [self.signatureTF becomeFirstResponder];
    }
    else {
        [self.signatureTF resignFirstResponder];
    }
    return YES;
}// called when 'return' key pressed. return NO to ignore.

#pragma mark ----
#pragma alert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[WarHorseSingleton sharedInstance] setIsWithDrawalSuccess:YES];
    [self.navigationController popViewControllerAnimated:YES];
}





@end
