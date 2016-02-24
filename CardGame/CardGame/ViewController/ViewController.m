//
//  ViewController.m
//  CardGame
//
//  Created by iYww on 15/10/16.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "ViewController.h"
#import "Deck.h"
#import "CardMatchingGame.h"

@interface ViewController ()

@end

@implementation ViewController

static CGFloat WIDTH_MARGIN = 10;
static CGFloat HEIGHT_MARGIN = 10;

- (NSMutableString *)segueText {
    if(!_segueText) {
        _segueText = [[NSMutableString alloc] init];
    }
    
    return _segueText;
}

- (NSMutableArray *)stackCardViews {
    if(!_stackCardViews) {
        _stackCardViews = [[NSMutableArray alloc] init];
    }
    return _stackCardViews;
}

// abstract method
- (Deck *)createDeck {
    return nil;
}

- (Game *)createGame {
    return nil;
}

- (void)updateUI {
    
}

- (CardView *)createViewAtx:(CGFloat)x AtY:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    return [[CardView alloc] initWithFrame:CGRectMake(x, y, width, height)];
}

- (void)resetAnimation {
    for(UIView *view in self.layoutView.subviews) {
        view.alpha = 0;
        [UIView animateWithDuration:1 animations:^ {
            view.alpha = 1;
        }];
    }
}

- (void)drawGridLayoutWithRow:(int)row withColumn:(int)column {
    CGSize layoutSize = [self.layoutView bounds].size;
    
    CGSize cellSize = CGSizeMake((layoutSize.width-(column-1)*WIDTH_MARGIN)/column, ((layoutSize.height-(row-1)*HEIGHT_MARGIN)/row));
    
    CGFloat originX;
    CGFloat originY;
    
    for(UIView *view in self.layoutView.subviews) {
        [view removeFromSuperview];
    }
    
    for(int i=0; i<row; i++) {
        for(int j=0; j<column; j++) {
            originX = j*(cellSize.width+WIDTH_MARGIN);
            originY = i*(cellSize.height+HEIGHT_MARGIN);
            
            CardView *view = [self createViewAtx:0 AtY:0 width:cellSize.width height:cellSize.height];
            
            [self addGestureToCardView:view];
            [UIView animateWithDuration:(i+j)*0.1 animations:^ {
                view.center = CGPointMake(originX+cellSize.width/2, originY+cellSize.height/2);
                view.centralX = view.center.x;
                view.centralY = view.center.y;
            }];
            
            view.backgroundColor = nil;
            view.opaque = NO;
            [self.layoutView addSubview:view];
        }
    }
}

- (void)addGestureToCardView:(CardView *)view {
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addToStackView:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [view addGestureRecognizer:longPressGesture];
    [view addGestureRecognizer:panGesture];
}

- (void)addToStackView:(UITapGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded) {
        CardView *view = (CardView *)sender.view;
        NSUInteger index = [self.stackCardViews count];
        CGSize cardViewSize = [view bounds].size;
        CGPoint stackViewPoint = [self.stackView frame].origin;
        CGPoint layoutViewPoint = [self.layoutView frame].origin;
        
        UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:view snapToPoint:CGPointMake(stackViewPoint.x+10*(index+1)-layoutViewPoint.x+cardViewSize.width/2, stackViewPoint.y-layoutViewPoint.y+cardViewSize.height/2)];
        [self.layoutView.animator addBehavior:snapBehavior];
        [self.layoutView bringSubviewToFront:view];
        
        [self.stackCardViews addObject:view];
    }
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    CGPoint offsetPoint = [sender translationInView:self.view];
    UIView *view = sender.view;
    view.center = CGPointMake(view.center.x+offsetPoint.x, view.center.y+offsetPoint.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)stackTap:(UITapGestureRecognizer *)sender {
    for(CardView *view in self.stackCardViews) {
        view.center = CGPointMake(view.centralX, view.centralY);
    }
    
    [self resetAnimatorBehavior];
}

- (void)resetAnimatorBehavior {
    [self.layoutView.animator removeAllBehaviors];
    [self.stackCardViews removeAllObjects];
}

- (void)viewDidLoad {
    self.layoutView.backgroundColor = nil;
    self.layoutView.opaque = NO;
    self.isToRedraw = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGSize layoutSize = self.layoutView.bounds.size;
    CGPoint layoutOrigin = self.layoutView.frame.origin;
    CGFloat stackViewWidth = (layoutSize.width-(self.layoutViewColumnCount-1)*WIDTH_MARGIN)/self.layoutViewColumnCount;
    CGFloat stackViewHeight = (layoutSize.height-(self.layoutViewRowCount-1)*HEIGHT_MARGIN)/self.layoutViewRowCount;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stackTap:)];
    
    self.stackView = [[UIView alloc] initWithFrame:CGRectMake(layoutOrigin.x, layoutOrigin.y+layoutSize.height+20, stackViewWidth, stackViewHeight)];
    [self.stackView addGestureRecognizer:tapGesture];
    
    self.stackView.backgroundColor = [UIColor whiteColor];
    
    [self.view insertSubview:self.stackView belowSubview:self.layoutView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *historyVC = [segue destinationViewController];
    
    [historyVC setValue:self.segueText forKey:@"segueText"];
}

@end
