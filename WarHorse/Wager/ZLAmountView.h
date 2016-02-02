//
//  ZLAmountView.h
//  AmountSelectionComponent
//
//  Created by Sparity on 17/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLAmountViewDelegate.h"

@interface ZLAmountView : UIView<UIScrollViewDelegate>
{
    UIImageView *selectionView;
    UIView *backgroundView;
    UIScrollView *scrollView;
}

@property (nonatomic, assign) id <ZLAmountViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger selectRow;

- (id)initWithFrame:(CGRect)frame delegate:(id)deleage;

@end
