//
//  PlayingCardViewController.m
//  CardGame
//
//  Created by iYww on 15/10/19.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingDeck.h"
#import "CardMatchingGame.h"
#import "PlayingCardView.h"

@interface PlayingCardViewController()

@property (nonatomic, strong) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation PlayingCardViewController

- (PlayingDeck *)createDeck {
    return [[PlayingDeck alloc] init];
}

- (CardMatchingGame *)game {
    if(!_game) {
        _game = [self createGameWithMode:2];
    }
    return _game;
}

- (CardMatchingGame *)createGameWithMode:(NSUInteger)mode {
    CardMatchingGame *game = [[CardMatchingGame alloc] initCardsUsingDeck:[self createDeck]];
    game.mode = mode;
    return game;
}

- (PlayingCardView *)createViewAtx:(CGFloat)x AtY:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    return [[PlayingCardView alloc] initWithFrame:CGRectMake(x, y, width, height)];
}

- (IBAction)segmentedValueChanged:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;
    self.game = [self createGameWithMode:(index+2)];
    [self updateUI];
    sender.enabled = NO;
}

- (void)updateUI {
    for(PlayingCardView *view in self.cardViews) {
        NSUInteger index = [self.cardViews indexOfObject:view];
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:index];
        [self updateCardView:view uising:card];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld",(long)self.game.score];
    
    if(self.game.isFinishAMatchRightNow) {
        [self.segueText appendString:self.game.tips];
        [self.segueText appendString:@"\n"];
    }
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.content : @"";
}

- (UIImage *)backgroungImageForCard:(Card *)card {
    
    return [UIImage imageNamed:card.isChosen ? @"blank_card" : @"stanford"];
}

- (void)updateCardView:(PlayingCardView *)view uising:(PlayingCard *)card {
    view.rank = card.rank;
    view.suit = card.suit;
    view.faceUp = card.isChosen;
}

- (void)flipCard:(PlayingCardView *)flipingView flipingCard:(PlayingCard *)flipingCard {
    [UIView animateWithDuration:0.3 animations:^ {
        flipingView.layer.transform = CATransform3DMakeRotation(M_PI/2, 0, 1, 0);
    } completion:^(BOOL finished) {
        [self updateCardView:flipingView uising:flipingCard];
        [UIView animateWithDuration:0.3 animations:^ {
            flipingView.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0);
        } completion:^(BOOL finished) {
            [self updateUI];
        }];
    }];
}

- (void)drawGridLayoutWithRow:(int)row withColum:(int)column {
    [super drawGridLayoutWithRow:row withColumn:column];
    
    int i=0;
    for(PlayingCardView *view in self.layoutView.subviews) {
        PlayingCard *card = self.game.cards[i++];
        [self updateCardView:view uising:card];
    }
}

- (void)initLayoutViews {
    if(self.isToRedraw) {
        [self drawGridLayoutWithRow:5 withColum:6];
        
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
    [self flipCard:(PlayingCardView *)sender.view flipingCard:self.game.cards[index]];
    
    if(self.modeSegmentedControl.enabled) {
        self.modeSegmentedControl.enabled = false;
    }
}

- (IBAction)resetTouchUp:(UIButton *)sender {
    self.game = [self createGameWithMode:2];
    
    self.isToRedraw = YES;
    [self initLayoutViews];
    [self updateUI];
    
    [self resetAnimatorBehavior];
    
    self.modeSegmentedControl.enabled = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardViews = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
}

- (void)viewDidAppear:(BOOL)animated {
    self.layoutViewRowCount = 5;
    self.layoutViewColumnCount = 6;
    [super viewDidAppear:animated];
    
    [self initLayoutViews];
}

@end
