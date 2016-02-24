//
//  Card.h
//  CardGame
//
//  Created by iYww on 15/10/16.
//  Copyright © 2015年 zank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int)match:(NSArray *) othercards;
@end
