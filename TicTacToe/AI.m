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
    iterations = 0;
    [self minimaxWithRoot:board withDepth:3 andMaximisingPlayer:YES andAlpha:INT_MIN beta:INT_MAX];
    NSLog(@"Best move: %@", NSStringFromCGPoint(self.chosenMove));
    NSLog(@"iterations: %i", iterations);
    return self.chosenMove;
}

static int iterations = 0;
- (NSInteger) minimaxWithRoot:(Board *) board withDepth: (NSInteger) depth andMaximisingPlayer:(BOOL)maxPlayer andAlpha:(int)alpha beta:(int)beta
{
    iterations = iterations + 1;
    
    if (board.gameOver || [[board possibleMoves] count] == 0) {
        int score = [self scoreForBoard:board];
        return score;
    } else {
        if (maxPlayer)
        {
            for (NSValue *moveWrapper in [board possibleMoves]) {
                CGPoint move = moveWrapper.CGPointValue;
                
                Board *newBoard = [board copy];
                [newBoard playCrossMove:move];
                
                int value = [self minimaxWithRoot:newBoard withDepth:depth - 1 andMaximisingPlayer:NO andAlpha:alpha beta:beta];
                if (value > alpha) {
                    self.chosenMove = move;
                }
                
                alpha = MAX(alpha, value);
                if (alpha >= beta) {
                    return beta;
                }
            }
            return alpha;
        } else {
            for (NSValue *moveWrapper in [board possibleMoves]) {
                CGPoint move = moveWrapper.CGPointValue;
                
                Board *newBoard = [board copy];
                [newBoard playCircleMove:move];
                
                int value = [self minimaxWithRoot:newBoard withDepth:depth - 1 andMaximisingPlayer:YES andAlpha:alpha beta:beta];
                
                if (value < beta) {
                    self.chosenMove = move;
                }
                
                beta = MIN(beta, value);
                if (alpha >= beta) {
                    return alpha;
                }
            }
            return beta;
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
        return 100;
    } else if ([board.winner isEqualToString:@"O"]) {
        return -100;
    } else {
        return 0;
    }
//    return [board scoreForCounter:@"X"];
}


@end
