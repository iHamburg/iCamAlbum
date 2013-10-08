//
//  CoachView.m
//  Everalbum
//
//  Created by AppDevelopper on 05.02.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import "CoachView.h"
#import "Utilities.h"


@implementation CoachView

@synthesize delegate;

- (void)setCoachImage:(UIImage *)coachImage{
	
	_bgV.image = coachImage;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *maskV = [[UIView alloc] initWithFrame:self.bounds];
        maskV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
		_bgV = [[UIImageView alloc]initWithFrame:self.bounds];
		_bgV.userInteractionEnabled = YES;

		[_bgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
		
        [self addSubview:maskV];
		[self addSubview:_bgV];
		
//		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
		
    }
    return self;
}

- (IBAction)handleTap:(id)sender{
	L();
	
	[delegate coachViewDidClicked:self];
}

@end
