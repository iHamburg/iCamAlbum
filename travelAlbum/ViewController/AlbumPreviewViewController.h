//
//  AlbumPreviewViewController.h
//  XappTravelAlbum
//
//  Created by  on 17.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "AppViewController.h"
#import "TableScrollView.h"
#import "MomentView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "IpodMusicLibraryViewController.h"
#import "MomentShareView.h"


typedef enum {
	SlideTypeDissolve,
	SlideTypeWipe,
	SlideTypeSlide
}SlideType;

@interface AlbumPreviewViewController : AppViewController<TableScrollViewDataSource,TableScrollViewDelegate, UIGestureRecognizerDelegate, IpodMusicLibraryDelegate,MomentShareViewDelegate>{

	
    UIView *bottomBanner;
    UIButton *backB, *settingB;

    UIButton *playB;
    UIButton *musicB;
    UIButton *shareB;
    UIButton *editB;
    UIImageView *maskV;

	TableScrollView *scrollView;  // 用来手动preview
    
    IpodMusicLibraryViewController *musicComp;
	MomentShareView *momentShareV;
    
	UILabel *titleL, *subTitleL;
	UIView *slideContainer;
	UIImageView *imgV1, *imgV2;  // imgV1 是现在的view，for slideshow
    
	NSMutableArray *previewImages;
	
	BOOL isSlideshowing; // 当updateSliding时为Yes


}

@property (nonatomic, assign) SlideType slideType;
@property (nonatomic, assign) float slideInterval;

- (void)back;

- (void)showToolbar;
- (void)hideToolbar;

- (void)updateSlideShow;
- (void)stopSlideShow;

- (void)switchToCurrentPage;


- (void)hintEmptyAlbum;

@end
