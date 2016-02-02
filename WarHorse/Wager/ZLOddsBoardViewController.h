//
//  ZLViewController.h
//  OddsMatrix
//
//  Created by Sparity on 08/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLMatrixView.h"

@interface ZLOddsBoardViewController : UIViewController
{
    IBOutlet UILabel *headerLabel;
}

@property(nonatomic,retain) IBOutlet UIButton *oddsPoolButton;
@property(nonatomic,retain) IBOutlet UIButton *probablesButton;
@property (nonatomic, retain) NSMutableArray *runnersArray;
@property (nonatomic, retain) ZLMatrixView *oddsmatrix;
@property (nonatomic, retain) ZLMatrixView *probablesmatrix;
@property (nonatomic, retain) NSMutableArray *oddsPoolArray;
@property (nonatomic, retain) NSMutableArray *probablesArray;
@property(nonatomic,retain) IBOutlet UIView *flippingView;
@property(nonatomic,retain) IBOutlet UILabel* lblOtherBetTypesPoolTotal;
@property(nonatomic,retain) IBOutlet UILabel* lblWinPoolTotal;
@property(nonatomic,retain) IBOutlet UILabel* lblPlcPoolTotal;
@property(nonatomic,retain) IBOutlet UILabel* lblShwPoolTotal;
@property(nonatomic,retain) IBOutlet UILabel* lblPoolGrandTotal;
@property(nonatomic,retain) IBOutlet UILabel *probablesLabel;
@property (strong, nonatomic) IBOutlet UILabel *poolTotal;
-(IBAction)oddsPoolButtonClicked:(id)sender;
-(IBAction)probablesButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;

@end
