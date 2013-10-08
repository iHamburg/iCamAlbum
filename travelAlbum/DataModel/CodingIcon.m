//
//  CodingIcon.m
//  InstaMagazine
//
//  Created by AppDevelopper on 10.11.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "CodingIcon.h"
#import "IconWidget.h"
#import "ImageModelView.h"

@implementation CodingIcon

@synthesize imgName;

- (id)initWithIconWidget:(IconWidget*)view{
	if (self = [super init]) {
		
		// 先把widget的anchorpoint改回0.5,0.5, 不是一定要的
		//		[view resetAnchorPoint];
		
		bounds = view.bounds;
		anchorPoint = view.layer.anchorPoint;
		transform = view.transform;
		center = view.center;
		
		imgName = view.imgName;
		
		
	}
	return self;
	
}


- (void)load{
	keys = [NSMutableArray arrayWithObjects:@"imgName",nil];
	
}

- (void)loadOthers:(NSCoder *)aDecoder withEmptyKeys:(NSArray *)emptyKeys{
	

	bounds = [aDecoder decodeCGRectForKey:@"bounds"];
	transform = [aDecoder decodeCGAffineTransformForKey:@"transform"];
	anchorPoint = [aDecoder decodeCGPointForKey:@"anchorPoint" ];
	center = [aDecoder decodeCGPointForKey:@"center"];
	

}

- (void)saveOthers:(NSCoder *)coder{
	

	[coder encodeCGRect:bounds forKey:@"bounds"];
	[coder encodeCGAffineTransform:transform forKey:@"transform"];
	[coder encodeCGPoint:center forKey:@"center"];

	[coder encodeCGPoint:anchorPoint forKey:@"anchorPoint"];
//    [coder encodeBool:croppedFlag forKey:@"croppedFlag"];
}

- (id)decodedObject{

//	return [[IconWidget alloc]initWithCodingIcon:self];
	return [[ImageModelView alloc]initWithCodingIcon:self];
	
}


@end
