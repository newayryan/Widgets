//
//  UIButton+WLSnake.h
//  Widgets
//
//  Created by Wei Liu on 7/2/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WLSnake)

+ (UIButton*)snakeButtonWithEvent:(SEL)action
                         andTitle:(NSString *)title
                        andTarget:(id)target;
+ (UIButton*)controlButtonWithEvent:(SEL)action
                           andTitle:(NSString *)title
                          andTarget:(id)target;
@end
