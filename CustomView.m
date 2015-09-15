//
//  CustomView.m
//  Grapherator
//
//  Created by Schuyler Reinken on 9/5/15.
//  Copyright (c) 2015 Harmonic. All rights reserved.
//

#import "CustomView.h"
#import <UIKit/UIKit.h>
@implementation CustomView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _value = NO;
        
    }
    return self;
}

-(void) layoutSubviews {
    self.center = self.superview.center;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}


- (void)drawRect:(CGRect)rect {

    UIBezierPath *xaxis = [UIBezierPath bezierPath];
    float midy = CGRectGetMidY(rect);
    [xaxis moveToPoint: CGPointMake(0, midy)];
    [xaxis addLineToPoint:CGPointMake(CGRectGetMaxX(rect), midy)];
    
    [xaxis stroke];
    
    UIBezierPath *yaxis = [UIBezierPath bezierPath];
    float midx = CGRectGetMidX(rect);
    [yaxis moveToPoint: CGPointMake(midx, 0)];
    [yaxis addLineToPoint:CGPointMake(midx, CGRectGetMaxY(rect))];
    
    [yaxis stroke];
    
    
    if (_value == YES && _function != nil) {
        _function.currentPoint = CGPointMake(0, 0);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [[UIColor redColor] setStroke];
        [path moveToPoint: CGPointMake(0, 0)];
        
        for (int i = 0; i < CGRectGetWidth(rect); i++) {
            if (i == 0) [path moveToPoint:[_function getNextPoint]];
            else [path addLineToPoint:[_function getNextPoint]];
        }
        [path stroke];

    }
    
}


@end
