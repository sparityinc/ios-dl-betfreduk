//
//  AKMTPScaleView.h
//  MTPComponent
//
//  Created by Sparity on 05/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKMTPScaleView : UIView
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) NSInteger interval;
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) NSInteger selectedPage;

@end
