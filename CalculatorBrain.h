 //
//  CalculatorBrain.h
//  Calculator
//
//  Created by Hon Ming Chen on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (readonly) id program;

//instance methods
- (void)pushOperand:(double)operand;
- (void)pushVariableOperand:(NSString *)variableOperand;
- (double)performOperation:(NSString *)operation;
- (void)resetBrain;
- (void)removeLastObjectFromStack;

//class methods
+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
