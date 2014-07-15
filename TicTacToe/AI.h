//
//  AI.h
//  TicTacToe
//
//  Created by Chris Howell on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Board;

@interface AI : NSObject
@property (nonatomic, strong) Board *gameBoard;

- (CGPoint)nextMoveForBoard: (Board *) board;
- (NSInteger) minimaxWithRoot:(Board *) board withDepth: (NSInteger) depth andMaximisingPlayer: (BOOL) maxPlayer;

@end
