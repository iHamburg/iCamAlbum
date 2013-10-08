//
//  CoverTemplate.h
//  MyPhotoAlbum
//
//  Created by  on 11.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//


/// 储存了Cover的模版信息
@interface CoverModel : NSObject{
	NSMutableArray *keys;
}

@property (nonatomic, assign) int templateIndex;
@property (nonatomic, strong) NSString *templateName;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSString *thumbName;
@property (nonatomic, strong) NSString *coverPhotoImgName;


- (id)initWithIndex:(int)index Dictionary:(NSDictionary*)dict;

@end
