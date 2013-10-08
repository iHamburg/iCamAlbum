//
//  AlbumTests.m
//  Everalbum
//
//  Created by AppDevelopper on 13-8-25.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "AlbumTests.h"
#import "Album.h"
@implementation AlbumTests{
    Album *album, *otherAlbum;
    
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
	album = [[Album alloc]init];
//    NSDate = [NSDate ]
    otherAlbum = [[Album alloc]init];
}

- (void)tearDown
{
    // Tear-down code here.
    
	album = nil;    
    [super tearDown];
}

- (void)testAlbumInitalState{
    
    STAssertFalse(album.loved, @"album init no loved");
    STAssertEqualObjects(album.password, @"", @"album init password ");
    STAssertTrue(ISEMPTY(album.password), @"password in empty");
    STAssertNotNil(album.password, @"password isn't nil");
    
}

- (void)testLovedAlbumBeforeUnloved{
    
}

- (void)test2AlbumsCreateAtTheSameTime{
//    STAssertFalse([album.fileName isEqualToString:otherAlbum.fileName], @"filename shouldn't be the same");
}

- (void)testNewAlbumIsEmpty{
    STAssertTrue(album.isNewAlbum, @"new is empty");
}
- (void)testAddMomentNotEmpty{
    [album addMoment];
    STAssertFalse(album.isNewAlbum, @"add moment isnot empty");
}
- (void)testAddElementsNotEmpty{
//    [album addWidgets:]
}
@end
