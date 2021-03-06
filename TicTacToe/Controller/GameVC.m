//
//  GameVC.m
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "GameVC.h"
#import "Colorscheme.h"
#import "Board.h"
#import "AI.h"
#import "NSString+FontAwesome.h"

@interface GameVC ()

@property (strong, nonatomic) IBOutlet UIView *gridContainer;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;

@property (strong, nonatomic) AI *ai;
@property (strong, nonatomic) Board *board;
@property (strong, nonatomic) ZZActivity *gameActivity;

@property (strong, nonatomic) UILabel *spinnerLabel;

@property (nonatomic) BOOL isMyTurn;
@property (nonatomic) unsigned int movesPlayed;
- (void)movePlayed;
@end

@implementation GameVC

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.gridWidth = 3;
        self.gridHeight = 3;
        // Instantiate AI`
        self.ai = [[AI alloc] init];
        self.board = [[Board alloc] init];
        self.isMultiplayer = YES;
    }
    return self;
}

- (void)activityLoaded:(NSNotification *)note {
    NSLog(@"we're here Jim.");
    NSDictionary *dict = [note userInfo];
    ZZActivity *activity = (ZZActivity *)dict[@"ACTIVITY"];
    self.gameActivity = activity;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Notifications
        self.gridWidth = 3;
        self.gridHeight = 3;
        // Instantiate AI
        self.ai = [[AI alloc] init];
        self.board = [[Board alloc] init];
        
        CGRect rect = CGRectMake(84, 212, 600, 600);
                
        self.gridContainer = [[UIView alloc] initWithFrame:rect];
        
        CGRect rectButton = CGRectMake(209, 904, 350, 100);
        self.resetButton = [[UIButton alloc] initWithFrame:rectButton];
        [self.resetButton setTitle:@"Reset" forState:UIControlStateNormal];
        self.resetButton.titleLabel.font     = [UIFont fontWithName:@"Fabada" size:44];
        [self.resetButton setTitleColor:[Colorscheme lightGrayColor] forState:UIControlStateNormal];
        [self.resetButton addTarget:self action:@selector(resetBoard) forControlEvents:UIControlEventTouchUpInside];
        self.resetButton.backgroundColor = [Colorscheme blackPurpleColor];
        self.resetButton.layer.cornerRadius = 20;
        
        [self.view addSubview:self.gridContainer];
        [self.view addSubview:self.resetButton];
    }
    return self;
}

- (void)resetBoard
{
    self.ai = [[AI alloc] init];
    self.board = [[Board alloc] init];
    [self resetGrid];
    [self animateCellsIntoView];
    [self performSelector:@selector(AIDidPlay) withObject:self afterDelay:0.25];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isMultiplayer) {
        self.gameActivity = [[ZZActivity alloc] init];
        self.gameActivity.name = @"GAME51";
        self.gameActivity.user = [ZZUser currentUser];
        self.gameActivity.multiplayer = self.isMultiplayer;
        self.gameActivity.level = 1;
        self.gameActivity.activityType = ZZActivityTypePlaying;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [Colorscheme darkPurpleColor];
    NSLog(@"notification added!");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundPartner:)        name:@"ZZChallengeAccepted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundPartner:)        name:@"NSActivityReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activityLoaded:)      name:@"NSActivityLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(partnerPlayed:)       name:@"NSNewAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(partnerCancelled:)    name:@"NSActivityCancelled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:)    name:@"AppTerminate" object:nil];
    self.movesPlayed = 0;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.isMultiplayer) {
        [self animateCellsIntoView];
        [self performSelector:@selector(AIDidPlay) withObject:self afterDelay:0.25];
    } else {
        // Show spinner!
        [self.gameActivity start];
        
        CGRect screen = [[UIScreen mainScreen] bounds];
        self.spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen.size.width / 2 - 150, screen.size.height / 2 - 150, 300, 300)];
        [self.spinnerLabel setTextAlignment:NSTextAlignmentCenter];
        [self.spinnerLabel setTextColor:[Colorscheme brightGreenColor]];
        [self.spinnerLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:60]];
        [self.spinnerLabel setText:[NSString fontAwesomeIconStringForEnum:FAchild]];
        [self.spinnerLabel setAlpha:0];
        [self.view addSubview:self.spinnerLabel];
        
        CABasicAnimation *animation;
        animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        animation.toValue = [NSNumber numberWithFloat: M_PI * 2 * 1 ];
        animation.duration = 0.8;
        animation.cumulative = YES;
        animation.repeatCount = HUGE_VALF;
        
        [self.spinnerLabel.layer addAnimation:animation forKey:@"rotationAnimation"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spinnerTapped:)];
        [tap setNumberOfTapsRequired:1];
        [self.view addGestureRecognizer:tap];
        
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.spinnerLabel setAlpha:1.0];
                         }
                         completion:^(BOOL finished) {
                         }];

    }
}

