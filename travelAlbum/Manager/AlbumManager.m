//
//  AlbumManager.m
//  TravelAlbum_1_0
//
//  Created by  on 25.04.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "AlbumManager.h"
#import "FileManager.h"
#import "UtilLib.h"
#import "ExportController.h"
#import "ICARootViewController.h"
#import "Moment.h"

#define kArchivedNameAlbumNames @"albumFileNames"


@interface AlbumManager()

@end

@implementation AlbumManager



- (void)setCurrentAlbumStatus:(AlbumStatus)currentAlbumStatus{
    self.currentAlbum.status = currentAlbumStatus;
}


- (void)setTitleOfCurrentAlbum:(NSString *)titleOfCurrentAlbum{
    self.currentAlbum.title = titleOfCurrentAlbum;
    
    [self saveCurrentAlbum];
    

}

- (void)setCurrentAlbumIndex:(int)currentAlbumIndex{
    _currentAlbumIndex = currentAlbumIndex;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"currentAlbumIndexChanged" object:nil];
}

- (int)numberOfDisplayedAlbums{
    return [self.displayedAlbums count];
}

- (int)numberOfAllAlbums{
    return _allAlbums.count;
}



- (int)maxNumOfAlbums{
    int maxNumOfAlbums;
    if (isPaid()||isIAPFullVersion) {
		maxNumOfAlbums = 9999;

	}
	else{
		maxNumOfAlbums = 4;

	}
    
    return maxNumOfAlbums;
}
- (NSString*)titleOfCurrentAlbum{

    return self.currentAlbum.title;

}

- (BOOL)isCurrentAlbumEmpty{
    return self.currentAlbum.isNewAlbum;
}

- ( BOOL)isThereFavoritedAlbum{
    BOOL flag = NO;
    for (Album *album in _allAlbums) {
        if (album.loved) {
            flag = YES;
            break;
        }
    }
    return flag;
}

- (BOOL)isCurrentAlbumLoved{
    return self.currentAlbum.loved;
}

- (NSArray*)displayedAlbums{

    
    NSMutableArray *array;
    if (_isFavoriteListed) {
        array = [NSMutableArray arrayWithCapacity:_allAlbums.count];
        for (Album *album in _allAlbums) {
            if (album.loved) {
                [array addObject:album];
            }
        }
    }
    else{
        array = [NSMutableArray arrayWithArray:_allAlbums];
    }
    
//    NSLog(@"displayed album # %@",array);
    return array;
}

- (Album*)currentAlbum{

//    NSLog(@"displayedAlbum # %@, currentIndex  # %d",self.displayedAlbums,_currentAlbumIndex);
    
    return self.displayedAlbums[_currentAlbumIndex];

}

- (NSString*)nextPhotoImgName{
    return [self.currentAlbum nextPhotoImgName];
}

static id sharedInstance;

+(id)sharedInstance{
	
	
	if (sharedInstance == nil) {
		
		sharedInstance = [[[self class] alloc]init];
	}
	
	return sharedInstance;
	
}

+(void)releaseSharedInstance{
    
    sharedInstance = nil;
}



- (void)loadEmptyAlbumFileNames
{
    _albumFileNames = [NSMutableArray array];
    
    Album *album = [self musterAlbum];
    if (album) {
        [self addAlbum:[self musterAlbum]];
    }
    else{


        [self addAlbum:[self newAlbum]];
    }
}

- (void)loadAllAlbums
{
    for (NSString *albumName in _albumFileNames) {
//        report_memory();
        //从Cache中载入所有的album
        Album *album = loadArchived(albumName);

        if (album) {
//            NSLog(@"load album # %@",album.title);
            [_allAlbums addObject:album];
            
        }
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        
        //load all album Name from album.plist
        L();
        report_memory();
        
        _allAlbums = [NSMutableArray array];
        
        NSString *albumFilePath = [NSString dataFilePath:kArchivedNameAlbumNames];
       
        _albumFileNames = [NSMutableArray arrayWithContentsOfFile:albumFilePath];
        
        
        if (ISEMPTY(_albumFileNames)) { // first open
            [self loadEmptyAlbumFileNames];
        }
        else {
            
            [self loadAllAlbums];
            
        }

    }
    return self;
}



#pragma mark - Function
/// 专门用来显示muster的album，默认使用
- (Album*)musterAlbum{
    
	NSString *albumName = kMusterAlbumName;
	
    Album *album = loadArchived(albumName);
	album.title = @"iCamAlbum";
	return album;
    
}

