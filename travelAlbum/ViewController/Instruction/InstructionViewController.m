//
//  InstructionViewController.m
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 16.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "InstructionViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface InstructionViewController ()

@end

@implementation InstructionViewController

- (void)loadView{
	self.view = [[UIView alloc]initWithFrame:_r];
	UIImageView *bgV = [[UIImageView alloc]initWithFrame:self.view.bounds];

//	w = self.view.width;
//	h = self.view.height;
    numOfPages = 2;
	
	bgV.image = [UIImage imageWithSystemName:@"BG_1024.jpg"];
	
	CGFloat wBackB = isPad?60:30;
	backB = [UIButton buttonWithFrame:isPad?CGRectMake(964, 5, wBackB, wBackB):CGRectMake(440, 10, wBackB, wBackB) title:nil imageName:@"icon_whiteClose.png" target:self action:@selector(buttonClicked:)];
	
	
	scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];

	scrollView.backgroundColor = [UIColor clearColor];
	scrollView.pagingEnabled = YES;
	scrollView.contentSize = CGSizeMake(_w * numOfPages, 0);
	scrollView.delegate = self;
	
	if (isPad||isPhone5) {
//		NSArray *imgNames = @[@"instruction_1.jpg",@"instruction_2.jpg"];
		
		CGFloat wImage = isPad?947:400;
		CGFloat hImage = isPad?658:300;
		
		for (int i = 0; i<numOfPages; i++) {
			
			UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(_w*i+(_w-wImage)/2, (_h-hImage)/2, wImage, hImage)];
			imgV.image = [UIImage imageWithSystemName:_imgNames[i]];
			imgV.layer.cornerRadius = hImage*0.05;
			imgV.layer.masksToBounds = YES;
			
			[scrollView addSubview:imgV];
			if (i == 1) {
				UIImageView *arrowV = [[UIImageView alloc]initWithFrame:self.view.bounds];
				arrowV.image = [UIImage imageWithSystemName:@"Instruction_arrows.png"];
				arrowV.center = imgV.center;
				[scrollView addSubview:arrowV];
			}
		}

	}
	else{ // iphone4 以下
//		NSArray *imgNames = @[@"instruction_960_1.jpg",@"instruction_960_2.jpg"];
		
		CGFloat wImage = 480;
		CGFloat hImage = 320;
		
		for (int i = 0; i<numOfPages; i++) {
			
			UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(_w * i+(_w - wImage)/2, (_h-hImage)/2, wImage, hImage)];
			imgV.image = [UIImage imageWithContentsOfFileName:_imgNames[i]];
			imgV.layer.cornerRadius = hImage*0.05;
			imgV.layer.masksToBounds = YES;
			
			[scrollView addSubview:imgV];

		}

	}
		
	CGFloat yPageControl = isPad?712:300;
	pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, yPageControl, _w, _h-yPageControl)];
	pageControl.numberOfPages = numOfPages;
	pageControl.userInteractionEnabled = NO;
	
	[self.view addSubview:bgV];
	[self.view addSubview:scrollView];
	[self.view addSubview:pageControl];
	[self.view addSubview:backB];
	
}

- (void)viewDidAppear:(BOOL)animated{
	L();
	[super viewDidAppear:animated];
	self.view.frame =_r;
}

- (void)dealloc{
    L();
}

#pragma mark - IBAction
- (void)buttonClicked:(id)sender{
	if (sender == backB) {

		[_delegate instructionVCWillDismiss:self];
	}
}

#pragma mark - ScrollView & PageControl

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView{
	CGFloat xOffset = scrollView.contentOffset.x;
	int page = xOffset/scrollView.width;
	pageControl.currentPage = page;
}

@end
