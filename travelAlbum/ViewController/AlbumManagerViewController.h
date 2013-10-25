//
//  AlbumManager2ViewController.h
//  Everalbum
//
//  Created by AppDevelopper on 19.08.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import "AppViewController.h"
#import "iCarousel.h"
#import "AlbumsTableViewController.h"
#import "ICAValidator.h"

typedef void (^AlertDidDoneBlock)(void);

@class AlbumCover;
@class BGViewController;

@interface AlbumManagerViewController : AppViewController<iCarouselDataSource, iCarouselDelegate,AlbumsTableViewControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate>{
	
    BGViewController *bgVC;
	UIView *topBanner, *bottomBanner;

	UIButton *infoB, *addB, *favoriteListB;
	UILabel *titleL;
    UILabel *hintLabel;
    iCarousel *carousel;
    UIPageControl *pageControl;
    
    AlbumsTableViewController *photoAlbumVC;
    ICAValidator *validator;
    
    UIAlertView *wrongPasswordAlert;
    UIAlertView *titleAlert, *newAlbumTitleAlert, *deleteAlbumAlert, *setupPasswordAlert, *_setupAgainPasswordAlert, *unlockPasswordAlert;
    UIAlertView *importPhotosAlert;
    
    NSString *password;
    NSMutableArray *importImages;
    SEL alertDidDoneSel;                                     /// 人工设置callback
    
    CGRect shareRect;
    
    
}

@property (nonatomic, readonly) AlbumCover* currentAlbumCover;

- (IBAction)addAlbum:(id)sender;
- (IBAction)deleteAlbum:(id)sender;


- (IBAction)previewAlbum:(id)sender;
- (IBAction)toEditAlbum:(id)sender;
- (IBAction)popShareAlbumView:(id)sender;
- (IBAction)toggleLoveAlbum:(id)sender;
- (IBAction)toggleLockAlbum:(id)sender;
- (IBAction)toInfo:(id)sender;
- (IBAction)openCamera:(id)sender;

/**
  改变当前album的cover图片
 */
- (IBAction)changeCoverImage:(id)sender;
- (IBAction)changeTitle:(id)sender;

@end
