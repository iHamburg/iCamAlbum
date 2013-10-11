//
//  SlideViewController.m
//  InstaMagazine
//
//  Created by AppDevelopper on 22.11.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "SlideViewController.h"
#import "ICARootViewController.h"

#define kSlideInterval 0.15

@implementation SlideViewController

@synthesize container;
@synthesize outOrigin,containerOrigin;

- (void)loadView{
	
	self.view = [[UIView alloc]initWithFrame:_r];
	self.view.backgroundColor = [UIColor clearColor];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(handleTap:)];
	tap.delegate = self;
	[self.view addGestureRecognizer:tap];

	w = self.view.width;
	h = self.view.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTap:(UITapGestureRecognizer*)tap{
	L();
	
	[self hideContainer];
}

#pragma mark - Gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
	if ([[touch view] isKindOfClass:[UIButton class]]) {
		return NO;
	}

	return YES;
}

#pragma mark - Public Methods


- (void)slideInView:(UIView*)_container from:(SlideDirection)direction{
	
	container = _container;
	containerOrigin = container.frame.origin;

	
	if (direction == SlideDirectionNone) {
		
		[self.view addSubview:container];

		return;
	}
	else if(direction == SlideDirectionFromDown){
		outOrigin = CGPointMake(container.frame.origin.x, h);
		[container setOrigin:outOrigin];
	}
	else if(direction == SlideDirectionFromRight){
		outOrigin = CGPointMake(w, container.frame.origin.y);
		[container setOrigin:outOrigin];
	}
	
	[self.view addSubview:container];
	
	[UIView animateWithDuration:kSlideInterval animations:^{
		[container setOrigin:containerOrigin];
	} completion:^(BOOL finished) {
		
	}];

	
}

- (void)hideContainer{
	
	[UIView animateWithDuration:kSlideInterval animations:^{
		[container setOrigin:outOrigin];
	} completion:^(BOOL finished) {
		
		[container removeFromSuperview];
		[container setOrigin:containerOrigin];
		[self.view removeFromSuperview];
	}];

}

@end
