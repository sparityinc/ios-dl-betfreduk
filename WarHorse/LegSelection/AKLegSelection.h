//
//  AKLegSelectionView.h
//  LegSelection
//
//  Created by Sparity on 03/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AKLegSelectionDelegate.h"

@interface AKLegSelection : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *selectionImage;
@property (nonatomic, assign) NSUInteger totalLegs;
@property (nonatomic, assign) NSUInteger legsInSinglePage;
@property (nonatomic, assign) NSUInteger currentLeg;
@property (nonatomic, assign) id<AKLegSelectionDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *itemsArray;

- (id)initWithFrame:(CGRect)frame totalnumberOfLegs:(NSUInteger)numberOfLegs legsPerPage:(NSUInteger)legsPerPage currentRace:(int) currentRace delegate:(id<AKLegSelectionDelegate>)delegate isMultiBetSelected:(BOOL)isMultiRunnerBet;

@end
