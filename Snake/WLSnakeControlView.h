//
//  WLSnakeControlView.h
//  Widgets
//
//  Created by Wei Liu on 6/17/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WLSnakeControlProtocol <NSObject>

- (void)upButtonTapped;
- (void)leftButtonTapped;
- (void)bottomButtonTapped;
- (void)rightButtonTapped;

- (void)startButtonTapped;
- (void)pauseButtonTapped;
- (void)resetButtonTapped;

@end

@interface WLSnakeControlView : UIView

- (nullable instancetype)initWithDelegate:(nullable id<WLSnakeControlProtocol>)delegate;
@end
