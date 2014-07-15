//
//  ;
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colorscheme : NSObject

+ (UIColor *)colorGridCellInactive;
/* Played cell background colors */
+ (UIColor *)colorGridCellActiveOne;
+ (UIColor *)colorGridCellActiveTwo;
/* Player cell foreground colors */
+ (UIColor *)colorGridCellActiveForegroundOne;
+ (UIColor *)colorGridCellActiveForegroundTwo;
/* Background colors */
+ (UIColor *)colorBackground;
+ (UIColor *)blueMellowColor;
+ (UIColor *)chalkboardBlackColor;
/* Foreground colors */
+ (UIColor *)lightGrayColor;
+ (UIColor *)darkGrayColor;

+ (UIColor *)darkPurpleColor;
+ (UIColor *)blackPurpleColor;
+ (UIColor *)brightGreenColor;
+ (UIColor *)brightYellowColor;

@end
