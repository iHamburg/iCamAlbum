//
//  RootViewController.m
//  XappTravelAlbum
//
//  Created by  on 21.01.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "ICARootViewController.h"

#import "AlbumEditViewController.h"
#import "AlbumPreviewViewController.h"
#import "mach/mach.h"
#import "EditPhotoViewController.h"
#import "ICAExportController.h"
#import "IFFilterManager.h"
#import "IAPManager.h"

#import "AlbumsTableViewController.h"
#import "AlbumManagerViewController.h"
#import "FileManager.h"
#import "VerticalInstructionViewController.h"
#import "VerticalSwipeInstructionViewController.h"
#import "EAInfoViewController.h"
#import "iCAInstructionViewController.h"
#import "ICAAdView.h"
#import "SDWebImageManager.h"
#import "ImageModelView.h"

#import "SetStrokeColorCommand.h"
#import "EALoadingView.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "NewsQuadView.h"
#import "FontNameLineScrollView.h"
#import "MBProgressHUD.h"


typedef int (^MyBlockType)(int);


void showLoading(void){
    [[EALoadingView sharedLoadingView]add];
}

void showMsg(NSString* msg){
    L();
    
    [[EALoadingView sharedLoadingView]addTitle:msg];
}


@implementation ICARootViewController




@synthesize editVC, previewVC,managerVC;

- (AppViewController*)editVC{
    if (!editVC) {
        
		editVC = [[AlbumEditViewController alloc] init];
		editVC.view.alpha = 1;
	}
    return editVC;
}

- (AppViewController*)previewVC{
    
	if (!previewVC) {
		previewVC = [[AlbumPreviewViewController alloc] init];
		previewVC.view.frame = self.view.bounds;
	}
    return previewVC;
}
//- (AppViewController*)managerVC{
//    if (!managerVC) {
//        managerVC = [[AlbumManagerViewController alloc] init];
//        managerVC.view.alpha = 1;
//    }
//    return managerVC;
//}

- (void)loadView{
    [super loadView];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    
//    [self printer:nil];
}

- (void)loadAdView{
    [ICAAdView sharedInstance];
}

- (void)handleAppFirstTimeOpen{
   
    
    [self setupCacheDocuments];
    
    [self loadMusterAlbum];
    
    [self toInstruction];
    
    _coachView = [[CoachView alloc] initWithFrame:self.view.bounds];
    
    /// 只需要一张图片就够了！
    UIImage *img = [UIImage imageWithSystemName:@"coach_home.png"];
    _coachView.coachImage = img;
    _coachView.delegate = self;
    [self.view insertSubview:_coachView aboveSubview:managerVC.view];

}

- (void)handleRootFirstDidAppear{
    
    [self toAlbumManager];
  
    [self test];
}
- (void)dealloc{

	[[NSNotificationCenter defaultCenter]removeObserver:self];

}


- (void)didReceiveMemoryWarning
{
	
	L();
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
	
	if (!managerVC.view.superview) { // 如果现在是managerVC
        
		managerVC = nil;
	}
	
	if (!instructionVC.view.superview) {
		instructionVC = nil;
	}
	
	[[ICAExportController sharedInstance] didReceiveMemoryWarning];
	
}




/**
 firstVersion: 第一次安装时的版本号
 lastVersion: 上次打开时的版本号
 thisVersion: 本次打开时的版本号
 
 isFirstOpen: 安装后第一次打开
 isUpdateOpen: 更新后第一次打开
 
 */


- (void)setupCacheDocuments{

	[[FileManager sharedInstance]createCachesDirectory];
	
	//给文件夹
	[FileManager addSkipBackupAttributeToItemAtPath:[NSString cachesPathForFileName:nil]];
}


// load album file to document, and load pictures to caches
- (void)loadMusterAlbum{
	
    L();
//	album 文件load到 document
	[NSString dataFilePath:kMusterAlbumName];
	
//	pictures load到caches
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *path = [[NSBundle mainBundle] resourcePath];
	NSDirectoryEnumerator* en = [fileManager enumeratorAtPath:path];

	NSError* err = nil;
	NSString* file;
    
	while (file = [en nextObject]) {
		NSRange range = [file rangeOfString:kMusterAlbumName];
		if (range.location == NSNotFound) {
			continue;
		}

		NSString *filePath = [path stringByAppendingPathComponent:file];
	
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSString *cacheDirectioryPath = [paths objectAtIndex:0];
		NSString *albumCacheDirectoryPath = [cacheDirectioryPath stringByAppendingPathComponent:kAlbumCacheDirectory];
		NSString *cachePath = [albumCacheDirectoryPath stringByAppendingPathComponent:file];
        
		if (![fileManager copyItemAtPath:filePath toPath:cachePath error:&err]) {
//			NSLog(@"Error # %@: %@ copy to cache failed. %@",err.localizedDescription,filePath,cachePath);
			
		}
        else{
//            NSLog(@"successful # copy to cache %@",cachePath);
        }

        
	}

}

