//
//  ZLAddFundsViewController.h
//  WarHorse
//
//  Created by Sparity on 8/8/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLAddFundsViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
{
    NSMutableArray *addCardsArray;
    
    NSMutableDictionary *selectedCardDict;
    IBOutlet UILabel *processingFeeLabel;
}


@property (nonatomic ,strong) IBOutlet UISegmentedControl *CardTypeSegmentedControl;
@property (nonatomic ,strong) IBOutlet UIImageView  *segmentedControlBackgroundImage;

@property(nonatomic,retain) IBOutlet UITableView *fundsTableView;
@property(nonatomic,retain) NSMutableArray *cardsArray;
@property(nonatomic,retain) UIButton *amountButton;
@property(nonatomic,retain) IBOutlet UIButton *wager_Button;
@property(nonatomic,retain) IBOutlet UIButton *backButton;
@property(nonatomic,retain) IBOutlet UIButton *addAmountBtn;

@property(nonatomic,retain) IBOutlet UILabel *addFundLabel;
@property(nonatomic,retain) IBOutlet UILabel *selectLabel;
@property	CGFloat shiftForKeyboard;

//popUPView
@property(nonatomic,retain) IBOutlet UIView *transparantView;
@property(nonatomic,retain) IBOutlet UIView *fundsView;
@property(nonatomic,retain) IBOutlet UIButton *fundCloseBtn;
@property(nonatomic,retain) IBOutlet UIView *insideFundsView;
@property(nonatomic,retain) IBOutlet UIButton *confirmBtn;
@property(nonatomic,retain) IBOutlet UIButton *cancelBtn;
@property(nonatomic,retain) IBOutlet UILabel *adngFunds_Label;
@property(nonatomic,retain) IBOutlet UILabel *amountLable;
@property(nonatomic,retain) IBOutlet UILabel *cardLabel;
@property(nonatomic,retain) IBOutlet UILabel *fundAmountLabel;

@property(nonatomic,retain) IBOutlet UILabel *cardNameLabel;
@property(nonatomic,retain) IBOutlet UILabel *accountNumLabel;

- (IBAction)fundCloseClicked:(id)sender;
- (IBAction)addAmountClicked:(id)sender;
- (IBAction)wagerButtonClicked:(id)sender;
-(IBAction)backClicked:(id)sender;
-(IBAction)cancelClicked:(id)sender;
- (IBAction)selectCardType:(id)sender;
- (IBAction)checkingRadioButtonAction:(id)sender;
- (IBAction)savingsRadioButtonAction:(id)sender;

@end
