//
//  GridCell.h
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameVC;

typedef enum ZZGridOccupant {
    ZZGridOccupantEmpty = 0,
    ZZGridOccupantX     = 1,
    ZZGridOccupantO     = 2
} ZZGridOccupant;

typedef enum ZZGridCellMergeDirection {
    ZZGridCellMergeDirectionNone    = 0,
    ZZGridCellMergeDirectionTop     = (1 << 1), // 00000001
    ZZGridCellMergeDirectionRight   = (1 << 2), // 00000010
    ZZGridCellMergeDirectionBottom  = (1 << 3), // 00000100
    ZZGridCellMergeDirectionLeft    = (1 << 4)  // 00001000
} ZZGridCellMergeDirection;

@interface GridCell : UIView

@property (nonatomic, strong) UIColor *colorBack;
@property (nonatomic) ZZGridOccupant occupant;
@property (nonatomic) ZZGridCellMergeDirection mergeDirections;
@property (nonatomic, strong) GameVC *parentVC;
/* Position on the grid */
@property (nonatomic) int positionX;
@property (nonatomic) int positionY;

- (id)initWithFrame:(CGRect)frame positionX:(int)x Y:(int)y;
- (void)activate:(ZZGridOccupant)state;
- (void)merge:(ZZGridCellMergeDirection)direction;

@end
