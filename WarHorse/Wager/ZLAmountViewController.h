//
//  ZLAmountViewController.h
//  WarHorse
//
//  Created by Sparity on 7/9/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLCustomAmountView.h"


@interface ZLAmountViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,ZLCustomAmountDelegate>

@property(strong,nonatomic) IBOutlet UICollectionView *amount_CollectionView;
@property(strong,atomic) NSArray *amount_Array;
@property(nonatomic,retain) IBOutlet UILabel *bet_Label;
@property(nonatomic,retain) ZLCustomAmountView *customAmountView;
@property(nonatomic,retain) IBOutlet UIButton *defaultButton;
@property(nonatomic,retain) IBOutlet UIButton *customButton;

-(IBAction)defaultButtonClicked:(id)sender;
-(IBAction)customButtonClicked:(id)sender;


@end
