//
//  Board.m
//  TicTacToe
//
//  Created by Chris Howell on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "Board.h"
#define BOARD_HEIGHT 3
#define BOARD_WIDTH 3

@interface Board()
@property (nonatomic, strong) NSMutableArray *boardArray;

- (BOOL)playMove:(CGPoint)move forCounter:(NSString *)counter;
- (BOOL)checkRow: (NSInteger) row;
- (BOOL)checkColumn: (NSInteger) column;
- (BOOL)checkTopLeftDiagonal;
- (BOOL)checkTopRightDiagonal;
@end

@implementation Board
- (id)init
{
    if ( self = [super init] ) {
        self.boardArray = [NSMutableArray arrayWithCapacity:BOARD_HEIGHT * BOARD_WIDTH];
        for (int i = 0; i < BOARD_WIDTH * BOARD_HEIGHT; i++) {
            [self.boardArray addObject:@"-"];
        }
        self.totalMovesPlayed = 0;
        self.winner = @"NONE";
        self.gameOver = NO;
    }
    return self;
}

#pragma mark - Moving
- (BOOL)playCrossMove:(CGPoint)move
{
    BOOL moveSuccessful = [self playMove:move forCounter:@"X"];
    if (moveSuccessful) {
        [self checkWinner];
    }
    return moveSuccessful;
}

- (BOOL)playCircleMove:(CGPoint)move
{
    BOOL moveSuccessful = [self playMove:move forCounter:@"O"];
    if (moveSuccessful) {
        [self checkWinner];
    }
    return moveSuccessful;
}

- (BOOL)playMove:(CGPoint)move forCounter: (NSString *) counter
{
    // Can't move to invalid position
    if (move.x < 0 || move.x >= BOARD_WIDTH || move.y < 0 || move.y >= BOARD_HEIGHT) {
        NSLog(@"Invalid position: %@", NSStringFromCGPoint(move));
        return NO;
    }
    
    // Can't move to an occupied tile
    if (![self isTileEmpty:move]) {
        NSLog(@"Tile not empty: %@", NSStringFromCGPoint(move));
        return NO;
    }
    
    self.totalMovesPlayed = self.totalMovesPlayed + 1;
    [self.boardArray replaceObjectAtIndex:[self map:move] withObject:counter];
    return YES;
}

#pragma mark - Query
- (BOOL)isTileEmpty: (CGPoint) point
{
    NSString *tile = (NSString *) self.boardArray[[self map:point]];
    if ([tile isEqualToString:@"-"]) {
        return YES;
    }
    return NO;
}

- (NSString *)counterAtPoint:(CGPoint)point
{
    return [self.boardArray objectAtIndex:[self map:point]];
}

- (NSArray *)possibleMoves
{
    NSMutableArray *moves = [NSMutableArray new];
    for (int x = 0; x < BOARD_WIDTH; x++) {
        for (int y = 0; y < BOARD_HEIGHT; y++) {
            CGPoint move = CGPointMake(x, y);
            if ([self isTileEmpty:move]) {
                [moves addObject:[NSValue valueWithCGPoint:move]];
            }
        }
    }
    return moves;
}

#pragma mark - Win checking
- (void)checkWinner
{
    // Check columns
    for (int x = 0; x < BOARD_WIDTH; x++) {
        if ([self checkColumn:x]) {
            self.gameOver = YES;
            NSLog(@"Column win: %i",x);
        }
    }
    
    // Check rows
    for (int y = 0; y < BOARD_HEIGHT; y++) {
        if ([self checkRow:y]) {
            self.gameOver = YES;
            NSLog(@"Row win: %i",y);
        }
    }
    
    if ([self checkTopLeftDiagonal]) {
        NSLog(@"Top left win");
        self.gameOver = YES;
    }
    
    if ([self checkTopRightDiagonal]) {
        NSLog(@"Top right win");
        self.gameOver = YES;
    }
    
    if (self.totalMovesPlayed == (BOARD_HEIGHT * BOARD_WIDTH)) {
        self.winner = @"DRAW";
        self.gameOver = YES;
    }
}

