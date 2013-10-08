//
//  MomentManager.m
//  Everalbum
//
//  Created by AppDevelopper on 13-8-29.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "MomentManager.h"
#import "UtilLib.h"
#import "IAPManager.h"
#import "Moment.h"
@implementation MomentManager

NSString* const NotificationCurrentMomentIndexChanged = @"currentMomentIndexChanged";

@synthesize maxNumOfMoments;

- (int)maxNumOfMoments{
    int numOfMoments;
    if (isPaid()||isIAPFullVersion) {

        numOfMoments = 9999;
	}
	else{

        numOfMoments = 8;
	}

    return numOfMoments;
}

- (int)numberOfMoments{
    return [_album numberOfMoments];
}
- (void)setCurrentMomentIndex:(int)currentMomentIndex{
    _currentMomentIndex  = currentMomentIndex;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationCurrentMomentIndexChanged object:nil];
}

- (Moment*)currentMoment{
    
    return [_album momentAtIndex:_currentMomentIndex];
    
}

- (BOOL)isCurrentMomentHasCaption{
    if (ISEMPTY(self.currentMoment.captionText)) {
        return NO;
    }
    else
        return YES;
}
//+(id)sharedInstance{
//	static id sharedInstance;
//	if (sharedInstance == nil) {
//		
//		sharedInstance = [[[self class] alloc]init];
//	}
//	
//	return sharedInstance;
//	
//}

- (id)initWithAlbum:(Album *)album{
    if (self = [self init]) {
        _album = album;
        
    }
    return self;
}

#pragma mark -

- (NSString*)createRandomPageBGImgName{
//    return @"newBG1.jpg";
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString dataFilePath:@"Material.plist"]];
//    return dict[@"PageBGs"];
    NSArray *array = dict[@"PageBGs"];
    return [array randomObject];
}
#pragma mark - Function

- (Moment*)addMoment{

    if (self.numberOfMoments >= self.maxNumOfMoments) {
        
		[[IAPManager sharedInstance]showBuyRestoreAlert:kIAPFullVersion title:SIAPTitle message:SIAPMsg];
        return nil;
    }
    
//    Moment* moment = [_currentAlbum addMoment];
    
    Moment *moment = [_album insertMomentAtIndex:self.currentMomentIndex + 1];
    
    self.currentMomentIndex ++;
    
    moment.bgImageName = [self createRandomPageBGImgName];
    
    ///保存preview image
    moment.previewImage = [UIImage imageWithSystemName:moment.bgImageName];
    
    return moment;
}

- (BOOL)deleteMoment{
    if (self.numberOfMoments > 1) {
        [_album deleteMomentAtIndex:_currentMomentIndex];
        return YES;
    }
    return NO;
}
- (BOOL)toNextMoment{
  
    if (_currentMomentIndex < _album.numberOfMoments - 1) {
//        self.currentMomentIndex = _currentMomentIndex + 1;
        self.currentMomentIndex ++;
        return YES;
    }
    else{
        return NO;
    }

}

- (void)toMomentAtIndex:(int)index{
    NSAssert(index>= 0 && index <= self.numberOfMoments-1, @"page Index error");
    
    self.currentMomentIndex = index;
}

- (void)toMoment:(Moment*)moment{
    int index = [self.album indexOfMoment:moment];
//    NSLog(@"to moment # %d",index);
    if (index >= 0) {
        self.currentMomentIndex = index;
    }
    else{
        self.currentMomentIndex = 0;
    }
}

- (BOOL)toPreviousMoment{
    if (_currentMomentIndex > 0) {
        self.currentMomentIndex = _currentMomentIndex - 1;
        return YES;
    }

    return NO;
}


- (BOOL)deleteMomentAtIndex:(int)index{
    
    [_album deleteMomentAtIndex:index];
    
    return YES;
}


- (Moment*)momentAtIndex:(int)index{

    
//    NSParameterAssert(index>0 &&index<self.numberOfMoments);
    NSAssert(index>=0 &&index<self.numberOfMoments, @"index # %d",index);
    
    return [_album momentAtIndex:index];
}


- (void)moveMomentFrom:(int)fromIndex to:(int)toIndex{
    [_album moveMomentFrom:fromIndex to:toIndex];
}

- (void)displayElment{
    for (Moment *m in _album.moments) {
        NSLog(@"coding element # %@",m.codingElements);
    }
}
@end
