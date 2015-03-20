//
//  PieChartView.m
//  PieChartViewDemo
//


#import "IRPieChartView.h"
#import <QuartzCore/QuartzCore.h>

@implementation IRPieChartView {

    NSMutableArray *dataArray;
    
}

-(id)initWithFrame:(CGRect)frame data:data
{
   self = [super initWithFrame:frame];
   if (self != nil)
   {
       _data = data;
       [self setup];
   }
   return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
    
    [self reloadData];
}


- (void)setup{
    //initialization
    self.backgroundColor = [UIColor clearColor];
    
    if (self.dropShaddow) {
        
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0.0f, 2.5f);
        self.layer.shadowRadius = 1.9f;
        self.layer.shadowOpacity = 0.9f;
        
    }

    
}

-(void)reloadData
{
   [self calculatePieChart];
   [self setNeedsDisplay];


}

- (void)calculatePieChart{
    NSUInteger numberOfSections = [self.data count];
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
    
    // Get the sum
    double sum = 0;
    for (int i = 0; i < numberOfSections; i ++) {
        sum += [self.data[i][1] integerValue];
    }
    
    for (int i = 0; i < numberOfSections; i ++) {
        double data = [self.data[i][1] integerValue];
        double angle = data / sum * 360;
        [dataArray addObject:[NSNumber numberWithDouble:angle]];
    }
    
    NSLog(@"%@",dataArray);
    
    
}

static inline UIColor *GetRandomUIColor()
{
    CGFloat r = arc4random() % 255;
    CGFloat g = arc4random() % 255;
    CGFloat b = arc4random() % 255;
    UIColor * color = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1.0f];
    return color;
}

- (void)drawRect:(CGRect)rect
{

   //prepare
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGFloat theHalf = rect.size.width/2;
   CGFloat lineWidth = theHalf;
   
   CGFloat radius = theHalf-lineWidth/2;
   
   CGFloat centerX = theHalf;
   CGFloat centerY = rect.size.height/2;
   
//drawing
   
   double sum = 0.0f;
    
    NSLog(@"aa %d",(int)self.data.count);
    
    NSUInteger slicesCount = [self.data count];
   
   for (int i = 0; i < slicesCount; i++)
   {
       sum += [self.data[i][1] doubleValue];
   }
   
   float startAngle = -M_PI_2;
   float endAngle = 0.0f;
      
   for (int i = 0; i < [self.data count]; i++)
   {
      double value = [self.data[i][1] doubleValue];

      endAngle = startAngle + M_PI*2*value/sum;
      CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, false);
   
      UIColor  *drawColor = self.data[i][2];
   
      CGContextSetStrokeColorWithColor(context, drawColor.CGColor);
      CGContextSetLineWidth(context, lineWidth);

      CGContextStrokePath(context);
      startAngle += M_PI*2*value/sum;
       
   }
    
    if (self.isDoughnut) {
        
        CGFloat ovalRadius = 0.5 * rect.size.width;
        
        //// Color Declarations
        UIColor* color = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        
        //// Oval 8 Drawing
        
        UIBezierPath* oval8Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake((rect.size.width - ovalRadius)/2, (rect.size.height - ovalRadius)/2, ovalRadius, ovalRadius)];

        [color setFill];
        [oval8Path fill];

    }
    
//    
//    int centerPoint = MIN(self.bounds.size.height/2, self.bounds.size.width/2);
//    int x = centerPoint;
//    int y = centerPoint;
//    radius = centerPoint = UIGraphicsGetCurrentContext(); // declare the uiview as the canvas
//    
//    CGContextSetLineWidth(context, 10);
//    
//    double currentAngle = 0;
//    int kColor = 1;
//    
//    
//    NSUInteger section = [self.data count];
//    
//    //for (NSNumber *angle in dataArray){
//    for (int i = 0; i < section; i ++) {
//        
//        double angle = [[dataArray objectAtIndex:i] doubleValue];
//        
//        [[UIColor blueColor] set];
//        CGContextMoveToPoint(context, x, y);
//        CGContextAddArc(context, 123, radius, 24, 21, 12, 1);
//        CGContextClosePath(context);
//        CGContextFillPath(context);
//        
//        currentAngle += angle;
//        kColor ++;
//        
//        [[UIColor blackColor] set];
//   }
   
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    // when user touch the chart
    return YES;
}

@end
