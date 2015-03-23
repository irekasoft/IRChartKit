//
//  IRLagendView.h
//  IRCharts
//
//  Created by Hijazi on 9/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRLegendView : UIView

typedef NS_ENUM(NSInteger, IRLegendViewDataType) {
    IRLegendViewDataPieChart = 0,
    IRLegendViewDataLineChart
};

@property IRLegendViewDataType dataType; // <nsstring, nsnumber>
@property (strong) NSArray *data; // <nsstring, nsnumber>

@end
