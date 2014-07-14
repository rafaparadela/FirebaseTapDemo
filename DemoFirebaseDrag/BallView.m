//
//  BallView.m
//  DemoFirebaseDrag
//
//  Created by Rafa Paradela on 13/07/14.
//  Copyright (c) 2014 rafaparadela. All rights reserved.
//

#import "BallView.h"

#define SIZEBALL 30.0


@implementation BallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}


- (instancetype)initWithPoint: (CGPoint) point color:(UIColor *)color owner:(NSString *)owner andIdentify:(NSString *) identify
{
    CGFloat x = point.x - SIZEBALL/2;
    CGFloat y = point.y - SIZEBALL/2;
    CGRect frame = CGRectMake(x, y, SIZEBALL, SIZEBALL);

    self = [super initWithFrame:frame];
    if (self) {
        _identify = identify;
        _owner = owner;
        self.backgroundColor = color;
        self.layer.cornerRadius = SIZEBALL/2;
    }
    return self;
}

@end
