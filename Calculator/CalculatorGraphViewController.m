//
//  CalculatorGraphViewController.m
//  Calculator
//
//  Created by Hon-ming Chen on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphViewController.h"
#import "CalculatorGraphView.h"
#import "CalculatorBrain.h"

@interface CalculatorGraphViewController() <CalculatorGraphViewDataSource>
@property (nonatomic, weak) IBOutlet CalculatorGraphView *graphView; //create an outlet to CalculatorGraphView
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@end

@implementation CalculatorGraphViewController
@synthesize graphView = _graphView;
@synthesize program = _program;
@synthesize toolBar = _toolBar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

//redraw view when program is updated
- (void)setProgram:(id)program {
    _program = program;
    [self.graphView setNeedsDisplay];
}

- (void)setGraphView:(CalculatorGraphView *)graphView {
    _graphView = graphView;
    //set CalculatorGraphView dataSource to be this controller
    self.graphView.dataSource = self;
    //Only views have recognizers
    //enable pinch gesture in the CalculatorGraphView using its pinch: handler
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    //enable pan gesture in the CalculatorGraphView using its pan: handler
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    //enable triple-tap gesture to set originPoint in the CalculatorGraphView using its tripleTapSetOriginPoint: handler
    [self.graphView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTapSetOriginPoint:)]];
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolBarItems = [self.toolBar.items mutableCopy]; //get toolbar items 
        if (_splitViewBarButtonItem) [toolBarItems removeObject:_splitViewBarButtonItem]; //remove if the bar button item already exist
        if (splitViewBarButtonItem) [toolBarItems insertObject:splitViewBarButtonItem atIndex:0]; //add new bar button item
        self.toolBar.items = toolBarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
        
    }
}

- (double)yValueForCalculatorGraph:(CalculatorGraphView *)sender usingXValue:(double)xVal {
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithDouble:xVal], @"x", nil];
    return [CalculatorBrain runProgram:self.program usingVariableValues:dictionary];
}

//returns YES to supports all orientations
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES; 
}

//set self as splitViewController delegate when coming out of storyboard.
- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

//hide masterView when in portrait orientation
- (BOOL)splitViewController:(UISplitViewController *)svc 
   shouldHideViewController:(UIViewController *)vc 
              inOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsPortrait(orientation);
}

//show barButtonItem when hiding masterView
- (void)splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc {
    barButtonItem.title = aViewController.title;
    self.splitViewBarButtonItem = barButtonItem;
}

//get ride of barButtonItem when showing masterView
- (void)splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    self.splitViewBarButtonItem = nil;
}

@end











