//
//  FileManager.m
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 25.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "FileManager.h"
#include<sys/xattr.h>

@implementation FileManager

+(id)sharedInstance{
	static id sharedInstance;
	if (sharedInstance == nil) {
		
		sharedInstance = [[[self class] alloc]init];
	}
	
	return sharedInstance;
	
}

- (id)init{
	if (self = [super init]) {
		
		fileManager = [NSFileManager defaultManager];
	
	}
	return self;
}

-(void)getFileAttributes:(NSString*)filePath
{
	
	
	NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
	
	if (fileAttributes != nil) {
		NSNumber *fileSize;
		if ((fileSize = [fileAttributes objectForKey:NSFileSize])) {
			NSLog(@"file size:%@",fileSize);
		}
		
	}
	else {
		NSLog(@"Path (%@) is invalid.", filePath);
	}
}

- (void)deleteFile:(NSString*)filePath{
	
    // Delete the file using NSFileManager
	[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}


- (void)deleteFileWithPrefix:(NSString*)prefix{

	[self deleteFileInCacheWithPrefix:prefix];
	[self deleteFileInDocumentWithPrefix:prefix];
	
}

- (void)deleteFileInDocumentWithPrefix:(NSString*)prefix{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(
														 NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSDirectoryEnumerator* en = [fileManager enumeratorAtPath:documentsDirectory];
	NSError* err = nil;
	BOOL res;
	
	NSString* file;
	while (file = [en nextObject]) {
		NSRange range = [file rangeOfString:prefix];
		if (range.location == NSNotFound) {
			continue;
		}
		
		NSLog(@"file # %@",file); // file # 20121207091839.alb_1_previewImage
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:file];
		
		res = [fileManager removeItemAtPath:filePath error:&err];
		if (!res && err) {
			NSLog(@"oops: %@", err);
		}
	}
	
}
- (void)deleteFileInCacheWithPrefix:(NSString*)prefix{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectioryPath = [paths objectAtIndex:0];
	NSString *albumCacheDirectoryPath = [cacheDirectioryPath stringByAppendingPathComponent:kAlbumCacheDirectory];
	
	NSDirectoryEnumerator* en = [fileManager enumeratorAtPath:albumCacheDirectoryPath];
	NSError* err = nil;
	BOOL res;
	
	NSString* file;
	while (file = [en nextObject]) {
		NSRange range = [file rangeOfString:prefix];
		if (range.location == NSNotFound) {
			continue;
		}
		
		NSLog(@"file # %@",file); // file # 20121207091839.alb_1_previewImage
		NSString *filePath = [albumCacheDirectoryPath stringByAppendingPathComponent:file];
		
		res = [fileManager removeItemAtPath:filePath error:&err];
		if (!res && err) {
			NSLog(@"oops: %@", err);
		}
	}
}

+ (void)copyFile:(NSString*)filePath to:(NSString*)toFilePath{
    
    [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:toFilePath error:nil];
    

}

/**
 
 如果已经有了文件夹，就不会操作，返回true
 */
- (void)createCachesDirectory{
	
//	NSLog(@"filePath # %@",filePath);

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectioryPath = [paths objectAtIndex:0];
	NSString *albumCacheDirectoryPath = [cacheDirectioryPath stringByAppendingPathComponent:kAlbumCacheDirectory];
	
	NSError* err = nil;
	if(![[NSFileManager defaultManager] createDirectoryAtPath:albumCacheDirectoryPath withIntermediateDirectories:YES attributes:nil error:&err]){
		NSLog(@"Create Caches Error # %@",err.description);
	}

}


+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePath {
    if (&NSURLIsExcludedFromBackupKey == NULL) {
        // Use iOS 5.0.1 mechanism
		NSLog(@"iOS5.0.1");
        const char *cfilePath = [filePath fileSystemRepresentation];
		
        const char *attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
		
        int result = setxattr(cfilePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
		
//		NSLog(@"result # %d",result);
        return result == 0;
    }
	else {
        // Use NSURLIsExcludedFromBackupKey mechanism, iOS 5.1+
		
		//即使没有这个filepath，也能succesful！！！
		
//		NSLog(@"iOS5.1");
        NSError *error = nil;
		NSURL *url = [[NSURL alloc]initFileURLWithPath:filePath];
		

        BOOL success = [url setResourceValue:[NSNumber numberWithBool:YES]
									  forKey:NSURLIsExcludedFromBackupKey
									   error:&error];
		//Check your error and take appropriate action
		if (!success) {
			NSLog(@"add error # %@",[error debugDescription]);
		}
		else{
			NSLog(@"add successful!");
		}
        return success;
    }
}

@end
