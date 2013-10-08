//
//  Manager.m
//  TravelAlbum_1_0
//
//  Created by  on 25.04.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "Manager.h"

@implementation Manager


+(id)sharedInstance{
	return nil;
}

- (id)init{

	if (self = [super init]) {
		[self load];
	}
	return self;
}

- (void)load{}

- (void)save{}
@end
