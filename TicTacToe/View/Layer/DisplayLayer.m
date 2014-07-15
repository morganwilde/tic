//
//  DisplayLayer.m
//  TicTacToe
//
//  Created by Morgan Wilde on 14/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "DisplayLayer.h"

typedef struct CellSpacing {
    CGFloat top;
    CGFloat right;
    CGFloat bottom;
    CGFloat left;
} CellSpacing;

@implementation DisplayLayer

+ (id)layerWithSize:(CGRect)rect Columns:(int)columns Rows:(int)rows
{
    DisplayLayer *layer = [[self alloc] init];
    if (layer) {
        layer.gridColumns   = columns;
        layer.gridRows      = rows;
        layer.frame         = rect;
        
        /* Generate the grid's cells */
        CGFloat width       = layer.bounds.size.width;
        CGFloat height      = layer.bounds.size.height;
        CGFloat paddingCoef = 0.4;
        CGFloat cellWidth   = (width / layer.gridColumns)   * (1 - paddingCoef);
        CGFloat cellHeight  = (width / layer.gridRows)      * (1 - paddingCoef);
        
        CellSpacing centralMargins = {rect.size.height - rect.size.width, 0, 0, 0};
        CellSpacing cellPadding = {
            (width - cellHeight * rows) / (rows+1),
            (width - cellWidth * columns) / (columns+1),
            0,
            0
        };
        cellPadding.bottom  = cellPadding.top;
        cellPadding.left    = cellPadding.right;
        
        for (int i = 0; i < layer.gridColumns; i++) {
            for (int j = 0; j < layer.gridRows; j++) {
                CGRect cellRect = CGRectMake(j * cellWidth  + centralMargins.left   + cellPadding.left*(j+1),
                                             i * cellHeight + centralMargins.top    + cellPadding.top *(i+1),
                                             cellWidth,
                                             cellHeight);
                CGPoint padding = CGPointMake(0, -height);
                Cell *cell = [Cell layerWithBounds:cellRect frame:layer.frame padding:padding];
                cell.x = j;
                cell.y = i;
                cell.horizontalD = cellPadding.left + cellWidth;
                cell.diagonalD = sqrtl(powl(cell.horizontalD, 2) * 2);
                [layer.cells addObject:cell];
                [layer addSublayer:cell];
            }
        }
    }
    return layer;
}

- (void)drawInContext:(CGContextRef)ctx
{
    UIGraphicsPushContext(ctx);
    
    /* Fill the central part with color */
    CGRect centralRect = CGRectMake(0,
                                    self.bounds.size.height - self.bounds.size.width,
                                    self.bounds.size.width,
                                    self.bounds.size.width);
    UIBezierPath *central = [UIBezierPath bezierPathWithRect:centralRect];
    [[UIColor lightGrayColor] setFill];
    [central fill];
    
    UIGraphicsPopContext();
}
#pragma mark - Lazy initialisers
- (NSArray *)cells
{
    if (!_cells) {
        _cells = [NSMutableArray array];
    }
    return _cells;
}
- (Cell *)getCellAtX:(int)x Y:(int)y
{
    return (Cell *)self.cells[y * self.gridColumns + x];
}
#pragma mark - Animations
- (void)mergeIfAdjacentTo:(Cell *)cell
{
    Cell *top       = [self getCellAtX:cell.x     Y:cell.y - 1];
    Cell *right     = [self getCellAtX:cell.x + 1 Y:cell.y];
    Cell *bottom    = [self getCellAtX:cell.x     Y:cell.y + 1];
    Cell *left      = [self getCellAtX:cell.x - 1 Y:cell.y];
    
    if (top.faceOccupant == cell.faceOccupant) {
        NSLog(@"merge top");
        [top merge:ZZGridCellMergeDirectionBottom];
        [cell merge:ZZGridCellMergeDirectionTop];
    }
    if (right.faceOccupant == cell.faceOccupant) {
        NSLog(@"merge right");
        [right merge:ZZGridCellMergeDirectionLeft];
        [cell merge:ZZGridCellMergeDirectionRight];
    }
    if (bottom.faceOccupant == cell.faceOccupant) {
        NSLog(@"merge bottom");
        [bottom merge:ZZGridCellMergeDirectionTop];
        [cell merge:ZZGridCellMergeDirectionBottom];
    }
    if (left.faceOccupant == cell.faceOccupant) {
        NSLog(@"merge left");
        [left merge:ZZGridCellMergeDirectionRight];
        [cell merge:ZZGridCellMergeDirectionLeft];
    }
}

@end
