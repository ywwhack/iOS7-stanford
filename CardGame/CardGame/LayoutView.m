//
//  layoutView.m
//  CardGame
//
//  Created by iYww on 15/10/31.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "layoutView.h"

@implementation LayoutView

- (UIDynamicAnimator *)animator {
    if(!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return _animator;
}

@end
