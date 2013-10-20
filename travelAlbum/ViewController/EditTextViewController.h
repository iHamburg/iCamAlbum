//
//  EditTextViewController.h
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 26.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "LabelModelView.h"
#import "TextViewController.h"



@interface EditTextViewController : TextViewController<UITextViewDelegate>{
	
    LabelModelView *_labelMV;
    
	
    
}


@end
