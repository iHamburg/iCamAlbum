//
//  ICEValidator.h
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-24.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "Validator.h"


@interface ICAValidator : Validator{
//   __unsafe_unretained AlbumManagerViewController *vc;
    NSString *truePW;
}

- (id)initWithPassword:(NSString*)truePW_;
@end
