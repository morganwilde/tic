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

- (void)drawInContext:(CGContextRef)ctx
{
    UIGraphicsPushContext(ctx);
    
    /* Fill the central part with color */
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGRect centralRect = CGRectMake(0,
                                    height - width,
                                    width,
                                    width);
    UIBezierPath *central = [UIBezierPath bezierPathWithRect:centralRect];
    [[UIColor redColor] setFill];
    [central fill];
    
    /* Generate the grid's cells */
    self.cellsInRow = 3;
    self.cellsInColumn = 3;
    CGFloat cellWidth = width / self.cellsInRow;
    CGFloat cellHeight = width / self.cellsInColumn;
    CellSpacing centralMargins = {centralRect.origin.y, 0, 0, 0};
    CGFloat paddingCoef = 0.1;
    CellSpacing cellPadding = {
        cellWidth * paddingCoef,
        cellWidth * paddingCoef,
        cellWidth * paddingCoef,
        cellWidth * paddingCoef
    };
    
    [[UIColor orangeColor] setFill];
    for (int i = 0; i < self.cellsInColumn; i++) {
        for (int j = 0; j < self.cellsInRow; j++) {
            CGRect cellRect = CGRectMake(j * cellWidth  + centralMargins.left   + cellPadding.left,
                                         i * cellHeight + centralMargins.top    + cellPadding.top,
                                         cellWidth      - cellPadding.left      - cellPadding.right,
                                         cellHeight     - cellPadding.top       - cellPadding.bottom);
            CGPoint padding = CGPointMake(0, -height);
            Cell *cell = [Cell layerWithBounds:cellRect padding:padding];
            cell.frame = self.frame;
            [self.cells addObject:cell];
            [self addSublayer:cell];
            [cell setNeedsDisplay];
        }
    }
    
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
    return (Cell *)self.cells[y * self.cellsInRow + x];
}

@end
