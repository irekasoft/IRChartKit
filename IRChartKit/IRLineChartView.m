//
//  IRLineChartView.m
//  IRCharts
//
//  Created by Hijazi on 17/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "IRLineChartView.h"

@implementation IRLineChartView


#define BOTTOM 15
#define X_AXIS_SPACE 15
#define PADDING 10
#define TOP_MARGIN 18
#define X_BASE 55
#define Y_BASE 18.5


- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self setup];
        [self reloadData];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
    [self reloadData];
}


- (void)setup
{

    //initialization
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;

    //
    // VERTICAL LINE
    self.verticalCurrentPosLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1 / self.contentScaleFactor, CGRectGetHeight(self.bounds)-BOTTOM*2.5)];
    self.verticalCurrentPosLine.backgroundColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
    self.verticalCurrentPosLine.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.verticalCurrentPosLine.alpha = 0.0;
    [self addSubview:self.verticalCurrentPosLine];
    

    // HORIZONTAL LINE
    self.horizontalCurrentPosLine = [[UIView alloc] initWithFrame:CGRectMake(X_BASE, 0,CGRectGetWidth(self.bounds)-X_BASE, 1 / self.contentScaleFactor)];
    self.horizontalCurrentPosLine.backgroundColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
    self.horizontalCurrentPosLine.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.horizontalCurrentPosLine.alpha = 0.0;
    [self addSubview:self.horizontalCurrentPosLine];
    

    
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

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    color  = [UIColor colorWithRed: 0.851 green: 0.851 blue: 0.851 alpha: 1];
    color3 = [UIColor colorWithRed: 0.21 green: 0.556 blue: 1 alpha: 1];
    
    CGFloat rightMargin = 5;

    //// horizontal grid
    x_gap = (rect.size.width - rightMargin - X_BASE) / self.xSteps.count;
    CGFloat text_width = self.bounds.size.width / self.xSteps.count;
    
    for (int i = 0; i < self.xSteps.count; i++){
        
        UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
        [bezier5Path moveToPoint: CGPointMake(X_BASE + (i * x_gap), rect.size.height-Y_BASE*2)];
        [bezier5Path addLineToPoint: CGPointMake(X_BASE + (i * x_gap), 0)];
        [color setStroke];
        bezier5Path.lineWidth = 1;
        [bezier5Path stroke];
        
        //// 1, 2, 3, xSteps
        CGRect textRect = CGRectMake( X_BASE + (i * x_gap) - text_width/2, rect.size.height-Y_BASE-BOTTOM, text_width, BOTTOM);
        {
            NSString* textContent =self.xSteps[i];
//            NSLog(@"text %@",textContent);
            NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            textStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: textStyle};
            
            CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            CGContextClipToRect(context, textRect);
            [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
            CGContextRestoreGState(context);
        }
    }

    
    CGFloat height_y_range = rect.size.height - Y_BASE*2 - TOP_MARGIN;

    // xpoints
    // should be flexible at some times.
    NSArray *points;

    if (self.yStepNumber){
        NSMutableArray *tempArray = [NSMutableArray array];
        CGFloat yGap = 1.0/(float)self.yStepNumber;
        for (int i = 0; i < self.yStepNumber; i++) {
            [tempArray addObject:@(yGap*i)];
        }
        
        points = tempArray;
    }else{
        NSMutableArray *tempArray = [NSMutableArray array];
        CGFloat yGap = 1.0/5.0;
        for (int i = 0; i < 5; i++) {
            [tempArray addObject:@(yGap*i)];
        }
        
        points = tempArray;
    }
    // vertical axis
    for (int i = 0; i <= points.count; i++){
        
        NSString* textContent = @"-";
        
        UIBezierPath* verticalPath = UIBezierPath.bezierPath;
        
        CGFloat y_pos;
        if (i == points.count){
            
            y_pos = (height_y_range ) + TOP_MARGIN;
            
        }else{
            y_pos = (height_y_range * [points[i] floatValue]) + TOP_MARGIN;
        }

        [verticalPath moveToPoint:CGPointMake(X_BASE, y_pos)];
        [verticalPath addLineToPoint:CGPointMake(rect.size.width - rightMargin, y_pos)];
        [color setStroke];
        verticalPath.lineWidth = 1;
        [verticalPath stroke];
        
        // Text Drawing
        // Text Size
        CGFloat width = 50;
        CGFloat height = 20;
        CGRect textRect = CGRectMake(X_BASE-width-10, y_pos-height/2, width, height);
        {

            NSString* textContent = @"-";
            
            if (i == 0) {
                textContent = [NSString stringWithFormat:@"%.0f",self.yMax];
            }else if (i > 0 && i < points.count){
                
                textContent = [NSString stringWithFormat:@"%.0f",self.yMin + (self.yMax - self.yMin)*[points[points.count - i] floatValue]];
            }else if (i == points.count){
                textContent = [NSString stringWithFormat:@"%.0f",self.yMin];
            }
            
            NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            textStyle.alignment = NSTextAlignmentRight;
            
            NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light" size:13], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: textStyle};
            
            CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            CGContextClipToRect(context, textRect);
            [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
            CGContextRestoreGState(context);
        }
        
    }

    //
    // black grid
    //// Base black axis-x/-y
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(X_BASE, 0)];
    [bezierPath addLineToPoint: CGPointMake(X_BASE, CGRectGetHeight(rect)-Y_BASE*2)];
    [bezierPath addLineToPoint: CGPointMake( rect.size.width - rightMargin, rect.size.height-Y_BASE*2)];
    [UIColor.blackColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
    // stratergy is to analyze all the data.
//    CGFloat maxVolume;
//    CGFloat minVolume;
//    CGFloat verticalScale = CGRectGetHeight(rect) / (maxVolume - minVolume);
//    CGFloat tradingDayLineSpacing = rint(CGRectGetWidth(rect) / 12.0f);
//    
//    CGFloat counter = 0.0;
//    CGFloat maxY = CGRectGetMaxY(rect);
    
    // This is the point where we want to plot
    // the graph
    for (NSArray *array in self.allDataArray){
        NSDictionary *dict = array[0];
        NSArray *data = [[dict allValues] firstObject];
        [self plot:rect data:data color:array[1]];
    }
 
    if (self.yAxisName) {
        
    
    
    //// Text 3 Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, X_BASE*0.7, (CGRectGetHeight(rect)-Y_BASE*2)/2);
    CGContextRotateCTM(context, -90 * M_PI / 180);
    CGRect text3Rect = CGRectMake(-(CGRectGetHeight(rect)-Y_BASE*2)/2, -X_BASE,CGRectGetHeight(rect)-Y_BASE*2, X_BASE);
    
    {
        NSString* textContent = self.yAxisName;
        NSMutableParagraphStyle* text3Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text3Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text3FontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: text3Style};
        
        CGFloat text3TextHeight = [textContent boundingRectWithSize: CGSizeMake(text3Rect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: text3FontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, text3Rect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(text3Rect), CGRectGetMinY(text3Rect) + (CGRectGetHeight(text3Rect) - text3TextHeight) / 2, CGRectGetWidth(text3Rect), text3TextHeight) withAttributes: text3FontAttributes];
        CGContextRestoreGState(context);
    }
    
    
    CGContextRestoreGState(context);
    }
}


