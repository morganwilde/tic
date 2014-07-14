//
//  Symbol.m
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "Symbol.h"
#import "Colorscheme.h"

@implementation Symbol

- (id)initWithFrame:(CGRect)frame andSymbol:(ZZSymbolType)symbol
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.symbol = symbol;
        self.hidden = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    /* Settings*/
    const CGFloat padding = rect.size.width * 0.40;
    const CGFloat strokeWidth = 0;
    /* Frame and path */
    CGRect pathRect = CGRectMake(rect.origin.x + padding + strokeWidth,
                                 rect.origin.y + padding + strokeWidth,
                                 rect.size.width - (padding + strokeWidth) * 2,
                                 rect.size.height - (padding + strokeWidth) * 2);
    UIBezierPath *path = nil;
    switch (self.symbol) {
        case ZZSymbolTypeX:
            /* The X */
            path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(pathRect.origin.x, pathRect.origin.y)];
            [path addLineToPoint:CGPointMake(pathRect.origin.x + pathRect.size.width, pathRect.origin.y + pathRect.size.height)];
            [path moveToPoint:CGPointMake(pathRect.origin.x + pathRect.size.width, pathRect.origin.y)];
            [path addLineToPoint:CGPointMake(pathRect.origin.x, pathRect.origin.y + pathRect.size.height)];
            break;
        case ZZSymbolTypeO:
            /* The O */
            path = [UIBezierPath bezierPathWithOvalInRect:pathRect];
        default:
            /* Do Nothing for random inputs */
            break;
    }
    
    /* Colors */
    if (self.symbol == ZZSymbolTypeX) {
        [[Colorscheme colorGridCellActiveForegroundOne] setStroke];
    } else if (self.symbol == ZZSymbolTypeO) {
        [[Colorscheme colorGridCellActiveForegroundTwo] setStroke];
    }
    
    /* Color the path */
    path.lineWidth = rect.size.width * 0.05;
    path.lineCapStyle = kCGLineCapRound;
    [path stroke];
}

@end
