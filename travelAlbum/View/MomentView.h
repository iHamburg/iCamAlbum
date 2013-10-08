//
//  MomentView.h
//  XappTravelAlbum
//
//  Created by  on 25.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Moment.h"
#import "PhotoAlbumLoader.h"


/**
 moment 还是用bgurl来导入图片？
 */

@class EditControlComponent;

extern NSString *const NotificationChangeCaption;

@interface MomentView : UIView<PhotoAlbumLoaderDelegate, UIAlertViewDelegate>{

	EditControlComponent *controlComp;
	UIImageView *bgV;
    UIView *widgetContainer;
    UILabel *captionL;
    UIAlertView *captionAlert;
}


@property (nonatomic, strong) Moment *moment;
@property (nonatomic, assign) BOOL isShakeLock;
@property (nonatomic, assign, getter = isMomentChanged) BOOL momentChanged;
@property (nonatomic, strong) NSString *captionText;


/**
 
 moment会加入codingElement，mv会addsubview
 */
- (void)addElement:(UIView*)element; // for photo crop

- (void)addElementRandomed:(UIView*)element;

/**
 
  如果momentView已经有了widget，就不会加入了
 */
- (BOOL)addTextWidget:(id)textWidget;

- (void)deleteElement:(UIView*)element;
- (void)copyElement:(UIView*)element;
- (BOOL)containElement:(UIView*)v; // editVC 在finishText会调用

- (void)lockUnlockAllWidgets;

- (void)savePreviewImage;

- (void)fadeSubviewsExcept:(UIView*)v;
- (void)unfadeSubviews;

- (void)bringWidgetToFront:(UIView*)widget;

- (id)convertPhotoElementToImv:(id)element;

@end

