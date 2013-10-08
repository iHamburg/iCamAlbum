//
//  PathImageView.m
//  CropImageTest
//
//  Created by  on 02.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "PathImageView.h"
#import "ViewController.h"
#import "UIBezierPath+Extras.h"

@interface PathImageView()

@end

@implementation PathImageView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		imgV = [[UIImageView alloc]initWithFrame:self.bounds];
		
		self.userInteractionEnabled = YES;
		
		[self addSubview:imgV];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

	
	if([_delegate respondsToSelector:@selector(pathImageViewDidBeginDraw:)])
		[_delegate pathImageViewDidBeginDraw:self];
	
	imgV.image = nil;

	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	newPath = [UIBezierPath bezierPath];
	newPath.lineWidth = 5;
	
	[newPath moveToPoint:point];
	lastPoint = point;
	firstPoint = point;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	 currentPoint = [touch locationInView:self];
	[newPath addLineToPoint:currentPoint];

	UIGraphicsBeginImageContext(self.frame.size);

	[[UIColor redColor] set];
	[newPath stroke];
	
	imgV.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
   
	
	lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	[newPath addLineToPoint:point];
	[newPath addLineToPoint:firstPoint];
	
	newPath = [newPath smoothedPathWithGranularity:8];

	imgV.image = nil;
	UIGraphicsBeginImageContext(self.frame.size);

	[[UIColor redColor]set];
	[newPath stroke];
	
	imgV.image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
    CGSize size = newPath.bounds.size;
	
	/// 防止画出直线，没有mask
	if (size.width*size.height>1) {
//		  [parent applyCropWithPath:newPath];
		if ([_delegate respondsToSelector:@selector(pathImageView:didFinishDrawWithPath:)]) {
			[_delegate pathImageView:self didFinishDrawWithPath:newPath];
		}
	}
	else{
		NSLog(@"maskpath zero");
	}
  

}


@end
