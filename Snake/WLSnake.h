//
//  WLSnake.h
//  Widgets
//
//  Created by Wei Liu on 6/16/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WL2DPoint.h"

// protocol methods need to be implement at controller
@protocol WLSnakeProtocol <NSObject>
@optional
- (void)speedUp;  // controller which set the timer will reduce the update interval
@end

// snake moving direction
typedef NS_ENUM(NSInteger, SnakeDirection) {
  SnakeDirectionUp = 0,
  SnakeDirectionLeft,
  SnakeDirectionBottom,
  SnakeDirectionRight
};

// error
extern NSString * __nonnull const WLSnakeErrorDomain;
typedef NS_ENUM(NSInteger, WLSnakeErrorCode) {
  WLSnakeErrorCodeHitSelf = 0,
  WLSnakeErrorCodeHitBoundary
};


@interface WLSnake : NSObject

@property (nullable, nonatomic, readonly) NSMutableArray<WL2DPoint*> *body; // points for snake
@property (nonatomic) SnakeDirection direction;
@property (nonatomic, weak) id<WLSnakeProtocol> delegate;

- (nullable instancetype)initWithDelegate:(nullable id<WLSnakeProtocol>)delegate;

// calculate next head point based on current direction, will use this point to do some tests (boundary, hit self, eat food...)
- (nonnull WL2DPoint*)nextHeadPointWithError:(NSError*__nullable*__nullable)error
                            containedInPoint:(nonnull WL2DPoint*)maxPoint;

// eat food at point: food, simply add this point to body array
- (void)eatFoodAtPoint:(nonnull WL2DPoint*)food;

// move snake to next point: p
- (nonnull WL2DPoint*)moveToPoint:(nonnull WL2DPoint*)p;
@end
