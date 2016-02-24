//
//  SetCard.m
//  CardGame
//
//  Created by iYww on 15/10/19.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (NSDictionary *)attributes {
    if(!_attributes) {
        _attributes = [[NSDictionary alloc] init];
    }
    
    return _attributes;
}

- (int)match:(NSArray *)othercards {

    NSMutableArray *chosenCards = [[NSMutableArray alloc] initWithArray:othercards];
    [chosenCards addObject:self];
    int score = 0;
    if([self isAllMatched:chosenCards]) {
        score = 1;
    }else {
        score = 0;
    }
    
    return score;
}

- (BOOL)isAllMatched:(NSArray *)cards {
    NSArray *attributes = @[@"number", @"color", @"symbol", @"shading"];
    
    for(NSString *attribute in attributes) {
        if(![self isAllSameOrDiffirenet:cards withAttribute:attribute]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isAllSameOrDiffirenet:(NSArray *)cards withAttribute:(NSString *)attribute {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for(int i=0; i<[cards count]; i++) {
        SetCard *card = cards[i];
        [values addObject:[card.attributes objectForKey:attribute]];
    }
    
    if([values[0] isKindOfClass:[NSString class]]) {
        if( ([values[0] isEqualToString:values[1]]) && ([values[0] isEqualToString:values[2]]) ) {
            return YES;
        }else if(!([values[0] isEqualToString:values[1]]) && !([values[0] isEqualToString:values[2]]) && !([values[1] isEqualToString:values[2]]) ) {
            return YES;
        }
    }
    
    if([values[1] isKindOfClass:[NSNumber class]]) {
        if( ([values[0] isEqualToNumber:values[1]]) && ([values[0] isEqualToNumber:values[1]]) ) {
            return YES;
        }else if(!([values[0] isEqualToNumber:values[1]]) && !([values[0] isEqualToNumber:values[2]]) && !([values[1] isEqualToNumber:values[2]]) ) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSArray *)numbers {
    return @[@1, @2, @3];
}

+ (NSArray *)colors {
    return @[@"red", @"green", @"purple"];
}

+ (NSArray *)symbols {
    return @[@"rhombus", @"circle", @"rectangle"];
}

+ (NSArray *)shadings {
    return @[@"slash", @"fill", @"boild"];
}

@end
