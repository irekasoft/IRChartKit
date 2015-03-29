//
//  PieChartView.m
//  PieChartViewDemo
//

#import "IRPieChartView.h"
#import <QuartzCore/QuartzCore.h>

@implementation IRPieChartView {
    NSMutableArray *dataArray;
}

- (id)initWithFrame:(CGRect)frame data:data
{
    if((self = [super initWithFrame:frame])) {
        _data = data;
        [self setup];
        [self reloadData];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self setup];
        [self reloadData];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
    [self reloadData];
}


- (void)setup
{
    if (self.bounds.size.width != self.bounds.size.height) {
        NSLog(@"please make the size side equal");
    }
    
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
    
//    NSLog(@"%@",dataArray);
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
   
   // drawing
   double sum = 0.0f;
    
   // //NSLog(@"aa %d",(int)self.data.count);
    
   NSUInteger slicesCount = [self.data count];
   
   for (int i = 0; i < slicesCount; i++)
   {
       sum += [self.data[i][1] doubleValue];
   }
   
   float startAngle = -M_PI_2; // -90
   float endAngle = 0.0f;
      
   for (int i = 0; i < [self.data count]; i++)
   {
      double value = [self.data[i][1] doubleValue];
      UIColor *drawColor = self.data[i][2];
      endAngle = startAngle + M_PI*2*value/sum;
      CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, false);
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
  
    [self drawPieLabel:context];
}

// Radians to degree
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
// Degrees to radians
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

- (void)drawPieLabel:(CGContextRef) context
{
    
    UIColor *whiteColor = [UIColor whiteColor];
    CGFloat radius = self.bounds.size.width/2;
    CGFloat diameter = self.bounds.size.width;
    // text
    
//    NSLog(@"aa %d",(int)self.data.count);
    

    NSUInteger slicesCount = [self.data count];
    double sum = 0.0f;
    CGFloat centerX = radius;
    CGFloat centerY = radius;
    for (int i = 0; i < slicesCount; i++)
    {
        sum += [self.data[i][1] doubleValue];
    }

    float endAngle = 0.0f;
    
    // starting point
    float startAngle = DEGREES_TO_RADIANS(-90);
    for (int i = 0; i < [self.data count]; i++)
    {
        double value = [self.data[i][1] doubleValue];
        double percentage = (value/sum);
        double pieceDegree = percentage * 360;
        double pieceRadian = DEGREES_TO_RADIANS(pieceDegree);
//      endAngle = startAngle + DEGREES_TO_RADIANS(value)/sum;
        CGFloat cx = radius;
        CGFloat cy = radius;

        CGFloat r;
        if (self.isDoughnut) {
            r = radius * 0.75;
        }else{
            r = radius * 0.6;
        }

        
//        NSLog(@"float %f %f %f",startAngle, pieceRadian, pieceRadian-startAngle);
        float targetAngle = startAngle + (pieceRadian/2);
        
        CGFloat x = cx + r * cos(targetAngle);
        CGFloat y = cy + r * sin(targetAngle);
//        NSLog(@"value %f",value);
        
        CGSize size = CGSizeMake(0.40*diameter, 0.30*diameter);
        //// Text 4 Drawing
        CGRect textRect = CGRectMake(x- size.width/2, y - size.height/2, size.width, size.height);
        {
            NSString* textContent;
            if (self.isPercentage) {
                textContent = [NSString stringWithFormat:@"%0.0f%%",(value/sum)*100];
            }else{
                textContent = [NSString stringWithFormat:@"%0.0f",value];
            }

            
            NSMutableParagraphStyle* text4Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            text4Style.alignment = NSTextAlignmentCenter;
            
            NSDictionary* text4FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Avenir-Light" size: 0.055*diameter], NSForegroundColorAttributeName: whiteColor, NSParagraphStyleAttributeName: text4Style};
            CGFloat text4TextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: text4FontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            CGContextClipToRect(context, textRect);
            [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - text4TextHeight) / 2, CGRectGetWidth(textRect), text4TextHeight) withAttributes: text4FontAttributes];
            CGContextRestoreGState(context);
        }
        
        startAngle += pieceRadian;
        
    }
    
}

#pragma mark - touch handler UIView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self showIndicatorForTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self showIndicatorForTouch:[touches anyObject]];
}

- (void)showIndicatorForTouch:(UITouch *)touch {
    
    CGPoint pos = [touch locationInView:self];
    
    for (int i = 0; i < [self.data count]; i++){
        double value = [self.data[i][1] doubleValue];
    }
    
//    NSLog(@"closet %f %f",pos.x, pos.y);
    
}


#pragma mark - UIControl

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}


@end
