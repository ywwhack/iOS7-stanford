//
//  ViewController.h
//  CardGame
//
//  Created by iYww on 15/10/16.
//  Copyright © 2015年 zank. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Deck.h"
#import "Game.h"
#import "CardView.h"
#import "LayoutView.h"

@interface ViewController : UIViewController {
    NSMutableString *_segueText;
}

@property (weak, nonatomic) IBOutlet LayoutView *layoutView;
//@property (weak, nonatomic) IBOutlet UIView *stackView;
@property (strong, nonatomic) UIView *stackView;
@property (strong, nonatomic) NSArray *cardViews;
@property (nonatomic, strong) NSMutableString *segueText;
@property (nonatomic) BOOL isToRedraw;
@property (nonatomic) int layoutViewRowCount;
@property (nonatomic) int layoutViewColumnCount;
@property (strong, nonatomic) NSMutableArray *stackCardViews;

- (Deck *)createDeck;
- (Game *)createGame;
- (void)updateUI;
- (void)drawGridLayoutWithRow:(int)row withColumn:(int)column;
- (void)resetAnimation;
- (void)resetAnimatorBehavior;

// need override
- (CardView *)createViewAtx:(CGFloat)x AtY:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

@end

