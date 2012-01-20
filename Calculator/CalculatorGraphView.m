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

@synthesize zoomScale = _zoomScale;

- (CGFloat)zoomScale {
    if (_zoomScale == 0) return 1;
    return _zoomScale;
}

//redraw when a new zoomScale is set
- (void)setZoomScale:(CGFloat)zoomScale {
    if (_zoomScale != zoomScale) {
        _zoomScale = zoomScale;
        [self setNeedsDisplay];
    }
}

//when bounds change, call drawRect
- (void)setup {
    self.contentMode = UIViewContentModeRedraw;
}

//awakeFromNib gets called when a UIView comes out of a storyboard
- (void)awakeFromNib {
    [self setup];
}

//gets called when the UIView first gets setup
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
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
    
    
    
    
    
    
