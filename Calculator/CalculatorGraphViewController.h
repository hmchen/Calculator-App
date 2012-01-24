//
//  CalculatorGraphViewController.h
//  Calculator
//
//  Created by Hon-ming Chen on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorGraphViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) id program; //the model, the current program when the graph button is pressed

@property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;
@end
