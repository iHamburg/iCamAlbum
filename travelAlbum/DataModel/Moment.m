//
//  Moment.m
//  XappTravelAlbum
//
//  Created by  on 21.01.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "Moment.h"
#import "FileManager.h"
#import "Protocols.h"
#import "UtilLib.h"

@interface Moment()

- (void)encodeElements __deprecated;  //save前， 把所有的widget-》CodingObj，如果明确了Model和View，应该就不用转换了
- (void)decodeElements __deprecated;  //load后， 把所有的CodingObj-》Widget，存放到elements中

@end

@implementation Moment


- (NSArray*)codingObjkeys{
	if (!_codingObjkeys) {
		_codingObjkeys = [NSArray arrayWithObjects:@"bgURL",@"bgImageName",@"codingElements",@"name",@"captionText", nil];
	}
	return _codingObjkeys;
}

- (NSString*)previewImgName{
	return [NSString stringWithFormat:@"%@_previewImage",_name];
}

- (BOOL)isEmptyMoment{
    
    /// 没有图片和文字
    if (ISEMPTY(_codingElements) && ISEMPTY(_captionText)) {
        return YES;
    }
    else{
        return NO;
    }
}

- (UIImage*)previewImage{
//    return [UIImage imageWithSystemName:self.previewImgName];
    
    UIImage *img = [UIImage imageWithCacheName:self.previewImgName];
    
    return img;
}
- (void)setPreviewImage:(UIImage *)previewImage_{

    [previewImage_ saveWithName:self.previewImgName];
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

- (id)initWithName:(NSString*)aName{

	_name = aName;
	
	return [self init];
}


// init & load
- (id)initWithCoder:(NSCoder *)aDecoder{
	
	
	NSMutableArray *emptyKeys = [NSMutableArray array];
	
	for (int i = 0; i<[self.codingObjkeys count]; i++) {
		
		NSString *key = [self.codingObjkeys objectAtIndex:i];
		
		// if the value of key is nil -> saved object didn't contain the key ->
		//   new keys haven been added in the update version,
		if (![aDecoder decodeObjectForKey:key]) {
			[emptyKeys addObject:key];
		}
		else
			[self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
	}
	
	[self load];

	[self loadOthers:aDecoder withEmptyKeys:emptyKeys];
    
//    NSLog(@"coding element # %@",_codingElements);

	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
	
//	[self saveOthers:coder];
	
//    NSLog(@"coding elment # %@",self.codingElements);
    
//	NSLog(@"save Moment with element # %@",self.codingElements);
//	 NSLog(@"bgname # %@, bgurl # %@",self.bgImageName,self.bgURL);
	// 默认保存所有的NSObject
	for (int i = 0; i<[self.codingObjkeys count]; i++) {
		NSString *key = [self.codingObjkeys objectAtIndex:i];
		[coder encodeObject:[self valueForKey:key] forKey:key];
	}
	

//    NSLog(@"coding elment # %@",self.codingElements);

}
- (void)firstLoad{

    //如果album是随机momentBG的，否则应该用默认bg

	_codingElements = [NSMutableArray array];
//
//
}

- (void)load{
	
}
- (void)loadOthers:(NSCoder *)aDecoder withEmptyKeys:(NSArray *)emptyKeys{

	
	if ([emptyKeys containsObject:@"bgImageName"] && [emptyKeys containsObject:@"bgURL"]) {
		_bgImageName = @"Page_BG_2.jpg";
	}
    
	
	[self decodeElements];

//	NSLog(@"load moment with element # %@",self.codingElements);
}

- (void)saveOthers:(NSCoder *)coder{

//	NSLog(@"when save, coding elements # %@",_codingElements);

//	[self encodeElements];

}



#pragma mark -

/// save:
- (void)encodeElements{

}


/// load 如果是old archive,保存的文件中还存在CodingPhoto， 要处理CodingPhoto，CodingText,用PhotoWidget来替代CodingPhoto
- (void)decodeElements{

//	for (int i = 0; i< _codingElements.count; i++) {
//		UIView *v = _codingElements[i];
//		if ([v respondsToSelector:@selector(decodedObject)]) { // CodingPhoto, CodingText
//			
////			NSLog(@"widget # %@ to decode",v);
//			[_codingElements replaceObjectAtIndex:i withObject:[(id<CodingDelegate>)v decodedObject]];
//
//			
//		}
//	}
//	
//	NSLog(@"when loading ,elements # %@",_codingElements);
}

#pragma mark - Delete

/// 删除的是保存在cache中的文件
- (void)deleteDocuments{
    for (UIView<Widget>* widget in _codingElements) {
        if ([widget respondsToSelector:@selector(deleteDocuments)]) {
            [widget deleteDocuments];
        }
    }

    [[FileManager sharedInstance]deleteFile:[NSString cachesPathForFileName:self.previewImgName]];

}

#pragma mark -

- (void)addWidget:(UIView*)widget{
	
	[_codingElements addObject:widget];
}


- (void)deleteWidget:(UIView<Widget>*)widget{
	
	if ([_codingElements containsObject:widget]) {
		[_codingElements removeObject:widget];
	}
	
	//widget 需要删除自己保存的文件
    if ([widget respondsToSelector:@selector(deleteDocuments)]) {
        [widget deleteDocuments];
    }
	
}

@end
