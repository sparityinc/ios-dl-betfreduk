//
//  ZLLoginViewController.h
//  WarHorse
//
//  Created by Sparity on 7/4/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLLoginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic,retain) IBOutlet UITextField *userName_TF;
@property (nonatomic,retain) IBOutlet UITextField *password_TF;
@property (nonatomic,retain) IBOutlet UITextField *pinNumber_TF;
@property (nonatomic,retain) IBOutlet UIButton *login_Button;
@property (nonatomic,retain) IBOutlet UIButton *forgotPWD_Button;
@property (nonatomic,retain) IBOutlet UIButton *back_Button;
@property (nonatomic,retain) IBOutlet UILabel *login_Label;
@property (nonatomic, strong) IBOutlet UIImageView *usernameImgView;
@property (nonatomic, strong) IBOutlet UIImageView *passwordImgView;
@property (nonatomic, strong) IBOutlet UIImageView *pinImgView;
@property (nonatomic,strong) IBOutlet UIImageView *selArrowImageView;
@property (nonatomic,strong) IBOutlet UIImageView *logoImageView;
@property (nonatomic,strong) IBOutlet UIImageView *lineImageView;
@property (nonatomic,strong) NSString *typeOfUser;
@property	CGFloat shiftForKeyboard;

-(IBAction)login_Clicked:(id)sender;
-(IBAction)back_Clicked:(id)sender;
-(IBAction)BackGroundClicked;

- (IBAction)resetPassword:(id)sender;



@end