- (Album*)newAlbum{
    Album *album = [[Album alloc]init];
    
    Moment *moment = [self createMomentForAlbum:album];
    
    [album addMoment:moment];
    
//    Moment *moment
	NSString *defaultCoverPhotoName = [self createRandomCoverPhotoName];
    album.coverPhotoImage = [UIImage imageWithContentsOfFileUniversal:defaultCoverPhotoName];
 
    album.status = AlbumStatusChanged;
    
    
	return album;

}



- (int)albumIndexOfAlbum:(Album*)album{
    
    if ([_allAlbums containsObject:album]) {
        return [_allAlbums indexOfObject:album];
    }
    else
        return 0;
}

- (Album*)addAlbumWithTitle:(NSString*)title{
    
    if ([self titleIsUsed:title]) {
        return nil;
    }
    else{
        Album *album = [self newAlbum];
        album.title = title;
        [self addAlbum:album];
        
        [self saveAlbumNamePlist];
        [self saveCurrentAlbum];
        return album;
    }
    
}

- (void)addAlbum:(Album *)album{

    int index = 0;
    
    if (!ISEMPTY(_albumFileNames)) {
        index = self.currentAlbumIndex + 1;
    }
    

    [_albumFileNames insertObject:album.fileName atIndex:index];
    [_allAlbums insertObject:album atIndex:index];
}

- (BOOL)deleteCurrentAlbum{
   
    if (self.numberOfAllAlbums < 2) {
        return NO;
    }
    else{
        [self deleteAlbum:self.currentAlbum];
        
        [self saveAlbumNamePlist];
        
        [self saveCurrentAlbum];
        
        return YES;
    }
    
}


- (void)deleteAlbum:(Album*)album{
//	L();
	
	if (!album) {
		NSLog(@"album empty error!");
		return;	
	}
    

	int index = [_allAlbums indexOfObject:album];

  
    [album deleteDocuments];
    
	[_allAlbums removeObjectAtIndex:index];
	[_albumFileNames removeObjectAtIndex:index];


}

- (void)loveAlbum{
    self.currentAlbum.loved = !self.currentAlbum.loved;
    
    [self saveCurrentAlbum];
}

- (BOOL)isPasswordCorrect:(NSString*)password{
    return [password isEqualToString:self.currentAlbum.password];
}

- (void)setupAlbumPassword:(NSString*)password{
    self.currentAlbum.password = password;
    
    [self saveCurrentAlbum];
}
- (void)unlockAlbumPassword{

    self.currentAlbum.password = @"";
    
    [self saveCurrentAlbum];
    
}

- (BOOL)isCurrentAlbumLocked{
    return self.currentAlbum.locked;
}


- (void)setCoverImageOfCurrentAlbum:(UIImage*)image{
//    NSLog(@"manager.currentindex # %d",_currentAlbumIndex);
    
    self.currentAlbum.coverPhotoImage = image;
    
    [self saveCurrentAlbum];
}


- (void)saveAlbumToPhotoLibrary {
    NSString *albumName = [self.currentAlbum.title stringByAppendingFormat:@"_Album"];
    
    NSArray *importImages = self.currentAlbum.momentPreviewImages;
    
    __block int numOfImages = importImages.count;
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    for (UIImage *image in importImages) {
        [library saveImage:image toAlbum:albumName withCompletionBlock:^(NSError *error) {
            
            if (error) {
                showMsg(@"Something wrong");
                
            }
            numOfImages --;
            
            
            if (numOfImages == 0) {
                showMsg(@"Saved!");
            }
            
        } ];
    }
}


- (void)shareCurrentAlbumWithType:(ShareType)type{
   
    L();

	 if(type == ShareAlbumSendPDF){ // send pdf as email

         
         generatePDFWithImages(self.currentAlbum.momentPreviewImages, [NSString cachesPathForFileName:self.currentAlbum.pdfName]);

         [[ExportController sharedInstance]sendPDFwithName:self.currentAlbum.pdfName];
	
     }
	else if(type == ShareAlbumSaveImages){
        
        [self saveAlbumToPhotoLibrary];
        
	}
    else if(type == ShareAlbumSendImages){
     
        [self sendAlbumAsImagesPerEmail];
    
    }
	else if(type == ShareAlbumToFacebook){
        
		[[FacebookManager sharedInstance]uploadNewAlbum:self.titleOfCurrentAlbum imgs:self.currentAlbum.momentPreviewImages];
	}
    else if(type == ShareAlbumSavePDF){

        generatePDFWithImages(self.currentAlbum.momentPreviewImages, [NSString cachesPathForFileName:self.currentAlbum.pdfName]);
        
        [[ExportController sharedInstance]sharePDFWithOtherApp:self.currentAlbum.pdfName inRect:CGRectMake(_w/2, _h/2, 10, 10)];
    }
//
//	NSDictionary *dict = @{
//                        
//                        @"ShareTo": [self stringFromShareType:type],
//                        
//                        };
//    
//	[Flurry logEvent:@"Share Album" withParameters:dict];
}

