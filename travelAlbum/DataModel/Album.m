//
//  Album.m
//  XappTravelAlbum
//
//  Created by  on 21.01.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.


#import "Album.h"
#import "Moment.h"

#import "FileManager.h"
#import "UtilLib.h"

@interface Album()


@end

@implementation Album

@synthesize coverPhotoImage, numberOfMoments;

- (BOOL) isNewAlbum{
//TODO: all moment should be empty
    if (self.numberOfMoments > 1 ) {
        return NO;
    }
    else if(![[self momentAtIndex:0] isEmptyMoment]){
        return NO;
    }
    else{
        return YES;
    }
}

- (NSArray*)codingObjKeys{
	if (!_codingObjKeys) {
		_codingObjKeys = [NSArray arrayWithObjects:@"moments",@"fileName",@"title",@"password",@"photoPreviewImage",nil];
        
	}
	return _codingObjKeys;
}


- (NSString*)coverPhotoImgName{

    return [_fileName stringByAppendingString:@"_coverPhoto"];
}

- (void)setCoverPhotoImage:(UIImage *)_coverPhotoImage{
	coverPhotoImage = _coverPhotoImage;
	[coverPhotoImage saveWithName:self.coverPhotoImgName];
    
    
}

- (UIImage*)coverPhotoImage{
//	return [UIImage imageWithSystemName:self.coverPhotoImgName];
    
    return [UIImage imageWithCacheName:self.coverPhotoImgName];
}


- (NSString*)pdfName{
	return [_title stringByAppendingPathExtension:@"pdf"];
}

- (int)locked{
    if (ISEMPTY(_password)) {
        return NO;
    }
    else{
        return YES;
    }
}

- (void)setPassword:(NSString *)password{
    _password = password;
    _status = AlbumStatusChanged;
}

- (UIImage*)coverBgImage{
	return [UIImage imageWithSystemName:self.coverBgImgName];
}

