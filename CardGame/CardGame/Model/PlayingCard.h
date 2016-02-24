//
//  PlayingCard.h
//  CardGame
//
//  Created by iYww on 15/10/16.
//  Copyright © 2015年 zank. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic, strong) NSString* suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString* tips;

+ (NSArray *) validSuit;
+ (NSUInteger)maxRank;

- (NSDictionary *)match:(NSArray *)othercards;

@end
