//
//  EditControlComponent.m
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 25.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "EditControlComponent.h"
#import "ImageModelView.h"
#import "LabelModelView.h"

@implementation EditControlComponent

@synthesize momentV;

static CGRect innenRect;
- (void)setMomentV:(MomentView *)momentV_{
    momentV = momentV_;
     CGFloat margin = isPad?20:10;
    innenRect = CGRectMake(margin,margin,momentV.width - 2*margin,momentV.height - 2 * margin);
    
}

- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
   

	UIView<Widget> *piece = (UIView<Widget>*)[gestureRecognizer view];
	if (piece.lockFlag) {
		return;
	}
	
	momentV.momentChanged = YES;
	
	if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {

		piece.alpha = 0.7;
		piece.backgroundColor = [UIColor blackColor];
	}
	else {
		piece.alpha = 1;
		piece.backgroundColor = [UIColor clearColor];
	}

	CGPoint point = [gestureRecognizer locationInView:momentV];

//    NSLog(@"point # %@, rect # %@",NSStringFromCGPoint(point),NSStringFromCGRect(innenRect));
	if (!CGRectContainsPoint(innenRect, point)) {
		[piece removeGestureRecognizer:gestureRecognizer];
		
		[[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDeleteWidget object:piece];
		return;
	}
	
	
	[self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
	
	
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
	
	
//	[momentV addSubview:piece];
    [momentV bringWidgetToFront:piece];
    
	
}

// rotate the piece by the current rotation
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
	
	UIView<Widget> *piece = (UIView<Widget>*)[gestureRecognizer view];

	if (piece.lockFlag) {
		return;
	}
	
	momentV.momentChanged = YES;

	[self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
      
		[gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];

    }
}

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
	

	UIView<Widget> *piece = (UIView<Widget>*)[gestureRecognizer view];
	if (piece.lockFlag) {
		return;
	}
	
	momentV.momentChanged = YES;
	
	[self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
		
		//sqrt(a^2+c^2)
		CGAffineTransform transform = piece.transform;
		float scale = sqrt((transform.a) * (transform.a) + (transform.c)*(transform.c));
		
		// 如果widget的scale超过了MaxScale，并且用户是要放大的(gesture。scale》1)，那么就直接return
		// Text 没有这个限制，是因为textwidget不改变transform的scale
		if ((scale>2 && gestureRecognizer.scale>1) || (scale<0.2 && gestureRecognizer.scale<1)) {
			return;
		}
		
		// 如果是text，不改变transform，只改变bounds
		if ( [piece isKindOfClass:[LabelModelView class]]) {
			
			float scale = gestureRecognizer.scale;
			
			[gestureRecognizer setScale:1];

			[(LabelModelView*)piece applyScale:scale];
			
		}
		else{
			[gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
			[gestureRecognizer setScale:1];

			
		}
		
    }
	
	
}

//单击
- (void)handleTap:(UITapGestureRecognizer*)gesture{
	L();

}

- (void)handleDoubleTap:(UITapGestureRecognizer*)gesture{
    L();

	UIView *piece = [gesture view];

	if([piece isKindOfClass:[ImageModelView class]]){
		[momentV copyElement:piece];
	}
	
}

- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
	selectedWidget = (UIView<Widget>*)[gestureRecognizer view];
	
//	[momentV addSubview:selectedWidget];
    [momentV bringWidgetToFront:selectedWidget];
	
	if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
		
        UIMenuController *menuController = [UIMenuController sharedMenuController];

        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];

		
		[self becomeFirstResponder];
	
		
        [menuController setTargetRect:CGRectMake(location.x, location.y, 5, 5) inView:[gestureRecognizer view]];


		menuController.menuItems = [selectedWidget menuItems];

		
        [menuController setMenuVisible:YES animated:YES];
        
		
    }
}



#pragma mark - Menu


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
//	L();
    
//	NSLog(@"action:%@",NSStringFromSelector(action));
    if (action == @selector(menuLockPiece:) || action == @selector(menuUnlockPiece:)|| action == @selector(menuEditPiece:) ||
        action == @selector(menuCropPiece:))
        
        return YES;

    
    return [super canPerformAction:action withSender:sender];
   
}

- (IBAction)menuLockPiece:(id)sender{

	selectedWidget.lockFlag = YES;
	
}

- (IBAction)menuUnlockPiece:(id)sender{
	selectedWidget.lockFlag = NO;
	
}

- (IBAction)menuEditPiece:(id)sender{


	/// 这里有两个选择： 一是让widget自己处理；二是用一个notification发给editVC，让editVC自己加判断处理，我还是选择第一种，这样editVC就不需要难看的多个if判断了
	[selectedWidget handleEdit];
}

- (void)menuCropPiece:(id)sender{
    L();
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationCropPhotoWidget object:selectedWidget];
}
@end
