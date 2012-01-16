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
@property (nonatomic, strong) NSDictionary *defaultDictionary;
@property (nonatomic, strong) NSSet *twoOperandOperations;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize defaultDictionary = _defaultDictionary;
@synthesize twoOperandOperations = _twoOperandOperations;

//overrides getter method for operandStack
- (NSMutableArray *)programStack {
    if (_programStack == nil) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

//override getter method for defaultDictionary
- (NSDictionary *)defaultDictionary {
    if (_defaultDictionary == nil) {
        _defaultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:1], @"x",
                              [NSNumber numberWithInt:2], @"y", nil];
    }
    return _defaultDictionary;
}

//override getter method for twoOperandOperations
- (NSSet *)twoOperandOperations {
    if (_twoOperandOperations == nil) {
        _twoOperandOperations = [NSSet setWithObjects:@"+", @"-", "*", @"/", nil];
    }
    return _twoOperandOperations;
}

//getter method for program, setter is not needed since program is readonly 
- (id)program {
    //returns an immutable array
    return [self.programStack copy];
}

//push operand onto the stack
- (void)pushOperand:(double)operand {
    //wrap primative numbers in an object
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

//push variable operand onto the stack
- (void)pushVariableOperand:(NSString *)variableOperand {
    [self.programStack addObject:variableOperand];
}

//clear the stack
- (void)resetBrain {
    [self.programStack  removeAllObjects];
}

//private helper method to distinguish between variables and operations
+ (BOOL)isOperation:(NSString *)operation {
    if ([operation isEqualToString:@"x"] || [operation isEqualToString:@"y"] || [operation isEqualToString:@"a"]) {
        return FALSE;
    }
    return TRUE;
} 

//get all the names of the variables used in a given program (returned as an NSSet of NSString objects)
+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableSet *mutableSet = [[NSMutableSet alloc] init];
    //check if the element in program is a variable
    if ([program isKindOfClass:[NSArray class]]) {
        for (id element in program) {
            if ([element isKindOfClass:[NSString class]]) {
                if (![CalculatorBrain isOperation:element]) {
                    [mutableSet addObject:(NSString *)element];
                }
            }
        }
    }
    if ([mutableSet count] > 0) {
        return [mutableSet copy];
    }
    else {
        return nil;
    }
}

//perform the operation and return the result
- (double)performOperation:(NSString *)operation {
    
    [self.programStack addObject:operation];
    if ([CalculatorBrain variablesUsedInProgram:self.program]) {
        return [CalculatorBrain runProgram:self.program usingVariableValues:self.defaultDictionary];
    }
    return [CalculatorBrain runProgram:self.program];
}

//test if two-operand operation
+ (BOOL)isTwoOperandOperation:(NSString *)operation {
    if ([operation isEqualToString:@"+"] || [operation isEqualToString:@"-"] ||
        [operation isEqualToString:@"*"] || [operation isEqualToString:@"/"]) {
        return TRUE;
    }
    return FALSE;
}

//test if one-operand operation
+ (BOOL)isOneOperandOperation:(NSString *)operation {
    if ([operation isEqualToString:@"sin"] || [operation isEqualToString:@"cos"] ||
        [operation isEqualToString:@"sqrt"]) {
        return TRUE;
    }
    return FALSE;
}

//test if no-operand operation
+ (BOOL)isNoOperandOperation:(NSString *)operation {
    if ([operation isEqualToString:@"π"]) return TRUE;
    return FALSE;
}

//use recursion to display the program in a more user-friendly manner
+ (NSString *)XXXdescriptionOfTopOfStack:(NSMutableArray *)stack {
    NSString *description = @"";
    //use id type because the items in the stack can either be 
    //a NSNumber or a NSString
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    //use introspection to find the type of topOfStack
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
//        if ([stack count] == 0) return [NSString stringWithFormat:@"%g", [topOfStack doubleValue]];
//        description = [NSString stringWithFormat:@"%g, ", [topOfStack doubleValue]];
//        description = [description stringByAppendingString:[CalculatorBrain descriptionOfTopOfStack:stack]];
        
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *str = topOfStack;
        if ([self isOperation:str]) {
            if ([CalculatorBrain isTwoOperandOperation:str]) { //if one operand operation
                NSNumber *leftOperand; 
                NSNumber *rightOperand;
                for (int i = [stack count]-1; i >= 0; i--) {
                    id element = [stack objectAtIndex:i];
                    if ([element isKindOfClass:[NSNumber class]]) {
                        [stack removeObjectAtIndex:i];
                        i--;
                        rightOperand = element;
                    }
                }
                for (int i = [stack count]-1; i >= 0; i--) {
                    id element = [stack objectAtIndex:i];
                    if ([element isKindOfClass:[NSNumber class]]) {
                        [stack removeObjectAtIndex:i];
                        i--;
                        leftOperand = element;
                    }
                }
                
                description = [NSString stringWithFormat:@"%g %@ %g", leftOperand, str, rightOperand];
                
//                [leftOperand stringByAppendingFormat:@" %@ %g", str, rightOperand];
            }

            
            if ([CalculatorBrain isOneOperandOperation:str]) { //if one operand operation
//                description = [str stringByAppendingFormat:@"(%@)",[CalculatorBrain descriptionOfTopOfStack:stack]];
            }
        }
    }
    return description;
}

