 //
//  CalculatorViewController.h
//  Calculator
//
//  Created by Hon Ming Chen on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *displayHistory;
@property (weak, nonatomic) IBOutlet UILabel *displayVariablesInProgram;
@end
