//
//  Character.m
//  TicTacToe
//
//  Created by Morgan Wilde on 11/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "Character.h"

@implementation Character

@dynamic red;
@dynamic green;
@dynamic blue;

- (id)initWithLayer:(id)layer
{
    Character *temp = (Character *)layer;
    self = [super initWithLayer:layer];
    if (self) {
        self.symbol = temp.symbol;
        self.red    = temp.red;
        self.green  = temp.green;
        self.blue   = temp.blue;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    UIGraphicsPushContext(ctx);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    [[UIColor redColor] setFill];
    [path fill];
    
    /* Set symbol color */
    NSRange range = {0, [self.symbol length]};
    UIColor *foreground = [UIColor colorWithRed:self.red    / 255.0
                                          green:self.green  / 255.0
                                           blue:self.blue   / 255.0
                                          alpha:1];
    [self.symbol addAttribute:NSForegroundColorAttributeName value:foreground range:range];
    NSLog(@"green: %d", self.green);
    
    CGSize symbolSize = CGSizeMake(0.0, 0.0);
    CGRect symbolBounds = [self.symbol boundingRectWithSize:symbolSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                    context:nil];
    CGRect symbolRect = CGRectMake(self.bounds.size.width/2.0 - symbolBounds.size.width/2.0,
                                   self.bounds.size.height/2.0 - symbolBounds.size.height/2.0,
                                   symbolBounds.size.width,
                                   symbolBounds.size.height);
    UIBezierPath *symbolBack = [UIBezierPath bezierPathWithRect:symbolRect];
    [[UIColor greenColor] setFill];
    [symbolBack fill];
    [self.symbol drawInRect:symbolRect];
    
    UIGraphicsPopContext();
}

+ (id)layer
{
    Character *layer = [[self alloc] init];
    if (layer) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Fabada" size:72],
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
        layer.symbol = [[NSMutableAttributedString alloc] initWithString:@"X" attributes:attributes];
        layer.green = 255;
    }
    return layer;
}

#pragma mark - Animations
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"red"] ||
        [key isEqualToString:@"green"] ||
        [key isEqualToString:@"blue"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

@end
