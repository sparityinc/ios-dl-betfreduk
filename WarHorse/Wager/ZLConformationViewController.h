//
//  ZLConformationViewController.h
//  WarHorse
//
//  Created by Sparity on 06/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZLConformationViewControllerDelegate <NSObject>

- (void) confirmWager:(id)sender;

- (void) cancelWager:(id)sender;

@end

@interface ZLConformationViewController : UIViewController
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) IBOutlet UILabel *raceNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *trackNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *leftPriseLabel;
@property (nonatomic, strong) IBOutlet UILabel *betTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel *runnersLabel;
@property (nonatomic, strong) IBOutlet UILabel *amountLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberOfBetsLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalAmountLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *bottomDateLabel;
@property (nonatomic, strong) IBOutlet UIButton *buttonConfirm;
@property (nonatomic, strong) IBOutlet UIButton *buttonCancel;

- (IBAction)conformButtonClicked:(id)sender;
- ( IBAction)cancelButtonClicked:(id)sender;
@end
