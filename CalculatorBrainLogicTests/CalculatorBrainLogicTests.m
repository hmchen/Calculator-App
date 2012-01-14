//
//  CalculatorBrainLogicTests.m
//  CalculatorBrainLogicTests
//
//  Created by Hon Ming Chen on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrainLogicTests.h"
#import "CalculatorBrain.h"

@implementation CalculatorBrainLogicTests
@synthesize brain = _brain;

- (void)setUp
{
    [super setUp];
    self.brain = [[CalculatorBrain alloc] init];
    NSLog(@"Testing the brain: %@", self.brain);
    // Set-up code here.
}

//- (void)tearDown
//{
//    // Tear-down code here.
//    
//    [super tearDown];
//}

- (void)testPushOperand {
    [self.brain pushOperand:3];
    [self.brain pushOperand:4.5];
    
    STAssertEquals(2, (int)[self.brain.program count], nil);
}

- (void)testPushVariableOperand {
    [self.brain pushVariableOperand:@"x"];
    [self.brain pushVariableOperand:@"y"];
    
    STAssertEquals(2, (int)[self.brain.program count], nil);
}

- (void)testRunProgram {
    [self.brain pushOperand:9];
    [self.brain pushVariableOperand:@"sqrt"];
    STAssertEquals(3.0, [CalculatorBrain runProgram:self.brain.program], @"");
    
}

- (void)testDescriptionOfProgram {
    NSString *description;
    
    [self.brain pushOperand:3];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
//    STAssertEqualObjects(description, @"3", nil);
    
    [self.brain pushOperand:5];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
//    STAssertEqualObjects(description, @"5, 3", nil);
    
    [self.brain pushOperand:6];
    [self.brain pushOperand:7];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
//    STAssertEqualObjects(description, @"7, 6, 5, 3", nil);
    
    [self.brain pushVariableOperand:@"+"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
//    STAssertEqualObjects(description, @"6 + 7, 5, 3", nil);
    
    [self.brain resetBrain];  //test one-operand operations
    [self.brain pushOperand:9];
    [self.brain pushVariableOperand:@"sqrt"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"sqrt(9)", nil);
    
    [self.brain pushVariableOperand:@"sqrt"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"sqrt(sqrt(9))", nil);
    
    [self.brain resetBrain];  //test two-operand operations
    [self.brain pushOperand:9];
    [self.brain pushOperand:6];
    [self.brain pushVariableOperand:@"+"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"9+6", nil);
    
    
}

@end















