//
//  Cell.h
//  TicTacToe
//
//  Created by Morgan Wilde on 14/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "../Colorscheme.h"

typedef enum ZZSymbolType {
    ZZSymbolTypeX = 1,
    ZZSymbolTypeO = 2
} ZZSymbolType;

typedef enum ZZGridCellMergeDirection {
    ZZGridCellMergeDirectionNone        = 0,
    ZZGridCellMergeDirectionTop         = (1 << 1), // 00000001
    ZZGridCellMergeDirectionTopRight    = (1 << 2), // 00000010
    ZZGridCellMergeDirectionRight       = (1 << 3), // 00000100
    ZZGridCellMergeDirectionBottomRight = (1 << 4), // 00001000
    ZZGridCellMergeDirectionBottom      = (1 << 5), // 00010000
    ZZGridCellMergeDirectionBottomLeft  = (1 << 6), // 00100000
    ZZGridCellMergeDirectionLeft        = (1 << 7), // 01000000
    ZZGridCellMergeDirectionTopLeft     = (1 << 8)  // 10000000
} ZZGridCellMergeDirection;

@interface Cell : CALayer

@property (nonatomic) CGRect rect;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat forward;
@property (nonatomic) CGFloat backward;
@property (nonatomic) CGFloat paddingLeft;
@property (nonatomic) CGFloat paddingTop;
@property (nonatomic) int x;
@property (nonatomic) int y;

// Travel distance for the merge
@property (nonatomic) CGFloat diagonalD;
@property (nonatomic) CGFloat horizontalD;

/* Cell ghosts for merging with other cells */
@property (nonatomic, strong) Cell *face;
@property (nonatomic, strong) Cell *horizontal;
@property (nonatomic, strong) Cell *vertical;
@property (nonatomic, strong) Cell *diagonalRight;
@property (nonatomic, strong) Cell *diagonalLeft;

@property (nonatomic) BOOL isFace;
@property (nonatomic) ZZSymbolType faceOccupant;
@property (nonatomic) BOOL sublayerAdded;

+ (id)layerWithBounds:(CGRect)bounds frame:(CGRect)frame padding:(CGPoint)padding;
- (void)merge:(ZZGridCellMergeDirection)direction;

@end
