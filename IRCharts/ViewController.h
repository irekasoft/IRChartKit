//
//  ViewController.h
//  IRCharts
//
//  Created by Muhammad Hijazi  on 5/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IRChartKit/IRChartKit.h>
#import "IRColor.h"
#import "IRLineChartView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *view_pieChart;
@property (weak, nonatomic) IBOutlet UIView *view_lineChart;

@end

