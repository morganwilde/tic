//
//  DisplayView.m
//  TicTacToe
//
//  Created by Morgan Wilde on 14/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "DisplayView.h"
#import "DisplayLayer.h"

@interface DisplayView()

@property (nonatomic, strong) DisplayLayer *displayLayer;

@end

@implementation DisplayView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:self.displayLayer];
    }
    return self;
}
#pragma mark - Lazy initialisers
- (DisplayLayer *)displayLayer
{
    if (!_displayLayer) {
        _displayLayer = [DisplayLayer layer];
        _displayLayer.frame = self.bounds;
        // Inform the view hierarchy to display this layer now
        [_displayLayer setNeedsDisplay];
    }
    return _displayLayer;
}
#pragma mark - Animations
- (void)animateCellsIntoDisplay
{
    CFTimeInterval beginTime = 0;
    for (int i = 0; i < self.displayLayer.cellsInColumn; i++) {
        for (int j = 0; j < self.displayLayer.cellsInRow; j++) {
            Cell *cell = [self.displayLayer getCellAtX:j Y:i];
            CABasicAnimation *animation = [CABasicAnimation animation];
            animation.duration = 0.5;
            animation.beginTime = beginTime;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.delegate = self;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.fromValue = [NSNumber numberWithDouble:cell.paddingTop];
            animation.toValue   = [NSNumber numberWithDouble:0];
            [cell addAnimation:animation forKey:@"paddingTop"];
            beginTime += 0.05;
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self animateCellsIntoDisplay];
}

@end
