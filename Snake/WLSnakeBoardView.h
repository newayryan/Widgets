//
//  WLSnakeBoardView.h
//  Widgets
//
//  Created by Wei Liu on 6/16/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WL2DPoint.h"

@interface WLSnakeBoardView : UIView

// show/hide grids, default = NO
@property (nonatomic) BOOL shouldDrawGrids;

/* 
 @brief initialize board view, pass row number and col number
 */
- (nullable instancetype)initWithRow:(NSInteger)rows
                              andCol:(NSInteger)cols;
/*
 @brief draw method on board view, will call -drawRect: to draw points with color
 @param dictionary, key is points array and value is the color for this array
 */
- (void)drawPointsWithColor:(nullable NSDictionary*)pointsWithColor;
@end
