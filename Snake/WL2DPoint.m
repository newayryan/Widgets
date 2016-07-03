//
//  WL2DPoint.m
//  Widgets
//
//  Created by Wei Liu on 6/19/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import "WL2DPoint.h"

@implementation WL2DPoint

+ (WL2DPoint*)X:(NSInteger)x
           andY:(NSInteger)y {
  WL2DPoint *point = [WL2DPoint new];
  point.pX = x;
  point.pY = y;
  return point;
}
- (BOOL)equalToPoint:(WL2DPoint*)p {
  return self.pX == p.pX && self.pY == p.pY;
}

- (BOOL)isEqual:(id)object {
  if (self == object) return YES;
  if (![object isKindOfClass:[WL2DPoint class]]) return NO;
  return [self equalToPoint:object];
}

- (NSString*)description {
  return [NSString stringWithFormat:@"x: %ld, y: %ld", (long)self.pX, (long)self.pY];
}

- (WL2DPoint*)increaseX {
  return [WL2DPoint X:self.pX+1 andY:self.pY];
}

- (WL2DPoint*)increaseY {
  return [WL2DPoint X:self.pX andY:self.pY+1];
}

- (WL2DPoint*)decreaseY {
  return [WL2DPoint X:self.pX andY:self.pY-1];
}

- (WL2DPoint*)decreaseX {
  return [WL2DPoint X:self.pX-1 andY:self.pY];
}
@end
