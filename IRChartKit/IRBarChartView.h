//
//  IRBarChartView.h
//  IRCharts
//
//  Created by Hijazi on 26/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRChartInfoView.h"

IB_DESIGNABLE

typedef void(^IRLineChartSelectedItem)();
typedef void(^IRLineChartDeselectedItem)();

@interface IRBarChartView : UIView {
    
    CGFloat x_gap;
    
    UIColor* color;
    UIColor* color3;
    
    CGFloat extra_bed;
}

@property NSString *yAxisName;
@property NSInteger yStepNumber;
@property double scaleForAnimation;
@property NSNumber *selectedData;
@property UIView *currentPosView; // the red line
@property double yMin;
@property double yMax;
@property (strong, nonatomic) NSArray *allDataArray;

// Array of step names (NSString). At each step, a scale line is shown.
@property (strong) NSArray *ySteps;

@property IRChartInfoView *infoView;
@property UILabel *xAxisLabel;

@property (copy) IRLineChartSelectedItem selectedItemCallback;
@property (copy) IRLineChartDeselectedItem deselectedItemCallback; /// Called after a data point is deselected and before the next `selected` callback

@property NSArray *xSteps;

@property (strong) UIFont *scaleFont; /// Font in which scale markings are drawn. Defaults to [UIFont systemFontOfSize:10].

@end
