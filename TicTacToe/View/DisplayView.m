//
//  DisplayView.m
//  TicTacToe
//
//  Created by Morgan Wilde on 14/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "DisplayView.h"

@interface DisplayView()



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
- (id)initWithFrame:(CGRect)frame GridSizeColumns:(int)columns Rows:(int)rows
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.gridColumns = columns;
        self.gridRows = rows;
        [self.layer addSublayer:self.displayLayer];
        [self.displayLayer setNeedsDisplay];
    }
    return self;
}
#pragma mark - Lazy initialisers
- (DisplayLayer *)displayLayer
{
    if (!_displayLayer) {
        _displayLayer = [DisplayLayer layerWithSize:self.bounds Columns:self.gridColumns Rows:self.gridRows];
        _displayLayer.frame = self.bounds;
        // Inform the view hierarchy to display this layer now
        [_displayLayer setNeedsDisplay];
    }
    return _displayLayer;
}
#pragma mark - Animations
- (void)animateCellsIntoDisplay
{
    double timeGap = 0.1;
    CFTimeInterval beginTime = CACurrentMediaTime() + timeGap * (self.gridRows * self.gridColumns);
    
    for (int i = 0; i < self.gridRows; i++) {
        for (int j = 0; j < self.gridColumns; j++) {
            Cell *cell = [self.displayLayer getCellAtX:j Y:i];
            CABasicAnimation *animation = [CABasicAnimation animation];
            animation.duration = 0.5;
            animation.beginTime = beginTime;
            animation.fillMode = kCAFillModeForwards;
            //animation.removedOnCompletion = NO;
            animation.delegate = cell;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.fromValue = [NSNumber numberWithDouble:cell.paddingTop];
            animation.toValue   = [NSNumber numberWithDouble:0];
            [cell.face addAnimation:animation forKey:@"paddingTop"];
            beginTime -= timeGap;
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    //[self animateCellsIntoDisplay];
}

@end
