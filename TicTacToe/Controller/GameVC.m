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

@interface GameVC ()

@property (strong, nonatomic) IBOutlet UIView *gridContainer;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;

@property (strong, nonatomic) AI *ai;
@property (strong, nonatomic) Board *board;
@property (strong, nonatomic) Activity *gameActivity;

@property (nonatomic) BOOL isMyTurn;

- (void)movePlayed;
@end

@implementation GameVC

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.gridWidth = 3;
        self.gridHeight = 3;
        // Instantiate AI
        self.ai = [[AI alloc] init];
        self.board = [[Board alloc] init];
        self.isMultiplayer = YES;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
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
    
    NSLog(@"multi: %i", self.isMultiplayer);
    if (self.isMultiplayer) {
        self.gameActivity = [[Activity alloc] init];
        self.gameActivity.name = @"GAME17";
        self.gameActivity.user = [self.sdk currentUser];
        self.gameActivity.multiplayer = self.isMultiplayer;
        self.gameActivity.level = 1;
        self.gameActivity.activityType = 1;

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundPartner:) name:@"NSActivityReady" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(partnerPlayed:) name:@"NSNewAction" object:nil];

        [self.sdk startActivity:self.gameActivity];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [Colorscheme darkPurpleColor];
    //self.view.backgroundColor = [Colorscheme colorBackground];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self animateCellsIntoView];
    if (!self.isMultiplayer) {
        [self performSelector:@selector(AIDidPlay) withObject:self afterDelay:0.25];
    }
}

- (void)viewWillLayoutSubviews
{
    [self resetGrid];
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
}

#pragma mark - User move
- (void)touchReceivedFor:(GridCell *)cell
{
    if (self.isMultiplayer) {
        if (!self.isMyTurn) {
            NSLog(@"Not my turn!");
            return;
        }
        
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
            Action *action = [[Action alloc] init];
            action.name = @"MOVE";
            action.activity = self.gameActivity;
//            [action setObject:[NSString stringWithFormat:@"%f", move.x] forKey:@"moveX"];
//            [action setObject:[NSString stringWithFormat:@"%f", move.y] forKey:@"moveY"];
            action.score = move.x;
            action.duration = move.y;
            [self.sdk updateAction:action];
            NSLog(@"Logging action");
            [self.sdk logAction:action];
        
            [self movePlayed];
            self.isMyTurn = NO;
        }
    } else {
        /* Place the symbol */
        if (self.playerSymbol == ZZPlayerSymbolX) {
            [cell activate:ZZGridOccupantX];
            self.playerSymbol = ZZGridOccupantO;
        } else {
            CGPoint move = CGPointMake(cell.positionX, cell.positionY);
            BOOL success = [self.board playCircleMove:move];
            if (success) {
                [cell activate:ZZGridOccupantO];
                self.playerSymbol = ZZGridOccupantX;
                [self performSelector:@selector(AIDidPlay) withObject:self afterDelay:0.25];
                [self movePlayed];
            }
        }
    }
}

#pragma mark - Move played
- (void)movePlayed
{
    if ([self.board gameOver]) {
        if (![[self.board winner] isEqualToString:@"DRAW"]) {
            NSArray *array = [self.board winningMoves];
            for (NSValue *point in array) {
                CGPoint move = point.CGPointValue;
                GridCell *cell = [self getGridCellX:(int)move.x Y:(int)move.y];
                [cell animateWinningCell];
            }
        }
    }
}

#pragma mark - Multiplayer
- (void)foundPartner:(NSNotification *)notification
{
    NSLog(@"Found partner!");
    // Load the board with Morgan's fancy animation!
    NSDictionary *userInfo = notification.userInfo;
    Activity *activity = [userInfo objectForKey:@"ACTIVITY"];
    NSLog(@"partner activity: %@", activity);
    NSLog(@"inititator : %i", activity.initiator);
    if (activity.initiator == 1) {
        NSLog(@"not my turn!");
        self.isMyTurn = NO;
        self.playerSymbol = ZZPlayerSymbolO;
    } else {
        NSLog(@"my turn!");
        self.isMyTurn = YES;
        self.playerSymbol = ZZPlayerSymbolX;
    }
}

- (void)partnerPlayed:(NSNotification *)notification
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"Partner played!");
        NSDictionary* userInfo = notification.userInfo;
        Action* action = [userInfo objectForKey:@"ACTION"];
    //    CGPoint move = CGPointMake([[[action attributesMap] objectForKey:@"moveX"] intValue], [[[action attributesMap] objectForKey:@"moveY"] intValue]);
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
    });
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
