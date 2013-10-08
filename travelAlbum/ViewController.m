//
//  RootViewController.m
//  XappTravelAlbum
//
//  Created by  on 21.01.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "ViewController.h"

#import "AlbumEditViewController.h"
#import "AlbumPreviewViewController.h"
#import "mach/mach.h"
#import "EditPhotoViewController.h"
#import "ExportController.h"
#import "IFFilterManager.h"
#import "IAPManager.h"
#import "EASetting.h"
#import "AlbumsTableViewController.h"
#import "AlbumManagerViewController.h"
#import "FileManager.h"
#import "VerticalInstructionViewController.h"
#import "VerticalSwipeInstructionViewController.h"
#import "EAInfoViewController.h"

#import "SDWebImageManager.h"
#import "ImageModelView.h"
#import "WebImage.h"
#import "SetStrokeColorCommand.h"
#import "EALoadingView.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "NewsQuadView.h"



#define kSaveWhenUsingInterval 120

typedef int (^MyBlockType)(int);


void showLoading(void){
    [[EALoadingView sharedLoadingView]add];
}

void showMsg(NSString* msg){
    L();
    
    [[EALoadingView sharedLoadingView]addTitle:msg];
}


@implementation ViewController


CommandType _command;


@synthesize popVC, editVC, previewVC,info2VC,managerVC;

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

+(id)sharedInstance{
	
	static id sharedInstance;
	
	if (sharedInstance == nil) {
		
		sharedInstance = [[[self class] alloc]init];
	}
	return sharedInstance;
	
}

- (void)checkSetting{
	
    [EASetting sharedInstance];
    
    [[EASetting sharedInstance] setIsHomeCoachShouldShown:NO];
    
}
- (void)configUIParameter {
    _w = self.view.width;
	_h = self.view.height;
	_r = r;
	_containerRect = containerRect;
    if(isPhone5){
		_containerRect = CGRectMake(44, 0, 480, 320);
	}
    
	_hAdBanner = isPad?66:32;
}



- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillEnterForeground)
												 name:UIApplicationWillEnterForegroundNotification
											   object: [UIApplication sharedApplication]];
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleWillResignActive) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
 
//    [[NSNotificationCenter defaultCenter]addObserverForName:kNotificationIAPRestore object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        [self IAPDidFinished];
//    }];
//    
//    [[NSNotificationCenter defaultCenter]addObserverForName:kNotificationIAPFinish object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        [self IAPDidFinished];
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IAPDidFinished) name:kNotificationIAPFinish object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IAPDidFinished) name:kNotificationIAPRestore object:nil];
}



- (void)loadAdView {
    ///启动adview
    [AdView sharedInstance];
}
//
//
//- (void)checkVersion{
//  CGFloat _firstVersion = [_settingDict[@"firstVersion"] floatValue];
//  CGFloat _lastVersion = [_settingDict[@"lastVersion"] floatValue];
//    
//    
//    //获得
//   CGFloat _thisVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] floatValue];
//    
//    if (_firstVersion == 0.0) { // 第一次安装app
//        isFirstOpen = YES;
//        isUpdateOpen = YES;
//        
//        _firstVersion =  [[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] floatValue];
//        
//        [_settingDict setObject:[NSString stringWithFloat:_firstVersion] forKey:@"firstVersion"];
//        
//        _lastVersion = _firstVersion;
//        [_settingDict setObject:[NSString stringWithFloat:_lastVersion] forKey:@"lastVersion"];
//        
//    }
//    else{ // 已经安装过app，再次打开
//        if (_thisVersion > _lastVersion) {
//            isUpdateOpen = YES;
//        }
//        
//        [_settingDict setObject:[NSString stringWithFloat:_thisVersion] forKey:@"lastVersion"];
//    }
//    
//    NSLog(@"firstVersion # %f, thisVersion # %f, isFirstOpen # %d",_firstVersion,_thisVersion,isFirstOpen);
//}
//

/**
 
  - 先检查版本
 
 */

- (void)loadView{

    
    L();
//    report_memory();
    
	[self checkSetting];


	r = [UIScreen mainScreen].bounds;
	r = CGRectApplyAffineTransform(r, CGAffineTransformMakeRotation(90 * M_PI / 180.));
	r.origin = CGPointZero;
	self.view = [[UIView alloc]initWithFrame:r];
    
	
    [self configUIParameter];
	
	
	if (isPad) {
		popVC = [[UIPopoverController alloc]initWithContentViewController:[[UIViewController alloc]init]];
		
	}
    
	firstLoadFlag = YES;

	[self registerNotification];
	
    [self loadAdView];
 
//    NSLog(@"after loadview");
//    
//    report_memory();
}


