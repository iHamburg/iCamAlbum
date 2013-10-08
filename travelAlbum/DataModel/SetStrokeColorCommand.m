//
//  SetStrokeColorCommand.m
//  Everalbum
//
//  Created by AppDevelopper on 13-8-26.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "SetStrokeColorCommand.h"

@implementation SetStrokeColorCommand

- (void)execute{
    int value = 0;
//    [_delegate command:self didRequestColorInt:&value];
//    NSLog(@"value # %d",value);
//    
//    [_delegate command:self didFinishColorWithString:[NSString stringWithFormat:@"%d",value]];

    if (_RGBValueProvider != nil) {
        _RGBValueProvider(&value);
    }
    
    NSLog(@"value # %d",value);
    
    
}
@end
