//
//  MomentShareView.m
//  InstaMagazine
//
//  Created by AppDevelopper on 22.11.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "MomentShareView.h"

#import "AlbumEditViewController.h"
#import "AlbumPreviewViewController.h"
#import "Protocols.h"
#import <QuartzCore/QuartzCore.h>

@implementation MomentShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		w = frame.size.width;
		h = frame.size.height;
		
		NSArray *buttonBGImageNames;
		if (isPad) {
			buttonBGImageNames= @[@"share_page-icons-facebook.png",@"share_page-icons-twitter.png",
			@"share_page-icons-email.png",@"share_page-icons-save.png"];
			
		}
		else{
			buttonBGImageNames= @[@"share_page-icons-facebook.png",@"share_page-icons-twitter.png",
			@"share_page-icons-email.png",@"share_page-icons-save.png",@"share_page-icons-instagram.png"];
		}
		int numOfButtons = [buttonBGImageNames count];
		
		CGFloat wB = isPad?70:50;
		CGFloat xMargin = (w- numOfButtons*wB)/(numOfButtons+1);
		CGFloat yMargin = (h-wB)/2;
		
		for (int i = 0; i<[buttonBGImageNames count]; i++) {
			UIButton *b = [UIButton buttonWithFrame:CGRectMake(xMargin+ (xMargin+wB)*i, yMargin, wB, wB) title:nil imageName:buttonBGImageNames[i] target:self action:@selector(buttonClicked:)];
			b.tag = i;

			[self addSubview:b];
		}
		
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkBGPattern1.png"]];
		self.layer.cornerRadius = round(0.1*h);
		self.layer.masksToBounds = YES;

    }
    return self;
}

- (void)buttonClicked:(id)sender{
	L();
	int index = [sender tag];
	NSLog(@"button # %d is clicked",index);
	
	
	ShareType type = ShareMax;
	if (index == 0) {
		type = ShareToFacebook;
	}
	else if(index == 1){
		type = ShareToTwitter;
	}
	else if(index == 2){
		type = ShareToEmail;
	}
	else if(index == 3){
		type = ShareToAlbum;
	}
	else if(index == 4){
		type = ShareInstagram;
	}
	
    [_delegate momentShareView:self didShareWithType:type];

	// rootVC slideback
	
}
@end
