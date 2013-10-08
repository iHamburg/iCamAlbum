//
//  AlbumPreviewViewController.m
//  XappTravelAlbum
//
//  Created by  on 17.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "AlbumPreviewViewController.h"
#import "PreviewSettingViewController.h"
#import "IpodMusicLibraryViewController.h"
#import "MomentShareView.h"
#import "ExportController.h"
#import "Protocols.h"
#import "EALoadingView.h"

#define kToolbarInterval 5



@implementation AlbumPreviewViewController

@synthesize slideType, slideInterval;

- (void)setAlbum:(Album *)album{
	_album = album;
	_momentManager = [[MomentManager alloc] initWithAlbum:_album];
    
	[previewImages removeAllObjects];
	
	//是否该一开始就load所有的image？
	previewImages = _album.momentPreviewImages;

	[self patchMusterAlbumPhone4];
    
    scrollView.numberOfCovers = [previewImages count];
	
	
	isSlideshowing = NO;
	
	slideType = SlideTypeDissolve;
	titleL.text = album.title;
	
    [scrollView bringCoverAtIndexToFront:0 animated:NO];
	
}

//- (void)setFullScreenFlag:(BOOL)_fullScreenFlag{
//
//	NSLog(@" pageIndex # %d",pageIndex);
//	
//	fullScreenFlag = _fullScreenFlag;
//	
//	// 应该scrollview到当前page，bringCoverAtIndexToFront
//
//	int aPageIndex = pageIndex;
//	
//	// scrollview setup会让pageIndex清零
//	[scrollView setup];
//
//	[scrollView setContentOffset:CGPointMake(aPageIndex*self.view.width,0)];
//}

#pragma mark - View lifecycle

- (void)loadBottomBanner{
    
    bottomBanner = [[UIView alloc]initWithFrame:CGRectMake(30, 0.88 * _h, _w - 60, 0.12 * _h)];
    bottomBanner.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
    [bottomBanner applyBorder:kCALayerTopEdge indent:1];
    
    
    maskV = [[UIImageView alloc]initWithFrame:CGRectMake(-30, bottomBanner.height - _h, _w, _h)];
    maskV.image = [UIImage imageNamed:@"PreviewMask.png"];
    
    CGFloat wB = 0.7*bottomBanner.height;
    NSLog(@"wb # %f",wB);
    
    backB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_previewHomeWhite.png" target:self action:@selector(back)];
    backB.center = CGPointMake(backB.width/2, bottomBanner.height/2);
    
    editB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:Nil imageName:@"icon_preview_edit.png" target:self action:@selector(buttonClicked:)];
    editB.center = CGPointMake(CGRectGetMaxX(backB.frame) + wB/2 + 10, bottomBanner.height/2);
    
//    settingB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_previewSettingWhite.png" target:self action:@selector(openSetting:)];
//    settingB.center = CGPointMake( bottomBanner.width - settingB.width/2, bottomBanner.height/2);
    
//    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backB.frame), 10, CGRectGetMinX(settingB.frame) - CGRectGetMaxX(backB.frame), 20)];
//    
////    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHEX:@"2361FE"];
//    
//    pageControl.numberOfPages = 5;
//    pageControl.currentPage = 3;
    
	titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, - 50 , bottomBanner.width, 30)];
	titleL.backgroundColor = [UIColor clearColor];
	titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont fontWithName:kFontName size:isPad?30:22];
	titleL.textColor = [UIColor colorWithWhite:1 alpha:1];
    titleL.text = @"FlyToSeattle";
    
    subTitleL = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleL.frame), bottomBanner.width, 20)];
	subTitleL.backgroundColor = [UIColor clearColor];
	subTitleL.textAlignment = NSTextAlignmentLeft;
    subTitleL.font = [UIFont fontWithName:kFontName size:isPad?20:12];
	subTitleL.textColor = [UIColor colorWithWhite:1 alpha:1];
    subTitleL.text = @"Page 1/10";
    
    
    
    playB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_Preview_play.png" target:self action:@selector(buttonClicked:)];
    playB.center = CGPointMake(bottomBanner.width - wB/2, bottomBanner.height/2);
    
    musicB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_Preview_playlist-off.png" target:self action:@selector(buttonClicked:)];
    musicB.center = CGPointMake(CGRectGetMinX(playB.frame) - wB, bottomBanner.height/2);
    
    shareB = [UIButton buttonWithFrame:CGRectMake(0, 0, 1.5*wB, 1.5*wB) title:nil imageName:@"icon_Preview_share.png" target:self action:@selector(buttonClicked:)];
    shareB.center = CGPointMake(bottomBanner.width/2, bottomBanner.height/2);
    
    [bottomBanner addSubview:maskV];
    [bottomBanner addSubview:backB];
    [bottomBanner addSubview:editB];
    [bottomBanner addSubview:titleL];
    [bottomBanner addSubview:subTitleL];
    [bottomBanner addSubview:playB];
    [bottomBanner addSubview:musicB];
    [bottomBanner addSubview:shareB];
    