//helper function to test if the string has a two-operand operation
+ (BOOL)hasTwoOperandOperation:(NSString *)description {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"+", @"-", @"*", @"/", nil];
    //check if there is a two-operand operation in the string
    for (NSString *str in arr) {
        NSRange range = [description rangeOfString:str];
        if (range.location != NSNotFound) { 
            return TRUE;
        }
    }
    return FALSE;
}

//use recursion to display the program in a more user-friendly manner
+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack {
    NSString *description = @"";
    //use id type because the items in the stack can either be 
    //a NSNumber or a NSString
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    //use introspection to find the type of topOfStack
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%g", [topOfStack doubleValue]];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *str = topOfStack;
        
        if ([CalculatorBrain isNoOperandOperation:topOfStack] ||
            ![CalculatorBrain isOperation:topOfStack]) {
            return topOfStack;
        }
        else if ([self isOperation:str]) {
            if ([CalculatorBrain isOneOperandOperation:str]) {
                return [str stringByAppendingFormat:@"(%@)",[CalculatorBrain descriptionOfTopOfStack:stack]];
            }
            else if ([CalculatorBrain isTwoOperandOperation:str]) {
                NSString *rightOperand = [CalculatorBrain descriptionOfTopOfStack:stack];
                if ([CalculatorBrain hasTwoOperandOperation:rightOperand]) {
                    rightOperand = [NSString stringWithFormat:@"(%@)", rightOperand];
                }
                NSString *leftOperand = [CalculatorBrain descriptionOfTopOfStack:stack];
                return [NSString stringWithFormat:@"%@ %@ %@", leftOperand, str, rightOperand];
                
            }
            
        }
    }
    
    return description;
}

//display the passed program in a more user-friendly manner
+ (NSString *)descriptionOfProgram:(id)program {
    NSString *description;
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    id topOfStack = [stack lastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        if (topOfStack) [stack removeLastObject];
        if ([stack count] == 0) return [NSString stringWithFormat:@"%g", [topOfStack doubleValue]];
        description = [NSString stringWithFormat:@"%g, %@", [topOfStack doubleValue],       [CalculatorBrain descriptionOfProgram:[stack copy]]];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *topOfStackString = topOfStack;
        
        if ([CalculatorBrain isNoOperandOperation:topOfStackString] ||
            ![CalculatorBrain isOperation:topOfStackString]) {
            if (topOfStack) [stack removeLastObject];
            if ([stack count] == 0) return topOfStackString;
            description = [NSString stringWithFormat:@"%@, %@", topOfStackString,       [CalculatorBrain descriptionOfProgram:[stack copy]]];
            
        }
        else if ([CalculatorBrain isOperation:topOfStackString]) {
            description = [self descriptionOfTopOfStack:stack];
            if ([stack count]>0) {
                description = [NSString stringWithFormat:@"%@, %@", description,       [CalculatorBrain descriptionOfProgram:[stack copy]]];
            }
        }
    }
    return description;
}

//pop the top operand off the stack
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

//run the program
+ (double)runProgram:(id)program {
    //local variables created in iOS5 start off at zero
    NSMutableArray *stack;
    //use introspection to see if it is an array
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}


//run the program with the given dictionary
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    //local variables created in iOS5 start off at zero
    NSMutableArray *stack;
    //use introspection to see if it is an array
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    //replace variables with values from the NSDictionary
    for (int i = 0; i < [stack count]; i++) {
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]) {
            if (![CalculatorBrain isOperation:[stack objectAtIndex:i]]) {
                NSNumber *num = [variableValues objectForKey:[stack objectAtIndex:i]];
                if (num) [stack replaceObjectAtIndex:i withObject:num];
                else [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
            }
        }
    }
    return [self popOperandOffStack:stack];
}

@end

















