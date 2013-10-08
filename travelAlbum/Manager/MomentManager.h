//
//  MomentManager.h
//  Everalbum
//
//  Created by AppDevelopper on 13-8-29.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"

extern NSString* const NotificationCurrentMomentIndexChanged;

@interface MomentManager : NSObject

@property (nonatomic, strong) Album *album;
@property (nonatomic, assign) int currentMomentIndex;


@property (nonatomic, readonly, assign) int maxNumOfMoments;
@property (nonatomic, readonly, strong) Moment *currentMoment;
@property (nonatomic, readonly, assign) int numberOfMoments;
@property (nonatomic, readonly, assign) BOOL isCurrentMomentHasCaption;

- (id)initWithAlbum:(Album*)album;

#pragma mark - change Moment
- (Moment*)addMoment;

- (BOOL)deleteMoment;
- (BOOL)toNextMoment;
- (BOOL)toPreviousMoment;
- (void)toMomentAtIndex:(int)index;
- (void)toMoment:(Moment*)moment;
- (Moment*)momentAtIndex:(int)index;
- (BOOL)deleteMomentAtIndex:(int)index;

- (void)moveMomentFrom:(int)fromIndex to:(int)toIndex;

- (void)displayElment;
@end
