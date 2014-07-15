//
//  GameVC.m
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "GameVC.h"
#import "../View/Colorscheme.h"
#import "../Board.h"
#import "../AI.h"

@interface GameVC ()

@property (strong, nonatomic) IBOutlet UIView *gridContainer;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) AI *ai;
@property (strong, nonatomic) Board *board;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [Colorscheme darkPurpleColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self animateCellsIntoView];
    [self performSelector:@selector(AIDidPlay) withObject:self afterDelay:0.25];
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
#pragma mark - Player actions
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

- (void)touchReceivedFor:(GridCell *)cell
{
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
