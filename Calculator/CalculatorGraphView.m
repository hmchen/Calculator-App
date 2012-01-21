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
@synthesize originPoint = _originPoint;

//zoomScale getter
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

//if originPoint is at 0,0 then set to midPoint
- (CGPoint)originPoint {
    if (_originPoint.x == 0 && _originPoint.y == 0) {
        CGPoint midPoint;
        midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
        midPoint.y = self.bounds.origin.x + self.bounds.size.height/2;
        _originPoint = midPoint;
    }
    return _originPoint;
}

//redraw when a new originPoint is set
- (void)setOriginPoint:(CGPoint)originPoint {
    if (!CGPointEqualToPoint(originPoint, _originPoint )) {
        _originPoint = originPoint;
        [self setNeedsDisplay];        
    }
}

//pinch handler, pinch to zoom implemented in the view so other controllers can call upon it
- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.zoomScale *= gesture.scale;
        gesture.scale = 1; //reset to 1 to get incremental instead of cumulative scale
    }
}

//pan handler, panning implemented in the view so other controllers can call upon it
- (void)pan:(UIPanGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self];
        self.originPoint = CGPointMake(self.originPoint.x+translation.x, self.originPoint.y+translation.y);
        [gesture setTranslation:CGPointZero inView:self]; //reset to get incremental instead of cumulative translation
    }
}

//triple-tap handler, set originPoint to the point of the triple-tap
- (void)tripleTapSetOriginPoint:(UITapGestureRecognizer *)gesture {
    gesture.numberOfTapsRequired = 3;
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.originPoint = [gesture locationInView:self];
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

    [[UIColor blueColor] setStroke];    //set line color
    //draw axes
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.originPoint scale:self.zoomScale];
}

@end
    
    
    
    
    
    
