//
//  WLSnakeControlView.m
//  Widgets
//
//  Created by Wei Liu on 6/17/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import "WLSnakeControlView.h"
#import "UIButton+WLSnake.h"

static CGSize const kButtonSize = {80,40};

@interface WLSnakeControlView ()
@property (nonatomic, weak) id<WLSnakeControlProtocol> controlDelegate;
@end

@implementation WLSnakeControlView

- (nullable instancetype)initWithDelegate:(id<WLSnakeControlProtocol>)delegate {
  if (self = [super init]) {
    _controlDelegate = delegate;
    
    [self setupUIAndConstraints];
  }
  return self;
}

- (void)setupUIAndConstraints {
  
  self.backgroundColor = [UIColor blueColor];
  UIButton *upButton = [UIButton snakeButtonWithEvent:@selector(upButtonTapped:) andTitle:NSLocalizedString(@"Up", nil) andTarget:self];
  [self addSubview:upButton];
  
  UIButton *leftButton = [UIButton snakeButtonWithEvent:@selector(leftButtonTapped:) andTitle:NSLocalizedString(@"Left", nil) andTarget:self];
  [self addSubview:leftButton];
  
  UIButton *bottomButton = [UIButton snakeButtonWithEvent:@selector(bottomButtonTapped:) andTitle:NSLocalizedString(@"Bottom", nil) andTarget:self];
  [self addSubview:bottomButton];
  
  UIButton *rightButton = [UIButton snakeButtonWithEvent:@selector(rightButtonTapped:) andTitle:NSLocalizedString(@"Right", nil) andTarget:self];
  [self addSubview:rightButton];
  
  UIButton *startButton = [UIButton controlButtonWithEvent:@selector(startButtonTapped:) andTitle:NSLocalizedString(@"Start", nil) andTarget:self];
  startButton.tag = 1;
  [self addSubview:startButton];
  
  UIButton *pauseButton = [UIButton controlButtonWithEvent:@selector(pauseButtonTapped:) andTitle:NSLocalizedString(@"Pause", nil) andTarget:self];
  pauseButton.tag = 2;
  [self addSubview:pauseButton];
  
  UIButton *resetButton = [UIButton controlButtonWithEvent:@selector(resetButtonTapped:) andTitle:NSLocalizedString(@"Reset", nil) andTarget:self];
  resetButton.tag = 3;
  [self addSubview:resetButton];
  
  // constraints
  upButton.translatesAutoresizingMaskIntoConstraints = NO;
  leftButton.translatesAutoresizingMaskIntoConstraints = NO;
  bottomButton.translatesAutoresizingMaskIntoConstraints = NO;
  rightButton.translatesAutoresizingMaskIntoConstraints = NO;
  startButton.translatesAutoresizingMaskIntoConstraints = NO;
  pauseButton.translatesAutoresizingMaskIntoConstraints = NO;
  resetButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  NSDictionary *viewDict = NSDictionaryOfVariableBindings(upButton, leftButton, rightButton, bottomButton, startButton, pauseButton, resetButton);
  NSDictionary *metrics = @{@"ButtonWidth":@(kButtonSize.width), @"ButtonHeight":@(kButtonSize.height), @"Margin":@5};
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[upButton(==ButtonHeight)]-Margin-[leftButton(==ButtonHeight)]-Margin-[bottomButton(==ButtonHeight)]" options:0 metrics:metrics views:viewDict]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[upButton(==ButtonHeight)]-Margin-[rightButton(==ButtonHeight)]-Margin-[bottomButton(==ButtonHeight)]" options:0 metrics:metrics views:viewDict]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-Margin-[startButton]-(>=1)-[leftButton(==ButtonHeight)]" options:0 metrics:metrics views:viewDict]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftButton(==ButtonWidth)]-Margin-[upButton(==ButtonWidth)]-Margin-[rightButton(==ButtonWidth)]" options:0 metrics:metrics views:viewDict]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftButton(==ButtonWidth)]-Margin-[bottomButton(==ButtonWidth)]-Margin-[rightButton(==ButtonWidth)]" options:0 metrics:metrics views:viewDict]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-Margin-[startButton]-Margin-[pauseButton]-(>=1)-[upButton(==ButtonWidth)]-(>=1)-[resetButton]-Margin-|" options:0 metrics:metrics views:viewDict]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:startButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:kButtonSize.height]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:startButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:kButtonSize.height]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:pauseButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:kButtonSize.height]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:pauseButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:kButtonSize.height]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:pauseButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:startButton attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:resetButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:kButtonSize.height]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:resetButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:kButtonSize.height]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:resetButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:startButton attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:upButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:bottomButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:leftButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:rightButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.]];
}

// add rounded effect for buttons
- (void)layoutSubviews {
  [super layoutSubviews];
  
  UIView *start = [self viewWithTag:1];
  UIView *pause = [self viewWithTag:2];
  UIView *reset = [self viewWithTag:3];
  start.layer.cornerRadius = pause.layer.cornerRadius = reset.layer.cornerRadius = start.frame.size.width * 0.5;
}

#pragma mark - delegate methods

- (void)upButtonTapped:(id)sender {
  if (self.controlDelegate && [self.controlDelegate respondsToSelector:@selector(upButtonTapped)]) {
    [self.controlDelegate upButtonTapped];
  }
}

- (void)leftButtonTapped:(id)sender {
  if (self.controlDelegate && [self.controlDelegate respondsToSelector:@selector(leftButtonTapped)]) {
    [self.controlDelegate leftButtonTapped];
  }
}

- (void)bottomButtonTapped:(id)sender {
  if (self.controlDelegate && [self.controlDelegate respondsToSelector:@selector(bottomButtonTapped)]) {
    [self.controlDelegate bottomButtonTapped];
  }
}

- (void)rightButtonTapped:(id)sender {
  if (self.controlDelegate && [self.controlDelegate respondsToSelector:@selector(rightButtonTapped)]) {
    [self.controlDelegate rightButtonTapped];
  }
}

- (void)startButtonTapped:(id)sender {
  if (self.controlDelegate && [self.controlDelegate respondsToSelector:@selector(rightButtonTapped)]) {
    [self.controlDelegate startButtonTapped];
  }
}

- (void)pauseButtonTapped:(id)sender {
  if (self.controlDelegate && [self.controlDelegate respondsToSelector:@selector(rightButtonTapped)]) {
    [self.controlDelegate pauseButtonTapped];
  }
}

- (void)resetButtonTapped:(id)sender {
  if (self.controlDelegate && [self.controlDelegate respondsToSelector:@selector(rightButtonTapped)]) {
    [self.controlDelegate resetButtonTapped];
  }
}

@end
