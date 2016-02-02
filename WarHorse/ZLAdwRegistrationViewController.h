//
//  ZLAdwRegistrationViewController.h
//  WarHorse
//
//  Created by Hiteshwar Vadlamudi on 21/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLAdwRegistrationViewController : UIViewController
{
    UIActivityIndicatorView *spinner;
}
@property (nonatomic,strong) IBOutlet UIView *ondayPassView;
@property (nonatomic, assign) BOOL isClicked;
@property (nonatomic,strong) NSDictionary *registerAppConfigDict;

@end
