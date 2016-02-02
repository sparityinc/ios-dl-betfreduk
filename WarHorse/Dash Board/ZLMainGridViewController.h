//
//  ZLMainGridViewController.h
//  WarHorse
//
//  Created by Sparity on 7/5/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLMainTileCell.h"
#import "ZLMainTableCustomCell.h"
@class RevealController;

@interface ZLMainGridViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property(nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

//pageControl
@property(nonatomic, retain) IBOutlet UIView *pageView;
@property(nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property(nonatomic, retain) IBOutlet UIScrollView *imageScrollView;
@property(nonatomic,retain) NSMutableArray *imagesArray;

//collection view
@property(strong,nonatomic) IBOutlet UICollectionView *mainGridCollectionView;
@property(strong,nonatomic) NSMutableArray *numberArray;

//table view
@property(nonatomic,retain) IBOutlet UITableView *mainTableView;
@property(nonatomic,retain) IBOutlet ZLMainTableCustomCell *mainTableCustomCell;
@property(strong,nonatomic) NSMutableArray *tableArray;

//leftview
@property (strong, nonatomic) RevealController *viewController;

@property (nonatomic, strong) NSTimer *imageTimer;


-(void)pageTurn:(UIPageControl *)aPageControl;


@end
