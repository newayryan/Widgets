//
//  ViewController.m
//  Widgets
//
//  Created by Wei Liu on 6/9/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import "ViewController.h"
#import "WLAnalogClockView.h"

@interface ViewController ()
@property (nonatomic, weak) WLAnalogClockView *clockView;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  WLAnalogClockView *clock = [WLAnalogClockView new];  
  [clock startTimer];
  [self.view addSubview:clock];
  _clockView = clock;
  
  // add constraints
  _clockView.translatesAutoresizingMaskIntoConstraints = NO;
  NSDictionary *viewDict = NSDictionaryOfVariableBindings(_clockView);
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_clockView(==200)]-(>=10)-|" options:0 metrics:nil views:viewDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_clockView(==200)]" options:0 metrics:nil views:viewDict]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:clock attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

- (void)dealloc {
  [self.clockView invalidate];
}

@end
