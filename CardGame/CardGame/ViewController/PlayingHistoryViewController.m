//
//  PlayingHistoryViewController.m
//  CardGame
//
//  Created by iYww on 15/10/21.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "PlayingHistoryViewController.h"

@interface PlayingHistoryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *historyText;

@end

@implementation PlayingHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.historyText.text = self.segueText;   
    
}

@end
