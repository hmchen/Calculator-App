//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Hon Ming Chen on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;

@property (nonatomic, strong) NSDictionary *testVariableValues1;
@property (nonatomic, strong) NSDictionary *testVariableValues2;
@property (nonatomic, strong) NSDictionary *testVariableValues3;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize displayHistory = _displayHistory;
@synthesize displayVariablesInProgram = _displayVariablesInProgram;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;
@synthesize testVariableValues1 = _testVariableValues1;
@synthesize testVariableValues2 = _testVariableValues2;
@synthesize testVariableValues3 = _testVariableValues3;

//allocate a new brain if one does not exist
- (CalculatorBrain *)brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

//override getter method for testVariableValues1
- (NSDictionary *)testVariableValues1 {
    if (_testVariableValues1 == nil) {
        _testVariableValues1 = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:1], @"x",
                              [NSNumber numberWithInt:2], @"y", nil];
    }
    return _testVariableValues1;
}

//override getter method for testVariableValues2
- (NSDictionary *)testVariableValues2 {
    if (_testVariableValues2 == nil) {
        _testVariableValues2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:3], @"x",
                                [NSNumber numberWithInt:4], @"y", nil];
    }
    return _testVariableValues2;
}

//update display
- (void)updateDisplay {
    double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

//update displayHistory
- (void)updateDisplayHistory {
    self.displayHistory.text = [CalculatorBrain descriptionOfProgram:[self.brain program]]; 
}

//update displayVariablesInProgram with the variables and values found in the program
- (void)updateDisplayVariablesInProgram {
    NSString *description = @"";
    NSNumber *num;
    NSSet *variableSet = [CalculatorBrain variablesUsedInProgram:self.brain.program];
    
    for (NSString *key in variableSet) {
        num = [self.testVariableValues objectForKey:key];
        if (num) {
            if (description == nil) {
                description = [NSString stringWithFormat:@"%@ = %g", key, [num doubleValue]];
            }
            else {
                description = [description stringByAppendingFormat:@" %@ = %g", key, [num doubleValue]];
            }
        }
    }
    self.displayVariablesInProgram.text = description;
}

//updates display, displayHistory, displayVariablesInProgram
- (void)updateAllTheDisplays {
    [self updateDisplay];
    [self updateDisplayHistory];
    [self updateDisplayVariablesInProgram];
}

//undo pressed
- (IBAction)undoPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([self.display.text length] == 1) {
            self.userIsInTheMiddleOfEnteringANumber = NO;
            [self updateAllTheDisplays];
        }
        else {
            self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
        }
    }
    else {
        [self.brain removeLastObjectFromStack];
        [self updateAllTheDisplays];
    }
    
}

//digit pressed
- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    //NSLog - similar to printf in c, %@ is an object 
//    NSLog(@"digit pressed = %@", digit);
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        NSString *currentText = self.display.text;
        
        //check if there is a "." in the display
        if ([digit isEqualToString:@"."]) {
            NSRange range = [self.display.text rangeOfString:@"."];
            if (range.location != NSNotFound) { //exit if self.display.text has a "."
                return;
            }
        }
        //append currentText to digit
        self.display.text = [currentText stringByAppendingString:digit];
    }
    else {
        self.display.text = digit;
        if ([digit isEqualToString:@"."]) {
            self.display.text = @"0.";
        }
        self.userIsInTheMiddleOfEnteringANumber = YES; 
    }
}

//private helper method to distinguish between variables and digit operand
+ (BOOL)isVariableOperand:(NSString *)operand {
    if ([operand isEqualToString:@"x"] || [operand isEqualToString:@"y"] || [operand isEqualToString:@"a"]) {
        return TRUE;
    }
    return FALSE;
}

//push whatever is in the display into the calculatorbrain
- (IBAction)enterPressed {
    if ([CalculatorViewController isVariableOperand:self.display.text]) {
        [self.brain pushVariableOperand:self.display.text];
    }
    else {
        //push the double value into the stack
        [self.brain pushOperand:[self.display.text doubleValue]];
    }
    [self updateDisplayHistory];
    [self updateDisplayVariablesInProgram];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}
//clear the display and the stack
- (IBAction)clearPressed {
    [self.brain resetBrain];
    self.display.text = @"0";
    self.displayHistory.text = @"";
    self.displayVariablesInProgram.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

//operation pressed
- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    [self updateDisplayHistory];
    [self updateDisplayVariablesInProgram];
}

//variable pressed
- (IBAction)variablePressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    
    NSString *variable = [sender currentTitle];
    self.display.text = variable;
    self.userIsInTheMiddleOfEnteringANumber = YES; 
}


//test button pressed, set the testVariableValues to a specific value
- (IBAction)testVariablePressed:(UIButton *)sender {
    double result;
    NSString *testButton = sender.currentTitle;
    if ([testButton isEqualToString:@"Test 1"]) {
        self.testVariableValues = self.testVariableValues1;
        result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    }
    else if ([testButton isEqualToString:@"Test 2"]) {
        self.testVariableValues = self.testVariableValues2;
        result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    }
    else if ([testButton isEqualToString:@"Test 3"]) {
        self.testVariableValues = self.testVariableValues3;
        result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    }
    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self updateDisplayVariablesInProgram];
}



- (void)viewDidUnload {
    [self setDisplayVariablesInProgram:nil];
    [super viewDidUnload];
}
@end










