//
//  CardSetGame.m
//  CardGame
//
//  Created by iYww on 15/10/20.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "CardSetGame.h"

@implementation CardSetGame

- (void)chooseCardAtIndex:(NSUInteger)index {
    SetCard *card = [self.cards objectAtIndex:index];
    
    if(!card.isMatched) {
        if(card.isChosen) {
            card.chosen = NO;
            [self.chosenCards removeObject:card];
        }else {
            card.chosen = YES;
            [self.chosenCards addObject:card];
            int score = 0;
            if([self.chosenCards count] == 3) {
                NSArray *othercards = [self.chosenCards objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
                score = [card match:othercards];
                if(score) {
                    for(SetCard *matchedCard in self.chosenCards) {
                        matchedCard.matched = YES;
                    }
                    self.score += score;
                }else {
                    for(SetCard *notMatchedCard in self.chosenCards) {
                        notMatchedCard.chosen = NO;
                    }
                }
                [self.chosenCards removeAllObjects];
            }
        }
    }
}

@end
