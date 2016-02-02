//
//  ZLMuiltiBetTypeVC.h
//  WarHorse
//
//  Created by Veeru on 12/11/15.
//  Copyright (c) 2015 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLMuiltiBetTypeVC : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>


@property(weak,nonatomic) IBOutlet UICollectionView *betType_CollectionView;
@property(weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (strong,nonatomic) NSString *betTypeName;

@end
