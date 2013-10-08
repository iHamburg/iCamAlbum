//
//  CodingText.m
//  InstaMagazine
//
//  Created by AppDevelopper on 29.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "CodingText.h"
#import "TextWidget.h"
#import "LabelModelView.h"
@implementation CodingText

@synthesize text,fontColor,fontName,backgroundColor,strokeColor;
@synthesize  fontSize,fontSizeFaktor,textAlignment, bgAlpha;

- (id)initWithTextWidget:(TextWidget*)view{
	if (self = [super init]) {

		bounds = view.bounds;
		anchorPoint = view.layer.anchorPoint;
		transform = view.transform;
		center = view.center;
		
		
		text = view.text;
		fontColor = view.textColor;
		fontSize = view.font.pointSize;
		fontSizeFaktor = view.fontSizeFaktor;
		fontName = view.fontName;
		textAlignment = view.textAlignment;
		backgroundColor = view.bgColor;
		bgAlpha = view.bgAlpha;
		strokeColor = view.strokeColor;
		
	}
	return self;
}


- (void)load{
	keys = [NSMutableArray arrayWithObjects:@"text",@"fontColor",@"fontName",@"backgroundColor",@"strokeColor",nil];
	
}

- (void)loadOthers:(NSCoder *)aDecoder withEmptyKeys:(NSArray *)emptyKeys{
	
	
	bounds = [aDecoder decodeCGRectForKey:@"bounds"];
	transform = [aDecoder decodeCGAffineTransformForKey:@"transform"];
	anchorPoint = [aDecoder decodeCGPointForKey:@"anchorPoint" ];
	center = [aDecoder decodeCGPointForKey:@"center"];
	
	fontSize = [aDecoder decodeFloatForKey:@"fontSize"];
	textAlignment = [aDecoder decodeIntForKey:@"textAlignment"];

	bgAlpha = [aDecoder decodeFloatForKey:@"bgAlpha"];
	if ([aDecoder decodeFloatForKey:@"fontSizeFaktor"]> DBL_MAX) {
		NSLog(@"fontSizeFatkor is inf");
	}else{
		fontSizeFaktor = [aDecoder decodeFloatForKey:@"fontSizeFaktor"];
	}
	
}

- (void)saveOthers:(NSCoder *)coder{
	
	
	[coder encodeCGRect:bounds forKey:@"bounds"];
	[coder encodeCGAffineTransform:transform forKey:@"transform"];
	[coder encodeCGPoint:center forKey:@"center"];
	[coder encodeCGPoint:anchorPoint forKey:@"anchorPoint"];
	
	[coder encodeFloat:fontSize forKey:@"fontSize"];
	[coder encodeInt:textAlignment forKey:@"textAlignment"];
	[coder encodeFloat:bgAlpha forKey:@"bgAlpha"];
	
	if (fontSizeFaktor>DBL_MAX) {
		NSLog(@"fontSizeFatkor is inf");
	}else{
		[coder encodeFloat:fontSizeFaktor forKey:@"fontSizeFaktor"];
	}
	
	
}
//
- (id)decodedObject{

//	return [[TextWidget alloc]initWithCodingText:self];
	
	return [[LabelModelView alloc]initWithCodingLabel:self];
	
}

@end
