//
//  IRLagendView.m
//  IRCharts
//
//  Created by Hijazi on 9/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "IRLegendView.h"

@implementation IRLegendView

- (void)loadExampleData{
    self.data = @[@[@"asdf",@(12)],
                  @[@"asdf",@(12)],
                  @[@"asdf",@(12)],
                  @[@"asdf",@(12)],
                  @[@"asdf",@(12)],
                  @[@"asdf",@(12)],
                  @[@"asdf",@(12)],
                  @[@"asdf",@(12)],
                  @[@"asdf",@(12)]];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    NSUInteger column = 2;
    if (self.column) {
        column = self.column;
    }
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat y_gap = rect.size.width/(float)column;

    
    
    
    NSUInteger row      = [self.data count] / column;
    NSUInteger last_row = [self.data count] % column;
    
    int count = 0;
    for (int i = 0; i <= row; i++) {
        for (int j = 0; j < column; j++) {
            
            UIColor *boxColor = [UIColor clearColor];
            NSString *text = @"";
            
            // only for 2 column case
            if ((i < row) || (i == row && j < last_row)){
                
            if (self.dataType == IRLegendViewDataPieChart) {
                boxColor = self.data[count][2];
                text = self.data[count][0];
            }else if(self.dataType == IRLegendViewDataLineChart){
                
//                NSLog(@"self.data %@",self.data);
                boxColor = self.data[count][1];
                text = [[self.data[count][0] allKeys] firstObject];

            }
            
            //// Rectangle Drawing
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(13 + (y_gap * j), 10 + (20* i), 14, 15)];
            [boxColor setFill];
            [rectanglePath fill];
            
            //// Text Drawing
            CGRect textRect = CGRectMake(33 + (y_gap * j), 10 + (20* i), 116, 15);
            {
                NSString* textContent;
                
                if (text) {
                    
                    textContent = text;
                }
                
                NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
                textStyle.alignment = NSTextAlignmentLeft;
                
                NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 12], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: textStyle};
                
                CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
                CGContextSaveGState(context);
                CGContextClipToRect(context, textRect);
                [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
                CGContextRestoreGState(context);
            }
            count++;
            }
        }
    }
 
}


@end
