//
//  Game.m
//  CardGame
//
//  Created by iYww on 15/10/20.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "Game.h"

@interface Game()

@end

@implementation Game

- (NSMutableArray *)cards {
    if(!_cards){
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

- (NSMutableArray *)chosenCards {
    if(!_chosenCards) {
        _chosenCards = [[NSMutableArray alloc] init];
    }

    return _chosenCards;
}

- (instancetype)initCardsUsingDeck:(Deck *)deck {
    self = [super init];
    
    if(self) {
        Card *card = [deck drawRandomCard];
        while(card) {
            [self.cards addObject:card];
            card = [deck drawRandomCard];
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    if(index < [self.cards count]) {
        return self.cards[index];
    }else {
        return nil;
    }
}

- (void)chooseCardAtIndex:(NSUInteger)index {
    if(index < [self.cards count]) {
        Card *card = self.cards[index];
        card.chosen = YES;
    }
}

@end