- (void)viewWillLayoutSubviews
{
    [self resetGrid];
}

#pragma mark - Cancel matchmaking
- (void)spinnerTapped:(UIGestureRecognizer *)gesture
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSActivityReady" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNewAction" object:nil];
    [self.gameActivity cancel];
    
    [UIView animateWithDuration:0.8 animations:^{
        self.spinnerLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismiss];
    }];
}

#pragma mark - Animate cells
- (void)animateCellsIntoView
{
    if ([self.grid count]) {
        for (int i = 0; i < self.gridHeight; i++) {
            for (int j = 0; j < self.gridWidth; j++) {
                GridCell *cell = [self getGridCellX:j Y:i];
                [cell animateCellIntoView];
            }
        }
    }
}
- (void)animateCellsOutOfView
{
    if ([self.grid count]) {
        for (int i = 0; i < self.gridHeight; i++) {
            for (int j = 0; j < self.gridWidth; j++) {
                GridCell *cell = [self getGridCellX:j Y:i];
                [cell animateCellOutOfView];
            }
        }
    }
}

#pragma mark - AI move
- (void)AIDidPlay
{
    CGPoint move = [self.ai nextMoveForBoard:self.board];
    BOOL success = [self.board playCrossMove:move];
    if (success) {
        GridCell *cell = [self getGridCellX:(int)move.x Y:(int)move.y];
        [cell activate:ZZGridOccupantX];
        self.playerSymbol = ZZGridOccupantO;
        [self movePlayed];
    }
    self.isMyTurn = YES;
}

#pragma mark - User move
- (void)touchReceivedFor:(GridCell *)cell
{
    NSLog(@"Touch");
    if (!self.isMyTurn) {
        NSLog(@"Not my turn!");
        return;
    }
    
    if (self.isMultiplayer) {
        CGPoint move = CGPointMake(cell.positionX, cell.positionY);
        NSLog(@"move: %@", NSStringFromCGPoint(move));
        BOOL success;
        if (self.playerSymbol == ZZPlayerSymbolX) {
            success = [self.board playCrossMove:move];
        } else {
            success = [self.board playCircleMove:move];
        }

        if (success) {
            if (self.playerSymbol == ZZPlayerSymbolX) {
                [cell activate:ZZGridOccupantX];
            } else {
                [cell activate:ZZGridOccupantO];
            }
            ZZAction *action = [[ZZAction alloc] init];
            action.name = @"MOVE";
            action.activity = self.gameActivity;
            action.score = move.x;
            action.duration = move.y;
            [action updateAction];
            [action logAction];
        
            [self movePlayed];
            self.isMyTurn = NO;
        }
    } else {
        /* Place the symbol */
        if (self.playerSymbol == ZZPlayerSymbolX) {
            self.playerSymbol = ZZGridOccupantO;
            [cell activate:ZZGridOccupantX];
        } else {
            CGPoint move = CGPointMake(cell.positionX, cell.positionY);
            BOOL success = [self.board playCircleMove:move];
            if (success) {
                [cell activate:ZZGridOccupantO];
                self.playerSymbol = ZZGridOccupantX;
                [self performSelector:@selector(AIDidPlay) withObject:self afterDelay:0.25];
                [self movePlayed];
                self.isMyTurn = NO;
            }
        }
    }
}

