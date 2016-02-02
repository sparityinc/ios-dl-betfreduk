//
//  ZLResetPasswordViewController.h
//  WarHorse
//
//  Created by Sparity on 8/6/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLResetPasswordViewController : UIViewController<UITextFieldDelegate>


@property(nonatomic,retain) IBOutlet UILabel *resetLabel;
@property(nonatomic,retain) IBOutlet UITextField *Pwd_TF;
@property(nonatomic,retain) IBOutlet UITextField *confirmPwd_TF;
@property (nonatomic,retain) IBOutlet UITextField *email_TF;
@property(nonatomic,retain) IBOutlet UIButton *submitBtn;
@property(nonatomic,retain) IBOutlet UIButton *backButton;
@property	CGFloat shiftForKeyboard;
@property (nonatomic,strong) IBOutlet UIImageView *logoImageView;
@property (nonatomic,strong) IBOutlet UIButton *submitButton;
@property (nonatomic,strong) IBOutlet UIButton *refreshBtn;

@property (nonatomic,strong) IBOutlet UIImageView *verificationImage;
//@property (nonatomic,strong) IBOutlet UIImageView *newPasswordImageView;
@property (nonatomic,strong) IBOutlet UIImageView *confirmPwdImage;
@property (nonatomic,strong) IBOutlet UIImageView *passwordImg;



-(IBAction)backClicked:(id)sender;
-(IBAction)submitClicked:(id)sender;

- (IBAction)resestPassword:(id)sender;
- (IBAction)resendVerificationCode;
@end
