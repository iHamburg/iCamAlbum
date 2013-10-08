//
//  SettingTests.m
//  Everalbum
//
//  Created by AppDevelopper on 13-8-23.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "SettingTests.h"
#import "Setting.h"

@implementation SettingTests{
    Setting *setting;
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
	setting = [Setting sharedInstance];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSettingChangeValue{
    setting.lastVersion = 9.7;
    NSLog(@"setting.lastv # %f",setting.lastVersion);
    
    STAssertTrue(setting.lastVersion > 9.69 && setting.lastVersion < 9.71   , @"lastversion should == 9.7");
}


@end
