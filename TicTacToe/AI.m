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
    int bestUtility = [self minimaxWithRoot:board withDepth:3 andMaximisingPlayer:YES];
    NSLog(@"Best move: %@", NSStringFromCGPoint(self.chosenMove));
    NSLog(@"iterations: %i", iterations);
    return self.chosenMove;
}

static int iterations = 0;
- (NSInteger) minimaxWithRoot:(Board *) board withDepth: (NSInteger) depth andMaximisingPlayer: (BOOL) maxPlayer
{
    iterations = iterations + 1;
    
    if (board.gameOver || [[board possibleMoves] count] == 0) {
        int score = [self scoreForBoard:board];
        return score;
    } else {
        int bestValue = 0;
        if (maxPlayer)
        {
            bestValue = -10000;
            for (NSValue *moveWrapper in [board possibleMoves]) {
                CGPoint move = moveWrapper.CGPointValue;
                
                Board *newBoard = [board copy];
                [newBoard playCrossMove:move];
                
                int value = [self minimaxWithRoot:newBoard withDepth:depth - 1 andMaximisingPlayer:NO];
                if (value > bestValue) {
                    bestValue = value;
                    self.chosenMove = move;
                }
            }
        } else {
            bestValue = 10000;
            for (NSValue *moveWrapper in [board possibleMoves]) {
                CGPoint move = moveWrapper.CGPointValue;
                
                Board *newBoard = [board copy];
                [newBoard playCircleMove:move];
                
                int value = [self minimaxWithRoot:newBoard withDepth:depth - 1 andMaximisingPlayer:YES];
                if (value < bestValue) {
                    bestValue = value;
                    self.chosenMove = move;
                }
            }
        }
        return bestValue;
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
        return 100;
    } else if ([board.winner isEqualToString:@"O"]) {
        return -100;
    } else {
        return 0;
    }
//    return [board scoreForCounter:@"X"];
}


@end