- (void)plot:(CGRect)rect data:(NSArray *)data color:(UIColor *)color_{
    
    // plot the charts
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, TOP_MARGIN);
    UIBezierPath* bezier11Path = UIBezierPath.bezierPath;
    
    CGFloat height_y_range = rect.size.height - Y_BASE*2 - TOP_MARGIN;
    
    CGFloat range = self.yMax - self.yMin;
    
    for (int i = 0; i < data.count; i++){
        
        CGFloat percentage = ([data[i] floatValue] - self.yMin) / range;

        CGFloat y_pos = height_y_range - (height_y_range * percentage);
        
        if (i == 0) {
            [bezier11Path moveToPoint: CGPointMake(X_BASE + (i * x_gap), y_pos)];
        }else{
            
            [bezier11Path addLineToPoint: CGPointMake(X_BASE + (i * x_gap), y_pos)];
        }
        
        [bezier11Path setLineJoinStyle:kCGLineJoinRound];
        [bezier11Path setLineCapStyle:kCGLineCapRound];

        
    }
    
    [color_ setStroke];
    bezier11Path.lineWidth = 2;
    [bezier11Path stroke];
    
    
    if (self.hasDot) {
        // make the 'o' mark for each point.
        for (int i = 0; i < data.count; i++){
            
            CGFloat percentage = ([data[i] floatValue] - self.yMin) / range;
            CGFloat y_pos = height_y_range - (height_y_range * percentage);
            
            //// Oval 4 Drawing
            CGFloat radius = 4;
            UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(X_BASE + (i * x_gap)- radius, y_pos - radius, radius * 2, radius *2 )];
            [[UIColor whiteColor] setFill];
            [oval4Path fill];
            [color_ setStroke];
            oval4Path.lineWidth = 2;
            [oval4Path stroke];
            
        }
    }
    
    
    
    
    //drawing gets shadowed
    CGContextRestoreGState(ctx);
}

