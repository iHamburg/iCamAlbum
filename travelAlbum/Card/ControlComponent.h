/*
   
*/

#import <UIKit/UIKit.h>


@protocol ControlComponentDelegate;

@interface ControlComponent : UIView <UIGestureRecognizerDelegate>
{
	// Views the user can move
   
	UIView *selectedPiece;

//    __unsafe_unretained id<ControlComponentDelegate> delegate;
}
//@property (nonatomic, unsafe_unretained) id<ControlComponentDelegate> delegate;

- (void)addGestureRecognizersToPiece:(UIView *)piece;
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer*)gesture;

@end

@protocol ControlComponentDelegate <NSObject>

@optional

@end
