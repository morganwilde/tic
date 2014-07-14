//
//  DisplayLayer.h
//  TicTacToe
//
//  Created by Morgan Wilde on 14/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Cell.h"

@interface DisplayLayer : CALayer

@property (nonatomic) int cellsInRow;
@property (nonatomic) int cellsInColumn;
@property (nonatomic) NSMutableArray *cells;

- (Cell *)getCellAtX:(int)x Y:(int)y;

@end
