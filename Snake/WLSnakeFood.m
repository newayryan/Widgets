//
//  WLSnakeFood.m
//  Widgets
//
//  Created by Wei Liu on 6/16/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import "WLSnakeFood.h"
#include <stdlib.h>

@interface WLSnakeFood ()
@property (nonatomic) NSInteger     maxRow;
@property (nonatomic) NSInteger     maxCol;
@property (nonatomic) NSMutableSet *allPointsSet;
@end

@implementation WLSnakeFood

- (nullable instancetype)initWithMaxRow:(NSInteger)row
                              andMaxCol:(NSInteger)col {
  if ([super init]) {
    _maxCol = col;
    _maxRow = row;
    _allPointsSet = [NSMutableSet set];
    for (int i = 0; i < self.maxCol*self.maxRow; i++) {
      [_allPointsSet addObject:[NSNumber numberWithInt:i]];
    }
  }
  return self;
}

- (NSMutableSet *)parseToSet:(NSArray *)points {
  NSMutableSet *set = [NSMutableSet set];
  for (WL2DPoint *p in points) {
    [set addObject:[NSNumber numberWithInteger:p.pX*self.maxCol+p.pY]];
  }
  return set;
}

- (void)generateLocationExcludePoints:(NSArray*)points {
  
  NSMutableSet *availableSet = [self.allPointsSet mutableCopy];
 
  NSMutableSet *pointsSet = [self parseToSet:points];
  [availableSet minusSet:pointsSet];
  NSArray *leftPoints = [availableSet allObjects];
  
  int rValue = arc4random_uniform((int)leftPoints.count);
  
  int randomX = [leftPoints[rValue] intValue] / self.maxCol;
  int randomY = [leftPoints[rValue] intValue] % self.maxCol;
  self.foodLocation = [NSArray arrayWithObject:[WL2DPoint X:randomX andY:randomY]];
}

@end