/// manager vc 已经加了
- (void)loadAppFirstTimeOpen {
    
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

- (void)viewDidAppear:(BOOL)animated{
	
	L();
	[super viewDidAppear:animated];
	
	if (firstLoadFlag) {
        firstLoadFlag = NO;

		[self toAlbumManager];

		if (isFirstOpen) {
			
			[self loadAppFirstTimeOpen];
			
		}
		else if(isUpdateOpen){
			
		}
	}
	
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
	
	[[ExportController sharedInstance] didReceiveMemoryWarning];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (NSUInteger)supportedInterfaceOrientations{

	return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
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

- (void)handleWillEnterForeground{
	
//	[self updateSaveWhenUsing];
}

- (void)handleWillResignActive{
//	L();
//	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateSaveWhenUsing) object:nil];
	L();
	[self saveWhenQuit];
}



#pragma mark - Navigation


- (void)toAlbumManager{
    managerVC = [[AlbumManagerViewController alloc] init];
    managerVC.view.alpha = 1;
	[self.view addSubview:managerVC.view];
}

- (void)expandToPreviewVC{
    
	
	self.previewVC.album = [[AlbumManager sharedInstance] currentAlbum];
    
    
    self.previewVC.view.transform = CGAffineTransformMakeScale(0.2, 0.2);
    
    [self.view addSubview:self.previewVC.view];


    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.previewVC.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        //        NSLog(@"animation finished");
        [self.previewVC layoutADBanner:[AdView sharedInstance]];
        
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
        [managerVC layoutADBanner:[AdView sharedInstance]];
       
        [self.previewVC.view removeFromSuperview];
         previewVC = nil;
    }];
  
}
- (void)toInfo{
  
	if(!info2VC.view){

		info2VC = [[EAInfoViewController alloc] init];
		info2VC.view.alpha = 1;
        info2VC.delegate = self;
	}



     [UIView transitionFromView:managerVC.view toView:info2VC.view duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];

}

- (void)closeInfo{

    [UIView transitionFromView:info2VC.view toView:managerVC.view duration:0.8 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL complete){
        info2VC = nil;
    }];
}

// 最先一开始和info

- (void)toInstruction{

	if(!instructionVC){
		instructionVC = [[VerticalInstructionViewController alloc]init];
		instructionVC.view.frame = self.view.bounds;
		instructionVC.delegate = self;
	}

//    NSLog(@"instruction.delegate # %@",instructionVC.delegate);
	
	[self.view addSubview:instructionVC.view];


}

- (void)instructionVCWillDismiss:(InstructionViewController *)vc{

    [self instructionToHome];
}

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
	
	// save Albums
    //	[[AlbumManager sharedInstance] saveAlbumNamePlist];
	
    //	[self saveSetting];
    [[EASetting sharedInstance]save];
	
    //
	[[NSUserDefaults standardUserDefaults]synchronize];
    
}

#pragma mark - CoachView
- (void)coachViewDidClicked:(CoachView *)coachView{
	[coachView removeFromSuperview];
	coachView = nil;
}


#pragma mark - Slide


- (void)slideInView:(UIView *)v from:(SlideDirection)direction{
		
	if (!slideVC) {
		slideVC = [[SlideViewController alloc]init];
		slideVC.view.alpha = 1;
	}
	
	[self.view addSubview:slideVC.view];
	[slideVC slideInView:v from:direction];
	
}

- (void)slideOutFrom:(SlideDirection)direction{
	
	if (direction == SlideDirectionNone) {

		[slideVC.view removeFromSuperview];
	}
	else{
	
		[slideVC hideContainer];
	
	}
	
}



//
//
/////  当进入editVC时会调用，每2min调用一次，以预防突然的崩溃, 当退出
//- (void)updateSaveWhenUsing{
//	
//	L();
//
//	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateSaveWhenUsing) object:nil];
//	
//	[self saveWhenQuit];
//	
//	[self performSelector:@selector(updateSaveWhenUsing) withObject:nil afterDelay:kSaveWhenUsingInterval];
//	
//}
//
//- (void)cancelUpdateSave{
//
//	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateSaveWhenUsing) object:nil];
//
//}
//#pragma mark -
//
//-(void)report_memory {
//
//	L();
//#ifdef DEBUG
//    struct task_basic_info info;
//    mach_msg_type_number_t size = sizeof(info);
//    kern_return_t kerr = task_info(mach_task_self(),
//                                   TASK_BASIC_INFO,
//                                   (task_info_t)&info,
//                                   &size);
//    if( kerr == KERN_SUCCESS ) {
//		//        NSLog(@"Memory in use (in bytes): %u", info.resident_size);
//		NSLog(@"Memory in use (in KB): %u", info.resident_size/1024);
//    } else {
//        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
//    }
//
//	
//#endif
//	
//}
//


//
//
//- (void)IAPDidRestored{
//	L();
//	
//	if (isPad) {
//		[[ViewController sharedInstance]dismissPopVC];
//	}
//	else{
//		[[ViewController sharedInstance]dismissModalViewControllerAnimated:YES];
//		
//	}
//	
//	[[ViewController sharedInstance]switchToScene:SceneManager];
//	
//}


