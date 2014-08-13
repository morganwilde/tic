//
//  GameVC.h
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridCell.h"
#import <PlatformSDK/PlatformSDK.h>
<<<<<<< HEAD
#import <PlatformSDK/Action.h>
=======
>>>>>>> 82c5a0b029a3ff49f65fc30127e9763827deb963

typedef enum ZZPlayerSymbol {
    ZZPlayerSymbolNone  = 0,
    ZZPlayerSymbolX     = 1,
    ZZPlayerSymbolO     = 2
} ZZPlayerSymbol;

@interface GameVC : PlatformViewController

@property (nonatomic) BOOL isMultiplayer;

@property (nonatomic) BOOL isMultiplayer;

/* Grid settings */
@property (nonatomic) int gridWidth;
@property (nonatomic) int gridHeight;

@property (nonatomic, strong) NSMutableArray *grid;

@property (nonatomic) ZZPlayerSymbol playerSymbol;

- (GridCell *)getGridCellX:(int)x Y:(int)y;
- (void)touchReceivedFor:(GridCell *)cell;
- (void)resetGrid;

@end
