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
    int bestUtility = [self minimaxWithRoot:board withDepth:3 andMaximisingPlayer:YES];
    NSLog(@"Best move: %@", NSStringFromCGPoint(self.chosenMove));
    return self.chosenMove;
}

static int iterations = 0;
static int backups = 0;
- (NSInteger) minimaxWithRoot:(Board *) board withDepth: (NSInteger) depth andMaximisingPlayer: (BOOL) maxPlayer
{
    iterations = iterations + 1;
    NSLog(@"%@", board);
    NSLog(@"board count: %i, gameover: %i", [[board possibleMoves] count], board.gameOver);
    if (board.gameOver || [[board possibleMoves] count] == 0) {
        NSLog(@"Iterations: %i", iterations);
        NSLog(@"backups: %i", backups);
        return [self scoreForBoard:board];
    } else {
        int bestValue = 0;
        if (maxPlayer)
        {
            bestValue = -100;
//            NSLog(@"%i", [[board possibleMoves] count]);
            for (NSValue *moveWrapper in [board possibleMoves]) {
                CGPoint move = moveWrapper.CGPointValue;
            
                [board playCrossMove:move];

                int value = [self minimaxWithRoot:[board copy] withDepth:depth - 1 andMaximisingPlayer:NO];
                if (value > bestValue) {
                    bestValue = value;
                    self.chosenMove = move;
                }
            }
            backups = backups + 1;
            return bestValue;
        } else {
            bestValue = 100;
//            NSLog(@"%i", [[board possibleMoves] count]);
            for (NSValue *moveWrapper in [board possibleMoves]) {
                CGPoint move = moveWrapper.CGPointValue;
                
                [board playCircleMove:move];
                
                int value = [self minimaxWithRoot:[board copy] withDepth:depth - 1 andMaximisingPlayer:YES];
                if (value < bestValue) {
                    bestValue = value;
                    self.chosenMove = move;
                }
            }
            backups = backups + 1;
            return bestValue;
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
        NSLog(@"%@", board);
        return 10;
    } else if ([board.winner isEqualToString:@"O"]) {
        return -10;
    } else {
        return 0;
    }
}


@end
