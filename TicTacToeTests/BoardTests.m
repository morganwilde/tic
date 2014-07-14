//
//  BoardTests.m
//  TicTacToe
//
//  Created by Chris Howell on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Board.h"
#import "AI.h"

@interface BoardTests : XCTestCase
@property (nonatomic, strong) Board *board;
@end

@implementation BoardTests

- (void)setUp
{
    [super setUp];
    self.board = [[Board alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialisation
{
    for (int x = 0, y = 0; x < 3 && y < 3; x++, y++) {
        CGPoint point = CGPointMake(x, y);
        XCTAssertTrue([self.board isTileEmpty:point], @"Board is not fully empty on initialisation");
    }
}

- (void)testPlayCrossMoveToEmptySpace
{
    BOOL success = [self.board playCircleMove: CGPointMake(0, 0)];
    XCTAssertTrue(success, @"Move unable to be played into empty space");
    XCTAssertFalse([self.board isTileEmpty:CGPointMake(0, 0)]);
}

- (void)testPlayCircleMoveToEmptySpace
{
    BOOL success = [self.board playCircleMove: CGPointMake(0, 0)];
    XCTAssertTrue(success, @"Move unable to be played into empty space");
    XCTAssertFalse([self.board isTileEmpty:CGPointMake(0, 0)]);
}

- (void)testPlayMoveToOccupiedSpace
{
    [self.board playCircleMove:CGPointMake(0, 0)];
    BOOL success = [self.board playCrossMove:CGPointMake(0, 0)];
    XCTAssertFalse(success, @"Move played onto occupied space.");
}

- (void)testInvalidMove
{
    BOOL success = [self.board playCircleMove:CGPointMake(-1, -1)];
    XCTAssertFalse(success, @"Move allowed to invalid space.");
}

- (void)testRowWin
{
    CGPoint point = CGPointMake(0, 0);
    [self.board playCircleMove:point];
    point.x = 1;
    [self.board playCircleMove:point];
    point.x = 2;
    [self.board playCircleMove:point];
    
    BOOL isWinnerCircle = [self.board.winner isEqualToString:@"O"];
    XCTAssertTrue(isWinnerCircle, @"Circle won row but winner not updated.");
}

- (void)testColumnWin
{
    CGPoint point = CGPointMake(0, 0);
    [self.board playCircleMove:point];
    point.y = 1;
    [self.board playCircleMove:point];
    point.y = 2;
    [self.board playCircleMove:point];
    
    BOOL isWinnerCircle = [self.board.winner isEqualToString:@"O"];
    XCTAssertTrue(isWinnerCircle, @"Circle won column but winner not updated.");
}

- (void)testDraw
{
    [self.board playCrossMove:CGPointMake(0, 0)];
    [self.board playCrossMove:CGPointMake(2, 2)];
    [self.board playCrossMove:CGPointMake(2, 0)];
    [self.board playCrossMove:CGPointMake(1, 2)];
    [self.board playCrossMove:CGPointMake(0, 1)];
    
    [self.board playCircleMove:CGPointMake(1, 1)];
    [self.board playCircleMove:CGPointMake(1, 0)];
    [self.board playCircleMove:CGPointMake(0, 2)];
    [self.board playCircleMove:CGPointMake(2, 1)];
    
    BOOL isDraw = [self.board.winner isEqualToString:@"DRAW"];
    XCTAssertTrue(isDraw, @"Game was a draw but draw is not set as winner.");
}

- (void)testTopLeftDiagonalWin
{
    [self.board playCrossMove:CGPointMake(0, 0)];
    [self.board playCrossMove:CGPointMake(1, 1)];
    [self.board playCrossMove:CGPointMake(2, 2)];
    
    XCTAssertTrue([self.board.winner isEqualToString:@"X"], @"Cross won diagonally but winner wasn't correct.");
}

- (void)testTopRightDiagonalWin
{
    [self.board playCircleMove:CGPointMake(2, 0)];
    [self.board playCircleMove:CGPointMake(1, 1)];
    [self.board playCircleMove:CGPointMake(0, 2)];
    
    XCTAssertTrue([self.board.winner isEqualToString:@"O"], @"Circle won diagonally but winner wasn't correct.");
}

- (void)testPartialRow
{
    [self.board playCircleMove:CGPointMake(0, 0)];
    [self.board playCircleMove:CGPointMake(0, 1)];
    
    BOOL *winner = [self.board.winner isEqualToString:@"NONE"];
    XCTAssertTrue(winner, @"Game has been incorrectly won.");
}

- (void)testPossibleMoves
{
    XCTAssertEqual([[self.board possibleMoves] count], 9, @"Number of initial moves doesn't equal 9.");
    [self.board playCircleMove:CGPointMake(0, 0)];
    XCTAssertEqual([[self.board possibleMoves] count], 8, @"Number of moves after a move was played doesn't equal 8");
    [self.board playCrossMove:CGPointMake(0, 0)];
}

- (void)testEndGamePossibleMoves
{
    [self.board playCrossMove:CGPointMake(0, 0)];
    [self.board playCrossMove:CGPointMake(2, 2)];
    [self.board playCrossMove:CGPointMake(2, 0)];
    [self.board playCrossMove:CGPointMake(1, 2)];
    [self.board playCrossMove:CGPointMake(0, 1)];
    
    [self.board playCircleMove:CGPointMake(1, 1)];
    [self.board playCircleMove:CGPointMake(1, 0)];
    [self.board playCircleMove:CGPointMake(0, 2)];
    [self.board playCircleMove:CGPointMake(2, 1)];
    
    XCTAssertEqual([[self.board possibleMoves] count], 0, @"Number of moves for complete game is not 0.");
}

- (void)testAI
{
    AI *ai = [[AI alloc] init];
    CGPoint point = [ai nextMoveForBoard:[self.board copy]];
//    [self.board playCrossMove:point];
//    [self.board playCircleMove:CGPointMake(1, 1)];
//    point = [ai nextMoveForBoard:self.board];
//    NSLog(@"point2: %@", NSStringFromCGPoint(point));
    
}

@end
