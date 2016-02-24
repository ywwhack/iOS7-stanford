//
//  SetCardView.m
//  SetCard
//
//  Created by iYww on 15/10/28.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

@synthesize card = _card;

static const int SHAPE_SIZE = 10;
static const int SHAPE_GUTTER = 16;
static const float FONT_STANDARD_HEIGHT = 180.0;
static const float CORNER_RADIUS = 12.0;

- (NSDictionary *)card {
    if(!_card) {
        _card = @{@"number":@3, @"color":@"red", @"shading":@"slash", @"symbol":@"rhombus"};
    }
    return _card;
}

- (void)setCard:(NSDictionary *)card {
    _card = card;
    [self setNeedsDisplay];
}

- (float)cornerScaleFactor {
    return self.bounds.size.height/FONT_STANDARD_HEIGHT;
}

- (float)cornerRadius {
    return [self cornerScaleFactor] * CORNER_RADIUS;
}

- (void)drawBorderAndRadius {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
}

- (void)drawCircleOrRect:(CGFloat)x originY:(CGFloat)y {
    UIBezierPath *path;
    int number = [[self.card objectForKey:@"number"] intValue];
    NSString *shading = [self.card objectForKey:@"shading"];
    NSString *symbol = [self.card objectForKey:@"symbol"];
    
    for(int i=0; i<number; i++) {
        CGRect rect = CGRectMake(x+i*SHAPE_GUTTER, y, SHAPE_SIZE, SHAPE_SIZE);
        
        if([symbol isEqualToString:@"circle"]) {
            path = [UIBezierPath bezierPathWithOvalInRect:rect];
        }else if([symbol isEqualToString:@"rectangle"]) {
            path = [UIBezierPath bezierPathWithRect:rect];
        }
        [path stroke];
        if([shading isEqualToString:@"slash"]) {
            [self drawSlash:x+i*SHAPE_GUTTER originY:y+SHAPE_SIZE/2];
        }else if([shading isEqualToString:@"fill"]) {
            [path fill];
        }
    }
}

- (void)drawRhombus:(CGFloat)x originY:(CGFloat)y {
    int number = [[self.card objectForKey:@"number"] intValue];
    NSString *shading = [self.card objectForKey:@"shading"];
    UIBezierPath *path;
    
    for(int i=0; i<number; i++) {
        CGFloat centralX = x + i*SHAPE_GUTTER;
        path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(centralX, y-SHAPE_SIZE/2)];
        [path addLineToPoint:CGPointMake(centralX+SHAPE_SIZE/2, y)];
        [path addLineToPoint:CGPointMake(centralX, y+SHAPE_SIZE/2)];
        [path addLineToPoint:CGPointMake(centralX-SHAPE_SIZE/2, y)];
        [path closePath];
        [path stroke];
        if([shading isEqualToString:@"slash"]) {
            [self drawSlash:centralX-SHAPE_SIZE/2 originY:y];
        }else if([shading isEqualToString:@"fill"]) {
            [path fill];
        }
    }
}

- (void)drawSlash:(CGFloat)x originY:(CGFloat)y {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(x, y)];
    [path addLineToPoint:CGPointMake(x+SHAPE_SIZE, y)];
    [path stroke];
}

- (void)setDrawColor {
    NSString *colorName = [self.card objectForKey:@"color"];
    UIColor *color;
    if([colorName isEqualToString:@"red"]) {
        color = [UIColor redColor];
    }else if([colorName isEqualToString:@"green"]) {
        color = [UIColor greenColor];
    }else if([colorName isEqualToString:@"purple"]) {
        color = [UIColor purpleColor];
    }
    [color setStroke];
    [color setFill];
}

- (void)drawRect:(CGRect)rect {
    [self drawBorderAndRadius];
    CGSize size = self.bounds.size;
    CGPoint centralPoint = CGPointMake(size.width/2, size.height/2);
    
    CGFloat centralX = centralPoint.x;
    CGFloat centralY = centralPoint.y;
    
    if([[self.card objectForKey:@"number"] intValue] == 2) {
        centralX -= SHAPE_GUTTER/2;
    }else if([[self.card objectForKey:@"number"] intValue] == 3) {
        centralX -= SHAPE_GUTTER;
    }
    
    [self setDrawColor];
    
    if([[self.card objectForKey:@"symbol"] isEqualToString:@"rhombus"]) {
        [self drawRhombus:centralX originY:centralY];
    }else {
        [self drawCircleOrRect:centralX-SHAPE_SIZE/2 originY:centralY-SHAPE_SIZE/2];
    }
}

- (void)awakeFromNib {
    self.backgroundColor = nil;
    self.opaque = NO;
}

@end
