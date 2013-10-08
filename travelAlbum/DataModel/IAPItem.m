//
//  IAP.m
//  InstaMagazine
//
//  Created by AppDevelopper on 20.11.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "IAPItem.h"
#import "UtilLib.h"

@implementation IAPItem

@synthesize name,identifier,iapDescription,iapTitle,iconImageName,previewImageName, availableFlag;

- (NSString*)iconImageName{
	return [name stringByAppendingString:@"_icon.jpg"];
}

- (NSString*)previewImageName{
	return [name stringByAppendingString:@"_preview.jpg"];
}

- (BOOL)availableFlag{

	return [[NSUserDefaults standardUserDefaults] boolForKey:identifier];

}
- (id)initWithDictionary:(NSDictionary*)dict{
	if (self = [super init]) {
        
		name = dict[@"name"];
		identifier = dict[isPaid()?@"identifierPro":@"identifierFree"];
		iapDescription = dict[@"description"];
		iapTitle = dict[@"title"];
	}
	return self;
}
@end
