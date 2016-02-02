//
//  LeveyHUD.m
//  Amgonna
//
//  Created by Sparity on 12/09/13.
//  Copyright (c) 2012 Sparity. All rights reserved.
//

#import "LeveyHUD.h"
#import "LeveyHUDBottomMask.h"
#import "LeveyHUDTopMask.h"



#define MASKOFFSET 30.0f
//static LeveyHUD *_sharedHUD = nil;

@implementation LeveyHUD

#pragma mark - Initialization
- (id)init
{
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]])
    {
        
        self.hidden = YES;
        // self.windowLevel = UIWindowLevelAlert;
        self.windowLevel = UIWindowLevelStatusBar;
        
        //self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
        self.backgroundColor = [UIColor clearColor];
        
        _label = [[UILabel alloc] init];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {//  (150, 250, 40, 40)
            
            _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(85, 255, 150, 50)];
            //            _label.font = [UIFont boldSystemFontOfSize:12.0f];
            [_label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
            
        }
        else {
            _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(184, 300, 400, 150)];
            _label.font = [UIFont boldSystemFontOfSize:30.0f];
            
        }
        _backgroundView.backgroundColor =[UIColor colorWithWhite: 0.0 alpha: 0.8];
        // _backgroundView.backgroundColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:0.8];
        _backgroundView.layer.cornerRadius = 10.0f;
        [self addSubview:_backgroundView];
        
        
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        //_label.layer.cornerRadius = 5.0;
        _label.adjustsFontSizeToFitWidth = YES;
        //_label.backgroundColor = [UIColor redColor];
        [_backgroundView addSubview:_label];
        
        //        _label.shadowColor = [UIColor blackColor];
        // _label.shadowOffset = CGSizeMake(0, 1);
        
        
        //  [self addSubview:_label];
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        //[self addSubview:_spinner];
        [_backgroundView addSubview:_spinner];
        
        
        
        
        
    }
    return  self;
}


+ (id)sharedHUD
{
    static dispatch_once_t once;
    static id sharedHUD;
    dispatch_once(&once, ^{
        sharedHUD = [[self alloc] init];
    });
    return sharedHUD;
}




/*
 + (id)sharedHUD
 {
 @synchronized(self)
 {
 if (_sharedHUD == nil)
 {
 [[[self alloc] init] autorelease];
 }
 }
 return _sharedHUD;
 }
 
 + (id)allocWithZone:(NSZone *)zone
 {
 @synchronized(self)
 {
 if (_sharedHUD == nil) {
 _sharedHUD = [super allocWithZone:zone];
 return _sharedHUD;
 }
 }
 return nil;
 }
 
 - (id)copyWithZone:(NSZone *)zone
 {
 return self;
 }
 
 - (id)retain
 {
 return self;
 }
 
 - (unsigned)retainCount
 {
 return UINT_MAX;  //denotes an object that cannot be released
 }
 - (oneway void)release{
 
 }
 
 */

#pragma mark - view's methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        _label.frame = CGRectMake(5, 27 ,140, 20);
    }
    else {
        _label.frame = CGRectMake(0, 26 ,400, 40);
        
    }}


#pragma mark - instant methods
- (void)appearWithText:(NSString *)text
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {//  (10 , 10, 20, 20)
        
        _spinner.frame = CGRectMake(70 , 6, 20, 20);
    }
    else {
        _spinner.frame = CGRectMake(170 , 80, 60, 60);
        
    }
    
    _label.text = text;
    if (self.hidden == NO)
    {
        return;
    }
    
    self.hidden = NO;
    
    self.alpha = 0.0f;
    _label.hidden = YES;
    [UIView animateWithDuration:.1f animations:^{
        self.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [_spinner startAnimating];
            _label.hidden = NO;
        }
    }];
    
    
}
- (void)disappear
{
    if (self.hidden == YES)
    {
        return;
    }
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            [_spinner stopAnimating];
            _label.text = @"";
            self.hidden = YES;
        }
    }];
}

- (void)delayDisappear:(NSTimeInterval)delay withText:(NSString *)text
{
    [_spinner stopAnimating];
    _label.text = text;
    [self performSelector:@selector(disappear) withObject:nil afterDelay:delay];
}

@end
