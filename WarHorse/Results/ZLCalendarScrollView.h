//
//  ZLCalendarScrollView.h
//  WarHorse
//
//  Created by Sparity on 02/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZLCalendarScrollViewDelegate;


@interface ZLCalendarScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDateFormatter *dateFormater;
@property (nonatomic, strong) NSMutableArray *dateLabelsArray;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, weak) id<ZLCalendarScrollViewDelegate> delegate;

- (void) setUpSubView;


@end

@protocol ZLCalendarScrollViewDelegate <NSObject>

@optional

/**
 * @method imagePickerDidCancel: gets called when the user taps the cancel button
 * @param imagePicker, the image picker instance
 */
- (void)dateDidChange;

@end