//
//  Character.h
//  TicTacToe
//
//  Created by Morgan Wilde on 11/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface Character : CALayer

@property (nonatomic, strong) NSMutableAttributedString *symbol;
@property (nonatomic) CGFloat symbolOpacity;
@property (nonatomic) int red;
@property (nonatomic) int green;
@property (nonatomic) int blue;

@end
