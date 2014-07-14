//
//  CharacterView.m
//  TicTacToe
//
//  Created by Morgan Wilde on 11/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "CharacterView.h"
#import "Character.h"

@interface CharacterView()

@property (nonatomic, strong) Character *character;

@end

@implementation CharacterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.character];
    }
    return self;
}

- (Character *)character
{
    if (!_character) {
        _character = [Character layer];
        _character.frame                = self.bounds;
        _character.rasterizationScale   =
        _character.contentsScale        = [[UIScreen mainScreen] scale];
        [_character setNeedsDisplay];
    }
    return _character;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.duration = 5.0;
    animation.fillMode = kCAFillModeForwards;
    //animation.removedOnCompletion = NO;
    animation.delegate = self;
    animation.fromValue = [NSNumber numberWithInt:255];
    animation.toValue   = [NSNumber numberWithInt:0];
    [self.character addAnimation:animation forKey:@"green"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        self.character.green = 0;
    }
}

@end
