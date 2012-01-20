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


@end
