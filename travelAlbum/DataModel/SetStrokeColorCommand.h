//
//  SetStrokeColorCommand.h
//  Everalbum
//
//  Created by AppDevelopper on 13-8-26.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "Command.h"



@protocol SetStrokeColorCommandDelegate;

typedef void (^RGBValueProvider) (int * value);

@interface SetStrokeColorCommand : Command

@property (nonatomic, unsafe_unretained) id<SetStrokeColorCommandDelegate> delegate;
@property (nonatomic, copy) RGBValueProvider RGBValueProvider;

@end


@protocol SetStrokeColorCommandDelegate <NSObject>

- (void)command:(SetStrokeColorCommand*)command didRequestColorInt:(int *)value;
- (void)command:(SetStrokeColorCommand*)command didFinishColorWithString:(NSString*)string;

@end