//  settingB.backgroundColor = [UIColor redColor];
//    titleL.backgroundColor  = [UIColor redColor];
    
}

- (void)registerGesture {
    //	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    //	doubleTap.numberOfTapsRequired = 2;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];

	
	[scrollView addGestureRecognizer:tap];
}

- (void)loadView{
	L();
	
	[super loadView];
    
    [self registerNotifications];
    
	self.view.backgroundColor = [UIColor blackColor];

	previewImages = [NSMutableArray array];

	scrollView = [[TableScrollView alloc]initWithFrame:self.view.bounds];
	scrollView.previewViewDelegate = self;
	scrollView.dataSource = self;
	scrollView.coverSize = scrollView.bounds.size;
	
    
    [self registerGesture];

    [self loadBottomBanner];

	slideContainer = [[UIView alloc]initWithFrame:self.view.bounds];
	
	
	[self.view addSubview:slideContainer];
	[self.view addSubview:scrollView];
   
    [self.view addSubview:bottomBanner];

	
	UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
	tap2.delegate = self;
	[slideContainer addGestureRecognizer:tap2];
	
//	slideInterval = kSlideIntervalMin+ 0.3*(kSlideIntervalMax - kSlideIntervalMin);
    slideInterval = 3;
	
	imgV1 = [[UIImageView alloc]initWithFrame:slideContainer.bounds];
	imgV2 = [[UIImageView alloc]initWithFrame:slideContainer.bounds];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
  
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
//	[self showToolbar];
//    if (manager.isCurrentAlbumEmpty) {
//        [self hintEmptyAlbum];
//    }
}


- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];

}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    L();

	
}

- (void)dealloc{
    L();
//    self.view = nil;
//    scrollView.delegate = nil;
//    scrollView.previewViewDelegate = nil;
//    [tableScrollView removeFromSuperview];
//    [scrollView removeFromSuperview];
//    scrollView = nil;
    
}

#pragma mark - Music

- (void)ipodMusicLibraryDidSelectedMusic{
    L();
    [musicB setImage:[UIImage imageNamed:@"icon_Preview_playlist.png"] forState:UIControlStateNormal];
    
    if (isPhone) {
        [root dismissModalViewControllerAnimated:YES];
    }
    else{
//        [root dismissPopVC];
        [pop dismissPopoverAnimated:YES];
    }
}

- (void)ipodMusicLibraryDidCancel{
    if (isPhone) {
        [root dismissModalViewControllerAnimated:YES];
    }
    else{
//        [root dismissPopVC];
        [pop dismissPopoverAnimated:YES];
    }
}

// 双击 toggle fullscreen
//- (void)handleDoubleTap:(UITapGestureRecognizer*)gesture{
//	L();
//	self.fullScreenFlag = !fullScreenFlag;
//}
//

#pragma mark - TableScrollView
- (UIView*)tableScrollView:(TableScrollView *)previewView viewAtIndex:(int)momentIndex{
	

	UIImageView *imgV = (UIImageView*)[previewView dequeueReusableCoverView];
	if (!imgV) {
		imgV = [[UIImageView alloc]initWithFrame:previewView.bounds];

        /// 由于默认的moment背景图的尺寸是960x640的，所以这里对于不同的size要进行自适应
        imgV.contentMode = UIViewContentModeScaleToFill;
	}
//
//	if (fullScreenFlag) {
//		imgV.contentMode = UIViewContentModeScaleAspectFit;
//	}
//	else{
//		imgV.contentMode = UIViewContentModeCenter;
//	}
//	
    UIImage *img = [previewImages objectAtIndex:momentIndex];
//    img = [img imageByScalingAndCroppingForSize:previewView.bounds.size];
//    NSLog(@"img # %@, scale # %f",NSStringFromCGSize(img.size),img.scale);
//    NSLog(@"imgV # %@",imgV);
	imgV.image = img;

	return imgV;
	
}

- (void)tableScrollView:(TableScrollView *)scrollView coverAtIndexWasBroughtToFront:(int)index{
//	L();
//	pageIndex = index;
    _momentManager.currentMomentIndex = index;

    [self updateTitle:_momentManager.currentMomentIndex + 1];
}


