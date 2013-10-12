/*
   
*/

#import <UIKit/UIKit.h>


@protocol ControlComponentDelegate;

@interface ControlComponent : UIView <UIGestureRecognizerDelegate>
{
	// Views the user can move
   
	UIView *selectedPiece;


}

- (void)addGestureRecognizersToPiece:(UIView *)piece;
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer*)gesture;

@end

@protocol ControlComponentDelegate <NSObject>

@optional

@end