- (void)createPDFForCurrentAlbum{
  
    
    NSString* pdfFilePath = [NSString cachesPathForFileName:self.currentAlbum.pdfName];
   
    NSArray *imgs = self.currentAlbum.momentPreviewImages;
    
	UIGraphicsBeginPDFContextToFile(pdfFilePath, CGRectZero, nil);
    
    for (UIImage *img in imgs) {
		UIGraphicsBeginPDFPageWithInfo(_r, nil);
        
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
		CGContextFillRect(context, _r);
        
		[img drawInRect:_r];
	}
	
    UIGraphicsEndPDFContext();
    
	

}

- (BOOL)titleIsUsed:(NSString*)newTitle{
    for (Album *album in _allAlbums) {
        if ([album.title isEqualToString:newTitle]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Intern Fcn
- (void)sendAlbumAsImagesPerEmail {
    
    [[ExportController sharedInstance]sendEmailWithImages:self.currentAlbum.momentPreviewImages];
    
}

- (NSString*)createRandomMomentBGImageName{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Material" ofType:@"plist"];
    NSDictionary *materialDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
    NSArray* pageBGNames = [materialDict objectForKey:@"PageBGs"];
    NSArray* page_ChrismasImageNames = materialDict[@"PageBG_Christmas"];
    
    
    NSMutableArray *imgNames = [NSMutableArray array];
    [imgNames addObjectsFromArray:pageBGNames];
	[imgNames addObjectsFromArray:page_ChrismasImageNames];
    
    return [imgNames randomObject];
}

- (Moment *)createMomentForAlbum:(Album *)album {
    Moment *moment = [[Moment alloc]initWithName:[NSString stringWithFormat:@"%@_%d",album.fileName,album.lastMomentIndex]];
  
    moment.bgImageName = [self createRandomMomentBGImageName];
	
    UIImage *previewImg = [UIImage imageWithSystemName:moment.bgImageName];
    
	//ipad retina 扩大到momentV正常size
//	if ([UIDevice resolution] == UIDeviceResolution_iPadRetina) {
//		previewImg = [previewImg imageByScalingAndCroppingForSize:CGSizeMake(_w, _h)];
//	}
    
    moment.previewImage = previewImg;
    return moment;
}


#pragma mark - File Management

- (void)getSizeOfAlbum:(Album*)album{

	[[FileManager sharedInstance] getFileAttributes:[NSString dataFilePath:album.fileName]];
}


#pragma mark - Save

/*
 
 当App关闭是会save所有的changed的album
 
 但如果当前有moment打开，需要save moment
 
 这里的save没有考虑到save当前album的preview img的细节,所以要求之前的album是要保存当前位置的！
 */

- (void)saveAlbumNamePlist{
	L();
	
	/// 先保存album的plist文件
	NSString *albumFileNamePath = [NSString dataFilePath:kArchivedNameAlbumNames];
    
	[_albumFileNames writeToFile:albumFileNamePath atomically:YES];
	
    NSLog(@"alumbFiePath # %@, array # %@",albumFileNamePath,_albumFileNames);
    
//	for (Album *album in _allAlbums) {
//
//		[album save];
//	}
	
}

- (void)saveCurrentAlbum{
    [self.currentAlbum save];
}
//
- (NSString*)createRandomCoverPhotoName{
	// cover photo name CoverPhoto_1.jpg - CoverPhoto_6.jpg
	
	int randomCoverPhotoIndex = arc4random()%6 +1;
	NSString *photoName = [NSString stringWithFormat:@"CoverPhoto_%d.jpg",randomCoverPhotoIndex];
	
//	// 如果photoName在pool里，重新取
//	while ([randomCoverPhotoPool containsObject:photoName]) {
//		int randomCoverPhotoIndex = arc4random()%kCoverPhotoNum +1;
//		photoName = [NSString stringWithFormat:@"CoverPhoto_%d.jpg",randomCoverPhotoIndex];
//	}
//	
//	[randomCoverPhotoPool addObject:photoName];
//	
//	if ([randomCoverPhotoPool count] == kCoverPhotoNum) {
//		[randomCoverPhotoPool removeAllObjects];
//	}
	
	return photoName;
}


@end
