//
//  SPSettingPopOverView.h
//  WarHorse
//
//  Created by EnterPi on 23/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPSettingPopOverView;

@protocol SPSettingPopOverDelegate

- (void)didChangeComboBoxValue:(SPSettingPopOverView *)popOverViewClass selectedIndexPath:(NSInteger)selectedIndexPath;

@end

@interface SPSettingPopOverView : UIView

@property (nonatomic,assign) id<SPSettingPopOverDelegate> popOverDelegate;
@property (nonatomic, strong) NSString *globalOrderBy;

- (void)tableReloadDataInTable:(NSString *)popOverFlagStr;

@end
