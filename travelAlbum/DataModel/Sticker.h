//
//  Icon.h
//  InstaMagazine
//
//  Created by AppDevelopper on 12.11.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilities.h"

extern NSString *const StickerChristmas;

@interface Sticker : NSObject

@property (nonatomic, strong) NSString *name, *imgName, *thumbImgName, *category;

- (id)initWithDictionary:(NSDictionary*)dict;

@end