#pragma mark - Move played
- (void)movePlayed
{
    if ([self.board gameOver]) {
        self.isMyTurn = NO;
        
        // Winner
        if (![[self.board winner] isEqualToString:@"DRAW"]) {
            NSArray *array = [self.board winningMoves];
            for (NSValue *point in array) {
                CGPoint move = point.CGPointValue;
                GridCell *cell = [self getGridCellX:(int)move.x Y:(int)move.y];
                [cell animateWinningCell];
            }
        }
    
        [self performSelector:@selector(animateCellsOutOfView) withObject:nil afterDelay:1.0];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0];
    }
}

- (void)dismiss
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSActivityReady" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNewAction" object:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Multiplayer
- (void)foundPartner:(NSNotification *)notification
{
    UITapGestureRecognizer *tap = [self.view.gestureRecognizers firstObject];
    [self.view removeGestureRecognizer:tap];
    
    NSLog(@"Found partner!");
    [UIView animateWithDuration:0.3 animations:^{
        [self.spinnerLabel setAlpha:0];
    } completion:^(BOOL finished) {
        // Load the board with Morgan's fancy animation!
        NSDictionary *userInfo = notification.userInfo;
        ZZActivity *activity = [userInfo objectForKey:@"ACTIVITY"];
        NSLog(@"partner activity: %@", activity);
        NSLog(@"inititator : %i", activity.initiator);
        if (activity.initiator == 1) {
            NSLog(@"not my turn!");
            self.isMyTurn = NO;
            self.playerSymbol = ZZPlayerSymbolO;
            [self animateCellsIntoView];
        } else {
            NSLog(@"my turn!");
            self.isMyTurn = YES;
            self.playerSymbol = ZZPlayerSymbolX;
            if (self.movesPlayed == 1) {
                CGFloat width = self.gridContainer.bounds.size.width;
                CGFloat height = ((UIView *)self.gridContainer.subviews[0]).bounds.size.height;
                CGRect rect = CGRectMake(self.gridContainer.bounds.origin.x,
                                         self.gridContainer.bounds.origin.y + self.gridContainer.bounds.size.height/2.0 - height/2.0,
                                         width,
                                         height);
                CGRect rectHidden = rect;
                rectHidden.origin.y = -self.view.frame.size.height;
                CGRect rectDown = rect;
                rectDown.origin.y = self.view.frame.size.height;
                
                UILabel *yourTurnLabel = [[UILabel alloc] initWithFrame:rectHidden];
                yourTurnLabel.text = @"Your First";
                yourTurnLabel.textAlignment = NSTextAlignmentCenter;
                yourTurnLabel.textColor = [Colorscheme brightGreenColor];
                yourTurnLabel.font = [UIFont fontWithName:@"Fabada" size:72];
                
                [self.gridContainer addSubview:yourTurnLabel];
                
                [UIView animateWithDuration:0.5 animations:^{
                    yourTurnLabel.frame = rect;
                } completion:^(BOOL finished) {
                    [UIView  animateWithDuration:0.25
                                           delay:0.5
                                         options:UIViewAnimationOptionCurveEaseInOut
                                      animations:^{
                                          yourTurnLabel.frame = rectDown;
                                      }
                                      completion:^(BOOL finished) {
                                          if (finished) {
                                              [yourTurnLabel removeFromSuperview];
                                              [self animateCellsIntoView];
                                          }
                                      }];
                }];
            }
        }

    }];
}

- (void)setIsMyTurn:(BOOL)isMyTurn
{
    _isMyTurn = isMyTurn;
    self.movesPlayed++;
}

