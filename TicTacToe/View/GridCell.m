//
//  GridCell.m
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "GridCell.h"
#import "Colorscheme.h"
#import "Symbol.h"
#import "Layer/CellBackground.h"
#import "GameVC.h"

@interface GridCell()

@property (nonatomic, strong) CellBackground *backgroundLayer;
@property (nonatomic, strong) Symbol *symbolX;
@property (nonatomic, strong) Symbol *symbolO;

@end

@implementation GridCell

- (id)initWithFrame:(CGRect)frame positionX:(int)x Y:(int)y
{
    self = [super initWithFrame:frame];
    if (self) {
        /* Position */
        self.positionX = x;
        self.positionY = y;
        
        /* Background layer setup */
        self.backgroundColor = [UIColor clearColor];
        self.colorBack = [Colorscheme blackPurpleColor];
        [self.layer addSublayer: self.backgroundLayer];
        [self.backgroundLayer setNeedsDisplay];
        
        /* Initialize the X, O symbols */
        self.occupant = ZZGridOccupantEmpty;
        self.symbolX = [[Symbol alloc] initWithFrame:self.bounds andSymbol:ZZSymbolTypeX];
        self.symbolO = [[Symbol alloc] initWithFrame:self.bounds andSymbol:ZZSymbolTypeO];
        [self addSubview:self.symbolX];
        [self addSubview:self.symbolO];
        
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0;
        self.layer.shadowRadius = 25;
        self.layer.shadowColor = [Colorscheme brightGreenColor].CGColor;
    }
    return self;
}
#pragma mark - Lazy background layer init
- (CellBackground *)backgroundLayer
{
    if (!_backgroundLayer) {
        _backgroundLayer = [CellBackground layer];
        _backgroundLayer.frame = self.bounds;
        _backgroundLayer.rasterizationScale = [[UIScreen mainScreen] scale];
        _backgroundLayer.contentsScale = [[UIScreen mainScreen] scale];
        _backgroundLayer.colorBack = self.colorBack;
        /* Merge expansions */
        _backgroundLayer.expandTop      = 0;
        _backgroundLayer.expandRight    = 0;
        _backgroundLayer.expandBottom   = 0;
        _backgroundLayer.expandLeft     = 0;
        //_backgroundLayer.transform;
    }
    return _backgroundLayer;
}
- (void)setColorBack:(UIColor *)colorBack
{
    _colorBack = colorBack;
    self.backgroundLayer.colorBack = colorBack;
    [self.backgroundLayer setNeedsDisplay];
}
#pragma mark - Changing grid cell state
- (void)activate:(ZZGridOccupant)state
{
    switch (state) {
        case ZZGridOccupantX:
            self.occupant = ZZGridOccupantX;
            self.colorBack = [Colorscheme brightGreenColor];
            self.symbolX.hidden = NO;
            break;
        case ZZGridOccupantO:
            self.occupant = ZZGridOccupantO;
            self.colorBack = [Colorscheme brightYellowColor];
            self.symbolO.hidden = NO;
            break;
        default:
            self.colorBack = [Colorscheme blackPurpleColor];
            break;
    }
}
#pragma mark - Animate grid cell for merge
- (void)merge:(ZZGridCellMergeDirection)direction
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.duration = 0.5;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :1 :1];
    animation.fromValue = [NSNumber numberWithDouble:0];
    switch (direction) {
        case ZZGridCellMergeDirectionTop:
            animation.toValue   = [NSNumber numberWithDouble:self.bounds.size.height/2.0 + 10];
            [self.backgroundLayer addAnimation:animation forKey:@"expandTop"];
            break;
        case ZZGridCellMergeDirectionRight:
            animation.toValue   = [NSNumber numberWithDouble:self.bounds.size.width/2.0];
            [self.backgroundLayer addAnimation:animation forKey:@"expandRight"];
            break;
        case ZZGridCellMergeDirectionBottom:
            animation.toValue   = [NSNumber numberWithDouble:self.bounds.size.height/2.0 + 10];
            [self.backgroundLayer addAnimation:animation forKey:@"expandBottom"];
            break;
        case ZZGridCellMergeDirectionLeft:
            animation.toValue   = [NSNumber numberWithDouble:self.bounds.size.width/2.0];
            [self.backgroundLayer addAnimation:animation forKey:@"expandLeft"];
            break;
        default:
            break;
    }
    [self setNeedsDisplay];
    self.mergeDirections |= direction;
}
- (void)animateWinningCell
{
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.15
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1.2, 1.2);
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             NSLog(@"done");
                         }
                     }];
}

- (void)animateCellIntoView
{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1, 1);
                     }
                     completion:^(BOOL finished){
                     }];
}
- (void)animateCellOutOfView
{
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.15
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(0, 0);
                     }
                     completion:^(BOOL finished){
                     }];
}
#pragma mark - Actions
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.parentVC touchReceivedFor:self];
}

@end
