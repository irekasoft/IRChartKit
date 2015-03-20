//
//  IRLineChartView.m
//  IRCharts
//
//  Created by Hijazi on 17/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "IRLineChartView.h"

@implementation IRLineChartView

-(id)initWithFrame:(CGRect)frame data:data
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
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
    self.clipsToBounds = NO;
}


-(void)reloadData
{
    NSAssert(!self.xSteps, @"please define xstep");
    NSAssert(!self.allDataArray, @"please add all data array");
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    
    
    topMargin = 18;
    
    //// Color Declarations
    color = [UIColor colorWithRed: 0.851 green: 0.851 blue: 0.851 alpha: 1];
    color3 = [UIColor colorWithRed: 0.21 green: 0.556 blue: 1 alpha: 1];
    
    x_base = 55; // x starter
    y_base = 18.5;
    
    CGFloat rightMargin = 5;
    
    NSUInteger x_axis = 12;
    

    CGContextRef context = UIGraphicsGetCurrentContext();
    //// x grid
    

    x_gap = (rect.size.width - rightMargin - x_base) / self.xSteps.count;
    CGFloat text_width = self.bounds.size.width / self.xSteps.count;
    
    for (int i = 0; i < self.xSteps.count; i++){
        
        UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
        [bezier5Path moveToPoint: CGPointMake(x_base + (i * x_gap), rect.size.height-y_base)];
        [bezier5Path addLineToPoint: CGPointMake(x_base + (i * x_gap), 0)];
        [color setStroke];
        bezier5Path.lineWidth = 1;
        [bezier5Path stroke];
        
        //// Text Drawing
        
        CGRect textRect = CGRectMake( x_base + (i * x_gap) - text_width/2, rect.size.height-y_base, text_width, 15);
        {
            NSString* textContent =self.xSteps[i];
            NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            textStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 12], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: textStyle};
            
            CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            CGContextClipToRect(context, textRect);
            [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
            CGContextRestoreGState(context);
        }

        
    }
    
    
    
    CGFloat height_y_range = rect.size.height - y_base*2 - topMargin;
    
    NSArray *points = @[@(0),@(0.5),@(1)];

    
    // y grid
    for (int i = 0; i < points.count; i++){
        
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        
        CGFloat y_pos = (height_y_range * [points[i] floatValue]) + topMargin;
        
        [bezier4Path moveToPoint:CGPointMake(x_base, y_pos)];
        [bezier4Path addLineToPoint:CGPointMake(rect.size.width - rightMargin, y_pos)];
        
        [color setStroke];
        bezier4Path.lineWidth = 1;
        [bezier4Path stroke];
        
        //// Text Drawing
        
        CGFloat width = 50;
        CGFloat height = 20;
        CGRect textRect = CGRectMake(x_base-width-10, y_pos-height/2, width, height);
        {
            
            
            NSString* textContent = @"1";
            
            if (i ==0) {
                textContent = [NSString stringWithFormat:@"%.2f",self.yMax];
            }else if (i > 0 && i < points.count - 1){
                
                textContent = [NSString stringWithFormat:@"%.2f",(self.yMax - self.yMin)/2];
            }else if (i == points.count - 1 ){
                textContent = [NSString stringWithFormat:@"%.2f",self.yMin];
            }
            
            NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            textStyle.alignment = NSTextAlignmentRight;
            
            NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 18], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: textStyle};
            
            CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            CGContextClipToRect(context, textRect);
            [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
            CGContextRestoreGState(context);
        }
        
    }

    
    
    //// Base black axis-x/-y
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(x_base, 0)];
    [bezierPath addLineToPoint: CGPointMake(x_base, rect.size.height-y_base)];
    [bezierPath addLineToPoint: CGPointMake( rect.size.width - rightMargin, rect.size.height-y_base)];
    [UIColor.blackColor setStroke];
    bezierPath.lineWidth = 1;
    
    
    [bezierPath stroke];
    
    // stratergy is to analyze all the data.
    
    CGFloat maxVolume;
    CGFloat minVolume;
    CGFloat verticalScale = CGRectGetHeight(rect) / (maxVolume - minVolume);
    CGFloat tradingDayLineSpacing = rint(CGRectGetWidth(rect) / 12.0f);
    
    CGFloat counter = 0.0;
    CGFloat maxY = CGRectGetMaxY(rect);
    
    
    for (NSArray *array in self.allDataArray){
//        NSLog(@"values %@",[[dict allValues] firstObject]);
//        NSLog(@"keys %@",[[dict allKeys] firstObject]);
        NSDictionary *dict = array[0];
        NSArray *data = [[dict allValues] firstObject];
        [self plot:rect data:data color:array[1]];
    }
    
}

static inline UIColor *GetRandomUIColor()
{
    CGFloat r = arc4random() % 255;
    CGFloat g = arc4random() % 255;
    CGFloat b = arc4random() % 255;
    UIColor * color = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1.0f];
    return color;
}

