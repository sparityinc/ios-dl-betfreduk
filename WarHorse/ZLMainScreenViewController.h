//
//  ZLMainScreenViewController.h
//  WarHorse
//
//  Created by Sparity on 7/19/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLMainScreenCollectionCell.h"
#import "ZLMainScreenTableViewCell.h"

@interface ZLMainScreenViewController : UIViewController <UIScrollViewDelegate>
@property(nonatomic,retain) IBOutlet UIButton *loginButton;
@property(nonatomic,retain) IBOutlet UIButton *accountButton;
@property(nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property(nonatomic, retain) IBOutlet UIScrollView *imageScrollView;
@property(nonatomic, retain) IBOutlet UICollectionView *collectionView;
@property(nonatomic,retain) NSMutableArray *collectionArray;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSTimer *imageTimer;
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, strong) IBOutlet ZLMainScreenTableViewCell *objTableViewCell;
@property (nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, strong) IBOutlet UITableView *menuTableView;


@property (nonatomic,strong) IBOutlet UIImageView *staticBannerImgView;

-(IBAction)loginClicked:(id)sender;
-(IBAction)accountCLicked:(id)sender;
@end
