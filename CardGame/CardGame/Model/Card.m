//
//  Card.m
//  CardGame
//
//  Created by iYww on 15/10/16.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)othercards {
    int score = 0;
    for(Card *card in othercards) {
        if([self.content isEqualToString:card.content]){
            score++;
        };
    }
    
    return score;
}

@end
