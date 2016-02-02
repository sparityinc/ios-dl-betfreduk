//
//  ZLCustomAmountView.h
//  CustomAmoutPicker
//
//  Created by Sparity on 29/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLCustomAmountDelegate.h"
@interface ZLCustomAmountView : UIView <UITextFieldDelegate, UITextViewDelegate>
{
    UITextField *amoutTextField;
}
@property (nonatomic, assign) id<ZLCustomAmountDelegate> delegate;
@end
