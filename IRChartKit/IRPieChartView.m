//
//  PieChartView.m
//  PieChartViewDemo
//


#import "IRPieChartView.h"
#import <QuartzCore/QuartzCore.h>

@implementation IRPieChartView {

    NSMutableArray *dataArray;
    
}

// it was a mistake
- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self setup];
        [self reloadData];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame data:data
{
   if((self = [super initWithFrame:frame])) {
   
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
   
    [self pieLabel:context];
}

- (void)pieLabel:(CGContextRef) context{
    UIColor *whiteColor = [UIColor whiteColor];
    CGFloat radius = 10;
    CGFloat diameter = 10;
    // text
    for (int i = 0; i < 12; i++){
        
        CGFloat cx = radius;
        CGFloat cy = radius;
        CGFloat r = radius * 0.79;
        
        CGFloat a = i * 30 * M_PI / 180;
        a = a - (90 * M_PI / 180); // fix back the rotation
        
        CGFloat x = cx + r * cos(a);
        CGFloat y = cy + r * sin(a);
        
        CGSize size = CGSizeMake(0.40*diameter, 0.30*diameter);
        
        
        
        //// Text 4 Drawing
        CGRect text4Rect = CGRectMake(x- size.width/2, y - size.height/2, size.width, size.height);
        {
            NSString* textContent = @"123";
            NSMutableParagraphStyle* text4Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            text4Style.alignment = NSTextAlignmentCenter;
            
            NSDictionary* text4FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Avenir-Light" size: 0.08*diameter], NSForegroundColorAttributeName: whiteColor, NSParagraphStyleAttributeName: text4Style};
            
            CGFloat text4TextHeight = [textContent boundingRectWithSize: CGSizeMake(text4Rect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: text4FontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            
            CGContextClipToRect(context, text4Rect);
            
            [textContent drawInRect: CGRectMake(CGRectGetMinX(text4Rect), CGRectGetMinY(text4Rect) + (CGRectGetHeight(text4Rect) - text4TextHeight) / 2, CGRectGetWidth(text4Rect), text4TextHeight) withAttributes: text4FontAttributes];
            
            CGContextRestoreGState(context);
        }
        
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    // when user touch the chart
    return YES;
}

@end
