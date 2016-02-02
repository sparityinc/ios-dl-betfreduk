//
//  ZLCustomAmountView.m
//  CustomAmoutPicker
//
//  Created by Sparity on 29/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLCustomAmountView.h"
#import <QuartzCore/QuartzCore.h>
#import "WarHorseSingleton.h"

#define BORDER_PADDING 5
#define BUTTON_BG_COLOR [UIColor colorWithRed:207.0/255 green:220.0/255 blue:226.0/255 alpha:1.0]

#define TEXT_COLOR [UIColor colorWithRed:36.0/255 green:36.0/255 blue:36.0/255 alpha:1.0]

#define BORDER_COLOR [UIColor colorWithRed:146.0/255 green:159.0/255 blue:165.0/255 alpha:1.0]

@implementation ZLCustomAmountView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpSubView];
        
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder

{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpSubView];
    }
    return self;
}

- (void) setUpSubView
{
    amoutTextField = [[UITextField alloc] initWithFrame:CGRectMake(BORDER_PADDING, BORDER_PADDING, self.frame.size.width - BORDER_PADDING*2, 30)];
    [amoutTextField setTextAlignment:NSTextAlignmentRight];
    [amoutTextField setBackgroundColor:[UIColor colorWithRed:86.0/255 green:86.0/255 blue:94.0/255 alpha:1.0]];
    [amoutTextField setAutoresizesSubviews:YES];
     amoutTextField.delegate = self;
    //[amoutTextField setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [amoutTextField setText:[[WarHorseSingleton sharedInstance] currencySymbel]];
    [amoutTextField setFont:[UIFont fontWithName:@"Roboto-Light" size:20]];
    [amoutTextField setContentMode:UIViewContentModeCenter];
    [amoutTextField setTextColor:[UIColor whiteColor]];
    [amoutTextField setBorderStyle:UITextBorderStyleLine];
    [self addSubview:amoutTextField];
    
    CGFloat buttonWidth = (self.frame.size.width - (BORDER_PADDING * 2))/3;
    
    CGFloat buttonStartingYValue = amoutTextField.frame.size.height + amoutTextField.frame.origin.y + 5;
    
    int count = 9;
    CGFloat y ;
    for (int i = 0; i <3 ; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            if (count == 9 || count == 8 || count == 7){
                CGFloat x = self.frame.size.width -  BORDER_PADDING - buttonWidth - ((j %3) * buttonWidth);
                y = buttonStartingYValue + (i *buttonWidth);
                [self addButtonWithFrame:CGRectMake(x,y+5,buttonWidth+1,buttonWidth-4) tag:count image:nil title:[NSString stringWithFormat:@"%i",count]];
            }
            if (count == 6 || count == 5 || count == 4){
                CGFloat x = self.frame.size.width -  BORDER_PADDING - buttonWidth - ((j %3) * buttonWidth);
                y = buttonStartingYValue + (i *buttonWidth);
                [self addButtonWithFrame:CGRectMake(x,y+1,buttonWidth+1,buttonWidth-4) tag:count image:nil title:[NSString stringWithFormat:@"%i",count]];
            }
            if (count == 3 || count == 2 || count == 1){
                CGFloat x = self.frame.size.width -  BORDER_PADDING - buttonWidth - ((j %3) * buttonWidth);
                y = buttonStartingYValue + (i *buttonWidth);
                [self addButtonWithFrame:CGRectMake(x,y-3,buttonWidth+1,buttonWidth-4) tag:count image:nil title:[NSString stringWithFormat:@"%i",count]];
            }
            
            count--;
        }
    }
    y += buttonWidth;
    [self addButtonWithFrame:CGRectMake(BORDER_PADDING, y-7,buttonWidth+1,buttonWidth) tag:10 image:nil title:@"."];
    
    [self addButtonWithFrame:CGRectMake(BORDER_PADDING + buttonWidth, y-7,buttonWidth+1,buttonWidth) tag:0 image:nil title:@"0"];
    
    [self addButtonWithFrame:CGRectMake(BORDER_PADDING + (buttonWidth *2), y-7,buttonWidth+1,buttonWidth) tag:11 image:[UIImage imageNamed:@"crossbutton.png"] title:nil];
    
    
    UIButton *goButtonClicked = [UIButton buttonWithType:UIButtonTypeCustom];
    [goButtonClicked setTitle:@"GO" forState:UIControlStateNormal];
    [goButtonClicked setBackgroundColor:[UIColor colorWithRed:47.0/255 green:57.0/255 blue:66.0/255 alpha:1.0]];
    [goButtonClicked setFrame:CGRectMake(BORDER_PADDING, self.frame.size.height - BORDER_PADDING - 40, self.frame.size.width - (2 * BORDER_PADDING)+1, 29)];
    [goButtonClicked setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goButtonClicked addTarget:self action:@selector(goButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[goButtonClicked setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];

    [self addSubview:goButtonClicked];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (void) addButtonWithFrame:(CGRect)rect tag:(int)tag image:(UIImage *)image title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:rect];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = BORDER_COLOR.CGColor;
    [button setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [button setBackgroundColor:BUTTON_BG_COLOR];
    [button.titleLabel setFont:[UIFont systemFontOfSize:36]];
    button.tag = tag;
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    if (image)
    {
        [button setImage:image forState:UIControlStateNormal];
    }
    //[button setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [button.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:40]];

    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
}

- (void) buttonClicked: (UIButton *) button
{
    if (button.tag == 10) {
        NSRange textRange;
        textRange =[amoutTextField.text rangeOfString:@"."];
        
        if(textRange.location == NSNotFound)
        {
            [amoutTextField setText:[NSString stringWithFormat:@"%@.",amoutTextField.text]];
        }
    
    }
    else if (button.tag == 11) {
        
        
        NSArray *array = [amoutTextField.text componentsSeparatedByString:@"."];
        if (array.count > 1) {
            NSString *string = [array objectAtIndex:1];
            if (string.length ==2) {
            
            }
        }
        
        NSString *string = [amoutTextField text];
        if ( [string length] > 1)
        {
            string = [string substringToIndex:[string length] - 1];
            amoutTextField.text = string;
        }
    }
    else
    {
        NSArray *array = [amoutTextField.text componentsSeparatedByString:@"."];
        if (array.count > 1) {
            NSString *string = [array objectAtIndex:1];
            if (string.length ==2) {
                return;
            }
        }
    
       [amoutTextField setText:[NSString stringWithFormat:@"%@%i",amoutTextField.text,button.tag]];
    }
}

- (void) goButtonClicked
{
    NSString * amount = [amoutTextField.text stringByReplacingOccurrencesOfString:[[WarHorseSingleton sharedInstance] currencySymbel] withString:@""];
    if( [amount floatValue] <= 0.0 ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please enter a valid amount." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self.delegate selectedAmount:amoutTextField.text];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UITextField Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (textField == amoutTextField) {
        if ([textField.text isEqualToString:[[WarHorseSingleton sharedInstance] currencySymbel]] && range.length == 1)
        {
            return NO;
        }
        
        if (range.location == 0 || (range.location == 1 && [string isEqualToString:@"."])) {
            return NO;
        }
        
        if (([textField.text rangeOfString:@"."].location == NSNotFound) && [string isEqualToString:@"."]) {
            return YES;
        }
        
        
        if (range.length == 0 &&
            ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSArray *sep = [newString componentsSeparatedByString:@"."];
        if([sep count] >= 2)
        {
            NSString *sepStr=[NSString stringWithFormat:@"%@",[sep objectAtIndex:1]];
            return !([sepStr length]>2);
        }
        return YES;
    }

    return NO;
}


@end
