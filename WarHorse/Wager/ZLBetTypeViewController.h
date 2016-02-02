//
//  ZLBetTypeViewController.h
//  WarHorse
//
//  Created by Sparity on 7/9/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLBetTypeViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property(strong,nonatomic) IBOutlet UICollectionView *betType_CollectionView;
@property (atomic, strong) NSMutableArray *singleHorseArray;
@property (strong, strong) NSMutableArray *multiHorseArray;
@property (atomic, strong) NSMutableArray *multiRaceArray;
@property(strong,nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *newmultiHorseArray;


@end
