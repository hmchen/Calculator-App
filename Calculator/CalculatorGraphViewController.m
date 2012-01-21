//
//  CalculatorGraphViewController.m
//  Calculator
//
//  Created by Hon-ming Chen on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphViewController.h"
#import "CalculatorGraphView.h"

@interface CalculatorGraphViewController()
@property (nonatomic, weak) IBOutlet CalculatorGraphView *graphView; //create an outlet to CalculatorGraphView
@end

@implementation CalculatorGraphViewController
@synthesize graphView = _graphView;
@synthesize program = _program;

- (void)setGraphView:(CalculatorGraphView *)graphView {
    _graphView = graphView;
    //Only views have recognizers
    //enable pinch gesture in the CalculatorGraphView using its pinch: handler
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    //enable pan gesture in the CalculatorGraphView using its pan: handler
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    //enable triple-tap gesture to set originPoint in the CalculatorGraphView using its tripleTapSetOriginPoint: handler
    [self.graphView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTapSetOriginPoint:)]];
}

//returns YES to supports all orientations
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES; 
}

@end