- (NSString*)createdDatum{
    
    NSString *year = [_fileName substringWithRange:NSMakeRange(2, 2)];
    NSString *month = [_fileName substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [_fileName substringWithRange:NSMakeRange(6, 2)];
    
    NSString *datum = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    
    return datum;
}

- (int)numberOfMoments{
	return [_moments count];
}

- (NSMutableArray*)momentPreviewImages{
    
	NSMutableArray *array = [NSMutableArray array];
	for (Moment *moment in _moments) {
        
        UIImage *img = moment.previewImage;
        
//        NSLog(@"img Size # %@",NSStringFromCGSize(img.size));
        if (img) {
            [array addObject:img];
        }
        else{
            NSLog(@"nil preview image");
        }
		
	}
	return array;
}

- (NSString*)nextPhotoImgName{
    NSString *imgName = [_fileName stringByAppendingFormat:@"_Photo_%d",_lastPhotoIndex++];
    
    return imgName;
}

#pragma mark - Life Cycle

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
//	L();
	
	NSMutableArray *emptyKeys = [NSMutableArray array];
	
	for (int i = 0; i<[self.codingObjKeys count]; i++) {
		
		NSString *key = [self.codingObjKeys objectAtIndex:i];
		
		
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

//	NSLog(@"self.title # %@, self # %@",self.title,self);
//    NSLog(@"init photoPreviewImage # %@",_photoPreviewImage);
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{


	[self saveOthers:coder];
	
	// 默认保存所有的NSObject
	for (int i = 0; i<[self.codingObjKeys count]; i++) {
		NSString *key = [self.codingObjKeys objectAtIndex:i];
		[coder encodeObject:[self valueForKey:key] forKey:key];
		
	}
	
//	    NSLog(@"save photoPreviewImage # %@",_photoPreviewImage);
}

- (NSString*)createFileName{
    //2012-09-24 20:52:11 +0000.alb  -》20120924205211.alb
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"YYYYMMddhhmmss"];// hh:mm:ss 也是可行的
	NSString *dateStr=[formatter stringFromDate: [NSDate date]];
   NSString *name = [dateStr stringByAppendingPathExtension:@"alb"];


    return name;
}

- (void)firstLoad{
	

    _fileName = [self createFileName];
	
	_title = @"Default Photo Album";
    
	_lastMomentIndex = 1;
    _lastPhotoIndex = 1;

    _loved = NO;
    _password = @"";
    
    _moments = [NSMutableArray array];


}

- (void)load{
	
	
	_status = AlbumStatusUnChanged;
	
    
//    NSString *dateStr = [_fileName substringToIndex:14];
//    float dateFloat = [[_fileName substringToIndex:14] floatValue];
////    int dateInt = [[_fileName substringToIndex:14] lon];
//    NSLog(@"fileName # %@,date # %@,float # %f",_fileName,dateStr,dateFloat);
}


- (void)loadOthers:(NSCoder *)aDecoder withEmptyKeys:(NSArray *)emptyKeys{
	if ([emptyKeys containsObject:@"title"]) {
		_title = @"Title";
	}
	
	
	_lastMomentIndex = [aDecoder decodeIntForKey:@"maxMomentIndex"];
    _lastPhotoIndex = [aDecoder decodeIntForKey:@"lastPhotoNum"];
    _loved = [aDecoder decodeBoolForKey:@"loved"];
}

- (void)saveOthers:(NSCoder *)coder{
	
	[coder encodeInt:_lastMomentIndex forKey:@"maxMomentIndex"];
    [coder encodeInt:_lastPhotoIndex forKey:@"lastPhotoNum"];
    [coder encodeBool:_loved forKey:@"loved"];
	
}

- (NSString*)description{
	
	NSString *str = @"";
	str = [str stringByAppendingFormat:@"filename:%@\n",_fileName];
	str = [str stringByAppendingFormat:@"title:%@\n",_title];
	str = [str stringByAppendingFormat:@"number of moments:%d\n",[_moments count]];

	
	return str;
}

- (Moment*)createMoment{
    Moment *moment = [[Moment alloc]initWithName:[NSString stringWithFormat:@"%@_%d",_fileName,_lastMomentIndex]];
    _lastMomentIndex ++;

    return moment;
}

#pragma mark -



- (Moment*)addMoment{
	
    Moment *moment = [self createMoment];
    
	[_moments addObject:moment];

//	self.momentIndex = self.numberOfMoments - 1;
	
	_status = AlbumStatusChanged;

    return moment;
}

- (Moment*)insertMomentAtIndex:(int)index{
    NSAssert(index>0, @"Error: index");
    
    Moment *moment = [self createMoment];
    [_moments insertObject:moment atIndex:index];
    _status = AlbumStatusChanged;
    return moment;
}
//- (Moment*)addMomentAfterCurrentMoment{
//    Moment *moment = [self createMoment];
//    
//	[_moments insertObject:moment atIndex:self.momentIndex + 1];
//    
//	self.momentIndex ++;
//	
//	_status = AlbumStatusChanged;
//    
//    return moment;
//
//}

- (void)addMoment:(Moment*)moment{
    [_moments addObject:moment];
    _lastMomentIndex ++;
    _status = AlbumStatusChanged;
    
}

//// 把moment插到index的后面一个，
//- (void)addMomentAtIndex:(int)index{
//
//	L();
//	
//	NSParameterAssert(index>=0 && index < [_moments count]);
//	
//	_lastMomentIndex++;
//	Moment *moment = [[Moment alloc]initWithName:[NSString stringWithFormat:@"%@_%d",_fileName,_lastMomentIndex]];
//	[_moments insertObject:moment atIndex:index+1];
//	
//}


- (void)deleteMomentAtIndex:(int)index{
	NSParameterAssert(index>= 0 && index < [_moments count]);

    Moment *moment = _moments[index];
    
	[_moments removeObjectAtIndex:index];
    [moment deleteDocuments];
    
	_status = AlbumStatusChanged;
	
}
- (Moment*)momentAtIndex:(int)index{
    
	NSParameterAssert(index>= 0 && index<[_moments count]);
	
	
	return [_moments objectAtIndex:index];
}


- (void)moveMomentFrom:(int)indexFrom to:(int)indexTo{
	[_moments moveFrom:indexFrom to:indexTo];
	
	_status = AlbumStatusChanged;
}

- (int)indexOfMoment:(Moment*)moment{
    if ([_moments containsObject:moment]) {
        return [_moments indexOfObject:moment];
    }
    else{
        return -1;
    }
}

#pragma mark -

- (void)save{
//    [self displayElement];
    saveArchived(self, self.fileName);
    self.status = AlbumStatusUnChanged;
//     [self displayElement];
}

- (void)deleteDocuments{

	[[FileManager sharedInstance]deleteFileWithPrefix:self.fileName];
}


- (NSComparisonResult)compare: (Album*)otherAlbum{

    if (_loved && !otherAlbum.loved) {
        return NSOrderedAscending;
    }
    else if(!_loved && otherAlbum.loved){
        return NSOrderedDescending;
    }
    
//20130826289152.00
    float dateFloat = [[_fileName substringToIndex:14] floatValue];
    float otherDataFloat = [[otherAlbum.fileName substringToIndex:14]floatValue];
    
    if (dateFloat > otherDataFloat) {
        return NSOrderedAscending;
    }
    else if(dateFloat< otherDataFloat){
        return NSOrderedDescending;
    }
    else{
        return NSOrderedSame;
    }
}

- (void)displayElement{
    for (Moment *m in self.moments) {
        NSLog(@"coding element # %@",m.codingElements);
    }
}

@end
