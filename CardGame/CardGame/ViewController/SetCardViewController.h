//
//  SetCardViewController.h
//  CardGame
//
//  Created by iYww on 15/10/19.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "ViewController.h"
#import "SetDeck.h"
#import "CardSetGame.h"

@interface SetCardViewController : ViewController

- (SetDeck *)createDeck;
- (CardSetGame *)createGame;

@end
