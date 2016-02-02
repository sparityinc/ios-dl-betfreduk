//
//  ZLVerificationCodeViewController.h
//  WarHorse
//
//  Created by PVnarasimham on 04/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLVerificationCodeViewController : UIViewController
{
    
}
@property (strong, nonatomic) NSString *accountId;
@property (strong, nonatomic) NSDictionary *responseDictionary;


@property (strong,nonatomic) IBOutlet UILabel *accountLbl1;
@property (strong,nonatomic) IBOutlet UILabel *accountLbl2;
@property (strong,nonatomic) IBOutlet UILabel *accountLbl3;
@property (strong,nonatomic) IBOutlet UILabel *accountLbl4;


@property (strong,nonatomic) IBOutlet UILabel *accountLabel;
@property (strong,nonatomic) IBOutlet UILabel *userLabel;
@property (strong,nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong,nonatomic) IBOutlet UILabel *pinLabel;



@property (strong,nonatomic) IBOutlet UIImageView *image1;
@property (strong,nonatomic) IBOutlet UIImageView *image2;
@property (strong,nonatomic) IBOutlet UIImageView *image3;
@property (strong,nonatomic) IBOutlet UIImageView *image4;


@property (strong ,nonatomic) IBOutlet UIButton *loginBtn;

@property(strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSDictionary *userDetailsDict;

@end