- (void)partnerPlayed:(NSNotification *)notification
{
    NSLog(@"Partner played!");
    NSDictionary* userInfo = notification.userInfo;
    ZZAction* action = [userInfo objectForKey:@"ACTION"];
    CGPoint move = CGPointMake(action.score, action.duration);
    NSLog(@"move received: %@", NSStringFromCGPoint(move));
    NSLog(@"Map: %@", [action attributesMap]);
    BOOL success;
    
    if (self.playerSymbol == ZZPlayerSymbolX) {
        success = [self.board playCircleMove:move];
    } else {
        success = [self.board playCrossMove:move];
    }
    
    if (success) {
        GridCell *cell = [self getGridCellX:(int)move.x Y:(int)move.y];
        if (self.playerSymbol == ZZPlayerSymbolX) {
            [cell activate:ZZGridOccupantO];
        } else {
            [cell activate:ZZGridOccupantX];
        }
        [cell setNeedsDisplay];
        self.isMyTurn = YES;
    }
    [self movePlayed];
}

- (void)partnerCancelled:(NSNotification *)notif
{
    [self.gameActivity cancel];
    [self performSelector:@selector(animateCellsOutOfView) withObject:nil afterDelay:1.0];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0];
}

- (void)appWillTerminate:(NSNotification *)notif
{
    [self.gameActivity cancel];
}

#pragma mark - Grid utility
- (NSMutableArray *)grid
{
    if (!_grid) {
        _grid = [[NSMutableArray alloc] init];
    }
    return _grid;
}

- (GridCell *)getGridCellX:(int)x Y:(int)y
{
    if (x >= 0 && x < self.gridWidth &&
        y >= 0 && y < self.gridHeight) {
        return (GridCell *)self.grid[x + y * self.gridWidth];
    }
    return nil;
}

- (void)mergeIfAdjacentTo:(GridCell *)cell
{
    GridCell *top       = [self getGridCellX:cell.positionX     Y:cell.positionY - 1];
    GridCell *right     = [self getGridCellX:cell.positionX + 1 Y:cell.positionY];
    GridCell *bottom    = [self getGridCellX:cell.positionX     Y:cell.positionY + 1];
    GridCell *left      = [self getGridCellX:cell.positionX - 1 Y:cell.positionY];
    
    if (top.occupant == cell.occupant) {
        NSLog(@"merge top");
        [top merge:ZZGridCellMergeDirectionBottom];
        [cell merge:ZZGridCellMergeDirectionTop];
    }
    if (right.occupant == cell.occupant) {
        NSLog(@"merge right");
        [right merge:ZZGridCellMergeDirectionLeft];
        [cell merge:ZZGridCellMergeDirectionRight];
    }
    if (bottom.occupant == cell.occupant) {
        NSLog(@"merge bottom");
        [bottom merge:ZZGridCellMergeDirectionTop];
        [cell merge:ZZGridCellMergeDirectionBottom];
    }
    if (left.occupant == cell.occupant) {
        NSLog(@"merge left");
        [left merge:ZZGridCellMergeDirectionRight];
        [cell merge:ZZGridCellMergeDirectionLeft];
    }
}

- (void)resetGrid
{
    /* Reset the grid */
    //[self animateCellsOutOfView];
    [self.grid removeAllObjects];
    NSArray *subviews = [self.gridContainer subviews];
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    self.playerSymbol = ZZPlayerSymbolX;
    /* Create the grid */
    CGFloat padding = 20;
    CGFloat cellWidth = (self.gridContainer.frame.size.width - 2*padding) / self.gridWidth;
    CGFloat cellHeight = (self.gridContainer.frame.size.height - 2*padding) / self.gridHeight;
    CGFloat paddingLeft = padding;
    CGFloat paddingTop = padding;
    
    for (int i = 0; i < self.gridHeight; i++) {
        for (int j = 0; j < self.gridWidth; j++) {
            CGRect frame = CGRectMake(paddingLeft, paddingTop, cellWidth, cellHeight);
            paddingLeft += cellWidth;
            GridCell *cell = [[GridCell alloc] initWithFrame:frame positionX:j Y:i];
            cell.parentVC = self;
            cell.transform = CGAffineTransformMakeScale(0, 0);
            [self.gridContainer addSubview:cell];
            [self.grid addObject:cell];
        }
        paddingTop += cellHeight;
        paddingLeft = padding;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
