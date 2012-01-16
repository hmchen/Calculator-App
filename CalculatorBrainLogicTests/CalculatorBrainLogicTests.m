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
    
    //3 E 5 E 6 E 7 + * - should display as 3 - (5 * (6 + 7))
    [self.brain pushOperand:3];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"3", nil);
    
    [self.brain pushOperand:5];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"5, 3", nil);
    
    [self.brain pushOperand:6];
    [self.brain pushOperand:7];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"7, 6, 5, 3", nil);
    
    [self.brain pushVariableOperand:@"+"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"6 + 7, 5, 3", nil);
    
    [self.brain pushVariableOperand:@"*"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"5 * (6 + 7), 3", nil);
    
    [self.brain pushVariableOperand:@"-"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"3 - (5 * (6 + 7))", nil);
    
    //9 sqrt sqrt should display as sqrt(sqrt(9))
    [self.brain resetBrain];  
    [self.brain pushOperand:9];
    [self.brain pushVariableOperand:@"sqrt"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"sqrt(9)", nil);
    
    [self.brain pushVariableOperand:@"sqrt"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"sqrt(sqrt(9))", nil);
    
    //3 E 5 + sqrt should display as sqrt(3 + 5)
    [self.brain resetBrain];  
    [self.brain pushOperand:3];
    [self.brain pushOperand:5];
    [self.brain pushVariableOperand:@"+"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"3 + 5", nil);
    
    [self.brain pushVariableOperand:@"sqrt"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"sqrt(3 + 5)", nil);
    
    //3 sqrt sqrt should display as sqrt(sqrt(3))
    [self.brain resetBrain];  
    [self.brain pushOperand:3];
    [self.brain pushVariableOperand:@"sqrt"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"sqrt(3)", nil);
    
    [self.brain pushVariableOperand:@"sqrt"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"sqrt(sqrt(3))", nil);
    
    //3 E 5 sqrt + should display as 3 + sqrt(5)
    [self.brain resetBrain];  
    [self.brain pushOperand:3];
    [self.brain pushOperand:5];
    [self.brain pushVariableOperand:@"sqrt"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"sqrt(5), 3", nil);
    
    [self.brain pushVariableOperand:@"+"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"3 + sqrt(5)", nil);
    
    //3 E 5 + 6 E 7 * 9 sqrt would be “sqrt(9), 6 * 7, 3 + 5”
    [self.brain resetBrain];
    [self.brain pushOperand:3];
    [self.brain pushOperand:5];
    [self.brain pushVariableOperand:@"+"];
    
    [self.brain pushOperand:6];
    [self.brain pushOperand:7];
    [self.brain pushVariableOperand:@"*"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"6 * 7, 3 + 5", nil);
    
    [self.brain pushOperand:9];
    [self.brain pushVariableOperand:@"sqrt"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"sqrt(9), 6 * 7, 3 + 5", nil);
    
    //π r r * * should display as π * (r * r) or, even better, π * r * r
    [self.brain resetBrain];
    [self.brain pushVariableOperand:@"π"];
    [self.brain pushVariableOperand:@"x"];
    [self.brain pushVariableOperand:@"x"];
    [self.brain pushVariableOperand:@"*"];
    [self.brain pushVariableOperand:@"*"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"π * (x * x)", nil);
    
    //a a * b b * + sqrt would be, at best, sqrt(a * a + b * b)
    [self.brain resetBrain];
    [self.brain pushVariableOperand:@"x"];
    [self.brain pushVariableOperand:@"x"];
    [self.brain pushVariableOperand:@"*"];
    [self.brain pushVariableOperand:@"y"];
    [self.brain pushVariableOperand:@"y"];
    [self.brain pushVariableOperand:@"*"];
    [self.brain pushVariableOperand:@"+"];
    [self.brain pushVariableOperand:@"sqrt"];
    description = [CalculatorBrain descriptionOfProgram:self.brain.program];
    STAssertEqualObjects(description, @"sqrt(x * x + (y * y))", nil);
    
    
    
}

@end















