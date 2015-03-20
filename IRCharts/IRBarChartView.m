//
//  IRBarChartView.m
//  IRCharts
//
//  Created by Hijazi on 9/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "IRBarChartView.h"

@implementation IRBarChartView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
 //// Color Declarations
 UIColor* color2 = [UIColor colorWithRed: 0 green: 1 blue: 0 alpha: 1];
 UIColor* color3 = [UIColor colorWithRed: 0.579 green: 0.112 blue: 0.286 alpha: 1];
 UIColor* color4 = [UIColor colorWithRed: 1 green: 0 blue: 0 alpha: 1];
 
 //// Bezier Drawing
 UIBezierPath* bezierPath = UIBezierPath.bezierPath;
 [bezierPath moveToPoint: CGPointMake(12.5, 12.5)];
 [bezierPath addLineToPoint: CGPointMake(12.5, 186.5)];
 [bezierPath addLineToPoint: CGPointMake(192.5, 186.5)];
 [UIColor.blackColor setStroke];
 bezierPath.lineWidth = 1;
 [bezierPath stroke];
 
 
 //// Rectangle Drawing
 UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(13, 31, 114, 16)];
 [color4 setFill];
 [rectanglePath fill];
 
 
 //// Rectangle 2 Drawing
 UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(13, 61, 66, 16)];
 [color3 setFill];
 [rectangle2Path fill];
 
 
 //// Rectangle 3 Drawing
 UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(13, 91, 48, 16)];
 [color2 setFill];
 [rectangle3Path fill];

}


@end
