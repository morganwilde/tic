//
//  AI.m
//  TicTacToe
//
//  Created by Chris Howell on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "AI.h"
#import "Board.h"

@interface AI()
@property (nonatomic) CGPoint chosenMove;
@property (nonatomic) NSInteger score;
- (NSInteger)score;
- (NSInteger) minimaxWithRoot:(Board *) board withDepth: (NSInteger) depth andMaximisingPlayer: (BOOL) maxPlayer;
@end

@implementation AI

- (CGPoint)nextMoveForBoard: (Board *) board
{
    if (board.totalMovesPlayed == 0) {
        return CGPointMake(0, 0);
    }
    iterations = 0;
    int bestUtility = [self minimaxWithRoot:board withDepth:300 andMaximisingPlayer:YES];
    NSLog(@"Best move: %@", NSStringFromCGPoint(self.chosenMove));
    NSLog(@"iterations: %i", iterations);
    return self.chosenMove;
}

static int iterations = 0;
- (NSInteger) minimaxWithRoot:(Board *) board withDepth: (NSInteger) depth andMaximisingPlayer: (BOOL) maxPlayer
{
    iterations = iterations + 1;
    NSMutableArray *scores = [NSMutableArray new];
    NSMutableArray *moves = [NSMutableArray new];
    
    if (board.gameOver || [[board possibleMoves] count] == 0) {
        int score = [self scoreForBoard:board];
        return score;
    } else {
        
        for (NSValue *moveWrapper in [board possibleMoves]) {
            CGPoint move = moveWrapper.CGPointValue;
            
            Board *newBoard = [board copy];
            if (newBoard.isCrossTurn) {
                [newBoard playCrossMove:move];
            } else {
                [newBoard playCircleMove:move];
            }
        
            [scores addObject:[NSNumber numberWithInt:[self minimaxWithRoot:newBoard withDepth:depth - 1 andMaximisingPlayer:NO]]];
            [moves addObject:moveWrapper];
        }
        
        if (board.isCrossTurn)
        {
            int max = 0;
            int maxIndex = 0;
            for (NSNumber *number in scores) {
                if ([number intValue] >= max) {
                    maxIndex = [scores indexOfObject:number];
                    max = [number intValue];
                }
            }
            
            self.chosenMove = ((NSValue *)moves[maxIndex]).CGPointValue;
            return [[scores objectAtIndex:maxIndex] intValue];
        } else {
            int min = 0;
            int minIndex = 0;
            for (NSNumber *number in scores) {
                if ([number intValue] <= min) {
                    minIndex = [scores indexOfObject:number];
                    min = [number intValue];
                }
            }
            
            self.chosenMove = ((NSValue *)moves[minIndex]).CGPointValue;
            return [[scores objectAtIndex:minIndex] intValue];
        }
    }
}

// Todo: make score more appropriate for each node, i.e. if you have 2 in a row you get a higher score (lower if opp. has 2 in a row)
//- (NSInteger)nodeScoreForBoard:(Board *)board
//{
//    
//}

- (NSInteger)scoreForBoard: (Board *) board
{
    if ([board.winner isEqualToString:@"X"]) {
        return 1;
    } else if ([board.winner isEqualToString:@"O"]) {
        return -1;
    } else {
        return 0;
    }
//    return [board scoreForCounter:@"X"];
}


@end
