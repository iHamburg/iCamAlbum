//
//  AlbumManagerTests.m
//  Everalbum
//
//  Created by AppDevelopper on 13-8-25.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "AlbumManagerTests.h"
#import "AlbumManager.h"

@implementation AlbumManagerTests{
    AlbumManager *manager;
    Album *album;
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
//	manager = [AlbumManager sharedInstance];
    manager = [[AlbumManager alloc]init];
    album = manager.newAlbum;
//    [manager adda]
}

- (void)tearDown
{
    // Tear-down code here.
    
	manager = nil;
    [super tearDown];
}

- (void)testDefaultAlbum{

    STAssertNotNil(manager.currentAlbum, @"default album shouldn't nil");
    STAssertTrue(manager.currentAlbumIndex == 0, @"default albumIndex == 0");
    
}

- (void)testAddAlbum{
//    
    NSLog(@"num of albums # %d",manager.numberOfAllAlbums);
    
    [manager addAlbumWithTitle:@"abc"];
    
//    NSLog(@"num of albums # %d",manager.numberOfAllAlbums);
    STAssertTrue(manager.numberOfAllAlbums == 2, @"");
    
    [manager addAlbumWithTitle:@"def"];
    
//    NSLog(@"num of albums # %d",manager.numberOfAllAlbums);
    STAssertTrue(manager.numberOfAllAlbums == 3, @"");
    
}

- (void)testDeleteLastAlbum{
  
//    NSLog(@"num of albums # %d",manager.numberOfAllAlbums);
    [manager deleteCurrentAlbum];
    STAssertTrue(manager.numberOfAllAlbums == 1, @"can't delete last album");
}

- (void)testAddAlbumAfterCurrentIndex{
//    Album *a1 = [manager addAlbumWithTitle:@"1"];
    
}

@end
