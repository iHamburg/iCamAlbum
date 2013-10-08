//
//  Setting.m
//  Everalbum
//
//  Created by AppDevelopper on 13-8-23.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "Setting.h"
#import "UtilLib.h"

@implementation Setting

+(id)sharedInstance{
	static id sharedInstance;
	if (sharedInstance == nil) {
		
		sharedInstance = [[[self class] alloc]init];
	}
	
	return sharedInstance;
	
}

- (void)checkVersion{
    _firstVersion = [_settingDict[@"firstVersion"] floatValue];
    _lastVersion = [_settingDict[@"lastVersion"] floatValue];
    
    
    //获得
    _thisVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] floatValue];
    
    if (_firstVersion == 0.0) { // 第一次安装app
        isFirstOpen = YES;
        isUpdateOpen = YES;
        
        _firstVersion =  [[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] floatValue];
        
        [_settingDict setObject:[NSString stringWithFloat:_firstVersion] forKey:@"firstVersion"];
        
        _lastVersion = _firstVersion;
        [_settingDict setObject:[NSString stringWithFloat:_lastVersion] forKey:@"lastVersion"];
        
    }
    else{ // 已经安装过app，再次打开
        if (_thisVersion > _lastVersion) {
            isUpdateOpen = YES;
        }
        
        [_settingDict setObject:[NSString stringWithFloat:_thisVersion] forKey:@"lastVersion"];
    }
    
    NSLog(@"firstVersion # %f, thisVersion # %f, isFirstOpen # %d",_firstVersion,_thisVersion,isFirstOpen);
}

- (id)init
{
    self = [super init];
    if (self) {
        
       _settingDict = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString dataFilePath:@"Setting.plist"]];

        NSLog(@"dict # %@",_settingDict);
        
        [self checkVersion];
     
    }
    return self;
}


- (void)save{
    
    [_settingDict writeToFile:[NSString dataFilePath:@"Setting.plist"] atomically:YES];
    
    
}

@end