- (BOOL)checkRow: (NSInteger) row
{
    CGPoint point = CGPointMake(0, row);
    NSString *firstTile = (NSString *) self.boardArray[[self map:point]];
    if ([firstTile isEqualToString:@"-"]) {
        return NO;
    }
    
    BOOL winner = YES;
    for (int column = 0; column < BOARD_WIDTH; column++) {
        point.x = column;
        NSString *tile = (NSString *) self.boardArray[[self map:point]];
        if (![tile isEqualToString: firstTile]) {
            winner = NO;
        }
    }
    if (winner) {
        self.winner = firstTile;
    }
    return winner;
}

- (BOOL)checkColumn: (NSInteger) column
{
    CGPoint point = CGPointMake(column, 0);
    NSString *firstTile = (NSString *) self.boardArray[[self map:point]];
    if ([firstTile isEqualToString:@"-"]) {
        return NO;
    }
    
    BOOL winner = YES;
    for (int row = 0; row < BOARD_HEIGHT; row++) {
        point.y = row;
        NSString *tile = (NSString *) self.boardArray[[self map:point]];
        if (![tile isEqualToString: firstTile]) {
            winner = NO;
        }
    }
    if (winner) {
        self.winner = firstTile;
    }
    return winner;
}

- (BOOL)checkTopLeftDiagonal
{
    NSString *firstTile = (NSString *) self.boardArray[[self map:CGPointMake(0, 0)]];
    if ([firstTile isEqualToString:@"-"]) {
        return NO;
    }
    
    BOOL winner = YES;
    for (int x = 0, y = 0; x < BOARD_HEIGHT && y < BOARD_WIDTH; x++, y++) {
        CGPoint point = CGPointMake(x, y);
        NSString *tile = (NSString *) self.boardArray[[self map:point]];
        if (![tile isEqualToString:firstTile]) {
            return NO;
        }
    }
    self.winner = firstTile;
    return winner;
}

- (BOOL)checkTopRightDiagonal
{
    NSString *firstTile = (NSString *) self.boardArray[[self map:CGPointMake(0, 2)]];
    if ([firstTile isEqualToString:@"-"]) {
        return NO;
    }
    
    BOOL winner = YES;
    for (int x = 2, y = 0; x < BOARD_HEIGHT && y < BOARD_WIDTH; x--, y++) {
        CGPoint point = CGPointMake(x, y);
        NSString *tile = (NSString *) self.boardArray[[self map:point]];
        if (![tile isEqualToString:firstTile]) {
            return NO;
        }
    }
    self.winner = firstTile;
    return winner;
}

#pragma mark - Helpers
- (NSInteger)map:(CGPoint)point
{
    return (point.x * BOARD_WIDTH) + point.y;
}

#pragma mark - Description
- (NSMutableString *) description
{
    NSMutableString *boardString = [NSMutableString string];
    [boardString appendString:@"\r"];
    for (int x = 0; x < BOARD_WIDTH; x++) {
        for (int y = 0; y < BOARD_HEIGHT; y++) {
            [boardString appendString:[self.boardArray objectAtIndex:[self map:CGPointMake(x, y)]]];
            [boardString appendString:@" | "];
        }
        [boardString appendString:@"\r"];
    }
    [boardString appendString:@"\r"];
    [boardString appendString:[NSString stringWithFormat:@"Winner: %@\r", self.winner]];
    [boardString appendString:[NSString stringWithFormat:@"Moves played: %i\r", self.totalMovesPlayed]];
    return boardString;
}

#pragma mark - Copy
 -(id)copyWithZone:(NSZone *)zone
{
    Board *board = [[Board alloc] init];
    board.boardArray = [NSMutableArray arrayWithArray:self.boardArray];
    board.totalMovesPlayed = _totalMovesPlayed ;
    board.winner = [self.winner copy];
    board.gameOver = _gameOver;
    return board;
}

@end