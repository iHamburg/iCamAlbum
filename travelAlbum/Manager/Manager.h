//
//  Manager.h
//  TravelAlbum_1_0
//
//  Created by  on 25.04.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilities.h"

@interface Manager : NSObject

+(id)sharedInstance;

- (void)load;

- (void)save;
@end
