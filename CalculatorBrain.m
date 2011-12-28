//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Hon Ming Chen on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

//overrides setter method for operandStack
- (NSMutableArray *)programStack {
    if (_programStack == nil) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

//pop operand from the stack
//-(double)popOperand {
//    NSNumber *operandObject = [self.programStack lastObject];
//    if (operandObject) [self.programStack removeLastObject];
//    return [operandObject doubleValue];
//}

//push operand onto the stack
- (void)pushOperand:(double)operand {
    //wrap primative numbers in an object
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}
//clear the stack
- (void)resetBrain {
    [self.programStack  removeAllObjects];
}

- (double)performOperation:(NSString *)operation {
    
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

//getter method for program, setter is not needed since program is readonly 
- (id)program {
    //returns an immutable array
    return [self.programStack copy];
}

//implement this
+ (NSString *)descriptionOfProgram:(id)program {
    return @"Implement this in Assignment 2";
}

+ (double)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    
    //use id type because the items in the stack can either be 
    //a NSNumber or a NSString
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    //use introspection to find the type of topOfStack
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        //calculate result
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        }
        else if ([operation isEqualToString:@"-"]) {
            result = -[self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
    }
    return result;
}

+ (double)runProgram:(id)program {
    //local variables created in iOS5 start off at zero
    NSMutableArray *stack;
    //use introspection to see if it is an array
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

@end
