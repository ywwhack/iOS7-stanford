//
//  SetCardViewController.m
//  CardGame
//
//  Created by iYww on 15/10/19.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "SetCardViewController.h"
#import "SetCardView.h"

@interface SetCardViewController ()

@property (nonatomic, strong) CardSetGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation SetCardViewController

static const int INITIAL_ROW = 4;
static const int INITIAL_COLUMN = 3;

- (CardSetGame *)game {
    if(!_game) {
        _game = [self createGame];
    }
    
    return _game;
}

- (SetDeck *)createDeck{
    return [[SetDeck alloc] init];
}

- (CardSetGame *)createGame {
    return [[CardSetGame alloc] initCardsUsingDeck:[self createDeck]];
}

- (SetCardView *)createViewAtx:(CGFloat)x AtY:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    return [[SetCardView alloc] initWithFrame:CGRectMake(x, y, width, height)];
}

- (void)initUI {
    for(int i=0; i<[self.cardViews count]; i++) {
        SetCard *card = [self.game.cards objectAtIndex:i];
        SetCardView *view = [self.cardViews objectAtIndex:i];
        view.card = card.attributes;
        view.alpha = 1;
    }
}

- (void)updateUI {
    __block int matched = 2;
    
    for(int i=0; i<[self.cardViews count]; i++) {
        SetCardView *cardView = self.cardViews[i];
        SetCard *card = self.game.cards[i];
        if(card.isChosen) {
            cardView.alpha = 0.5;
        }else {
            cardView.alpha = 1;
        }
        if(card.isMatched) {
            [UIView animateWithDuration:1 animations:^ {
                cardView.center = CGPointMake(-10, -20);
            } completion:^(BOOL finished) {
                [cardView removeFromSuperview];
                [self.game.cards removeObject:card];
                
                matched--;
                if(matched == 0) {
                    self.layoutViewRowCount = INITIAL_ROW;
                    self.layoutViewColumnCount = INITIAL_COLUMN;
                    [self redrawLayout];
                }
            }];
        }
    }
}

- (void)redrawLayout {
    self.isToRedraw = YES;
    [self initLayoutViews:self.layoutViewRowCount withColumn:self.layoutViewColumnCount];
}

- (void)drawGridLayoutWithRow:(int)row withColumn:(int)column {
    [super drawGridLayoutWithRow:row withColumn:column];
    
    int index = 0;
    for(SetCardView* view in self.layoutView.subviews) {
        SetCard *card = self.game.cards[index++];
        view.card = card.attributes;
    }
}

- (void)initLayoutViews:(int)row withColumn:(int)column {
    if(self.isToRedraw) {
        [self drawGridLayoutWithRow:row withColumn:column];
        
        NSArray *cardViews = self.layoutView.subviews;
        self.cardViews = cardViews;
        for(int i=0; i<[cardViews count]; i++) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCardTouchUp:)];
            [cardViews[i] addGestureRecognizer:tapGesture];
        }
        self.isToRedraw = NO;
    }
}

- (IBAction)chooseCardTouchUp:(UITapGestureRecognizer *)sender {
    NSUInteger index = [self.cardViews indexOfObject:sender.view];
    [self.game chooseCardAtIndex:index];
    
    [self updateUI];
}

- (IBAction)resetTouchUp:(UIButton *)sender {
    self.game = [self createGame];
    
    self.layoutViewRowCount = INITIAL_ROW;
    self.layoutViewColumnCount = INITIAL_COLUMN;
    [self redrawLayout];
    
    [self initUI];
    
    [self resetAnimation];
}

- (IBAction)moreCardsTouchUp:(UIButton *)sender {
    self.layoutViewRowCount++;
    [self redrawLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutViewRowCount = INITIAL_ROW;
    self.layoutViewColumnCount = INITIAL_COLUMN;
    self.cardViews = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self initLayoutViews:INITIAL_ROW withColumn:INITIAL_ROW];
    [self initUI];
}

@end
