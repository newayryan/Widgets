//
//  WLSnake.m
//  Widgets
//
//  Created by Wei Liu on 6/16/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import "WLSnake.h"

// error
NSString *const WLSnakeErrorDomain = @"WLSnakeErrorDomain";

@interface WLSnake ()
@property (nonatomic,readwrite) NSMutableArray *body;
@end

@implementation WLSnake

- (nullable instancetype)initWithDelegate:(nullable id<WLSnakeProtocol>)delegate {
  if ([super init]) {
    _body = [NSMutableArray array];
    _delegate = delegate;
    // init direction to right and on the top-left corner
    _direction = SnakeDirectionRight;
    // init snake at top-left corner
    [_body addObject:[WL2DPoint X:0 andY:0]];
  }
  return self;
}

- (void)setDirection:(SnakeDirection)direction {
  _direction = direction;
}

- (WL2DPoint*)generateNextPoint {
  // head is last point in body array
  WL2DPoint *head = self.body.lastObject;
  switch (self.direction) {
    case SnakeDirectionRight:
    {
      return [head increaseX];
    }
      break;
    case SnakeDirectionBottom:
    {
      return [head increaseY];
    }
      break;
    case SnakeDirectionLeft:
    {
      return [head decreaseX];
    }
      break;
    case SnakeDirectionUp:
    {
      return [head decreaseY];
    }
      break;
    default:
      return [WL2DPoint X:0 andY:0];
      break;
  }
}

- (BOOL)isPointInBody:(WL2DPoint*)p {
  if ([self.body containsObject:p]) {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - Public methods

// next head point, calculated based on current direction
- (WL2DPoint*)nextHeadPointWithError:(NSError**)error
                    containedInPoint:(WL2DPoint*)maxPoint {
  WL2DPoint *nextPoint = [self generateNextPoint];
  // self.body
  if ([self isPointInBody:nextPoint]) {
    *error = [NSError errorWithDomain:WLSnakeErrorDomain code:WLSnakeErrorCodeHitSelf userInfo:nil];
    return nextPoint;
  }
  
  // boundary
  if (nextPoint.pX < 0 || nextPoint.pX >= maxPoint.pX || nextPoint.pY < 0 || nextPoint.pY >= maxPoint.pY) {
    *error = [NSError errorWithDomain:WLSnakeErrorDomain code:WLSnakeErrorCodeHitBoundary userInfo:nil];
    return nextPoint;
  }
  return nextPoint;
}

- (void)eatFoodAtPoint:(WL2DPoint*)food {
  [self.body addObject:food];
  if (self.delegate && [self.delegate respondsToSelector:@selector(speedUp)]) {
    [self.delegate speedUp];
  }
}

- (WL2DPoint*)moveToPoint:(WL2DPoint*)p {
  WL2DPoint *removedPoint = self.body[0];
  [self.body removeObjectAtIndex:0];
  [self.body addObject:p];
  
  return removedPoint;
}

@end
