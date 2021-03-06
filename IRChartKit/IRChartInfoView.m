//
//  IRChartInfoView.m
//  IRCharts
//
//  Created by Hijazi on 21/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "IRChartInfoView.h"

@interface IRChartInfoView (private)

- (void)recalculateFrame;

@end

@implementation IRChartInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        UIFont *fatFont = [UIFont boldSystemFontOfSize:12];
        
        self.infoLabel = [[UILabel alloc] init];
        self.infoLabel.font = fatFont;
        self.infoLabel.backgroundColor = [UIColor clearColor]; self.infoLabel.textColor = [UIColor whiteColor];
        self.infoLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        self.infoLabel.shadowColor = [UIColor blackColor];
        self.infoLabel.shadowOffset = CGSizeMake(0, -1);
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.infoLabel];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)init {
    if((self = [self initWithFrame:CGRectZero])) {
        ;
    }
    return self;
}


#define TOP_BOTTOM_MARGIN 5
#define LEFT_RIGHT_MARGIN 15
#define SHADOWSIZE 3
#define SHADOWBLUR 5
#define HOOK_SIZE 8


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self sizeToFit];
    
    [self recalculateFrame];
    
    [self.infoLabel sizeToFit];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.frame = CGRectMake(self.bounds.origin.x + 7, self.bounds.origin.y + 2, 40, self.infoLabel.frame.size.height);
}

- (CGSize)sizeThatFits:(CGSize)size {
    // TODO: replace with new text APIs in iOS 7 only version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize s = [self.infoLabel.text sizeWithFont:self.infoLabel.font];
#pragma clang diagnostic pop
    s.height += 15;
    s.height += SHADOWSIZE;
    
    s.width += 2 * SHADOWSIZE + 7;
    s.width = MAX(s.width, HOOK_SIZE * 2 + 2 * SHADOWSIZE + 10);
    
    return s;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGRect theRect = self.bounds;
    theRect.size.height -= SHADOWSIZE * 2;
    theRect.origin.x += SHADOWSIZE;
    theRect.size.width -= SHADOWSIZE * 2;
    theRect.size.height -= SHADOWSIZE * 2;
    
    [[UIColor colorWithWhite:0.0 alpha:1.0] set];
    CGContextSetAlpha(c, 0.7);
    
    CGContextSaveGState(c);
    
    CGContextSetShadow(c, CGSizeMake(0.0, SHADOWSIZE), SHADOWBLUR);
    
    CGContextBeginPath(c);
    CGContextAddRoundedRectWithHookSimple(c, theRect, 7);
    CGContextFillPath(c);
    
}



#define MAX_WIDTH 50
// calculate own frame to fit within parent frame and be large enough to hold the event.
- (void)recalculateFrame {
    CGRect theFrame = self.frame;
    theFrame.size.width = MAX(MAX_WIDTH, theFrame.size.width);
    
    CGRect theRect = self.frame; theRect.origin = CGPointZero;
    
    {
        theFrame.origin.y = self.tapPoint.y - theFrame.size.height + 2 * SHADOWSIZE + 1;
        theFrame.origin.x = round(self.tapPoint.x - ((theFrame.size.width - 2 * SHADOWSIZE)) / 2.0);
    }
    self.frame = theFrame;
}

#pragma mark - helpers


void CGContextAddRoundedRectWithHookSimple(CGContextRef c, CGRect rect, CGFloat radius) {
    //eventRect must be relative to rect.
    CGFloat hookSize = HOOK_SIZE;
    CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + radius, radius, M_PI, M_PI * 1.5, 0); //upper left corner
    CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, M_PI * 1.5, M_PI * 2, 0); //upper right corner
    CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI * 2, M_PI * 0.5, 0);
    {
        CGContextAddLineToPoint(c, rect.origin.x + rect.size.width / 2 + hookSize, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(c, rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height + hookSize);
        CGContextAddLineToPoint(c, rect.origin.x + rect.size.width / 2 - hookSize, rect.origin.y + rect.size.height);
    }
    CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI * 0.5, M_PI, 0);
    CGContextAddLineToPoint(c, rect.origin.x, rect.origin.y + radius);
}

void CGContextFillRoundedRect(CGContextRef c, CGRect rect, CGFloat radius) {
    CGContextBeginPath(c);
    CGContextAddRoundedRect(c, rect, radius);
    CGContextFillPath(c);
}

void CGContextAddRoundedRect(CGContextRef c, CGRect rect, CGFloat radius) {
    if(2 * radius > rect.size.height) radius = rect.size.height / 2.0;
    if(2 * radius > rect.size.width) radius = rect.size.width / 2.0;
    CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + radius, radius, M_PI, M_PI * 1.5, 0);
    CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, M_PI * 1.5, M_PI * 2, 0);
    CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI * 2, M_PI * 0.5, 0);
    CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI * 0.5, M_PI, 0);
    CGContextAddLineToPoint(c, rect.origin.x, rect.origin.y + radius);
}

@end
