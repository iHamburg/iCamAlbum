//
//  IconWidget.m
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 28.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "IconWidget.h"
#import "Sticker.h"
#import "CodingIcon.h"

@implementation IconWidget

@synthesize imgName,menuItems;


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self load];
    }
    return self;
}



- (id)initWithSticker:(Sticker*)sticker{
	imgName = sticker.imgName;
	UIImage *img = [UIImage imageWithSystemName:imgName];
    CGSize size = img.size;

    if (self = [self initWithFrame:CGRectMake(0, 0, size.width/2, size.height/2)]) {
        self.image = img;
    }
	return self;
}

- (id)initWithCodingIcon:(CodingIcon*)v{
//	L();
	if (self = [self initWithFrame:v.bounds]) {

		self.transform = v.transform;
		self.center = v.center;
	
		self.imgName = v.imgName;
		self.image = [UIImage imageWithSystemName:self.imgName];
	}
	return self;

}


- (void)load{
//	L();

	self.userInteractionEnabled = YES;

	
	self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowOffset = CGSizeMake(1, 1);

	self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
}


- (id)copyWithZone:(NSZone *)zone{
	L();
	
	
	IconWidget *copy = [[IconWidget alloc]initWithFrame:self.bounds];
	copy.imgName = self.imgName;
	[copy loadImage];
	copy.layer.anchorPoint = self.layer.anchorPoint;
    copy.transform = self.transform;
    copy.center = self.center;

	return copy;
}


#pragma mark - Widget
- (id)encodedObject{
	
	if (self.superview) {
		[self resetAnchorPoint];

	}
	return [[CodingIcon alloc]initWithIconWidget:self];
	
}

- (void)loadImage{
	
	self.image = [UIImage imageWithSystemName:imgName];
	
}

- (NSArray*)menuItems{
	
//	if (widgetComp.lockFlag) {
//		menuItems = @[[WidgetComponent unlockItem]];
//	}
//	else{
//		menuItems = @[[WidgetComponent lockItem]];
//	}
	return menuItems;
	
}

- (void)setLockFlag:(BOOL)_lockFlag{
//	widgetComp.lockFlag = _lockFlag;
	
}
- (BOOL)lockFlag{
	
//	return widgetComp.lockFlag;
	return YES;
}

- (void)handleEdit{
	
}

@end
