//
//  BGViewController.h
//  iCamAlbum
//
//  Created by AppDevelopper on 13-9-13.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGViewController : UIViewController{
    UIImageView *bgV1, *bgV2;
    
    NSString *currentImgName;
    
    NSArray *bgImgNames;
}

- (void)beginUpdate;
- (void)stopUpdate;
@end
