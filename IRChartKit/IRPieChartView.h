//
//  PieChartView.h


#import <UIKit/UIKit.h>


@interface IRPieChartView : UIControl

@property (strong) NSArray *data; // <nsstring, nsnumber>
@property (assign) BOOL dropShaddow;
@property (assign) BOOL isDoughnut;
@property (assign) BOOL isPercentage;

-(void)reloadData;
-(id)initWithFrame:(CGRect)frame data:data;

@end

@protocol PieChartViewDelegate <NSObject>

- (CGFloat)centerCircleRadius;

@end



