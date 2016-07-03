//
//  UIButton+WLSnake.m
//  Widgets
//
//  Created by Wei Liu on 7/2/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import "UIButton+WLSnake.h"

@implementation UIButton (WLSnake)

+ (UIButton*)snakeButtonWithEvent:(SEL)action
                         andTitle:(NSString *)title
                        andTarget:(id)target {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.layer.borderColor = [UIColor grayColor].CGColor;
  button.layer.borderWidth = 1;
  [button setTitle:title forState:UIControlStateNormal];
  [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  return button;
}

+ (UIButton*)controlButtonWithEvent:(SEL)action
                           andTitle:(NSString *)title
                          andTarget:(id)target {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.layer.borderColor = [UIColor grayColor].CGColor;
  button.layer.borderWidth = 1;
  button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
  [button setTitle:title forState:UIControlStateNormal];
  [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  return button;
}

@end
