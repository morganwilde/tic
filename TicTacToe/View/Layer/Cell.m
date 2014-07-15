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
@dynamic width;
@dynamic height;

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
        /* Children */
        self.horizontal     = temp.horizontal;
        self.vertical       = temp.vertical;
        self.diagonalRight  = temp.diagonalRight;
        self.diagonalLeft   = temp.diagonalLeft;
        /* Face layer */
        self.isFace         = temp.isFace;
        self.faceOccupant   = temp.faceOccupant;
        self.sublayerAdded  = temp.sublayerAdded;
    }
    return self;
}

+ (id)initChildOfLayer:(id)layer
{
    Cell *parent = (Cell *)layer;
    Cell *child = [[self alloc] init];
    if (child) {
        child.rect           = parent.rect;
        child.width          = parent.width;
        child.height         = parent.height;
        child.paddingLeft    = parent.paddingLeft;
        child.paddingTop     = parent.paddingTop;
        child.frame          = parent.frame;
        child.sublayerAdded  = parent.sublayerAdded;
    }
    return child;
}

+ (id)layerWithBounds:(CGRect)bounds frame:(CGRect)frame padding:(CGPoint)padding
{
    Cell *layer = [[self alloc] init];
    if (layer) {
        layer.rect          = bounds;
        layer.width         = bounds.size.width;
        layer.height        = bounds.size.height;
        layer.paddingLeft   = padding.x;
        layer.paddingTop    = padding.y;
        layer.frame         = frame;
        
        /* Initialise all children */
        layer.face          = [Cell initChildOfLayer:layer];
        layer.horizontal    = [Cell initChildOfLayer:layer];
        layer.vertical      = [Cell initChildOfLayer:layer];
        layer.diagonalRight = [Cell initChildOfLayer:layer];
        layer.diagonalLeft  = [Cell initChildOfLayer:layer];
        // Custom properties
        layer.face.isFace = YES;
        layer.horizontal.paddingTop     =
        layer.vertical.paddingTop       =
        layer.diagonalRight.paddingTop  =
        layer.diagonalLeft.paddingTop   = 0;
        
        /* Rotate into position */
        CGPoint centerPoint = CGPointMake(layer.bounds.size.width / 2.0,
                                          layer.bounds.size.height / 2.0);
        CGPoint rotationPoint = CGPointMake(layer.rect.origin.x + layer.rect.size.width/2.0,
                                            layer.rect.origin.y + layer.rect.size.height/2.0);
        CGFloat rotationAngle = 0;
        
        // Vertical
        rotationAngle = M_PI/2;
        CATransform3D transformVertical = CATransform3DIdentity;
        transformVertical = CATransform3DTranslate(transformVertical, rotationPoint.x-centerPoint.x, rotationPoint.y-centerPoint.y, 0.0);
        transformVertical = CATransform3DRotate(transformVertical, rotationAngle, 0.0, 0.0, 1.0);
        transformVertical = CATransform3DTranslate(transformVertical, centerPoint.x-rotationPoint.x, centerPoint.y-rotationPoint.y, 0.0);
        layer.vertical.transform = transformVertical;
        
        // Right diagonal
        rotationAngle = M_PI/4 + M_PI/2;
        CATransform3D transformRight = CATransform3DIdentity;
        transformRight = CATransform3DTranslate(transformRight, rotationPoint.x-centerPoint.x, rotationPoint.y-centerPoint.y, 0.0);
        transformRight = CATransform3DRotate(transformRight, rotationAngle, 0.0, 0.0, 1.0);
        transformRight = CATransform3DTranslate(transformRight, centerPoint.x-rotationPoint.x, centerPoint.y-rotationPoint.y, 0.0);
        layer.diagonalRight.transform = transformRight;
        
        // Left diagonal
        rotationAngle = M_PI/4;
        CATransform3D transformLeft = CATransform3DIdentity;
        transformLeft = CATransform3DTranslate(transformLeft, rotationPoint.x-centerPoint.x, rotationPoint.y-centerPoint.y, 0.0);
        transformLeft = CATransform3DRotate(transformLeft, rotationAngle, 0.0, 0.0, 1.0);
        transformLeft = CATransform3DTranslate(transformLeft, centerPoint.x-rotationPoint.x, centerPoint.y-rotationPoint.y, 0.0);
        layer.diagonalLeft.transform = transformLeft;
        
        /* Add them in the layer stack */
        [layer addSublayer:layer.face];
    }
    return layer;
}

