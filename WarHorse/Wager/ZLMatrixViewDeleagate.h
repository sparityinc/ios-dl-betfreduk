//
//  ZLMatrixViewDeleagate.h
//  OddsMatrix
//
//  Created by Sparity on 08/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZLMatrixViewDelegate <NSObject>

@optional
- (CGFloat) widthForCellInMatrixView:(id)matrixView;
- (CGFloat) heightForCellInMatrixView:(id)matrixView;
- (NSString *) matrixView:(id)matrixView titleForRow:(NSInteger)row forColumn:(NSInteger)column;
- (NSString *) matrixView:(id)matrixView headerForColumn:(NSInteger)column;
- (NSString *) matrixView:(id)matrixView headerForRow:(NSInteger)row;
- (UIColor *) backgroundColorCellIndex:(NSUInteger)index;
- (UIColor *) textColorCellIndex:(NSUInteger)index;
-(void) tapedCellWithRow:(NSUInteger) row andWIthColumn:(NSUInteger)column;

@required
- (NSUInteger) numberOfRowsInMatrixView:(id)matrixView;
- (NSUInteger) numberOfColumnsInMatrixView:(id)matrixView;


@end
