//
//  ViewController.m
//  DemoFirebaseDrag
//
//  Created by Rafa Paradela on 13/07/14.
//  Copyright (c) 2014 rafaparadela. All rights reserved.
//

#import <Firebase/Firebase.h>
#import "ViewController.h"
#import "BallView.h"


@interface ViewController ()

@property (strong, nonatomic) Firebase * myRootRef;
@property (strong, nonatomic) UIColor * myColor;
@property (strong, nonatomic) NSString * owner;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFirebaseOberver];

}

#pragma mark - lazyloads

- (Firebase *)myRootRef
{
    if (_myRootRef == nil)
    {
        _myRootRef = [[Firebase alloc] initWithUrl:@"https://demodrag.firebaseio.com/"];
        
    }
    return _myRootRef;
}


- (UIColor *)myColor
{
    if (_myColor == nil)
    {
        _myColor = [self rndColor];
        
    }
    return _myColor;
}

- (NSString *)owner
{
    if (_owner == nil)
    {
        _owner = [self deviceID];
        
    }
    return _owner;
}


#pragma mark - firebase interact

- (void)setupFirebaseOberver{
    [self.myRootRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        [self drawOneBall:snapshot.value];
    }];
    
    [self.myRootRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        
        [self unDrawOneBall:snapshot.value];
    }];
}

- (void) addBallInFirebase: (CGPoint) point{
    NSString * identify = [NSString stringWithFormat:@"%d", [self getBallIdentify]];
    NSString * color = [self stringColor:self.myColor];
    NSString * x = [NSString stringWithFormat:@"%f", point.x];
    NSString * y = [NSString stringWithFormat:@"%f", point.y];
    [[self.myRootRef childByAppendingPath:identify] setValue:@{@"owner": self.owner, @"identify": identify, @"x": x, @"y": y, @"color": color}];
}

- (void) removeBallInFirebase: (BallView *) ball{
    [[self.myRootRef childByAppendingPath:ball.identify] setValue:@{}];
}


#pragma mark - drawing

- (void) drawOneBall: (NSDictionary *) item{
    
    CGFloat x = [item[@"x"] floatValue];
    CGFloat y = [item[@"y"] floatValue];
    CGPoint point = CGPointMake(x, y);
    UIColor * color = [self colorFromStrong:item[@"color"]];
    NSString * owner = item[@"owner"];
    NSString * identify = item[@"identify"];
    BallView * newBall = [[BallView alloc] initWithPoint:point color:color owner:owner andIdentify:identify];
    [self.view addSubview:newBall];
    
}

- (void) unDrawOneBall: (NSDictionary *) item{
    NSString * identify = item[@"identify"];
    
    for (UIView *subView in [self.view subviews]) {
        
        if([subView isKindOfClass:[BallView class]]){
            
            if ([ ((BallView*)subView).identify isEqual:identify]) {
                [subView removeFromSuperview];
                return;
            }

        }
    }
    
}

- (void) removeOneBall: (BallView *) ball{
    if(![ball.owner isEqual:self.owner]){
        [self removeBallInFirebase:ball];
    }
}


#pragma mark - view


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self.view];
        
        for (BallView *itemBall in [self.view subviews]) {
            if (CGRectContainsPoint(itemBall.frame, touchPoint)) {
                
                [self removeOneBall:itemBall];
                return;
            }
        }
        
        [self addBallInFirebase:touchPoint];
    }
}



#pragma mark - Utils

- (NSUInteger) getBallIdentify{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    return [timeStampObj intValue];
}

- (NSString *) stringColor: (UIColor *) color{
    CGColorRef colorRef = color.CGColor;
    NSString *colorString = [CIColor colorWithCGColor:colorRef].stringRepresentation;
    return colorString;
}

- (UIColor *) colorFromStrong: (NSString *) string{
    CIColor *coreColor = [CIColor colorWithString:string];
    UIColor *color = [UIColor colorWithCIColor:coreColor];
    return color;
}

- (UIColor *) rndColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

- (NSString *) deviceID{
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uniqueIdentifier;
}

@end
