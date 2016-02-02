//
//  ZLMatrixView.h
//  OddsMatrix
//
//  Created by Sparity on 08/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLMatrixView : UIView <UIScrollViewDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet id delegate;
@property (nonatomic, assign) NSInteger tag;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate tag:(NSInteger)tag;
@end
