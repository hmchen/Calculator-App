 //
//  CalculatorBrain.h
//  Calculator
//
//  Created by Hon Ming Chen on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
//- means these are instance methods
- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)resetBrain;

@property (readonly) id program;
//+ means these are class methods
+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

@end
