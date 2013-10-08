//
//  FBAlbum.m
//  InstaMagazine
//
//  Created by AppDevelopper on 07.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "FBAlbum.h"

@interface FBAlbum ()

- (void)requestPhotos;

@end

@implementation FBAlbum


/**
 {
 "can_upload" = 0;
 count = 2;
 "cover_photo" = 134759469953130;
 "created_time" = "2011-08-31T18:00:00+0000";
 from =             {
 id = 100002572320629;
 name = "Zh Tom";
 };
 id = 134759466619797;
 link = "http://www.facebook.com/album.php?fbid=134759466619797&id=100002572320629&aid=26860";
 name = "supercry Photos";
 privacy = everyone;
 type = app;
 "updated_time" = "2011-08-31T18:10:56+0000";
 }

 */

- (id)initWithDictionary:(NSDictionary*)dict{
	if (self = [super init]) {
		_albumID = dict[@"id"];
		_name = dict[@"name"];
		_numberOfPhotos = [dict[@"count"] intValue];
		_coverID = dict[@"cover_photo"];
		_fbPhotos = [NSMutableArray array];
		
		[self requestPhotos];
	}
	return self;
}

- (NSString*)description{
	NSString *str = @"";
	str = [str stringByAppendingFormat:@"name:%@\n",_name];
	str = [str stringByAppendingFormat:@"number of cover:%d\n",_numberOfPhotos];
	str = [str stringByAppendingFormat:@"coverLink:%@\n",_coverLink];
	return str;
}

/*
 如果在返回request之前，FBAlbum就被dealloc，
 
 */

- (void)requestPhotos{
	L();
//	NSLog(@"album # %@ request photos, cover # %@",name,coverID);
	
   albumCoverRequest = [[FacebookManager sharedInstance]requestPhoto:_coverID withDelegate:self];
	
   photoInAlbumRequest = [[FacebookManager sharedInstance]requestAlbumPhotos:_albumID withDelegate:self];

	
}



#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	//    NSLog(@"received response");
}


/**
 
 这里面picture的size最大130
 
 "created_time" = "2011-08-31T18:00:00+0000";
 from =     {
 id = 100002572320629;
 name = "Zh Tom";
 };
 height = 39;
 icon = "https://s-static.ak.facebook.com/rsrc.php/v2/yz/r/StEh3RhPvjk.gif";
 id = 134759469953130;
 images =     (
 {
...
 }
 );
 link = "http://www.facebook.com/photo.php?fbid=134759469953130&set=a.134759466619797.26860.100002572320629&type=1";
 picture = "https://fbcdn-photos-a.akamaihd.net/hphotos-ak-ash4/300475_134759469953130_2268230_s.jpg";
 source = "https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-ash4/300475_134759469953130_2268230_n.jpg";
 "updated_time" = "2011-08-31T18:00:01+0000";
 width = 184;
 */

- (void)request:(FBRequest *)request didLoad:(id)result {

//	NSLog(@"request # %@",request.url);
	if (ISEMPTY(result)) {
		NSLog(@"empty result");
		return;
	}

//	NSLog(@"album # %@,result:%@",name,result);
	
    if (request == albumCoverRequest) {
        NSString *aCoverID = result[@"id"];
        
		if ([aCoverID isEqualToString:_coverID]) {
            
			_coverLink = result[@"picture"];
            
			
			//调用 sddownloader
			if (!ISEMPTY(_coverLink)) {
				[SDWebImageDownloader downloaderWithURL:[NSURL URLWithString:[_coverLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] delegate:self];
                
			}
			
		}

    }
    else if(request == photoInAlbumRequest){
        NSArray *photoArray = result[@"data"];
        for (NSDictionary *dict in photoArray) {
            
            FBPhoto *photo = [[FBPhoto alloc]initWithDictionary:dict];
            [_fbPhotos addObject:photo];
            
        }

    }


}


- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@,%@", [[error userInfo] objectForKey:@"error_msg"],[error localizedDescription]);
    NSLog(@"Err code: %d", [error code]);
	
//	[[LoadingView sharedLoadingView] addTitle:@"" inView:]];
}

#pragma mark - SDDownloader
- (void)imageDownloader:(SDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image{
	
	_coverImage = image;

    
}
- (void)imageDownloader:(SDWebImageDownloader *)downloader didFailWithError:(NSError *)error{
	L();
	NSLog(@"error:%@",[error description]);
}

@end
