//
//  SlideViewController.h
//  InstaMagazine
//
//  Created by AppDevelopper on 22.11.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

typedef enum {
	SlideDirectionFromUp,
	SlideDirectionFromDown,
	SlideDirectionFromLeft,
	SlideDirectionFromRight,
	SlideDirectionNone
}SlideDirection;

@interface SlideViewController : UIViewController<UIGestureRecognizerDelegate>{
		
	UIView *container;
	CGFloat w,h;
}

@property (nonatomic, assign) CGPoint outOrigin, containerOrigin;
@property (nonatomic, strong) UIView *container;

- (void)slideInView:(UIView*)container from:(SlideDirection)direction;
- (void)hideContainer;

@end


