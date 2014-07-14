//
//  Cell.m
//  TicTacToe
//
//  Created by Morgan Wilde on 14/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "Cell.h"

@implementation Cell

@dynamic paddingLeft;
@dynamic paddingTop;

- (id)initWithLayer:(id)layer
{
    Cell *temp = (Cell *)layer;
    self = [super initWithLayer:layer];
    if (self) {
        self.rect           = temp.rect;
        self.width          = temp.width;
        self.height         = temp.height;
        self.paddingLeft    = temp.paddingLeft;
        self.paddingTop     = temp.paddingTop;
    }
    return self;
}

+ (id)layerWithBounds:(CGRect)bounds padding:(CGPoint)padding
{
    Cell *layer = [[self alloc] init];
    if (layer) {
        layer.rect          = bounds;
        layer.width         = bounds.size.width;
        layer.height        = bounds.size.height;
        layer.paddingLeft   = padding.x;
        layer.paddingTop    = padding.y;
    }
    return layer;
}

- (void)drawInContext:(CGContextRef)ctx
{
    UIGraphicsPushContext(ctx);
    
    CGFloat cellCornerRadius = self.width * 0.5;
    CGRect cellRect = CGRectMake(self.rect.origin.x + self.paddingLeft,
                                 self.rect.origin.y + self.paddingTop,
                                 self.width,
                                 self.height);
    UIBezierPath *cell = [UIBezierPath bezierPathWithRoundedRect:cellRect cornerRadius:cellCornerRadius];
    [[UIColor orangeColor] setFill];
    [cell fill];
    
    UIGraphicsPopContext();
}
#pragma mark - Animations
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"paddingLeft"] ||
        [key isEqualToString:@"paddingTop"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

@end
