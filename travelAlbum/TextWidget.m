//
//  TextWidget.m
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 24.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "TextWidget.h"
#import "CodingText.h"
//#import "SpriteManager.h"

#define kTextFontOriginalSize 30
#define kTextFontOriginalName @"Chalkboard SE"

@implementation TextWidget

@synthesize fontSizeFaktor,fontName,bgAlpha, bgColor,strokeColor;
@synthesize menuItems;

- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		[self firstLoad];
		[self load];
	}
	return self;
}

- (void)firstLoad{
	self.font = [UIFont fontWithName:kTextFontOriginalName size:kTextFontOriginalSize];
	self.textColor = kColorDarkGreen;
	self.fontName = kTextFontOriginalName;
	bgColor = [UIColor blackColor];
	strokeColor = [UIColor whiteColor];
	bgAlpha = 0.3;
	fontSizeFaktor = self.font.pointSize/self.bounds.size.width;
	
}



- (id)initWithCodingText:(CodingText*)v{

	if (self = [super initWithFrame:v.bounds]) {

		[self load];
		
		self.layer.anchorPoint = v.anchorPoint;
		self.transform = v.transform;
		self.center = v.center;

		self.text = v.text;
		self.textColor = v.fontColor;
		self.textAlignment = v.textAlignment;		
		self.font = [UIFont fontWithName:v.fontName size:v.fontSize];

		fontSizeFaktor = v.fontSizeFaktor;
		fontName = v.fontName;

		bgAlpha = v.bgAlpha;
		bgColor = v.backgroundColor;
		strokeColor = v.strokeColor;
	}
	return self;
}

- (void)load{
	
	self.userInteractionEnabled = YES;
	self.backgroundColor = [UIColor clearColor];
	self.numberOfLines = 0;
	
	
	
	if (!fontName) {
		fontName = kTextFontOriginalName;
	}
	
}

#pragma mark - Widget, save
- (id)encodedObject{

	// 保存前
	if (self.superview) {
		[self resetAnchorPoint];

	}
	return [[CodingText alloc]initWithTextWidget:self];
}

- (NSArray*)menuItems{
	
//	if (widgetComp.lockFlag) {
//		menuItems = @[[WidgetComponent unlockItem],[WidgetComponent editItem]];
//	}
//	else{
//		menuItems = @[[WidgetComponent lockItem],[WidgetComponent editItem]];
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
	[[NSNotificationCenter defaultCenter]postNotificationName:NotificationEditLabelModelView object:self];
}


#pragma mark - Adjust



/**
 scale 变形 bounds
 */
- (void)applyScale:(float)scale{
	
	CGSize size = self.bounds.size;
	
	self.bounds = CGRectMake(0, 0, size.width*scale, size.height*scale);
	
	[self adjustFontSize];
}

// 在scale 的时候会调用，
- (void)adjustFontSize{
	
	float aFontSize = self.bounds.size.width * fontSizeFaktor;
	
	self.font = [UIFont fontWithName:fontName size:aFontSize];
	
	
}


#pragma mark -
- (void)drawRect:(CGRect)rect{
//	L();
//	[super drawRect:rect];

	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	
	// widget背景色
	if (bgAlpha>0.01) {

		CGContextSetFillColorWithColor(context, [bgColor colorWithAlpha:bgAlpha].CGColor);
		CGContextFillRect(context, self.bounds);
		
	}
	
	// ---
	CGContextSetFillColorWithColor(context, self.textColor.CGColor);


	if (strokeColor) {
		
		CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
		float strokeWidth = round(0.03*self.font.pointSize);
//		NSLog(@"stroke width # %f",strokeWidth);
		CGContextSetLineWidth(context, round(strokeWidth));
		CGContextSetTextDrawingMode(context, kCGTextFillStroke);

	}
	else {
			CGContextSetTextDrawingMode(context, kCGTextFill);
	}
	
	[self.text drawInRect:self.bounds withFont:self.font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];


	CGContextRestoreGState(context);

}

@end
