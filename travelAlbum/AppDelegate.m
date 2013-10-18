//
//  AppDelegate.m
//  travelAlbum
//
//  Created by  on 17.05.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "AppDelegate.h"
#import "CPMotionRecognizingWindow.h"
#import "ICARootViewController.h"
#import "Flurry.h"
#import "Appirater.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize facebook;


- (void)initVariablesICamAlbum
{
    //	L();
	
    APPNAME = @"iCamAlbum";
    APPID = isPaid()?@"699048547":@"699053198";
    APPLINK = @"https://itunes.apple.com/de/app/id699053198?l=en&mt=8";
    IAP_KEY = @"de.xappsoft.icamalbumfree.fullversion";

    FBICONLINK = @"http://www.xappsoft.de/img/icamalbum_qrcode.png";
    ADMOB_KEY = @"a15226a64014da4"; // ICA
    FB_KEY = @"213853645405469";
    FLURRY_KEY = @"HWTNY5JZ2YWHQY2ZRG8B";
        
    TWEETUSTEXT = @"iCamAlbum - Album your photos \nCheck it out!";
    SUPPORTEMAILSUBJECT = @"Feedback for iCamAlbum";
    RECOMMENDEMAILSUBJECT = @"iCamAlbum -- Amazing App for Photo Collage Album";
    RECOMMENDEMAILBODY = @"Check it Out!";
    FB_CAPTION = @"Album your photos";
    FB_DESCRIPTION = @"";
    
    UPLOAD_IMAGE_MSG = @"via iCamAlbum";
    FB_NEW_ALBUM_DESC = @"Created via iCamAlbum";
    SHARE_MSG = @"\nCreated via iCamAlbum by Xappsoft";
}

- (void)initVariablesMyPhotoAlbum
{
    //	L();
	
    APPNAME = @"iCamAlbum";
    APPID = isPaid()?@"699048547":@"699053198";
    APPLINK = @"https://itunes.apple.com/de/app/id699053198?l=en&mt=8";
    IAP_KEY = @"de.xappsoft.icamalbumfree.fullversion";
    
    FBICONLINK = @"http://www.xappsoft.de/img/icamalbum_qrcode.png";
    ADMOB_KEY = @"a15226a64014da4"; // ICA
    FB_KEY = @"213853645405469";
    FLURRY_KEY = @"HWTNY5JZ2YWHQY2ZRG8B";
    
    TWEETUSTEXT = @"iCamAlbum - Album your photos \nCheck it out!";
    SUPPORTEMAILSUBJECT = @"Feedback for iCamAlbum";
    RECOMMENDEMAILSUBJECT = @"iCamAlbum -- Amazing App for Photo Collage Album";
    RECOMMENDEMAILBODY = @"Check it Out!";
    FB_CAPTION = @"Album your photos";
    FB_DESCRIPTION = @"";
    
    UPLOAD_IMAGE_MSG = @"via iCamAlbum";
    FB_NEW_ALBUM_DESC = @"Created via iCamAlbum";
    SHARE_MSG = @"\nCreated via iCamAlbum by Xappsoft";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initVariablesICamAlbum];
    
    [Appirater setAppId:@"552035781"];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:YES];
	
#if TARGET_IPHONE_SIMULATOR
	//	NSString *hello = @"Hello, iOS Simulator!";
	;
#else
//	[NSThread sleepForTimeInterval:5];
    
#endif
    
//---------------- Flurry
	
	
	
#ifndef DEBUG

	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	[Flurry startSession:FLURRY_KEY];  // 如果不是测试版本，激活flurry
	
#endif
	
    
	
//--------------Facebook
    
    facebook = [[Facebook alloc] initWithAppId:FB_KEY
								   andDelegate:[FacebookManager sharedInstance]];
//	NSString *facebookSuffix = isPaid()?@"paid":@"free";
//	NSLog(@"ispaid # %d",isPaid());
//    
//	
//
//    facebook = [[Facebook alloc]initWithAppId:FBAppID urlSchemeSuffix:@"abc" andDelegate:[FacebookManager sharedInstance]];
    

//-------------------------

//	[self customizeAppearance];
//---------------------------------------
	

    
//    L();
//    report_memory();
    
	self.window = [[CPMotionRecognizingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	self.window.rootViewController = [ICARootViewController sharedInstance];
	
    [self.window makeKeyAndVisible];

    
//    [Appirater appLaunched:YES];
	return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	L();
	
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//	L();
	
//	[Appirater appEnteredForeground:YES];

//	[[ExportController sharedInstance]estimateRate];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//	L();
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
//	L();
	return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - Appearance
- (void)customizeAppearance{
	if (isPhone) {
		[[UINavigationBar appearance] setTitleTextAttributes:
		 [NSDictionary dictionaryWithObjectsAndKeys:
		  [UIColor colorWithWhite:0.8 alpha:1.0],UITextAttributeTextColor,
		  [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
		  [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],UITextAttributeTextShadowOffset,
		  [UIFont fontWithName:@"Arial-Bold" size:0.0],UITextAttributeFont,
		  nil]];
	
	}
}


#pragma mark - Flurry Error Handlung
void uncaughtExceptionHandler(NSException *exception) {
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

#pragma mark - Facebook

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	NSLog(@"hanlde openurl");
    return [facebook handleOpenURL:url];
}

@end
