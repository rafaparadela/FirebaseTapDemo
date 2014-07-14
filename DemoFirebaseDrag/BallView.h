//
//  BallView.h
//  DemoFirebaseDrag
//
//  Created by Rafa Paradela on 13/07/14.
//  Copyright (c) 2014 rafaparadela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallView : UIView

@property (strong, nonatomic) NSString * identify;
@property (strong, nonatomic) NSString * owner;

- (instancetype)initWithPoint: (CGPoint) point color:(UIColor *)color owner:(NSString *)owner andIdentify:(NSString *) identify;

@end
