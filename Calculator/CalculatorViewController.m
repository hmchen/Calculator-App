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

/* IBAction - typedef to void, used by Xcode to identify this method as an action
    digitPressed - name of the function
    (UIButton *) - data type of sender
 */
- (IBAction)digitPressed:(UIButton *)sender {
    //NSString pointer called digit
    NSString *digit = [sender currentTitle];

    //NSLog - similar to printf in c
    //%@ is an object 
    NSLog(@"digit pressed = %@", digit);
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        //pointer to UILabel
        UILabel *myDisplay = self.display; //same as [self display];
        
        //text is a method that will return the text in the UILabel
        NSString *currentText = myDisplay.text; //  [myDisplay text]; 
        
        //append currentText to digit
        NSString *newText = [currentText stringByAppendingString:digit];
        
        //set text in myDisplay
        myDisplay.text = newText; //[myDisplay setText:newText]; 
    }
    else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES; 
    }
}

//push whatever is in the display into the calculatorbrain
- (IBAction)enterPressed {
    //push the double value into the stack
    [self.brain pushOperand:[self.display.text doubleValue]];
    //update the displayHistory with the double value 
    self.displayHistory.text = [self.displayHistory.text stringByAppendingString:self.display.text];
    self.displayHistory.text = [self.displayHistory.text stringByAppendingString:@" "];
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
    
    double result = [self.brain performOperation:sender.currentTitle];
    //%g used for floating point numbers
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    
    //update the displayHistory with the operation pressed 
    self.displayHistory.text = [self.displayHistory.text stringByAppendingString:sender.currentTitle];
    self.displayHistory.text = [self.displayHistory.text stringByAppendingString:@" "];
}

- (void)viewDidUnload {
    [self setDisplayHistory:nil];
    [super viewDidUnload];
}
@end
