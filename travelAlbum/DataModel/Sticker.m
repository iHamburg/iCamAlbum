//
//  Icon.m
//  InstaMagazine
//
//  Created by AppDevelopper on 12.11.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "Sticker.h"

@implementation Sticker

NSString *const StickerChristmas = @"Christmas";

@synthesize name,imgName,thumbImgName, category;

- (id)initWithDictionary:(NSDictionary*)dict{
	if (self = [super init]) {
	
		name = dict[@"name"];
		category = dict[@"category"];
		imgName = [name stringByAppendingString:@".png"];
		thumbImgName = [name stringByAppendingString:@"_thumb.png"];
	}
    return self;
}

@end
