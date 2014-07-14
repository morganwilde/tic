//
//  Board.h
//  TicTacToe
//
//  Created by Chris Howell on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Board : NSObject <NSCopying>
@property (nonatomic, strong) NSString *winner;
@property (nonatomic) NSInteger totalMovesPlayed;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) BOOL isCrossTurn;

- (id) init;

#pragma mark - Moving
- (BOOL)playCrossMove: (CGPoint) move;
- (BOOL)playCircleMove: (CGPoint) move;

#pragma mark - Querying
- (NSString *)counterAtPoint:(CGPoint)point;
- (BOOL)isTileEmpty: (CGPoint) point;
- (NSArray *)possibleMoves;
- (int) scoreForCounter: (NSString *) counter;

#pragma mark - Description
- (NSString *) description;
@end
