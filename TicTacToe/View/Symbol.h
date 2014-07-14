//
//  Symbol.h
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ZZSymbolType {
    ZZSymbolTypeX = 1,
    ZZSymbolTypeO = 2
} ZZSymbolType;

@interface Symbol : UIView

@property (nonatomic) ZZSymbolType symbol;

- (id)initWithFrame:(CGRect)frame andSymbol:(ZZSymbolType)symbol;

@end
