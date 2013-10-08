//
//  CoverTemplate.m
//  MyPhotoAlbum
//
//  Created by  on 11.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "CoverModel.h"

@implementation CoverModel

@synthesize templateIndex, templateName,thumbName,imgName, displayName; 


- (id)initWithIndex:(int)index Dictionary:(NSDictionary*)dict{
	templateIndex = index;
	if (self = [super init]) {
		
		templateName = [dict objectForKey:@"templateName"];
		displayName = [dict objectForKey:@"displayedName"];
		imgName = [templateName stringByAppendingString:@".jpg"];
		

	
	}
	return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self firstLoad];
		[self load];
    }
    return self;
}

// init & load
- (id)initWithCoder:(NSCoder *)aDecoder{
	
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
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
	[self saveOthers:coder];
	
	// 默认保存所有的NSObject
	for (int i = 0; i<[keys count]; i++) {
		NSString *key = [keys objectAtIndex:i];
		[coder encodeObject:[self valueForKey:key] forKey:key];
	}
	
	
}
- (void)firstLoad{
	

}

- (void)load{
	keys = [NSMutableArray arrayWithObjects:@"bgURL",@"bgImageName",@"codingElements",@"name", nil];
	
}

- (void)loadOthers:(NSCoder *)aDecoder withEmptyKeys:(NSArray *)emptyKeys{
	
	
	if ([emptyKeys containsObject:@"bgImageName"]) {
		
	}
    
}

- (void)saveOthers:(NSCoder *)coder{

	
	
}




@end
