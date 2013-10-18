//
//  EditControlComponent.h
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 25.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "ControlComponent.h"
#import "MomentView.h"
#import "Protocols.h"


@interface EditControlComponent : ControlComponent{
	UIView<Widget> *selectedWidget;
   
}

@property (nonatomic, unsafe_unretained) MomentView *momentV;

@end
