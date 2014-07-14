//
//  CellBackground.h
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CellBackground : CALayer

@property (nonatomic, strong) UIColor *colorBack;
/* These coordinate vertical/horizontal merges */
@property (nonatomic) CGFloat expandTop;
@property (nonatomic) CGFloat expandRight;
@property (nonatomic) CGFloat expandBottom;
@property (nonatomic) CGFloat expandLeft;

@end
