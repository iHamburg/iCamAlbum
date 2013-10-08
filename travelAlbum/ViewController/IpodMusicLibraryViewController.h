/*
    File: MainViewController.h
Abstract: View controller class for AddMusic. Sets up user interface, responds 
to and manages user interaction.
 Version: 1.1


Copyright (C) 2009 Apple Inc. All Rights Reserved.

*/

//#define PLAYER_TYPE_PREF_KEY @"player_type_preference"
//#define AUDIO_TYPE_PREF_KEY @"audio_technology_preference"

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol IpodMusicLibraryDelegate;

@interface IpodMusicLibraryViewController : UIViewController <MPMediaPickerControllerDelegate, AVAudioPlayerDelegate> {

	
	BOOL						playedMusicOnce;

	IBOutlet UIButton			*addOrShowMusicButton;
	BOOL						interruptedOnPlayback;
	BOOL						playing ;

	UIBarButtonItem				*playBarButton;
	UIBarButtonItem				*pauseBarButton;
	MPMusicPlayerController		*musicPlayer;	
	MPMediaItemCollection		*userMediaItemCollection;
	MPMediaPickerController     *picker;

}

@property (readwrite)			BOOL					playedMusicOnce;
@property (nonatomic, strong)	UIBarButtonItem			*playBarButton;
@property (nonatomic, strong)	UIBarButtonItem			*pauseBarButton;
@property (nonatomic, strong)	MPMediaItemCollection	*userMediaItemCollection; 
@property (nonatomic, strong)	MPMusicPlayerController	*musicPlayer;
@property (nonatomic, strong)   MPMediaPickerController *picker;

@property (nonatomic, strong)	IBOutlet UIButton		*addOrShowMusicButton;
@property (readwrite)			BOOL					interruptedOnPlayback;
@property (readwrite)			BOOL					playing;

//@property (nonatomic, unsafe_unretained) PreviewSettingViewController *parent;
@property (nonatomic, unsafe_unretained) id<IpodMusicLibraryDelegate> delegate;

- (IBAction)playOrPauseMusic:		(id) sender;
- (IBAction)AddMusicOrShowMusic:	(id) sender;
- (void) stopMusic;


@end

@protocol IpodMusicLibraryDelegate <NSObject>

- (void)ipodMusicLibraryDidSelectedMusic;
- (void)ipodMusicLibraryDidCancel;
@end
