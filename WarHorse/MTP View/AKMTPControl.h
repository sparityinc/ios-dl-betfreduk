//
//  AKMTPControl.h
//  MTPComponent
//
//  Created by Sparity on 05/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKMTPScaleView.h"
#import "ZLCurrentBetTypeViewController.h"

@interface AKMTPControl : UIScrollView 
{

}
@property (nonatomic, strong) AKMTPScaleView *scaleView;
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) NSInteger interval;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (strong, nonatomic) id <ZLCurrentBetTypeViewControllerProtocol> currentBetTypeDelegate;

- (void)setMTPSelectedForPage:(NSInteger)selectedPage;

@end
