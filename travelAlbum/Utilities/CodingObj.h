//
//  CodingObject.h
//  TravelAlbum_1_0
//
//  Created by  on 25.04.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//


//#import "Utilities.h"
#import "QuartzCore/QuartzCore.h"





@interface CodingObj : NSObject<NSCoding, CodingDelegate>{

	NSMutableArray *keys;
	CGRect bounds;
	CGAffineTransform transform;
	CGPoint center;
	CGPoint anchorPoint;

}

@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) CGAffineTransform transform;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGPoint anchorPoint;

@property (nonatomic, strong) NSMutableArray *keys;

- (void)firstLoad;
- (void)load;
- (void)loadOthers:(NSCoder *)aDecoder withEmptyKeys:(NSArray*)emptyKeys;


- (void)saveOthers:(NSCoder*)coder;

@end


