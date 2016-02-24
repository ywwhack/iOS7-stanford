//
//  PlayingCard.m
//  CardGame
//
//  Created by iYww on 15/10/16.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (NSDictionary *)match:(NSArray *)othercards {
    int score = 0;
    NSString *tips = @" ";
    
    if([othercards count] == 1) {
        PlayingCard *card = [othercards firstObject];
        if(card.rank == self.rank) {
            score = 4;
            tips = [NSString stringWithFormat:@"Matched %ld%@ %ld%@ for 4 points", card.rank, card.suit, self.rank, self.suit];
        }else if([card.suit isEqualToString:self.suit]){
            score = 1;
            tips = [NSString stringWithFormat:@"Matched %ld%@ %ld%@ for 1 points", card.rank, card.suit, self.rank, self.suit];
        }else {
            tips = [NSString stringWithFormat:@"%ld%@ %ld%@ dont't match! 2 points penalty", card.rank, card.suit, self.rank, self.suit];
        }
    }else if([othercards count] == 2) {
        PlayingCard *othercard1 = othercards[0];
        PlayingCard *othercard2 = othercards[1];
        
        if([self.suit isEqualToString:othercard1.suit] && [self.suit isEqualToString:othercard2.suit] && [othercard1.suit isEqualToString:othercard2.suit]) {
            score = 4;
            tips = [NSString stringWithFormat:@"Matched %ld%@ %ld%@ %ld%@ for 4 points", othercard1.rank, othercard1.suit, othercard2.rank,othercard2.suit, self.rank, self.suit];
        }else if(self.rank == othercard1.rank && self.rank == othercard2.rank && othercard1.rank == othercard2.rank) {
            score = 8;
            tips = [NSString stringWithFormat:@"Matched %ld%@ %ld%@ %ld%@ for 8 points", othercard1.rank, othercard1.suit, othercard2.rank,othercard2.suit, self.rank, self.suit];
        }else if([self.suit isEqualToString:othercard1.suit] || [self.suit isEqualToString:othercard2.suit] || [othercard2.suit isEqualToString:othercard1.suit]) {
            score = 1;
            tips = [NSString stringWithFormat:@"Matched %ld%@ %ld%@ %ld%@ for 1 points", othercard1.rank, othercard1.suit, othercard2.rank,othercard2.suit, self.rank, self.suit];
        }else if(self.rank == othercard1.rank || self.rank == othercard2.rank || othercard1.rank == othercard2.rank ) {
            score = 2;
            tips = [NSString stringWithFormat:@"Matched %ld%@ %ld%@ %ld%@ for 2 points", othercard1.rank, othercard1.suit, othercard2.rank,othercard2.suit, self.rank, self.suit];
        }else {
            tips = [NSString stringWithFormat:@"%ld%@ %ld%@ %ld%@ dont't match! 2 points penalty", othercard1.rank, othercard1.suit, othercard2.rank,othercard2.suit, self.rank, self.suit];
        }
    }
    
    return @{@"score": [NSNumber numberWithInt:score], @"tips": tips};
}

- (NSString *)content {
    NSArray *rankStrings = [PlayingCard rankStings];
    return [rankStrings[_rank] stringByAppendingString:_suit];
}

- (void)setSuit:(NSString *)suit {
    if([[PlayingCard validSuit] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank {
    if(rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

+ (NSArray *)validSuit {
    return @[@"♥",@"♦",@"♠",@"♣"];
}

+ (NSArray *)rankStings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];;
}

+ (NSUInteger)maxRank {
    return [[PlayingCard rankStings] count] - 1;
}

@end
