//
//  WLSnakeBoardView.m
//  Widgets
//
//  Created by Wei Liu on 6/16/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import "WLSnakeBoardView.h"

@interface WLSnakeBoardView ()

@property (nonatomic) NSInteger rows; // board rows
@property (nonatomic) NSInteger cols; // board columns
@property (nonatomic) CGSize blockSize;

@property (nonatomic) CAShapeLayer *bgLayer;  // grid layer

@property (nonatomic) NSDictionary *pointsToDraw; // need to hold the points-color dictionary - we will use it in -drawRect:

@end

@implementation WLSnakeBoardView

- (nullable instancetype)initWithRow:(NSInteger)rows
                              andCol:(NSInteger)cols {
  if ([super init]) {
    _rows = rows;
    _cols = cols;
    _shouldDrawGrids = NO;
    _pointsToDraw = [NSDictionary dictionary];
    _blockSize = CGSizeZero;
    
    self.backgroundColor = [UIColor whiteColor]; // avoid clearColor if no need
  }
  return self;
}

// override the -drawRect: method to draw a. grids if needed; b. points if needed
- (void)drawRect:(CGRect)rect {
  [self drawGridsIfNeeded];
  [self drawPointsIfNeeded];
}

- (void)drawPointsIfNeeded {
  if (self.pointsToDraw.count == 0) return;
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  for (NSArray *array in [self.pointsToDraw allKeys]) {
    UIColor *currentColor = self.pointsToDraw[array];
    
    CGContextSetFillColorWithColor(context, currentColor.CGColor);
    for (WL2DPoint *p in array) {
      CGContextFillRect(context, CGRectMake(p.pX*self.blockSize.width, p.pY*self.blockSize.height, self.blockSize.width, self.blockSize.height));
    }
  }
  
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)drawGridsIfNeeded {
  self.bgLayer.hidden = self.shouldDrawGrids;
}

#pragma mark - Setter/Getter

- (void)setShouldDrawGrids:(BOOL)drawGrids {
  _shouldDrawGrids= drawGrids;
  [self setNeedsDisplay];
}

- (CGSize)blockSize {
  if (CGSizeEqualToSize(_blockSize, CGSizeZero)) {
    _blockSize = CGSizeMake(CGRectGetHeight(self.bounds)/self.rows, CGRectGetWidth(self.bounds)/self.cols);
  }
  return _blockSize;
}

// Create a background layer here used to draw grids, then insert it to the self.layer
// TODO: Frame change?
- (CAShapeLayer*)bgLayer {
  if (!_bgLayer) {
    
    UIBezierPath *gridPath = [UIBezierPath bezierPath];
    
    for (int i = 0; i <= self.rows; i++) {
      [gridPath moveToPoint:CGPointMake(0, i*self.blockSize.height)];
      [gridPath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), i*self.blockSize.height)];
    }
    
    for (int i = 0; i <= self.cols; i++) {
      [gridPath moveToPoint:CGPointMake(i*self.blockSize.width, 0)];
      [gridPath addLineToPoint:CGPointMake(i*self.blockSize.width, CGRectGetHeight(self.bounds))];
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.anchorPoint = CGPointMake(0, 0);
    layer.bounds = self.bounds;
    layer.lineWidth = 1;
    layer.strokeColor = [UIColor darkGrayColor].CGColor;
    layer.path = gridPath.CGPath;
    [self.layer addSublayer:layer];
  }
  return _bgLayer;
}

#pragma mark - Public methods

- (void)drawPointsWithColor:(NSDictionary *)pointsWithColor {
  self.pointsToDraw = pointsWithColor;
  [self setNeedsDisplay];
}

@end