#pragma mark - Notifications

- (void)registerNotification {
    
    [super registerNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IAPDidFinished) name:kNotificationIAPFinish object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IAPDidFinished) name:kNotificationIAPRestore object:nil];
}



- (void)handleWillResignActive{

	L();
	[self saveWhenQuit];
}



#pragma mark - Navigation


- (void)toAlbumManager{
    managerVC = [[AlbumManagerViewController alloc] init];
    managerVC.view.alpha = 1;
    NSLog(@"managerVC # %@",managerVC.view);
	[self.view addSubview:managerVC.view];
        NSLog(@"managerVC # %@",managerVC.view);
}

- (void)expandToPreviewVC{
    
	
	self.previewVC.album = [[AlbumManager sharedInstance] currentAlbum];
    
    
    self.previewVC.view.transform = CGAffineTransformMakeScale(0.2, 0.2);
    
    [self.view addSubview:self.previewVC.view];


    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.previewVC.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        //        NSLog(@"animation finished");
//        [self.previewVC layoutADBanner:[AdView sharedInstance]];
        
        if ([[AlbumManager sharedInstance] isCurrentAlbumEmpty]) {
            [previewVC hintEmptyAlbum];
        }
 
        [managerVC.view removeFromSuperview];
        managerVC = nil;
       
        
    }];
    
}

- (void)expandToEditVC{
    self.editVC.momentManager = [[MomentManager alloc] initWithAlbum:[[AlbumManager sharedInstance] currentAlbum]];
    
    self.editVC.view.transform = CGAffineTransformMakeScale(0.2, 0.2);
    
    [self.view addSubview:self.editVC.view];
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.editVC.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [managerVC.view removeFromSuperview];
        managerVC = nil;

    }];

    
}

- (void)previewToEdit{
 
	
    self.editVC.momentManager = self.previewVC.momentManager;


    [UIView transitionFromView:self.previewVC.view toView:self.editVC.view duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
//         [self.editVC layoutADBanner:[AdView sharedInstance]];
        
        /// 自动release preview view
//        [previewVC.view removeFromSuperview];
          previewVC = nil;
    }];
    
}

- (void)editToPreview{
    
    /// preview需要转到相应的页数
    self.previewVC.album = [[AlbumManager sharedInstance] currentAlbum];
    previewVC.momentManager = self.editVC.momentManager;
    [previewVC switchToCurrentPage];


    [UIView transitionFromView:self.editVC.view toView:self.previewVC.view duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {

        editVC = nil;
    
//        NSLog(@"editVC # %@",editVC);
    }];
}
//
- (void)shrinkToHome{
//    NSLog(@"root.subviews # %@",self.view.subviews);
    managerVC = [[AlbumManagerViewController alloc] init];
    managerVC.view.alpha = 1;
    managerVC.view.transform = CGAffineTransformMakeScale(2, 2);
    
    [self.view addSubview:managerVC.view];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        managerVC.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
//        [managerVC layoutADBanner:[AdView sharedInstance]];
       
        [self.previewVC.view removeFromSuperview];
         previewVC = nil;
    }];
  
}
- (void)toInfo{
  
	if(!infoVC.view){

		infoVC = [[EAInfoViewController alloc] init];
		infoVC.view.alpha = 1;
        infoVC.delegate = self;
	}

     [UIView transitionFromView:managerVC.view toView:infoVC.view duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];

}

- (void)closeInfo{

    [UIView transitionFromView:infoVC.view toView:managerVC.view duration:0.8 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL complete){
        infoVC = nil;
    }];
}

// 最先一开始和info


#pragma mark - Function
- (void)IAPDidFinished{
	
	L();
    
    [self toAlbumManager];
    
    // remove ads
    [AdView releaseSharedInstance];
    
    
    
}


- (void)saveWhenQuit{
	L();
	
	// 保存当前正在操作的Album
	[(AlbumEditViewController*)self.editVC saveCurrentAlbum];
	

	
    //
	[[NSUserDefaults standardUserDefaults]synchronize];
    
}

#pragma mark - CoachView
- (void)coachViewDidClicked:(CoachView *)coachView{
	[coachView removeFromSuperview];
	coachView = nil;
}


#pragma mark - Instruction

- (void)toInstruction{
    
	if(!instructionVC){
		instructionVC = [[iCAInstructionViewController alloc]init];
		instructionVC.view.frame = self.view.bounds;
		instructionVC.delegate = self;
	}
    
	
	[self.view addSubview:instructionVC.view];
    
    
}

