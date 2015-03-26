//
//  ViewController.m
//  IRCharts
//
//  Created by Muhammad Hijazi  on 5/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
{
    
   IRPieChartView *pieChartView;

}


@property (strong) NSArray *data; // <name, value>

@end

@implementation ViewController

static inline UIColor *GetRandomUIColor()
{
    CGFloat r = arc4random() % 255;
    CGFloat g = arc4random() % 255;
    CGFloat b = arc4random() % 255;
    UIColor * color = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1.0f];
    return color;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self setupDoughnutChart];
    [self setupLineChart];
    
}



- (void)setupLineChart{
    
    NSArray *xSteps = @[@"1", @"2", @"3",@"4", @"5", @"6", @"7", @"8",@"9", @"10", @"11", @"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view_lineChart.frame];
    scrollView.showsHorizontalScrollIndicator = NO;
    CGRect rect = self.view_lineChart.frame;

    // uncomment if want to make inside the scroll view
    // scrollable
//    rect.size.width = CGRectGetWidth(rect)*2;
//    scrollView.contentSize = rect.size;
    
    IRLineChartView *lineChartView = [[IRLineChartView alloc] initWithFrame:rect];
    lineChartView.yStepNumber = 3;
    self.view_lineChart.backgroundColor = [UIColor clearColor];
    self.view_lineChart.clipsToBounds = NO;
    //    self.xSteps = @[@"Jan", @"Feb", @"Mac",@"April", @"May", @"Jun", @"Julai", @"Ogos",@"September", @"Oktober", @"November", @"Disember"];
    lineChartView.xSteps = xSteps;

    
    NSArray *data = @[@(4),@(12),@(3),@(2),@(6),@(8),@(22),@(12),@(0.8),@(0.8),@(1.0),@(3),@(2)];
    NSArray *data2 = @[@(1),@(4),@(7),@(23),@(6),@(8),@(22),@(23),@(1),@(3),@(1.0),@(6),@(4)];
    NSArray *data3 = @[@(21),@(32),@(8),@(5),@(13),@(32),@(3),@(9),@(21),@(12),@(1.0),@(6),@(4)];
    NSArray *data4 = @[@(121),@(12),@(3),@(11),@(3),@(2),@(3),@(9),@(1),@(3),@(1.0),@(5),@(2),@(121),@(121),@(121),@(121),@(121),@(121),@(124),@(121),@(11)];
    
    lineChartView.allDataArray = @[@[@{@"sms":data},GetRandomUIColor()],
                                   @[@{@"mobile":data2},GetRandomUIColor()],
                                   @[@{@"email":data3},GetRandomUIColor()],
                                   @[@{@"web":data4},GetRandomUIColor()]
                                   ];
    
    
    
    [self.view addSubview:lineChartView];
//    [scrollView addSubview:lineChartView];
    
    // legend
    
    
    
    IRLegendView *legendView = [[IRLegendView alloc] initWithFrame:CGRectMake(self.view_lineChart.frame.origin.x, self.view_lineChart.frame.origin.y+self.view_lineChart.frame.size.height, self.view_lineChart.frame.size.width, 300)];
    legendView.dataType = IRLegendViewDataLineChart;
    legendView.data = lineChartView.allDataArray;
    legendView.column = 4;
    legendView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:legendView];
    
    
}

- (void)setupDoughnutChart{

    // example show donut and legend share same data
    
    NSArray *data = @[@[@"nama 1", @(10), GetRandomUIColor()],
                    @[@"nama 2", @(40), GetRandomUIColor()],
                    @[@"nama 3", @(10), GetRandomUIColor()],
                    @[@"nama 4", @(20), GetRandomUIColor()],
                    @[@"nama 5", @(20), GetRandomUIColor()]];
    
    pieChartView = [[IRPieChartView alloc] initWithFrame:CGRectMake(self.view_pieChart.frame.origin.x, self.view_pieChart.frame.origin.y, self.view_pieChart.frame.size.width, self.view_pieChart.frame.size.height) data:data];
    self.view_pieChart.backgroundColor = [UIColor clearColor];
    pieChartView.isDoughnut = NO;
    [self.view addSubview:pieChartView];
    
    IRLegendView *legendView = [[IRLegendView alloc] initWithFrame:CGRectMake(self.view_pieChart.frame.origin.x, self.view_pieChart.frame.origin.y+self.view_pieChart.frame.size.height, self.view_pieChart.frame.size.width, 300)];
    legendView.dataType = IRLegendViewDataPieChart;
    legendView.data = data;
    legendView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:legendView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
