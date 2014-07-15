//
//  DisplayView.h
//  TicTacToe
//
//  Created by Morgan Wilde on 14/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayLayer.h"

@interface DisplayView : UIView

@property (nonatomic, strong) DisplayLayer *displayLayer;
@property (nonatomic) int gridRows;
@property (nonatomic) int gridColumns;

- (id)initWithFrame:(CGRect)frame GridSizeColumns:(int)columns Rows:(int)rows;
- (void)animateCellsIntoDisplay;

@end
