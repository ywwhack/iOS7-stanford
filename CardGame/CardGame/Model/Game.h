//
//  Game.h
//  CardGame
//
//  Created by iYww on 15/10/20.
//  Copyright © 2015年 zank. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Card.h"
#import "Deck.h"

@interface Game : NSObject {
    NSMutableArray *_cards;
    NSMutableArray *_chosenCards;
    NSInteger _score;
    BOOL _isFinishAMatchRightNow;
}

- (instancetype)initCardsUsingDeck:(Deck *)deck;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *chosenCards;
@property (nonatomic) NSInteger score;

@property (nonatomic) BOOL isFinishAMatchRightNow;

@end