- (void)instructionVCWillDismiss:(InstructionViewController *)vc{
    
    [self instructionToHome];
}
- (void)removeInstruction {
    [instructionVC.view removeFromSuperview];
    instructionVC = nil;
}

- (void)instructionToHome{

    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [instructionVC.view setOrigin:CGPointMake(0, -_h)];
    } completion:^(BOOL finished) {

        [self performSelector:@selector(removeInstruction) withObject:nil afterDelay:1];
    }];
    
}

#pragma mark - Info
- (void)infoVCWillClose:(InfoViewController *)infoVC{
    [self closeInfo];
}


#pragma mark - Test
- (void)test{
    L();

    [super test];
    
//    NSLog(@"loading Str # %@",LoadingStr);
//    loadingHeight = 12;
//    NSLog(@"loadingHeight # %f",loadingHeight);
    
//    [self testView:[[FontNameLineScrollView alloc] initWithFrame:CGRectMake(100, 100, 400, 60)]];
    
//    [self expandToEditVC];
 
//    UIView *window1 =  [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//    UIView *window2 = UIApplication.sharedApplication.keyWindow;
//    
//    NSLog(@"window1 # %@; window2 # %@",window1,window2);
//    NSLog(@"abc # %@");
    
//    [self testHUDText];
    
//    [self printer:nil];
}



- (void)testHUDText{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = @"Some message...";
    //	hud.margin = 10.f;
    //	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:3];
}

- (void)testAlpha{
//    UIImage *png = [UIImage imageWithSystemName:@"Sticker_Tag_10.png"];
//    UIImage *jpg = [UIImage imageWithSystemName:@"AlbumBG_13.jpg"];
    
//    NSLog(@"png # %@, alpha # %d",NSStringFromCGSize(png.size),[png hasAlpha]);
//    NSLog(@"jpg # %@, alpha # %d",NSStringFromCGSize(jpg.size),[jpg hasAlpha]);
//    
    
}

- (void)testABC{
    
}
- (void)testLocalize{
    NSString *dismiss = NSLocalizedString(@"Dismiss", nil);
    
    NSLog(@"dismiss # %@",dismiss);
}
//
- (void)testSaveArray{
    NSArray *array = @[@1,@2,@3];
    
    NSString *filePath = [NSString dataFilePath:@"abc"];
    [array writeToFile:filePath atomically:YES];
    
    NSArray *arr2 = [NSArray arrayWithContentsOfFile:filePath];
    NSLog(@"array # %@, arr2 # %@",array,arr2);
}

- (void)testEALoadingView{
    [[EALoadingView sharedLoadingView]addTitle:@"abc"];
}

- (void)testSetStrokeCommand{
    SetStrokeColorCommand *command = [[SetStrokeColorCommand alloc]init];
    command.RGBValueProvider = ^(int *value){
        *value = 100;
    };
    
    [command execute];
}

- (void)testBlock{
    int (^myBlock)(int) = ^(int num){
        return num*num;
    };
	
    MyBlockType myBlockType = ^ (int abc){
        return abc+1;
    };
    NSLog(@" block 3 # %d, %d",myBlock(3),myBlockType(3));
    
  ;
}

- (void)testVC:(UIViewController*)vc{
    
	[testObjs addObject:vc];
	[self.view addSubview:vc.view];

}

- (void)testNavVC:(UIViewController*)vc{
	
	
	UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
	nav.view.frame = CGRectMake(0, 0, vc.view.width, vc.view.height + 44);
	[self.view addSubview:nav.view];
	[testObjs addObject:nav];
}
- (void)testImage:(UIImage*)img{
	UIImageView *imgV = [[UIImageView alloc]initWithImage:img];
	[self.view addSubview:imgV];
}

- (void)testGPUImage{
	GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"placeholder.jpg"]];
	GPUImageFilter *stillImageFilter = [[IFLomofiFilter alloc] init];
	
	[stillImageSource addTarget:stillImageFilter];
	[stillImageSource processImage];
	
	UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentlyProcessedOutput];
	[self testImage:currentFilteredVideoFrame];
}

- (void)testFilterImage{
	IFFilterManager *filterManager = [IFFilterManager sharedInstance];

	
	UIImage *newImg = [filterManager imageByFiltingImage:[UIImage imageNamed:@"new_BG5.jpg"] filterType:IF_1977_FILTER];
	NSLog(@"img # %@",NSStringFromCGSize(newImg.size));
	[self testImage:newImg];
}

- (void)testException{
	@try {
		
		[NSException raise:@"WebService error" format:@"%@", @"Reason: xxxx"];
	}
	@catch (NSException *exception) {
		NSLog(@"Exception # %@",exception);
	}
	@finally {
		NSLog(@"finally");
	}
	 
}

- (void)testView:(UIView*)v{
    [self.view addSubview:v];
}

@end
