//
//  FileManager.h
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 25.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 fileName 是文件名，
 filePath 是路径
 */

@interface FileManager : NSObject{
	NSFileManager *fileManager;
}

+ (id)sharedInstance;

- (void)createCachesDirectory;
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePath;

+ (void)copyFile:(NSString*)filePath to:(NSString*)toFilePath;

- (void)deleteFile:(NSString*)filePath;
- (void)deleteFileWithPrefix:(NSString*)prefix;
- (void)deleteFileInDocumentWithPrefix:(NSString*)prefix;
- (void)deleteFileInCacheWithPrefix:(NSString*)prefix;


- (void)getFileAttributes:(NSString*)filePath;

@end
