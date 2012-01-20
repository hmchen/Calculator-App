//
//  CalculatorGraphView.m
//  Calculator
//
//  Created by Hon-ming Chen on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphView.h"
#import "AxesDrawer.h"

@implementation CalculatorGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();   //always get the context
    
    //get mid point of the view
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.x + self.bounds.size.height/2;
    CGFloat pointsPerUnit = 5;
    [[UIColor blueColor] setStroke];    //set line color
    //draw axes
    [AxesDrawer drawAxesInRect:rect originAtPoint:midPoint scale:pointsPerUnit];
}

@end
    
    
    
    
    
    
