//
//  CardMatchingGame.m
//  CardGame
//
//  Created by iYww on 15/10/17.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@end

@implementation CardMatchingGame

- (NSString *)tips {
    if(!_tips) {
        return @"";
    }
    
    return _tips;
}

const int MISMATCH_PENALTY = 2;
const int MATCH_BONUS = 4;
const int COST_TO_CHOOSE = 1;

- (BOOL)doMatch:(PlayingCard *)currntChosenCard {
    NSDictionary *result = [currntChosenCard match:self.chosenCards];
    
    NSNumber *matchSocreNumber = [result objectForKey:@"score"];
    int matchScore = matchSocreNumber.intValue;
    self.tips = [result objectForKey:@"tips"];
    self.isFinishAMatchRightNow = YES;
    if(matchScore) {
        self.score += matchScore * MATCH_BONUS;
        currntChosenCard.matched = YES;
        for(Card *card in self.chosenCards) {
            card.matched = YES;
        }
        [self.chosenCards removeAllObjects];
        return YES;
    }else {
        self.score -= MISMATCH_PENALTY;
        for(Card *card in self.chosenCards) {
            card.chosen = NO;
        }
        [self.chosenCards removeAllObjects];
        return NO;
    }
}

- (void)chooseCardAtIndex:(NSUInteger)index {
    PlayingCard *card = _cards[index];
    
    if(!card.isMatched) {
        if(card.isChosen) {
            card.chosen = NO;
        }else {
            BOOL matched = NO;
            // 2-card-match
            if(self.mode == 2) {
                self.isFinishAMatchRightNow = NO;
                if([self.chosenCards count] == 1) {
                    matched = [self doMatch:card];
                }
            }else if(self.mode == 3) { // 3-card-match
                self.isFinishAMatchRightNow = NO;
                if([self.chosenCards count] == 2) {
                    matched = [self doMatch:card];
                }
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
            [self.chosenCards addObject:card];
            
            if(matched) {
                [self.chosenCards removeAllObjects];
            }
        }
    }
}

@end