#pragma mark - MomentShare
- (void)momentShareView:(MomentShareView *)view didShareWithType:(ShareType)type{
    
    [self shareMomentWithType:type];
    
    [root slideOutFrom:SlideDirectionFromDown];
}



#pragma mark - IBOutlet

- (IBAction)buttonClicked:(id)sender{
    if (sender == playB) {
        if (isSlideshowing) {
            [self stopSlideShow];
        }
        else{
            [self performSelector:@selector(updateSlideShow) withObject:nil afterDelay:1];
        }
    }
    else if(sender == musicB){
        if (musicComp.playing) {
            [musicB setImage:[UIImage imageNamed:@"icon_Preview_playlist-off.png"] forState:UIControlStateNormal];
            [musicComp stopMusic];
        }
        else{
            [self showMusicLibrary];
        }
        
    }
    else if(sender == shareB){
        
        [self popShare:sender];
    }
    else if(sender == editB){
        [self toEdit];
    }
}
// 单击toggle toolbar
- (void)handleTap:(UITapGestureRecognizer*)gesture{
	L();
	
//    isIOS7
    [self toggleBottomBanner:gesture];
    
}



- (IBAction)toggleBottomBanner:(id)sender{
    if (bottomBanner.alpha == 0) {
        [self showToolbar];
    }
    else{
        [self hideToolbar];
    }
    
}



- (IBAction)popShare:(UIButton*)sender{
    CGRect rect = [bottomBanner convertRect:sender.frame toView:self.view];
  
    if (isIOS6) {
        [self showActivityVC];
    }
    else{
        [self showMomentShareV:rect];
    }
}

- (void)showActivityVC{
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[previewImages[_momentManager.currentMomentIndex],SShareText] applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard];
    activityViewController.completionHandler = ^(NSString *activityType, BOOL complete){
        NSLog(@"completeHandler # %@ %d",activityType,complete);
        if (complete) {
            if (activityType == UIActivityTypeSaveToCameraRoll) {
                [[EALoadingView sharedLoadingView] addTitle:@"Saved Successfully!"];
            }
        }
        
    };

    [root presentViewController:activityViewController animated:YES completion:^{
        
    }];
    
    
}


- (void)showMomentShareV:(CGRect)rect {
    if(!momentShareV){
        CGFloat wShareV = isPad?320:280;
        CGFloat hShareV = isPad?80:60;
        momentShareV = [[MomentShareView alloc]initWithFrame:CGRectMake(_w/2- wShareV/2, rect.origin.y - hShareV - 5, wShareV, hShareV)];
        momentShareV.delegate = self;
    }
    
    [root slideInView:momentShareV from:SlideDirectionFromDown];
}

