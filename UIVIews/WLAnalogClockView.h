//
//  WLAnalogClockView.h
//  Widgets
//
//  Created by Wei Liu on 6/9/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLAnalogClockView : UIView

/*
 *@brief Expose them just for customization 
 */
@property (nonatomic, weak) UIView *secondView;
@property (nonatomic, weak) UIView *minuteView;
@property (nonatomic, weak) UIView *hourView;

/*
 *@brief Call startTimer when start from current time
 */
- (void)startTimer;

/*
 *@brief Call startTimer when start from specific time
 */
- (void)startTimerAtTime:(NSDate*)date;

/*
 *@brief Called when remove clock view
 */
- (void)invalidate;

@end
