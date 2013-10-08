//
//  Setting.h
//  Everalbum
//
//  Created by AppDevelopper on 13-8-23.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/// setting的item 是保存在setting.plist中
@interface Setting : NSObject{
    NSMutableDictionary *_settingDict;
}

@property (nonatomic, assign) float firstVersion;
@property (nonatomic, assign) float thisVersion;
@property (nonatomic, assign) float lastVersion;

+(id)sharedInstance;

- (void)save;
@end
