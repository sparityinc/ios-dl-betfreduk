//
//  ZLPaperLessRegistrationViewController.h
//  WarHorse
//
//  Created by Hiteshwar Vadlamudi on 21/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLPaperLessRegistrationViewController : UIViewController <UITextFieldDelegate>


@property(nonatomic,retain) IBOutlet UIButton *backButton;
@property(nonatomic,retain) IBOutlet UILabel *createActLabel;
@property(nonatomic,retain) IBOutlet UITextField *userName_TF;
@property(nonatomic,retain) IBOutlet UITextField *pwd_TF;
@property(nonatomic,retain) IBOutlet UITextField *confirmPwd_TF;
@property(nonatomic,retain) IBOutlet UITextField *enterPin_TF;
@property(nonatomic,retain) IBOutlet UITextField *confirmPin_TF;
@property(nonatomic,retain) IBOutlet UIButton *registerBtn;
@property(nonatomic,retain) IBOutlet UILabel *accountLabel;
@property(nonatomic,retain) IBOutlet UIButton *loginButton;
@property(nonatomic, strong) IBOutlet UIImageView *usernameImgView;
@property(nonatomic, strong) IBOutlet UIImageView *passwordImgView;
@property(nonatomic, strong) IBOutlet UIImageView *cnfrmpswdImgView;
@property(nonatomic, strong) IBOutlet UIImageView *pinNumbrImgView;
@property(nonatomic, strong) IBOutlet UIImageView *cnfrmPinImgView;

@property	CGFloat shiftForKeyboard;


-(IBAction)backClicked:(id)sender;
-(IBAction)registerClicked:(id)sender;
-(IBAction)loginClicked:(id)sender;
-(IBAction)BackGroundClicked;



@end
