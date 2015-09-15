//
//  Function.m
//  Grapherator
//
//  Created by Schuyler Reinken on 9/7/15.
//  Copyright (c) 2015 Harmonic. All rights reserved.
//

#import "Function.h"
#define MULT 1
#define DIV 2
#define EXP 3
#define PAR 4
@implementation Function

- (instancetype)init: (NSString *) function withWindowWidth:(float) width zoom:(float) z{
    _index = 0;
    _functionString = function;
    _formatString = @"";
    _windowWidth = width;
    _zoom = z;
    _currentPoint = CGPointMake(0, 0);
    return self;
}

+ (void)setZoom:(float)zoom {
    self.zoom = zoom;
}

- (void)setFunctionString:(NSString *)functionString {
    _index = 0;
    _formatString = [self format:0 withString:functionString];
    _functionString = functionString;
}

- (CGPoint)getNextPoint {
    _index = 0;
    int currentx = _currentPoint.x;
    double step = (_zoom*2) / _windowWidth;
    int nextx = currentx+1;
    double xvalue = (nextx - _windowWidth / 2) * step;
    double yValue = [self eval:_formatString currentTotal:0 withValue:xvalue];
    //NSLog(@"\nX is: %f\nY is: %f", xvalue, yValue);
    int nexty = yValue / step;
    nexty = (_windowWidth / 2) - nexty;
    _currentPoint.x = nextx;
    _currentPoint.y = nexty;
    
    //NSLog(@"Current Point is: %d , %d\nValue is: %f", nextx, nexty, yValue);
    
    return CGPointMake(nextx, nexty);
}

- (NSString *)format:(int)operation withString: (NSString *) string{
    NSMutableString *final = [NSMutableString localizedStringWithFormat:string];
    NSLog(@"\nString is: %@\nIndex is: %d\nOperation is: %d", final, _index, operation);
    while (_index < final.length) {
        if ([final characterAtIndex:_index] == '(') {
            _index++;
            final = [NSMutableString localizedStringWithFormat:[self format:PAR withString:final]];
            if (operation != 0) return final;
        }
        else if ([final characterAtIndex:_index] == '^') {
            _index++;
            final = [NSMutableString localizedStringWithFormat:[self format:EXP withString:final]];
        }
        else if ([final characterAtIndex:_index] == '*') {
            _index++;
            final = [NSMutableString localizedStringWithFormat:[self format:MULT withString:final]];
        }
        else if ([final characterAtIndex:_index] == '/') {
            _index++;
            final = [NSMutableString localizedStringWithFormat:[self format:DIV withString:final]];
        }
        else {
            _index++;
        }
        
        if (_index < final.length && operation == EXP && (
                                      [final characterAtIndex:_index] == '^' ||
                                      [final characterAtIndex:_index] == '/' ||
                                      [final characterAtIndex:_index] == '*' ||
                                      [final characterAtIndex:_index] == '+' ||
                                      [final characterAtIndex:_index] == '-' ||
                                      [final characterAtIndex:_index] == ')' )) {

            [final insertString:@")" atIndex:_index];
            NSLog(@"\nEXP is now: %@", final);
            _index++;
            return final;
            
        }
        else if (_index < final.length && (operation == MULT || operation == DIV) && (
                                                             [final characterAtIndex:_index] == '/' ||
                                                             [final characterAtIndex:_index] == '*' ||
                                                             [final characterAtIndex:_index] == '+' ||
                                                             [final characterAtIndex:_index] == '-' ||
                                                             [final characterAtIndex:_index] == ')' )) {

            [final insertString:@")" atIndex:_index];
            NSLog(@"\nMULT/DIV is now: %@", final);
            _index++;
            return final;
        }
        
        else if (_index < final.length && operation == PAR && [final characterAtIndex:_index] == ')') {
            _index++;
            return final;
        }
    }
    NSLog(@"String is now: %@", final);
    return final;
}


- (double) eval: (NSString *) func currentTotal:(double) total withValue:(double) value {
    
    //NSLog(@"Recur");
    double subtotal = 0;
    //NSLog(@"\nCurrent index is: %d\nCurrent total is: %.0f\nCurrent subtotal is: %.0f", _index, total, subtotal);
    
    while (_index < func.length) {
        
        
        if ([self isNumber:[func characterAtIndex:_index]]) {
            NSMutableString *num = [[NSMutableString alloc] init];
            while (_index < func.length && [self isNumber:[func characterAtIndex:_index]]) {
                unichar c = [func characterAtIndex:_index];
                NSString *string = [NSString stringWithCharacters:&c length:1];
                [num appendString: string];
                subtotal = [num doubleValue];
                _index++;
            }
            //NSLog(@"%@", num);
        }
        else if ([func characterAtIndex:_index] == 'x') {
            _index++;
            subtotal = value;
            //NSLog(@"x");
        }
        
        else if ([func characterAtIndex:_index] == '(') {
            _index++;
            //NSLog(@"(");
            //subtotal = [self eval:func currentTotal:0 withValue:value];
        }
        
        else if ([func characterAtIndex:_index] == '*') {
            _index++;
            subtotal = total * [self eval:func currentTotal:total withValue:value];
        }
        else if ([func characterAtIndex:_index] == '/') {
            _index++;
            //NSLog(@"/");
            subtotal = total / [self eval:func currentTotal:total withValue:value];
        }
        else if ([func characterAtIndex:_index] == '+') {
            _index++;
            subtotal = total + [self eval:func currentTotal:total withValue:value];
        }
        else if ([func characterAtIndex:_index] == '-') {
            _index++;
            //NSLog(@"-");
            subtotal = total - [self eval:func currentTotal:total withValue:value];
        }
        else if ([func characterAtIndex:_index] == 'l') {
            _index += 2;
            subtotal = log([self eval:func currentTotal:0 withValue:value]);
        }
        
        else if (_index < func.length && [func characterAtIndex:_index] == ')') {
            _index++;
            //NSLog(@")");
            return total;
        }
        
        if (_index < func.length && [func characterAtIndex:_index] == '^') {
            _index++;
            subtotal = pow(subtotal, [self eval:func currentTotal:0 withValue:value]);
        }
    
        total = subtotal;
    }
    
    return total;
}

- (BOOL) isNumber: (unichar) value {
    if (value == '1' ||
        value == '2' ||
        value == '3' ||
        value == '4' ||
        value == '5' ||
        value == '6' ||
        value == '7' ||
        value == '8' ||
        value == '9' ||
        value == '0') return YES;
    else return NO;
}

@end
