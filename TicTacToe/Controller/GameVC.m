//
//  GameVC.m
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "GameVC.h"
#import "../View/Colorscheme.h"

@interface GameVC ()

@property (weak, nonatomic) IBOutlet UIView *gridContainer;

@end

@implementation GameVC

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.gridWidth = 3;
        self.gridHeight = 3;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [Colorscheme darkPurpleColor];
    //self.view.backgroundColor = [Colorscheme colorBackground];
}

- (void)viewWillLayoutSubviews
{
    /* Reset the grid */
    [self.grid removeAllObjects];
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
        [cell activate:ZZGridOccupantO];
        self.playerSymbol = ZZGridOccupantX;
    }
    /* Check for merge opportunities */
    //[cell animateWinningCell];
    //[self mergeIfAdjacentTo:cell];
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
