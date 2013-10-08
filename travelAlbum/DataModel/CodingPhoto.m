//
//  CodingPhoto.m
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 24.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "CodingPhoto.h"
#import "PhotoWidget.h"
#import "IconWidget.h"
#import "ImageModelView.h"

@implementation CodingPhoto

@synthesize imgName, borderColor;
@synthesize borderWidth,croppedFlag;


//init
- (id)initWithPhotoWidget:(PhotoWidget*)view{
	if (self = [super init]) {

		bounds = view.bounds;
		anchorPoint = view.layer.anchorPoint;
		transform = view.transform;
		center = view.center;
		imgName = view.imgName;
		
		borderColor = [UIColor colorWithCGColor:view.layer.borderColor];
		borderWidth = view.layer.borderWidth;
        croppedFlag = view.croppedFlag;
	}
	return self;
}


- (void)load{
	keys = [NSMutableArray arrayWithObjects:@"imgName",@"borderColor",nil];
	
}

- (void)loadOthers:(NSCoder *)aDecoder withEmptyKeys:(NSArray *)emptyKeys{
	
	bounds = [aDecoder decodeCGRectForKey:@"bounds"];
	transform = [aDecoder decodeCGAffineTransformForKey:@"transform"];
	anchorPoint = [aDecoder decodeCGPointForKey:@"anchorPoint" ];
	center = [aDecoder decodeCGPointForKey:@"center"];
	borderWidth = [aDecoder decodeFloatForKey:@"borderWidth"];
    croppedFlag = [aDecoder decodeBoolForKey:@"croppedFlag"];
}

- (void)saveOthers:(NSCoder *)coder{
	
//	[coder encodeInt:type forKey:@"type"];
	[coder encodeCGRect:bounds forKey:@"bounds"];
	[coder encodeCGAffineTransform:transform forKey:@"transform"];
	[coder encodeCGPoint:center forKey:@"center"];
	[coder encodeFloat:borderWidth forKey:@"borderWidth"];
	[coder encodeCGPoint:anchorPoint forKey:@"anchorPoint"];
    [coder encodeBool:croppedFlag forKey:@"croppedFlag"];
}

- (id)decodedObject{

	return [[ImageModelView alloc]initWithCodingPhoto:self];
}

@end
