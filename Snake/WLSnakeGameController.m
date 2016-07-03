//
//  WLSnakeGameController.m
//  Widgets
//
//  Created by Wei Liu on 6/16/16.
//  Copyright © 2016 WL. All rights reserved.
//

#import "WLSnakeGameController.h"
#import "WLSnakeBoardView.h"
#import "WLSnakeControlView.h"
#import "WLSnake.h"
#import "WLSnakeFood.h"
#import "UIColor+WLSnake.h"

// TODO: fixed board view and control view size, can we not use fixed values?
static CGSize const kBoardSize = {350,350};
static CGSize const kControlSize = {300, 200};

@interface WLSnakeGameController () <WLSnakeControlProtocol, WLSnakeProtocol>

@property (nonatomic) NSInteger boardRows;
@property (nonatomic) NSInteger boardCols;
@property (nonatomic) BOOL      isPaused;    // pause the game

@property (nonatomic) WLSnakeBoardView    *boardView;
@property (nonatomic) WLSnakeControlView  *controlView;
@property (nonatomic) WLSnake             *snake;
@property (nonatomic) WLSnakeFood         *food;

@property (nonatomic) NSTimer *gameTimer;
@property (nonatomic) CGFloat timerInterval;
@end

@implementation WLSnakeGameController

- (nullable instancetype)initWithRows:(NSInteger)row
                             andCount:(NSInteger)col {
  if ([super init]) {
    _boardRows = row;
    _boardCols = col;
    _isPaused = NO;
    
    [self setupUI];
    [self setConstraints];
  }
  return self;
}

- (void)setupUI {
  self.view.backgroundColor = [UIColor whiteColor]; // avoid clearColor if needed
  _boardView = [[WLSnakeBoardView alloc] initWithRow:self.boardRows andCol:self.boardCols];
  [self.view addSubview:_boardView];
  _controlView = [[WLSnakeControlView alloc] initWithDelegate:self];
  [self.view addSubview:_controlView];
  
  [self resetGame];
}

- (void)setConstraints {
  self.boardView.translatesAutoresizingMaskIntoConstraints = NO;
  self.controlView.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_boardView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:kBoardSize.width]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_boardView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:kBoardSize.height]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_boardView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_boardView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:0.8f constant:0.f]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_controlView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:kControlSize.width]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_controlView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:kControlSize.height]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_controlView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_controlView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_boardView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:50.f]];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.boardView.shouldDrawGrids = YES;
}

#pragma mark - Utility/Private methods

// invalidate the timer, and recreate snake, food, and draw points on board view
- (void)resetGame {
  if ([_gameTimer isValid]) {
    [_gameTimer invalidate];
  }
  _snake = [[WLSnake alloc] initWithDelegate:self];
  _food = [[WLSnakeFood alloc] initWithMaxRow:self.boardRows andMaxCol:self.boardCols];
  [_food generateLocationExcludePoints:_snake.body];
  [self.boardView drawPointsWithColor:@{self.snake.body:[UIColor snakeColor], self.food.foodLocation:[UIColor snakeFoodColor]}];
}

// game logic goes here
- (void)tick:(NSTimer*)timer {
  // first get next snake point based on its current direction
  NSError *error = nil;
  WL2DPoint *nextPoint = [self.snake nextHeadPointWithError:&error containedInPoint:[WL2DPoint X:self.boardRows andY:self.boardCols]];
  WL2DPoint *removedPoint = nil;
  
  if (error) {
    // currently don't use the error code
    [self pauseButtonTapped];
    [self showSnakeDead];
    return;
  } else if ([nextPoint equalToPoint:self.food.foodLocation[0]]) {
    // food point, eat it
    [self.snake eatFoodAtPoint:self.food.foodLocation[0]];
    [self.food generateLocationExcludePoints:self.snake.body];
  } else {
    // simply move to next point
    removedPoint = [self.snake moveToPoint:nextPoint];
  }
  
  NSDictionary *dict = @{self.snake.body:[UIColor snakeColor], self.food.foodLocation:[UIColor snakeFoodColor]};
  [self.boardView drawPointsWithColor:dict];
}

- (void)showSnakeDead {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Get Killed, Please restart", nil) preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *restart = [UIAlertAction actionWithTitle:NSLocalizedString(@"Restart", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self resetButtonTapped];
  }];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
  [alertController addAction:restart];
  [alertController addAction:cancelAction];
  [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Snake delegate

// for -speedUp we just simply reduce the timer interval, call the selector more frequently
- (void)speedUp {
  [self.gameTimer invalidate];
  _timerInterval *= 0.8;
  self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:_timerInterval target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

#pragma mark - Control delegate and methods

- (void)upButtonTapped {
  [self.snake setDirection:SnakeDirectionUp];
}

- (void)leftButtonTapped {
  [self.snake setDirection:SnakeDirectionLeft];
}

- (void)bottomButtonTapped {
  [self.snake setDirection:SnakeDirectionBottom];
}

- (void)rightButtonTapped {
  [self.snake setDirection:SnakeDirectionRight];
}

// TODO: implement button disable/enable logic
- (void)startButtonTapped {
  _timerInterval = 1.0f;
  if ([_gameTimer isValid]) {
    [_gameTimer invalidate];
  }
  _gameTimer = [NSTimer scheduledTimerWithTimeInterval:_timerInterval target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

- (void)resetButtonTapped {
  [self resetGame];
}

- (void)pauseButtonTapped {
  self.isPaused = !self.isPaused;
  if (self.isPaused) {
    [self.gameTimer invalidate];
  } else {
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:_timerInterval target:self selector:@selector(tick:) userInfo:nil repeats:YES];
  }
}

@end
