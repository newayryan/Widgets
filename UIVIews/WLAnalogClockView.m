//
//  WLAnalogClockView.m
//  Widgets
//
//  Created by Wei Liu on 6/9/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import "WLAnalogClockView.h"

/***********Constants****************/

static CGPoint const anchorPoint = {0,0.5};

static CGFloat const kHourHandleWidthRatio = 0.25;
static CGFloat const kMinuteHandleWidthRatio = 0.4;
static CGFloat const kSecondHandleWidthRatio = 0.45;

static NSInteger const kHourCount = 12;

static CGFloat const kDegreePerUnit = M_PI * 2 / 60;

static CGSize const kCenterViewSize = {10,10};

static CGFloat const kBgBorderWidth = 2.0f;

@interface UIColor (WLAnalogClock)
+(UIColor*)grayColorLevel1;
+(UIColor*)grayColorLevel2;
+(UIColor*)grayColorLevel3;
@end

@implementation UIColor (WLAnalogClock)
+(UIColor*)grayColorLevel1 {
  return [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
}
+(UIColor*)grayColorLevel2 {
  return [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1];
}
+(UIColor*)grayColorLevel3 {
  return [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
}
@end

/************************************/

@interface WLAnalogClockView ()
@property (nonatomic) dispatch_source_t timerSource;

@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UIView *centerView;

@property (nonatomic) NSInteger minuteCounter;
@property (nonatomic) NSInteger hourCounter;

@property (nonatomic) BOOL alreadyTranslate;
@end

@implementation WLAnalogClockView

- (instancetype)init {
  if (self = [super init]) {
    [self createUIViews];
    [self createTimeLabel];
    [self createConstraints];
  }
  return self;
}

- (void)createUIViews {
  UIView *background = [UIView new];
  [self addSubview:background];
  background.backgroundColor = [UIColor clearColor];
  background.layer.borderColor = [UIColor lightGrayColor].CGColor;
  background.layer.borderWidth = kBgBorderWidth;
  _backgroundView = background;
  
  UIView *centerView = [UIView new];
  centerView.bounds = CGRectMake(0, 0, kCenterViewSize.width, kCenterViewSize.height);
  centerView.layer.cornerRadius = centerView.bounds.size.width/2;
  centerView.backgroundColor = [UIColor darkGrayColor];
  [_backgroundView addSubview:centerView];
  _centerView = centerView;
  
  UIView *second = [UIView new];
  second.backgroundColor = [UIColor grayColorLevel1];
  [_backgroundView addSubview:second];
  _secondView = second;
  _secondView.layer.anchorPoint = anchorPoint;
  
  UIView *minute = [UIView new];
  minute.backgroundColor = [UIColor grayColorLevel2];
  [_backgroundView addSubview:minute];
  _minuteView = minute;
  _minuteView.layer.anchorPoint = anchorPoint;
  
  UIView *hour = [UIView new];
  hour.backgroundColor = [UIColor grayColorLevel3];
  [_backgroundView addSubview:hour];
  _hourView = hour;
  _hourView.layer.anchorPoint = anchorPoint;
}

- (void)createConstraints {
  self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
  self.secondView.translatesAutoresizingMaskIntoConstraints = NO;
  self.minuteView.translatesAutoresizingMaskIntoConstraints = NO;
  self.hourView.translatesAutoresizingMaskIntoConstraints = NO;
  
  NSDictionary *viewDict = NSDictionaryOfVariableBindings(_backgroundView, _secondView, _minuteView, _hourView);
  NSDictionary *metrics = @{@"kHourHandleThick":@4, @"kMinuteHandleThick":@3, @"kSecondHandleThick":@2};
  // background view constraints
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundView]|" options:0 metrics:nil views:viewDict]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundView]" options:0 metrics:nil views:viewDict]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.f]];
  
  // second, minute, and hour (width, height)
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_secondView(kSecondHandleThick)]" options:0 metrics:metrics views:viewDict]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_minuteView(kMinuteHandleThick)]" options:0 metrics:metrics views:viewDict]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_hourView(kHourHandleThick)]" options:0 metrics:metrics views:viewDict]];
  [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_hourView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeWidth multiplier:kHourHandleWidthRatio constant:0.0f]];
  [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_minuteView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeWidth multiplier:kMinuteHandleWidthRatio constant:0.0f]];
  [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_secondView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeWidth multiplier:kSecondHandleWidthRatio constant:0.0f]];
  
  // second center
  [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_secondView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
  [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_secondView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
  
  // minute center
  [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_minuteView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
  [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_minuteView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
  
  // hour center
  [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_hourView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
  [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_hourView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
  
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.backgroundView.layer.cornerRadius = CGRectGetWidth(self.backgroundView.frame) / 2;
  self.centerView.center = self.backgroundView.center;

  // layout the time labels
  if (!self.alreadyTranslate) {
    self.alreadyTranslate = YES;
    for (int i = 1; i <= kHourCount; i++) {
      UIView *sub = [self.backgroundView viewWithTag:i];
      if (sub) {
        CGFloat angle = M_PI*2.0*i/12 - M_PI_2;
        CGFloat radius = 0.5 * (CGRectGetWidth(self.backgroundView.frame)) - 10;
        CGFloat x = radius * cos(angle);
        CGFloat y = radius * sin(angle);
        sub.transform = CGAffineTransformTranslate(sub.transform, x, y);
      }
    }
  }
}

#pragma mark - Private methods

- (void)createTimeLabel {
  for (int i = 1; i <= kHourCount; i++) {
    UILabel *label = [UILabel new];
    label.tag = i;
    label.text = [NSString stringWithFormat:@"%d",i];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:label];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[label(==15)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
    [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label(==15)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
    
    [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  }
}

- (void)moveSecond {
  self.secondView.transform = CGAffineTransformRotate(self.secondView.transform, kDegreePerUnit);
  
  self.minuteCounter++;
  NSRange secondRange = [[NSCalendar currentCalendar] minimumRangeOfUnit:NSCalendarUnitSecond];
  if (self.minuteCounter >= secondRange.length) {
    self.minuteCounter = 0;
    [self moveMinute];
  }
}

- (void)moveMinute {
  self.minuteView.transform = CGAffineTransformRotate(self.minuteView.transform, kDegreePerUnit);
  
  self.hourCounter++;
  NSRange minuteRange = [[NSCalendar currentCalendar] minimumRangeOfUnit:NSCalendarUnitMinute];
  if (self.hourCounter >= minuteRange.length/5) { // 5 * 12 = 60
    self.hourCounter = 0;
    [self moveHour];
  }
}

- (void)moveHour {
  self.hourView.transform = CGAffineTransformRotate(self.hourView.transform, kDegreePerUnit);
}

- (void)initTimerAtTime:(NSDate*)date {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
  
  self.minuteCounter = [components second];
  self.hourCounter = [components minute];
  
  // normalize hour
  NSInteger hour = [components hour];
  if (hour > kHourCount) {
    hour -= kHourCount;
  }
  
  CGFloat hourAngle = M_PI * 2 * (1.0 * hour / kHourCount) - M_PI_2;
  CGFloat minuteAngle = M_PI * 2 * (1.0 * [components minute] / [calendar minimumRangeOfUnit:NSCalendarUnitMinute].length) - M_PI_2;
  CGFloat secondAngle = M_PI * 2 * (1.0 * [components second] / [calendar minimumRangeOfUnit:NSCalendarUnitSecond].length) - M_PI_2;
  // hour angle need to add the minute offset
  hourAngle += M_PI * 2 / kHourCount * [components minute] / [calendar minimumRangeOfUnit:NSCalendarUnitMinute].length;
  
  self.hourView.transform = CGAffineTransformRotate(self.hourView.transform, hourAngle);
  self.minuteView.transform = CGAffineTransformRotate(self.minuteView.transform, minuteAngle);
  self.secondView.transform = CGAffineTransformRotate(self.secondView.transform, secondAngle);
}

#pragma mark - Public methods

- (void)startTimer {
  [self startTimerAtTime:[NSDate date]];
}

- (void)startTimerAtTime:(NSDate*)date {
  [self initTimerAtTime:date];
  
  if (!self.timerSource) {
    dispatch_queue_t timerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timerQueue);
    if (_timerSource) {
      dispatch_source_set_timer(_timerSource, dispatch_walltime(NULL, 0), 1ull * NSEC_PER_SEC, 0);
      dispatch_source_set_event_handler(_timerSource, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
          [self moveSecond];
        });
        
      });
      dispatch_resume(_timerSource);
    }
  }
}

- (void)invalidate {
  dispatch_source_cancel(self.timerSource);
  self.timerSource = nil;
}

@end
