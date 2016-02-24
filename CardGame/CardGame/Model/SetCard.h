//
//  SetCard.h
//  CardGame
//
//  Created by iYww on 15/10/19.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic, strong) NSDictionary *attributes;

+ (NSArray *)numbers;
+ (NSArray *)colors;
+ (NSArray *)symbols;
+ (NSArray *)shadings;

@end
