//
//  CodingObject.m
//  TravelAlbum_1_0
//
//  Created by  on 25.04.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "CodingObj.h"

@implementation CodingObj

@synthesize keys, bounds,transform,center,anchorPoint;

//object第一此被调用,会由firstLoad

- (id)init{
	if (self = [super init]) {
		[self firstLoad];
		
		// load 会定义keys
		[self load];
		
		// setup maybe unnecessary
		[self setup];
	}
	return self;
}


//如果是被loadArchived调用的load
- (id)initWithCoder:(NSCoder *)aDecoder{
	
	// keys will be initialized in "load", key不用static是为了subclass的考虑，其实也可以用static string
	[self load];
	
	NSMutableArray *emptyKeys = [NSMutableArray array];

	for (int i = 0; i<[keys count]; i++) {
		
		NSString *key = [keys objectAtIndex:i];

		 // if the value of key is nil -> saved object didn't contain the key -> 
		//   new keys haven been added in the update version, 
		if (![aDecoder decodeObjectForKey:key]) {
			[emptyKeys addObject:key];
		}
		else
			[self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
	}
	
	[self loadOthers:aDecoder withEmptyKeys:emptyKeys];
	
//	[self setup];


	return self;
}

- (void)firstLoad{}

- (void)load{
	keys = [NSMutableArray array];
}


- (void)loadOthers:(NSCoder *)aDecoder withEmptyKeys:(NSArray*)emptyKeys{
	
}
- (void)setup{
	
}

#pragma mark - Save

// 要求:在Controller调用saveArchived时会调用encode来save object
// 如果是array或是dictionary的话可以直接调用writefofile,当然保存的object都要是能够save的!

- (void) encodeWithCoder: (NSCoder *)coder
{
	
	// 保存int,bool等非NSObject， 及处理保存前的设置:比如说UIImageView的设置image = nil
	[self saveOthers:coder];
	
	// 默认保存所有的NSObject
	for (int i = 0; i<[keys count]; i++) {
		NSString *key = [keys objectAtIndex:i];
		[coder encodeObject:[self valueForKey:key] forKey:key];
	}
	

}

- (void)saveOthers:(NSCoder *)coder{
	
}
- (void)willSave{}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone{
	
	CodingObj* clone =[[[self class] allocWithZone:zone] init];
	
	clone.keys = self.keys;
	
	return clone;
}

#pragma mark -

- (id)decodedObject{
	return nil;
}
@end
