//
//  AlbumEditViewController.h
//  XappTravelAlbum
//
//  Created by  on 16.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//


#import "AppViewController.h"
#import "TextViewController.h"
#import "Moment.h"
#import "Album.h"
#import "MomentView.h"
#import "MomentShareView.h"
#import "MomentManager.h"
#import "ICAValidator.h"


//@class EditSidebar;
@class EditPhotoViewController;

@class PhotoCropViewController;
@class PageManagerViewController;
@class EditSideControlViewController;

@interface AlbumEditViewController : AppViewController <TextVCDelegate, MomentShareViewDelegate, UIActionSheetDelegate,UIAlertViewDelegate, UIGestureRecognizerDelegate>{

	TextViewController  *textVC;
    PhotoCropViewController *photoCropVC;
    EditPhotoViewController *photoVC;  // PhotoEdit
    PageManagerViewController *pageManagerVC;

    EditSideControlViewController *editSideControlVC;
    UINavigationController *editSideNav;
    
	MomentShareView *momentShareV;
	MomentView *momentView;
	
    ICAValidator *validator;
	
	UIView *momentContainer;  // 为什么要container？
    UIView *bottomBanner;
    UIView *hotkeyBanner;
	UIPageControl *pageControl;
	UILabel *titleL;
    UIButton *backB,*hotkeyB, *addB, *shareB, *deleteB;
    UIButton *previewB;
    UIButton *sideControlB;

    
    UIAlertView *deleteAlert;

    
}


@property (nonatomic, strong) NSArray *kxEditMenuAddCaptionItems;
@property (nonatomic, strong) NSArray *kxEditMenuRemoveCaptionItems;


@property (nonatomic, readonly, assign) BOOL isHotkeyBannerShown;
@property (nonatomic, readonly, assign) BOOL isSideControlOpen;

- (void)addPage;
- (void)deletePage;
- (void)toPageAtIndex:(int)index;

- (IBAction)popShare:(id)sender;
- (void)shareMomentWithType:(int)type; // root call

- (IBAction)popTextEdit:(id)textWidget;
- (void)closeTextEdit;
- (void)finishTextEdit:(id)textWidget;

- (IBAction)openPhotoEdit:(id)v;  // edit photo
- (void)closePhotoEdit;

- (IBAction)openPhotoCrop:(id)widget; //
- (void)closePhotoCrop:(id)widget;

- (void)closeEditSideControl;

- (void)showDeleteAlert;
//- (void)showCaptionAlert;

- (void)hidePageManagerVC;

- (void)saveCurrentAlbum;


@end
