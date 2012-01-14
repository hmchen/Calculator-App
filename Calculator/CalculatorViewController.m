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
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize displayHistory = _displayHistory;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

//allocate a new brain if one does not exist
- (CalculatorBrain *)brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

//remove "=" from displayHistory
- (void)removeEqualInDisplayHistory {
    NSRange range = [self.displayHistory.text rangeOfString:@"="];
    if (range.location != NSNotFound) {
        self.displayHistory.text = [self.displayHistory.text substringToIndex:range.location];
    }
}

//backspace pressed
- (IBAction)backspacePressed {
    if ([self.display.text length] == 1) {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
    else {
        self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
    }
}

/* IBAction - typedef to void, used by Xcode to identify this method as an action
    digitPressed - name of the function
    (UIButton *) - data type of sender
 */
- (IBAction)digitPressed:(UIButton *)sender {
    //NSString pointer called digit
    NSString *digit = [sender currentTitle];
    //NSLog - similar to printf in c, %@ is an object 
    NSLog(@"digit pressed = %@", digit);
    
//    [self removeEqualInDisplayHistory];
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        //pointer to UILabel
        UILabel *myDisplay = self.display; //same as [self display];
        //text is a method that will return the text in the UILabel
        NSString *currentText = myDisplay.text; //  [myDisplay text]; 
        
        //check if there is a "." in the display
        if ([digit isEqualToString:@"."]) {
            NSRange range = [self.display.text rangeOfString:@"."];
            if (range.location != NSNotFound) { //exit if self.display.text has a "."
                return;
            }
        }
                
        //append currentText to digit
        NSString *newText = [currentText stringByAppendingString:digit];
        
        //set text in myDisplay
        myDisplay.text = newText; //[myDisplay setText:newText]; 
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
    //update the displayHistory with the operand
//    [self removeEqualInDisplayHistory];
//    self.displayHistory.text = [self.displayHistory.text stringByAppendingString:self.display.text];
//    self.displayHistory.text = [self.displayHistory.text stringByAppendingString:@" "];
    self.displayHistory.text = [CalculatorBrain descriptionOfProgram:[self.brain program]]; 
    self.userIsInTheMiddleOfEnteringANumber = NO;
}
//clear the display and the stack
- (IBAction)clearPressed {
    [self.brain resetBrain];
    self.display.text = @"0";
    self.displayHistory.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
//    [self enterPressed];
    
    double result = [self.brain performOperation:sender.currentTitle];
    //%g used for floating point numbers
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    
    //update the displayHistory with the operation pressed 
//    [self removeEqualInDisplayHistory];
//    self.displayHistory.text = [self.displayHistory.text stringByAppendingString:sender.currentTitle];
//    self.displayHistory.text = [self.displayHistory.text stringByAppendingString:@" ="];
}

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    
    NSString *variable = [sender currentTitle];
    self.display.text = variable;
    
    //update the displayHistory with the variable operand pressed 
//    [self removeEqualInDisplayHistory];
//    self.displayHistory.text = [self.displayHistory.text stringByAppendingString:sender.currentTitle];
//    self.displayHistory.text = [self.displayHistory.text stringByAppendingString:@" "];
}

@end










