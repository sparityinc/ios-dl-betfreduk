//
//  LeveyHUD.h
//  Amgonna
//
//  Created by Ravi Shankar Metlapalli on 12/07/12.
//  Copyright (c) 2012 urzravi23@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class LeveyHUDTopMask, LeveyHUDBottomMask;
@interface LeveyHUD : UIWindow
{
   
    UIView * _backgroundView;    
    UIActivityIndicatorView *_spinner;
    UILabel *_label;
//    LeveyHUDTopMask *_topMask;
//    LeveyHUDBottomMask *_bottomMask;
}

+ (id)sharedHUD;

- (void)appearWithText:(NSString *)text;
- (void)disappear;
- (void)delayDisappear:(NSTimeInterval)delay withText:(NSString *)text;

@end