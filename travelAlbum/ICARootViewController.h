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
#import "iCAInstructionViewController.h"
#import "CoachView.h"



#define kFirstVersionKey @"firstVersionKey"
#define kLastVersionKey @"lastVersionKey"
#define kCoachEditOffKey @"coachEditOff"
#define kCoachManagerOffKey @"coachManagerOff"

typedef enum {
	SceneNone,
	SceneManager,
	SceneEdit,
	ScenePreview,
	SceneShare,
	SceneMoreApp,
	SceneInfo,
	SceneInstruction
}AppScene;

typedef enum {
    CommandNone,
    CommandChangeBGImage,
    CommandChangeCoverImage,
    CommandValidateEnterEditAlbum,
    CommandValidateEnterPreviewAlbum,
    CommandValidateChangeAlbumTitle,
    CommandValidateChangeCoverImage,
    CommandValidateShareAlbum,
    CommandValidateDeleteAlbum,
    CommandMax
}CommandType;

extern CommandType _command;

void showLoading(void);
void showMsg(NSString*);

@class AppViewController;
@class AlbumPreviewViewController;
@class AlbumManagerViewController;

@interface ICARootViewController : LRootViewController<CoachViewDelegate>{

    AppViewController *editVC;
	AlbumPreviewViewController *previewVC;
    AlbumManagerViewController *managerVC;

	 // 只有一个壳子，还没有写内容
	SlideViewController *slideVC;

	CoachView *_coachView;


}

@property (nonatomic, strong) AppViewController *editVC;
@property (nonatomic, strong) AlbumPreviewViewController *previewVC;
@property (nonatomic, strong) AlbumManagerViewController *managerVC;
@property (nonatomic, assign) CommandType command;
//
//+ (id)sharedInstance;

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


///SlideVC
- (void)slideInView:(UIView *)v from:(SlideDirection)direction;
- (void)slideOutFrom:(SlideDirection)direction;


- (void)saveWhenQuit; // 当quit的时候调用，save 当前album

//- (void)report_memory;



@end
