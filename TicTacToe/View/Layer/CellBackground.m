//
//  CellBackground.m
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "CellBackground.h"
#import "../Colorscheme.h"

@implementation CellBackground

@dynamic expandTop;
@dynamic expandRight;
@dynamic expandBottom;
@dynamic expandLeft;

- (id)init
{
    self = [super init];
    if (!self) {
        self.colorBack = [Colorscheme colorGridCellInactive];
    }
    return self;
}

- (id)initWithLayer:(id)layer
{
    CellBackground *temp = (CellBackground *)layer;
    self = [super initWithLayer:layer];
    if (self) {
        self.colorBack = temp.colorBack;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    UIGraphicsPushContext(ctx);
    
    /* Settings */
    static CGFloat padding = 20;
    static CGFloat strokeWidth = 0;
    
    /* Frame and path */
    CGRect rect     = self.bounds;
    CGFloat originX = rect.origin.x + padding + strokeWidth;
    CGFloat originY = rect.origin.y + padding + strokeWidth;
    CGFloat sizeW   = rect.size.width - (padding + strokeWidth) * 2;
    CGFloat sizeH   = rect.size.height - (padding + strokeWidth) * 2;
    CGRect horizontalRect   = CGRectMake(originX - self.expandLeft,
                                         originY,
                                         sizeW + self.expandRight + self.expandLeft,
                                         sizeH);
    CGRect verticalRect     = CGRectMake(originX,
                                         originY - self.expandTop,
                                         sizeW,
                                         sizeH + self.expandTop + self.expandBottom);
    
    const CGFloat cornerRadius = horizontalRect.size.width / 2.0;
    
    UIBezierPath *backHorizontal = [UIBezierPath bezierPathWithRoundedRect:horizontalRect
                                                              cornerRadius:cornerRadius];
    UIBezierPath *backVertical = [UIBezierPath bezierPathWithRoundedRect:verticalRect
                                                            cornerRadius:cornerRadius];
    
    /* Colors */
    [self.colorBack setFill];
    /* Color the path */
    backHorizontal.lineWidth = strokeWidth;
    backVertical.lineWidth = strokeWidth;
    [backHorizontal stroke];
    [backHorizontal fill];
    [backVertical stroke];
    [backVertical fill];
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"expandTop"] ||
        [key isEqualToString:@"expandRight"] ||
        [key isEqualToString:@"expandBottom"] ||
        [key isEqualToString:@"expandLeft"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

@end
