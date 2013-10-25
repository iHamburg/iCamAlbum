//
//  RootViewController.h
//  XappTravelAlbum
//
//  Created by  on 21.01.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRootViewController.h"

#import "FacebookManager.h"
#import "SlideViewController.h"
#import "CoachView.h"
//#import <ShipLib/ShipLib.h>

#define kCoachEditOffKey @"coachEditOff"
#define kCoachManagerOffKey @"coachManagerOff"


void showLoading(void);
void showMsg(NSString*);

@class AppViewController;
@class AlbumPreviewViewController;
@class AlbumManagerViewController;

@interface ICARootViewController : LRootViewController<CoachViewDelegate>{

    AppViewController *editVC;
	AlbumPreviewViewController *previewVC;
    AlbumManagerViewController *managerVC;


	CoachView *_coachView;


}

@property (nonatomic, strong) AppViewController *editVC;
@property (nonatomic, strong) AlbumPreviewViewController *previewVC;
@property (nonatomic, strong) AlbumManagerViewController *managerVC;



- (void)setupCacheDocuments;
- (void)loadMusterAlbum;

- (void)instructionToHome;


- (void)toAlbumManager;
- (void)expandToPreviewVC;
- (void)expandToEditVC;
- (void)previewToEdit;
- (void)editToPreview;
- (void)shrinkToHome;


- (void)toInfo;
- (void)closeInfo;
- (void)toInstruction;



- (void)saveWhenQuit; // 当quit的时候调用，save 当前album



@end