- (void)drawInContext:(CGContextRef)ctx
{
    if (self.face) {
        // Don't draw anything for the superLayer
    } else {
        UIGraphicsPushContext(ctx);
        
        // Shape
        CGFloat cellCornerRadius = self.width * 0.5;
        CGRect cellRect = CGRectMake(self.rect.origin.x + self.paddingLeft - self.backward,
                                     self.rect.origin.y + self.paddingTop,
                                     self.width + self.backward + self.forward,
                                     self.height);
        UIBezierPath *cell = [UIBezierPath bezierPathWithRoundedRect:cellRect cornerRadius:cellCornerRadius];
        
        
        // Color
        if (self.isFace) {
            /* Settings*/
            CGRect rect = self.rect;
            const CGFloat padding = rect.size.width * 0.40;
            const CGFloat strokeWidth = 0;
            /* Frame and path */
            CGRect pathRect = CGRectMake(rect.origin.x + padding + strokeWidth,
                                         rect.origin.y + padding + strokeWidth,
                                         rect.size.width - (padding + strokeWidth) * 2,
                                         rect.size.height - (padding + strokeWidth) * 2);
            UIBezierPath *path = nil;
            switch (self.faceOccupant) {
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
            if (self.faceOccupant == ZZSymbolTypeX) {
                [[Colorscheme colorGridCellActiveForegroundOne] setStroke];
                [[Colorscheme colorGridCellActiveOne] setFill];
            } else if (self.faceOccupant == ZZSymbolTypeO) {
                [[Colorscheme colorGridCellActiveForegroundTwo] setStroke];
                [[Colorscheme colorGridCellActiveTwo] setFill];
            } else {
                [[Colorscheme colorGridCellInactive] setFill];
            }
            
            /* Color the path */
            path.lineWidth = rect.size.width * 0.05;
            path.lineCapStyle = kCGLineCapRound;
            [path stroke];
            
        } else {
            [[Colorscheme colorGridCellInactive] setFill];
        }
        
        [cell fill];
        
        UIGraphicsPopContext();
    }
}
#pragma mark - Animations
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"paddingLeft"] ||
        [key isEqualToString:@"paddingTop"] ||
        [key isEqualToString:@"width"] ||
        [key isEqualToString:@"forward"] ||
        [key isEqualToString:@"backward"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        if (!self.sublayerAdded) {
            self.face.paddingTop = 0;
            [self insertSublayer:self.horizontal below:self.face];
            [self insertSublayer:self.vertical below:self.face];
            [self insertSublayer:self.diagonalRight below:self.face];
            [self insertSublayer:self.diagonalLeft below:self.face];
            
            self.sublayerAdded = YES;
        }
    }
}
- (void)merge:(ZZGridCellMergeDirection)direction
{
    Cell *cell = nil;
    NSString *key = nil;
    CGFloat from = 0;
    CGFloat to = 0;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.duration = 0.25;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = cell;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    switch (direction) {
        case ZZGridCellMergeDirectionTop:
            cell = self.vertical;
            key = @"backward";
            to = self.horizontalD;
            break;
        case ZZGridCellMergeDirectionTopRight:
            cell = self.diagonalRight;
            key = @"backward";
            to = self.diagonalD;
            break;
        case ZZGridCellMergeDirectionRight:
            cell = self.horizontal;
            key = @"forward";
            to = self.horizontalD;
            break;
        case ZZGridCellMergeDirectionBottomRight:
            cell = self.diagonalLeft;
            key = @"forward";
            to = self.diagonalD;
            break;
        case ZZGridCellMergeDirectionBottom:
            cell = self.vertical;
            key = @"forward";
            to = self.horizontalD;
            break;
        case ZZGridCellMergeDirectionBottomLeft:
            cell = self.diagonalRight;
            key = @"forward";
            to = self.diagonalD;
            break;
        case ZZGridCellMergeDirectionLeft:
            cell = self.horizontal;
            key = @"backward";
            to = self.horizontalD;
            break;
        case ZZGridCellMergeDirectionTopLeft:
            cell = self.diagonalLeft;
            key = @"backward";
            to = self.diagonalD;
            break;
            
        default:
            break;
    }

    animation.fromValue = [NSNumber numberWithDouble:from];
    animation.toValue   = [NSNumber numberWithDouble:to];
    [cell addAnimation:animation forKey:key];
}

@end
