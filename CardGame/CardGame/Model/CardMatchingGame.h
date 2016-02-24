//
//  CardMatchingGame.h
//  CardGame
//
//  Created by iYww on 15/10/17.
//  Copyright © 2015年 zank. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PlayingCard.h"
#import "Game.h"

@interface CardMatchingGame : Game

@property (nonatomic) NSUInteger mode;
@property (nonatomic, strong) NSString *tips;

@end
