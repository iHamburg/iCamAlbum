//
//  EASetting.m
//  Everalbum
//
//  Created by AppDevelopper on 13-8-23.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "EASetting.h"

@implementation EASetting

- (void)setIsHomeCoachShouldShown:(BOOL)isHomeCoachShouldShown{
    _isHomeCoachShouldShown = isHomeCoachShouldShown;
    [_settingDict setValue:[NSString stringWithInt:_isHomeCoachShouldShown] forKey:@"isHomeCoachShouldShown"];
}

- (id)init
{
    self = [super init];
    if (self) {
        _isHomeCoachShouldShown = [_settingDict[@"isHomeCoachShouldShown"] boolValue];
        
    }
    return self;
}
@end