#pragma mark - touch handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.enabledFeedback) return;
    
    [self showIndicatorForTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.enabledFeedback) return;
    
    [self showIndicatorForTouch:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.enabledFeedback) return;
    [self hideIndicatorForTouch:[touches anyObject]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.enabledFeedback) return;
    [self hideIndicatorForTouch:[touches anyObject]];
}



#pragma mark - indicator

//here is the indicator the red line
- (void)showIndicatorForTouch:(UITouch *)touch {
    CGPoint pos = [touch locationInView:self];

    if(! self.infoView) {
        self.infoView = [[IRChartInfoView alloc] init];
        [self addSubview:self.infoView];
    }

    CGFloat yRangeLen = self.yMax - self.yMin;
    if (yRangeLen == 0) yRangeLen = 1;
    CGFloat xPos = pos.x;
    CGFloat yPos = pos.y - 44;

    CGPoint closestPos = CGPointZero;
    
    // we want to find the closest point that near to the finger.
    // the positioning is exactly the same
    // with how them are plotted
    
    CGFloat closestX = 0;
    CGFloat closestY = 0;
    NSString *text;
    for (NSArray *array in self.allDataArray){
        NSDictionary *dict = array[0];
        NSArray *data = [[dict allValues] firstObject];
        
        CGFloat height_y_range = self.bounds.size.height - Y_BASE*2 - TOP_MARGIN;
        CGFloat range = self.yMax - self.yMin;
        for (int i = 0; i < data.count; i++){

            
            
            // differenct of x touch position
            CGFloat x = X_BASE + (i * x_gap);
            CGFloat xDifferent = fabs(pos.x -x);
//            NSLog(@"x pos %f",fabs(pos.x -x));
            
            if (closestX > xDifferent || closestX == 0) {
                closestX = xDifferent;
                closestPos = CGPointMake(x, 0);
                text = [NSString stringWithFormat:@"%.1f",[data[i] floatValue]];
            }
            
            // different of y touch position
            CGFloat percentage = ([data[i] floatValue] - self.yMin) / range;
            CGFloat y = height_y_range - (height_y_range * percentage);
            CGFloat yDifferent = fabs(pos.y - y);
//            NSLog(@"y dif %f",yDifferent);
            
            if (closestY > yDifferent || closestY == 0) {
                closestY = yDifferent;
                closestPos = CGPointMake(closestPos.x, y);
                text = [NSString stringWithFormat:@"%.1f",[data[i] floatValue]];
            }
            
            
        }
    }

//    NSLog(@"closet %f",closestY);
    
    
    [UIView animateWithDuration:0.1 animations:^{

        // black info
        self.infoView.alpha = 1.0;
        
        // vertical line
        self.verticalCurrentPosLine.alpha = 1.0;
        CGRect r = self.verticalCurrentPosLine.frame;
        r.origin.x = closestPos.x;
        self.verticalCurrentPosLine.frame = r;

        // horizontal line
        self.horizontalCurrentPosLine.alpha = 1.0;
        r = self.horizontalCurrentPosLine.frame;
        r.origin.y = pos.y;
        self.horizontalCurrentPosLine.frame = r;
        
    }];

//    NSLog(@"currentPosView %@",NSStringFromCGRect(self.verticalCurrentPosLine.frame));
//    NSLog(@"pos %@",NSStringFromCGPoint(pos));
    
    self.infoView.center = CGPointMake(closestPos.x, yPos);
    self.infoView.infoLabel.text = text;
    self.infoView.tapPoint = closestPos;
    
    if(self.selectedItemCallback) {
        self.selectedItemCallback();
    }
}

- (void)hideIndicatorForTouch:(UITouch *)touch {
    if(self.deselectedItemCallback)
        self.deselectedItemCallback();
    
    self.selectedData = nil;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.infoView.alpha = 0.0;
        self.verticalCurrentPosLine.alpha = 0.0;
        self.horizontalCurrentPosLine.alpha = 0.0;

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
        //NSLog(@"data %@",[[dict allValues] firstObject]);
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
    
//    NSLog(@"xmax %f xmin %f",ymax, ymin);
    _yMin = ymin;
    _yMax = ymax;
    _allDataArray = allDataArray;
    
}

#pragma mark - helper


@end