//
//  Cell.h
//  TicTacToe
//
//  Created by Morgan Wilde on 14/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface Cell : CALayer

@property (nonatomic) CGRect rect;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat paddingLeft;
@property (nonatomic) CGFloat paddingTop;

+ (id)layerWithBounds:(CGRect)bounds padding:(CGPoint)padding;

@end
