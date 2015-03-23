//
//  IRColor.m
//  IRPieChart
//
//  Created by Muhammad Hijazi on 11/02/01.
//  Copyright 2011 hijazi.org. All rights reserved.
//

#import "IRColor.h"

@implementation UIColor (IRColor)

+ (UIColor *)getColorByNumber:(int)number{

	if (number > 14) {
		number = number % 15;
	}
	

	switch (number) {
		case 0:
			return [UIColor blackColor];
			break;
		case 1:
			return [UIColor darkGrayColor];
			break;
		case 2:
			return [UIColor lightGrayColor];			
			break;
		case 3:
			return [UIColor grayColor];
			break;
		case 4:
			return [UIColor redColor];			
			break;
		case 5:
			return [UIColor greenColor];			
			break;
		case 6:
			return [UIColor blueColor];			
			break;			
		case 7:
			return [UIColor blackColor];
			break;
		case 8:
			return [UIColor cyanColor];
			break;
		case 9:
			return [UIColor yellowColor];			
			break;
		case 10:
			return [UIColor redColor];
			break;
		case 11:
			return [UIColor magentaColor];			
			break;
		case 12:
			return [UIColor orangeColor];			
			break;
		case 13:
			return [UIColor purpleColor];			
			break;			
		case 14:
			return [UIColor brownColor];			
			break;
		default:
			return [UIColor whiteColor];	
			break;
	}
	return nil;
}


@end


