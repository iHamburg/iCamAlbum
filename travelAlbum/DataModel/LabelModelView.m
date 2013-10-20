//
//  TextModelView.m
//  Everalbum
//
//  Created by AppDevelopper on 30.07.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import "LabelModelView.h"

#import "Category.h"
#import <QuartzCore/QuartzCore.h>

#define kTextFontOriginalSize 30
#define kTextFontOriginalName @"Chalkboard SE"

@interface LabelModelView()

- (void)firstLoad;
- (void)load;
- (void)adjustFontSize;

@end

@implementation LabelModelView

@synthesize menuItems,lockFlag;

static NSArray *lockMenuItems, *unlockMenuItems;

- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		[self firstLoad];
		[self load];
	}
	return self;
}

/// 可以被保存
- (void)firstLoad{
	self.font = [UIFont fontWithName:kTextFontOriginalName size:kTextFontOriginalSize];
	self.textColor = kColorDarkGreen;
	_fontName = kTextFontOriginalName;
	_bgColor = [UIColor blackColor];
	_strokeColor = [UIColor whiteColor];
	_bgAlpha = 0.3;
	_fontSizeFaktor = self.font.pointSize/self.bounds.size.width;
	
}

/// 不被保存，每次都要调用的
- (void)load{
	
	self.userInteractionEnabled = YES;
	self.numberOfLines = 0;
	self.backgroundColor = [_bgColor colorWithAlpha:_bgAlpha];
	
	
}

/// load
- (id)initWithCoder:(NSCoder *)aDecoder{
	
	if (self = [super initWithCoder:aDecoder]) {
	
		_bgColor = [aDecoder decodeObjectForKey:@"bgColor"];
		_strokeColor = [aDecoder decodeObjectForKey:@"strokeColor"];
		_fontName = [aDecoder decodeObjectForKey:@"fontName"];
		_fontSizeFaktor = [aDecoder decodeFloatForKey:@"fontSizeFaktor"];
		_bgAlpha = [aDecoder decodeFloatForKey:@"bgAlpha"];
		lockFlag = [aDecoder decodeBoolForKey:@"lockFlag"];
        
		[self load];
	}
	return self;
}



/// save
- (void) encodeWithCoder: (NSCoder *)coder
{

	[self resetAnchorPoint];
	
	[super encodeWithCoder:coder];
	
	[coder encodeObject:_bgColor forKey:@"bgColor"];
	[coder encodeObject:_strokeColor forKey:@"strokeColor"];
	[coder encodeObject:_fontName forKey:@"fontName"];
	[coder encodeFloat:_fontSizeFaktor forKey:@"fontSizeFaktor"];
	[coder encodeFloat:_bgAlpha forKey:@"bgAlpha"];
	[coder encodeBool:lockFlag forKey:@"lockFlag"];
}



#pragma mark - Widget, save

- (NSArray*)menuItems{
		
	if (!lockMenuItems) {
		lockMenuItems = @[[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Unlock", nil) action:@selector(menuUnlockPiece:)],
					[[UIMenuItem alloc]initWithTitle:@"Edit" action:@selector(menuEditPiece:)],
					];
	}
	
	if (!unlockMenuItems) {
		unlockMenuItems = @[[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Lock", nil) action:@selector(menuLockPiece:)],
					  [[UIMenuItem alloc]initWithTitle:@"Edit" action:@selector(menuEditPiece:)],
					 ];
	}

	if (lockFlag) {
		return lockMenuItems;
	}
	else
		return unlockMenuItems;

}



- (void)handleEdit{

	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationEditLabelModelView object:self];

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
	
	float aFontSize = self.bounds.size.width * _fontSizeFaktor;
	
	self.font = [UIFont fontWithName:_fontName size:aFontSize];
	
	
}

#pragma mark -

+ (id)defaultInstance{
	LabelModelView *lmv = [[LabelModelView alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
	lmv.text = @"Default Label";
	
	return lmv;
}

#pragma mark -
- (void)drawRect:(CGRect)rect{

	//	[super drawRect:rect];
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	
	// widget背景色
	if (_bgAlpha>0.01) {
		
		CGContextSetFillColorWithColor(context, [_bgColor colorWithAlpha:_bgAlpha].CGColor);
		CGContextFillRect(context, self.bounds);
		
	}
	
	CGContextSetFillColorWithColor(context, self.textColor.CGColor);
	
	
	if (_strokeColor) {
		
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
