//
//  NewsQuadView.m
//  MusterProject
//
//  Created by AppDevelopper on 26.06.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import "NewsQuadView.h"

@implementation NewsQuadView

@synthesize textLabel,detailTextLabel,imgV;

/****
 
 iphone: 145 x 145
 下方145x90的黑色半透明mask
 
 
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
		imgV = [[UIImageView alloc]initWithFrame:self.bounds];
        imgV.image = kPlaceholderImage;
		
		UIView *subMaskV = [[UIView alloc]initWithFrame:CGRectMake(0, (90.0/145.0)*self.height, self.width, (55.0/145.0)* self.height )];
		subMaskV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
		
		textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(subMaskV.frame), self.width, subMaskV.height*2/3)];
		textLabel.text = @"TextLabel";
		textLabel.textColor = [UIColor whiteColor];
		textLabel.backgroundColor = [UIColor clearColor];
		
		detailTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textLabel.frame),self.width, self.height - CGRectGetMaxY(textLabel.frame))];
		detailTextLabel.text = @"DetailText";
		detailTextLabel.backgroundColor = [UIColor clearColor];
		detailTextLabel.textColor = [UIColor whiteColor];
		
		[self addSubview:imgV];
		[self addSubview:subMaskV];
		[self addSubview:textLabel];
		[self addSubview:detailTextLabel];
    }
    return self;
}

@end