- (void)showMusicLibrary{
    if (!musicComp) {
        musicComp = [[IpodMusicLibraryViewController alloc]init];
        musicComp.view.alpha = 1;
        
        musicComp.delegate = self;
    }
    
    
    if (isPhone) {
        [root presentModalViewController:musicComp.picker animated:YES];
        
    }
    else{
        //        [root popViewController:musicComp.picker fromRect:CGRectMake(100, 100, 10, 10)];
        pop = [[UIPopoverController alloc] initWithContentViewController:musicComp.picker];
        pop.popoverContentSize = CGSizeMake(musicComp.picker.view.width, musicComp.picker.view.width);
        [pop presentPopoverFromRect:CGRectMake(100, 100, 10, 10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - Navigation
- (void)back{
    
    [musicComp stopMusic];
   
    [self stopSlideShow];
    
    [root shrinkToHome];
}

- (void)toEdit{
    L();
    [musicComp stopMusic];
    
    [self stopSlideShow];
    
    [root previewToEdit];
    
}
#pragma mark - Functions



- (void)showToolbar{
    
    bottomBanner.alpha = 1;

}


- (void)hideToolbar{
//	L();
	
	
	[UIView animateWithDuration:0.3 animations:^{

        bottomBanner.alpha = 0;
	}];
	
}
//



- (void)shareMomentWithType:(int)type{
	
	[[LoadingView sharedLoadingView]addInView:self.view];

    
	UIImage *img = previewImages[_momentManager.currentMomentIndex];
    
	///momentView 恢复IMV
	[[ExportController sharedInstance]shareImage:img type:type];
    
}



- (void)updateSlideShow{
	L();
	
	scrollView.alpha = 0;
	
	/// 如果只有一个moment， return，不进行slideshow
	if (_album.numberOfMoments == 1) {
		return;
	}
	
	isSlideshowing = YES;
	
	[self.view insertSubview:slideContainer belowSubview:bottomBanner];
    
	
	//第一次开始slide，imgV1没有image
	if (!imgV1.image) {
		imgV1.image = [previewImages objectAtIndex:_momentManager.currentMomentIndex];
        
		[slideContainer addSubview:imgV1];
	}
	
    
	
	// if pageIndex是最后一张
	if (_momentManager.currentMomentIndex >= _album.numberOfMoments-1) {
		_momentManager.currentMomentIndex = -1;
	}
    
	NSLog(@"momentindex:%d",_momentManager.currentMomentIndex);
	
	imgV2.image = [previewImages objectAtIndex:_momentManager.currentMomentIndex + 1];
	
	if(slideType == SlideTypeDissolve){
		// 初始位置：
		
		// imgV2 -> imgV1;
		[slideContainer insertSubview:imgV2 belowSubview:imgV1];
		imgV1.alpha = 1;
		imgV2.alpha = 1;
		imgV1.center = slideContainer.center;
		imgV2.center = slideContainer.center;
		
		
		[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			imgV1.alpha = 0;
		} completion:^(BOOL finished) {
			UIImageView *tempV = imgV1;
			imgV1 = imgV2;
			imgV2 = tempV;
			
			_momentManager.currentMomentIndex ++;
		}];
	}
 	
    [self updateTitle:_momentManager.currentMomentIndex + 2];
    
    [playB setImage:[UIImage imageNamed:@"icon_Preview_pause.png"] forState:UIControlStateNormal];
    
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateSlideShow) object:nil];
	[self performSelector:@selector(updateSlideShow) withObject:nil afterDelay:slideInterval];
}

- (void)stopSlideShow{
	
    
	scrollView.alpha = 1;
	
	// stop slideshow
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateSlideShow) object:nil];
	
	// scrollview 划到当前 pageIndex
	[imgV1 removeFromSuperview];
	[imgV2 removeFromSuperview];
	[scrollView setContentOffset:CGPointMake(_momentManager.currentMomentIndex * _w, 0)];
    
	[self.view insertSubview:scrollView belowSubview:bottomBanner];
	isSlideshowing = NO;
    
    [playB setImage:[UIImage imageNamed:@"icon_Preview_play.png"] forState:UIControlStateNormal];
}

- (void)hintEmptyAlbum{
    
    //    []
    [[EALoadingView sharedLoadingView]addTitle:@"Start filling the memory!"];
    
    [editB performSelector:@selector(rotate) withObject:nil afterDelay:1];
}

#pragma mark - Intern Fcn

- (void)updateTitle:(int)page{
    subTitleL.text = [NSString stringWithFormat:@"Page %d/%d",page,_album.numberOfMoments];
}



- (void)switchToPage:(int)pageIndex{
    [scrollView setContentOffset:CGPointMake(pageIndex * scrollView.width, 0) animated:NO];
}

- (void)switchToCurrentPage{
    [self switchToPage:_momentManager.currentMomentIndex];
}

- (void)patchMusterAlbumPhone4{
    
//    NSLog(@"album.filename # %@",_album.fileName);
    if ([_album.fileName isEqualToString:kMusterAlbumName] && isPhone4) {
     
        L();
    
        for (int i = 0 ; i<previewImages.count; i++) {
            UIImage *img = previewImages[i];
            UIImage *newImg = [img imageByScalingAndCroppingForSize:self.view.bounds.size];
//            [previewImages replaceObjectsAtIndexes:i withObjects:newImg];
            [previewImages replaceObjectAtIndex:i withObject:newImg];
        }
    
    }
}
#pragma mark - ADView


- (void)layoutADBanner:(AdView *)banner{
//    L();
    if (!banner.isAdDisplaying) {
        [banner setOrigin:CGPointMake(0, _h)];
    }
    [UIView animateWithDuration:0.25 animations:^{
		
		if (banner.isAdDisplaying) { // 从不显示到显示banner
			
			[banner setOrigin:CGPointMake(0, _h- _hAdBanner)];
            [bottomBanner setOrigin:CGPointMake(30, _h -bottomBanner.height - banner.height)];

			[root.view addSubview:banner];
		}
		else{
            [bottomBanner setOrigin:CGPointMake(30, _h - bottomBanner.height )];

			[banner setOrigin:CGPointMake(0, _h)];
			
		}
		
    }];
    
}





@end
