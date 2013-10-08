//
//  IconWidget.h
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 28.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"


@interface IconWidget : UIImageView<Widget, NSCopying>{
	
}

@property (nonatomic, strong) NSString *imgName;


- (id)initWithSticker:(id)sticker;
- (id)initWithCodingIcon:(id)codingIcon;

- (void)load;

@end
