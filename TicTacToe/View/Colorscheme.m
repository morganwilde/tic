//
//  Colorscheme.m
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "Colorscheme.h"

/* Helper functions */
UIColor *colorWith(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) { return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha]; }

@implementation Colorscheme

+ (UIColor *)colorGridCellInactive { return colorWith(68, 88, 107, 1); }
/* Played cell background colors */
+ (UIColor *)colorGridCellActiveOne { return colorWith(134, 182, 13, 1); }
+ (UIColor *)colorGridCellActiveTwo { return colorWith(226, 71, 77, 1); }
/* Player cell foreground colors */
+ (UIColor *)colorGridCellActiveForegroundOne { return colorWith(90, 130, 24, 1); }
+ (UIColor *)colorGridCellActiveForegroundTwo { return colorWith(163, 50, 64, 1); }
/* Background colors */
+ (UIColor *)colorBackground { return colorWith(45, 41, 76, 1); }
+ (UIColor *)blueMellowColor { return colorWith(89, 157, 186, 1.0); }
+ (UIColor *)chalkboardBlackColor { return colorWith(65, 65, 65, 1); }
// Old colorscheme
+ (UIColor *)darkPurpleColor { return colorWith(36, 38, 63, 1); }
+ (UIColor *)blackPurpleColor { return colorWith(48, 51, 77, 1); }
+ (UIColor *)brightGreenColor { return colorWith(131, 255, 0, 1); }
+ (UIColor *)brightYellowColor { return colorWith(199, 255, 1, 1); }
/* Foreground colors */
+ (UIColor *)lightGrayColor { return colorWith(216, 216, 216, 1); }
+ (UIColor *)darkGrayColor { return colorWith(175, 175, 175, 1); }

@end
