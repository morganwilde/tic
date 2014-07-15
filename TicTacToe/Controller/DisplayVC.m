//
//  DisplayVC.m
//  TicTacToe
//
//  Created by Morgan Wilde on 14/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "DisplayVC.h"
#import "../View/DisplayView.h"
#import "../View/Layer/Cell.h"

@interface DisplayVC ()

@property (nonatomic, strong) DisplayView *display;
@property (nonatomic) int gridColumns;
@property (nonatomic) int gridRows;

@end

@implementation DisplayVC

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Setup
    }
    return self;
}
#pragma mark - VC life cycle
- (void)viewWillLayoutSubviews
{
    self.gridColumns    = 3;
    self.gridRows       = 3;
    CGRect displayRect = CGRectMake(54,
                                    0,
                                    660,
                                    842);
    self.display = [[DisplayView alloc] initWithFrame:displayRect
                                      GridSizeColumns:self.gridColumns
                                                 Rows:self.gridRows];
    [self.view addSubview:self.display];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.display animateCellsIntoDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    self.counter++;
    Cell *cell = (Cell *)[self.display.displayLayer getCellAtX:1 Y:1];
    [cell merge:(1 << self.counter)];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
