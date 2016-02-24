//
//  PlayingDeck.m
//  CardGame
//
//  Created by iYww on 15/10/16.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "PlayingDeck.h"

@implementation PlayingDeck

- (instancetype)init {
    self = [super init];
    if(self) {
        for(NSString *suit in [PlayingCard validSuit]) {
            for(NSUInteger rank=1; rank<=[PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
            }
        }
    }
    
    return self;
}

@end