#pragma mark - Instruction
- (void)removeInstruction {
    [instructionVC.view removeFromSuperview];
    instructionVC = nil;
}

- (void)instructionToHome{
//    NSLog(@"begin animation");
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [instructionVC.view setOrigin:CGPointMake(0, -_h)];
    } completion:^(BOOL finished) {

//        [self removeInstruction];
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
	testObjs = [NSMutableArray array];
//	[self testImage:[UIImage imageWithSystemName:@"20130403090938.alb_coverPhoto"]];
//	[self testVC:[[UINavigationController alloc]initWithRootViewController:[[PhotoAlbumViewController alloc]init]]];
//	[self testVC:[[PhotoAlbumViewController alloc]init]];
//	[self testNavVC:[[PhotoAlbum2ViewController alloc]init]];
//
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"abc" ofType:@"jpg"];
//	NSLog(@"path # %@",path);
//	UIImage *img = [UIImage imageWithContentsOfFileUniversal:@"ddt.jpg"];
//		NSLog(@"img # %@,scale # %f",NSStringFromCGSize(img.size),img.scale);
////	img = [img resizedImage:CGSizeMake(300, 200) interpolationQuality:kCGInterpolationDefault];
//	img = [img imageByScalingAndCroppingForSize:CGSizeMake(300, 200)];
//		NSLog(@"img # %@,scale # %f",NSStringFromCGSize(img.size),img.scale);
//	[self testImage:img];
//	[self testImage:[[UIImage imageNamed:@"abc.jpg"] image]];
	
//	[self testGPUImage];
//	[self testFilterImage];

//    [self testVC:[[AlbumManager2ViewController alloc]init]];

    
//    [self testView:[[ImageModelView alloc]initWithImage:kPlaceholderImage]];
//    UIImage *img = [[WebImage alloc]initWithURL:@"http://imgsrc.baidu.com/forum/pic/item/bc27cffc1e178a8253e49120f603738da877e85c.jpg"];
//    UIImage *img = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:[@"http://imgsrc.baidu.com/forum/pic/item/bc27cffc1e178a8253e49120f603738da877e85c.jpg" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    NSLog(@"img # %@",img);
//    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 400, 300)];
//    imgV.backgroundColor = [UIColor redColor];
//    imgV.image = img;
//    [self testView:imgV];
    
//    [[PhotoAlbum2ViewController alloc]init];
//    
//    PhotoAlbum2ViewController *vc =  [[PhotoAlbum2ViewController alloc]init];
//    vc.didSelectedImageBlock = ^(UIImage *image){
//      
//        NSLog(@"image # %@",image);
//    };
//
//    [self testVC:vc.nav];
//    
//    [self testBlock];
    
//    [self testSetStrokeCommand];
//    [self testEALoadingView];
    
//    [self testSaveArray];
    
//    [self testAddPhotoToLibrary];

//    [self testLocalize];
//    [self testView:[[NewsQuadView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)]];
//    
//    [self testAlpha];
//    
//    Album *album = [[Album alloc]init];
////    album.photoPreviewImage = kPlaceholderImage;
//    
//    saveArchived(album, @"testAlbum");
//    
//    Album *album2 = loadArchived(@"testAlbum");
//    NSLog(@"album2 # %@, photoPreviewImage # %@",album2,album2.photoPreviewImage);
//    
//    [self testImage:album2.photoPreviewImage];

//    NSLog(@"ios version # %f, is 6 %d",kVersion,kVersion >= 6);
    
//    [self testImage:[UIImage imageNamed:@"coach_home.png"]];
   
//    NSLog(@"kh # %f",kHPopNavigationbar);
 
//    UIViewController *vc = [[AlbumPreviewViewController alloc] init];
//    [self.view addSubview:vc.view];

//    InfoViewController *vc = [[InfoViewController alloc] init];
//    NSLog(@"info # %@",vc);
//    [self.view addSubview:vc.view];
    
//    for (int i = 0; i<20; i++) {
//        
//        CGFloat x = arc4random()%(int)(0.6* 100) + 0.3* (100);
//        NSLog(@"x # %f",x);
//    }
}

- (void)testAlpha{
    UIImage *png = [UIImage imageWithSystemName:@"Sticker_Tag_10.png"];
    UIImage *jpg = [UIImage imageWithSystemName:@"AlbumBG_13.jpg"];
    
    NSLog(@"png # %@, alpha # %d",NSStringFromCGSize(png.size),[png hasAlpha]);
    NSLog(@"jpg # %@, alpha # %d",NSStringFromCGSize(jpg.size),[jpg hasAlpha]);
    
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
//	UIImage *newImg = [filterManager filteredImageWithRaw:kPlaceholderImage filterType:IF_1977_FILTER];
//	UIImage *newImg = [filterManager testImage:IF_HEFE_FILTER];
//	UIImage *newImg = [filterManager filteredImageWithRawImage: filterType:<#(IFFilterType)#>]
	
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
