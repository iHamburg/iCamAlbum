//
//  RootViewController.h
//  XappTravelAlbum
//
//  Created by  on 21.01.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FacebookManager.h"
#import "SlideViewController.h"
#import "iCAInstructionViewController.h"
#import "CoachView.h"
#import "InfoViewController.h"


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

@interface ViewController : UIViewController<CoachViewDelegate,InstructionDelegate, InfoDelegate>{

    AppViewController *editVC;
	AlbumPreviewViewController *previewVC;
    AlbumManagerViewController *managerVC;

	InfoViewController *info2VC;
	InstructionViewController *instructionVC; // 只有一个壳子，还没有写内容
	SlideViewController *slideVC;

	CoachView *_coachView;
	

    
	UIPopoverController *popVC;

	CGRect r,containerRect;  // r 是全屏，

	BOOL firstLoadFlag;
	
	NSMutableArray *testObjs;

}

@property (nonatomic, strong) UIPopoverController *popVC;

@property (nonatomic, strong) AppViewController *editVC;
@property (nonatomic, strong) AlbumPreviewViewController *previewVC;
@property (nonatomic, strong) AlbumManagerViewController *managerVC;
@property (nonatomic, strong) InfoViewController *info2VC;

@property (nonatomic, assign) CommandType command;

+ (id)sharedInstance;

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
- (void)test;


@end
