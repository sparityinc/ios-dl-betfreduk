//
//  ZLWagerViewController.h
//  WarHorse
//
//  Created by Sparity on 7/5/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RevealController,ZLSideMenu,ZLSideMenuTile,ZLRunnersViewController,ZLConformationViewController,ZLAmountView,ZLPlaceWagerResultsViewController;

@interface ZLWagerViewController : UIViewController
{
    ZLAmountView *amountView;
}

@property (nonatomic, strong) IBOutlet UINavigationController *wagerNavigationCoontroller;
@property (nonatomic, strong) ZLSideMenu *sideMenu;
@property (nonatomic, strong) NSMutableArray *sideMenuDetailsArray;
@property (nonatomic, strong) IBOutlet UIButton *amountButton;
@property (nonatomic, strong) IBOutlet UIButton *homeButton;
@property (nonatomic, strong) IBOutlet UIButton *listGridButton;
@property (nonatomic, strong) ZLConformationViewController *objZLConformationViewController;
@property (nonatomic, strong) NSMutableArray *amountsArray;
@property (nonatomic, strong) IBOutlet UIImageView *topRightImageView;
@property (nonatomic, strong) IBOutlet UIImageView *topLeftImageView;
@property (nonatomic, strong) ZLPlaceWagerResultsViewController *objResult;


- (IBAction)switchBetweenListAndGried:(id)sender;
- (IBAction)homeButtonClicked:(id)sender;
@end
