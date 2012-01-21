//
//  CalculatorGraphView.h
//  Calculator
//
//  Created by Hon-ming Chen on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorGraphView : UIView

@property (nonatomic) CGFloat zoomScale;
@property (nonatomic) CGPoint originPoint;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;
- (void)tripleTapSetOriginPoint:(UITapGestureRecognizer *)gesture;

@end
