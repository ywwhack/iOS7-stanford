//
//  SetDeck.m
//  CardGame
//
//  Created by iYww on 15/10/19.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "SetDeck.h"

@implementation SetDeck

- (instancetype)init {
    self = [super init];
    
    if(self) {
        for(NSNumber *number in [SetCard numbers]) {
            for(NSString *color in [SetCard colors]) {
                for(NSString *symbol in [SetCard symbols]) {
                    for(NSNumber *shading in [SetCard shadings] ) {
                        
                        SetCard *card = [[SetCard alloc] init];
                        card.attributes = @{@"number":number, @"color":color, @"symbol":symbol, @"shading":shading};
                        
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