- (void)plot:(CGRect)rect data:(NSArray *)data color:(UIColor *)color_{
    
    // plot the charts
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, topMargin);
    UIBezierPath* bezier11Path = UIBezierPath.bezierPath;
    
    CGFloat height_y_range = rect.size.height - y_base*2 - topMargin;
    
    for (int i = 0; i < data.count; i++){
        
        
        CGFloat y_pos = height_y_range - (height_y_range * [data[i] floatValue]);
        
        if (i == 0) {
            [bezier11Path moveToPoint: CGPointMake(x_base + (i * x_gap), y_pos)];
        }else{
            
            [bezier11Path addLineToPoint: CGPointMake(x_base + (i * x_gap), y_pos)];
        }
        
        [bezier11Path setLineJoinStyle:kCGLineJoinRound];
        [bezier11Path setLineCapStyle:kCGLineCapRound];
        
        
        
    }
    
    [color_ setStroke];
    bezier11Path.lineWidth = 2;
    [bezier11Path stroke];
    
    
    
    for (int i = 0; i < data.count; i++){
        
        
        CGFloat y_pos = height_y_range - (height_y_range * [data[i] floatValue]);
        
        //// Oval 4 Drawing
        CGFloat radius = 4;
        UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(x_base + (i * x_gap)- radius, y_pos - radius, radius * 2, radius *2 )];
        [[UIColor whiteColor] setFill];
        [oval4Path fill];
        [color_ setStroke];
        oval4Path.lineWidth = 2;
        [oval4Path stroke];
        
    }
    
    
    //drawing gets shadowed
    CGContextRestoreGState(ctx);
}

#pragma mark - touch handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
NSLog(@"%s",__PRETTY_FUNCTION__);
    [self showIndicatorForTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
NSLog(@"%s",__PRETTY_FUNCTION__);
    [self showIndicatorForTouch:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
NSLog(@"%s",__PRETTY_FUNCTION__);
    [self hideIndicator];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
NSLog(@"%s",__PRETTY_FUNCTION__);
    [self hideIndicator];
}

#define X_AXIS_SPACE 15
#define PADDING 10

- (void)showIndicatorForTouch:(UITouch *)touch {
    if(! self.infoView) {
        self.infoView = [[IRChartInfoView alloc] init];
        [self addSubview:self.infoView];
    }
    
    CGPoint pos = [touch locationInView:self];
    CGFloat xStart = PADDING + self.yAxisLabelsWidth;
    CGFloat yStart = PADDING;
    CGFloat yRangeLen = self.yMax - self.yMin;
    if(yRangeLen == 0) yRangeLen = 1;
    CGFloat xPos = pos.x - xStart;
    CGFloat yPos = pos.y - yStart;
    CGFloat availableWidth = self.bounds.size.width - 2 * PADDING - self.yAxisLabelsWidth;
    CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE;
//    
//    LCLineChartDataItem *closest = nil;
//    LCLineChartData *closestData = nil;
    
    NSUInteger closestIdx = INT_MAX;
    double minDist = DBL_MAX;
    double minDistY = DBL_MAX;
    CGPoint closestPos = CGPointZero;
    
    
  
    
    
    self.infoView.infoLabel.text = @"test";
    self.infoView.tapPoint = closestPos;
    [self.infoView sizeToFit];
    [self.infoView setNeedsLayout];
    [self.infoView setNeedsDisplay];
    
    if(self.currentPosView.alpha == 0.0) {
        CGRect r = self.currentPosView.frame;
        r.origin.x = closestPos.x + 3 - 1;
        self.currentPosView.frame = r;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        self.infoView.alpha = 1.0;
        self.currentPosView.alpha = 1.0;
        self.xAxisLabel.alpha = 1.0;
        
        CGRect r = self.currentPosView.frame;
        r.origin.x = closestPos.x + 3 - 1;
        self.currentPosView.frame = r;
        
        self.xAxisLabel.text = @"hello";
        if(self.xAxisLabel.text != nil) {
            [self.xAxisLabel sizeToFit];
            r = self.xAxisLabel.frame;
            r.origin.x = round(closestPos.x - r.size.width / 2);
            self.xAxisLabel.frame = r;
        }
    }];
    
    if(self.selectedItemCallback != nil) {
        self.selectedItemCallback();
    }
}

- (void)hideIndicator {
    if(self.deselectedItemCallback)
        self.deselectedItemCallback();
    
    
    [UIView animateWithDuration:0.1 animations:^{
        self.infoView.alpha = 0.0;
        self.currentPosView.alpha = 0.0;
        self.xAxisLabel.alpha = 0.0;
    }];
}

#pragma mark - get set

// TODO: This should really be a cached value. Invalidated iff ySteps changes.
- (CGFloat)yAxisLabelsWidth {
    double maxV = 0;
    for(NSString *label in self.ySteps) {
        CGSize labelSize = [label sizeWithFont:self.scaleFont];
        if(labelSize.width > maxV) maxV = labelSize.width;
    }
    return maxV + PADDING;
}


- (void)setAllDataArray:(NSArray *)allDataArray{
    

    NSMutableArray *bigArray = [NSMutableArray array];
    
    
    
    for (NSArray *array in allDataArray){
        
        NSDictionary *dict = array[0];
        NSLog(@"data %@",[[dict allValues] firstObject]);
        NSArray *data = [[dict allValues] firstObject];
        
        [bigArray addObjectsFromArray:data];

    }
    
    __block float ymax = -MAXFLOAT;
    __block float ymin = MAXFLOAT;
    [bigArray enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL *stop) {
        float y = num.floatValue;
        if (y < ymin) ymin = y;
        if (y > ymax) ymax = y;
    }];
    
    NSLog(@"xmax %f xmin %f",ymax, ymin);
    _yMin = ymin;
    _yMax = ymax;
    _allDataArray = allDataArray;
    
}

@end
