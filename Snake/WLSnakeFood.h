//
//  WLSnakeFood.h
//  Widgets
//
//  Created by Wei Liu on 6/16/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WL2DPoint.h"

@interface WLSnakeFood : NSObject

@property (nullable, nonatomic) NSArray<WL2DPoint*> *foodLocation;

// food point will be in [0...row][0...col]
- (nullable instancetype)initWithMaxRow:(NSInteger)row
                              andMaxCol:(NSInteger)col;

// generate a random point, but this point should not in points
- (void)generateLocationExcludePoints:(nullable NSArray*)points;

@end
