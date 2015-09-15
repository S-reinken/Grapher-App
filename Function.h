//
//  Function.h
//  Grapherator
//
//  Created by Schuyler Reinken on 9/7/15.
//  Copyright (c) 2015 Harmonic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Function : NSObject

@property NSString *functionString;
@property NSString *formatString;
@property CGPoint currentPoint;
@property float windowWidth;
@property float zoom;
@property int index;

- (instancetype)init: (NSString *) function withWindowWidth:(float) width zoom:(float) z;
- (CGPoint) getNextPoint;
- (void) setZoom:(float)zoom;
- (double) eval: (NSString *) func currentTotal: (double) total withValue: (double) value;
- (BOOL) isNumber: (unichar) value;
- (NSString *) format: (int) operation withString: (NSString *) string;

@end
