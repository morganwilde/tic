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

@property (nonatomic) int gridColumns;
@property (nonatomic) int gridRows;
@property (nonatomic) NSMutableArray *cells;

+ (id)layerWithSize:(CGRect)rect Columns:(int)columns Rows:(int)rows;
- (Cell *)getCellAtX:(int)x Y:(int)y;

@end
