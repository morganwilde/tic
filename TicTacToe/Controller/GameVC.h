//
//  GameVC.h
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridCell.h"

typedef enum ZZPlayerSymbol {
    ZZPlayerSymbolNone  = 0,
    ZZPlayerSymbolX     = 1,
    ZZPlayerSymbolO     = 2
} ZZPlayerSymbol;

@interface GameVC : UIViewController

/* Grid settings */
@property (nonatomic) int gridWidth;
@property (nonatomic) int gridHeight;

@property (nonatomic, strong) NSMutableArray *grid;

@property (nonatomic) ZZPlayerSymbol playerSymbol;

- (GridCell *)getGridCellX:(int)x Y:(int)y;
- (void)touchReceivedFor:(GridCell *)cell;

@end
