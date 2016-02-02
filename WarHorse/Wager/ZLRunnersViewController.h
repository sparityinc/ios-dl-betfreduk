//
//  ZLTileComponentViewController.h
//  WarHorse
//
//  Created by Sparity on 7/9/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKLegSelection.h"
#import "ZLRunnersViewCell.h"

@interface ZLRunnersViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,AKLegSelectionDelegate>
@property (strong,nonatomic) IBOutlet UICollectionView *tile_CollectionView;
@property (strong,nonatomic) IBOutlet UITableView *runnersTableView;
@property (strong,nonatomic) IBOutlet ZLRunnersViewCell *objZLRunnersViewCell;

@property (strong,nonatomic) NSMutableArray *numbers_Array;
@property (strong,nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) AKLegSelection *legSelection;
@property (strong,nonatomic) IBOutlet UIButton *boxButton;
@property (strong,nonatomic) IBOutlet UIButton *withButton;
@property (strong,nonatomic) IBOutlet UIButton *allButton;
@property (strong,nonatomic) IBOutlet UIButton *clearButton;
@property (strong,nonatomic) IBOutlet UIView *bottomView;
@property (assign,nonatomic) int numberOfItems;

@property (strong, nonatomic) IBOutlet UILabel *selectedValuesLabel;
@property (strong,nonatomic) IBOutlet UIView *belowResultsView;
@property (strong,nonatomic) IBOutlet UILabel *raceNumberLabel;
@property (strong,nonatomic) IBOutlet UILabel *postTimeLabel;
@property (strong,nonatomic) IBOutlet UILabel *furlongsLabel;
@property (strong,nonatomic) IBOutlet UILabel *weatherLabel;
@property (strong,nonatomic) IBOutlet UILabel *amoutLabel;
@property (strong,nonatomic) IBOutlet UILabel *betTypeLabel;
@property (strong,nonatomic) IBOutlet UILabel *wagerLabel;
@property (strong,nonatomic) IBOutlet UILabel *runnersLabel;

@property (strong,nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) IBOutlet UIImageView *wagerOnImageView;

@property (strong, nonatomic) IBOutlet UIButton *oddsButton;
@property (strong, nonatomic) IBOutlet UIButton *listButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) IBOutlet UIImageView *separatorLine;

- (IBAction)bottomViewExpanstionOrCompression:(id)sender;
- (void) switchBetweenListAndGrid;
- (IBAction)allButtonClicked:(id)sender;
- (IBAction)clearButtonClicked:(id)sender;
- (void) reloadViews;
- (IBAction)listOrGridButtonClicked:(id)sender;
- (IBAction)sideMenuButtonClicked:(id)sender;
- (IBAction)oddsButtonClicked:(id)sender;

@end
