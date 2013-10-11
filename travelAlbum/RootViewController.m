//
//  RootViewController.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-11.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

+(id)sharedInstance{
	
	static id sharedInstance;
	
	if (sharedInstance == nil) {
		
		sharedInstance = [[[self class] alloc]init];
	}
	return sharedInstance;
	
}

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
- (void)loadView{
    
    
	rootLoadViewFlag = YES;
    [self registerNotification];
}

- (void)handleAppFirstTimeOpen{
    
}
- (void)handleRootFirstDidAppear{
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (rootLoadViewFlag) {
        
        rootLoadViewFlag = NO;
        
		if (isFirstOpen) {
			
			[self handleAppFirstTimeOpen];
			
		}
		else if(isUpdateOpen){
			
		}
        
        [self handleRootFirstDidAppear];
        [self loadAdView];
	}

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillEnterForeground)
												 name:UIApplicationWillEnterForegroundNotification
											   object: [UIApplication sharedApplication]];
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleWillResignActive) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IAPDidFinished) name:kNotificationIAPFinish object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IAPDidFinished) name:kNotificationIAPRestore object:nil];
}

- (void)handleWillEnterForeground{
	
    
}

- (void)handleWillResignActive{
    


}


#pragma mark - Info
- (void)infoVCWillClose:(InfoViewController *)infoVC{
    
}

#pragma mark - Instruction
- (void)instructionVCWillDismiss:(InstructionViewController *)vc{
    
}

#pragma mark - Intern Fcn

- (void)loadAdView {
    
    ///启动adview
    [AdView sharedInstance];
}

- (void)test{
    testObjs = [NSMutableArray array];
}

@end
