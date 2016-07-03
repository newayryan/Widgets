//
//  WL2DPoint.h
//  Widgets
//
//  Created by Wei Liu on 6/19/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import <Foundation/Foundation.h>

// a light wrapper for 2d NSInteger point object
@interface WL2DPoint : NSObject

@property (nonatomic) NSInteger pX;
@property (nonatomic) NSInteger pY;

+ (WL2DPoint*)X:(NSInteger)x
           andY:(NSInteger)y;
- (BOOL)equalToPoint:(WL2DPoint*)p;
- (WL2DPoint*)increaseX;
- (WL2DPoint*)increaseY;
- (WL2DPoint*)decreaseY;
- (WL2DPoint*)decreaseX;
@end
