/*
    File: MainViewController.m
Abstract: View controller class for AddMusic. Sets up user interface, responds 
to and manages user interaction.
 Version: 1.1

Copyright (C) 2009 Apple Inc. All Rights Reserved.

*/


#import "IpodMusicLibraryViewController.h"
#import <Foundation/Foundation.h>
#import "ViewController.h"

@implementation IpodMusicLibraryViewController


@synthesize userMediaItemCollection;	// the media item collection created by the user, using the media item picker	
@synthesize playBarButton;				// the button for invoking Play on the music player
@synthesize pauseBarButton;				// the button for invoking Pause on the music player
@synthesize musicPlayer;				// the music player, which plays media items from the iPod library

@synthesize addOrShowMusicButton;		// the button for invoking the media item picker. if the user has already
										//		specified a media item collection, the title changes to "Show Music" and
										//		the button invokes a table view that shows the specified collection

@synthesize interruptedOnPlayback;		// A flag indicating whether or not the application was interrupted during 
										//		application audio playback
@synthesize playedMusicOnce;			// A flag indicating if the user has played iPod library music at least one time
										//		since application launch.
@synthesize playing;					// An application that responds to interruptions must keep track of its playing/
										//		not-playing state.

@synthesize picker;
//@synthesize parent;

- (MPMediaPickerController*)picker{
	if (!picker) {
		picker =
		[[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
		
		picker.delegate						= self;
		picker.allowsPickingMultipleItems	= NO;
		picker.prompt						= NSLocalizedString (@"Add a song to play", "Prompt in media item picker");
	}
    return picker;
}

#pragma mark -

- (void)loadView{
	self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
	self.view.backgroundColor = [UIColor redColor];

}


// Configure the application.
- (void) viewDidLoad {
	
    [super viewDidLoad];
	
	
	
	[self setPlayedMusicOnce: NO];
	
	
	
//	[nowPlayingLabel setText: NSLocalizedString (@"Instructions", @"Brief instructions to user, shown at launch")];
	
	[self setMusicPlayer: [MPMusicPlayerController applicationMusicPlayer]];
	
	// By default, an application music player takes on the shuffle and repeat modes
	//		of the built-in iPod app. Here they are both turned off.
	[musicPlayer setShuffleMode: MPMusicShuffleModeOff];
//	[musicPlayer setRepeatMode: MPMusicRepeatModeNone];
	[musicPlayer setRepeatMode:MPMusicRepeatModeAll];
	
	[self registerForMediaPlayerNotifications];
	
}


#pragma mark Application state management_____________

- (void) didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void) viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	/*
	 // This sample doesn't use libray change notifications; this code is here to show how
	 //		it's done if you need it.
	 [[NSNotificationCenter defaultCenter] removeObserver: self
	 name: MPMediaLibraryDidChangeNotification
	 object: musicPlayer];
	 
	 [[MPMediaLibrary defaultMediaLibrary] endGeneratingLibraryChangeNotifications];
	 
	 */
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
												  object: musicPlayer];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
												  object: musicPlayer];
	
	[musicPlayer endGeneratingPlaybackNotifications];
	
	
}


#pragma mark Music control________________________________

// A toggle control for playing or pausing iPod library music playback, invoked
//		when the user taps the 'playBarButton' in the Navigation bar. 
- (IBAction) playOrPauseMusic: (id)sender {

	MPMusicPlaybackState playbackState = [musicPlayer playbackState];

	if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
		[musicPlayer play];
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
		[musicPlayer pause];
	}
	
}

// If there is no selected media item collection, display the media item picker. If there's
// already a selected collection, display the list of selected songs.
- (IBAction) AddMusicOrShowMusic: (id) sender {    

	
	    picker =
			[[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
		
		picker.delegate						= self;
		picker.allowsPickingMultipleItems	= NO;
		picker.prompt						= NSLocalizedString (@"Add songs to play", "Prompt in media item picker");
		
	if (isPad) {
//		[[ViewController sharedInstance]popViewController:picker fromBarbuttonItem:sender];
	}
//	[[ViewController sharedInstance]popViewController:picker fromBarbuttonItem:sender];
}

- (void) stopMusic{
	[musicPlayer stop];
}

#pragma mark -
// Invoked by the delegate of the media item picker when the user is finished picking music.
//		The delegate is either this class or the table view controller, depending on the 
//		state of the application.
- (void) updatePlayerQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection {

	// Configure the music player, but only if the user chose at least one song to play
	if (mediaItemCollection) {

		// If there's no playback queue yet...
		if (userMediaItemCollection == nil || YES) {  // 人工设置不排队
		
			// apply the new media item collection as a playback queue for the music player
			[self setUserMediaItemCollection: mediaItemCollection];
			[musicPlayer setQueueWithItemCollection: userMediaItemCollection];
			[self setPlayedMusicOnce: YES];
			[musicPlayer play];
			
//			MPMediaItem *representativeItem = [mediaItemCollection representativeItem];//mediaItemCollection is MPMediaItemCollectionObject
//			NSString *albumName = [representativeItem valueForProperty: MPMediaItemPropertyTitle];
//			NSLog(@"songname:%@",albumName);

//			[parent didUsedMusic:albumName];
            [_delegate ipodMusicLibraryDidSelectedMusic];
		}
		else {

			// Take note of whether or not the music player is playing. If it is
			//		it needs to be started again at the end of this method.
			BOOL wasPlaying = NO;
			if (musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
				wasPlaying = YES;
			}
			
			// Save the now-playing item and its current playback time.
			MPMediaItem *nowPlayingItem			= musicPlayer.nowPlayingItem;
			NSTimeInterval currentPlaybackTime	= musicPlayer.currentPlaybackTime;

			// Combine the previously-existing media item collection with the new one
			NSMutableArray *combinedMediaItems	= [[userMediaItemCollection items] mutableCopy];
			NSArray *newMediaItems				= [mediaItemCollection items];
			[combinedMediaItems addObjectsFromArray: newMediaItems];
			
			[self setUserMediaItemCollection: [MPMediaItemCollection collectionWithItems: (NSArray *) combinedMediaItems]];

			// Apply the new media item collection as a playback queue for the music player.
			[musicPlayer setQueueWithItemCollection: userMediaItemCollection];
			
			// Restore the now-playing item and its current playback time.
			musicPlayer.nowPlayingItem			= nowPlayingItem;
			musicPlayer.currentPlaybackTime		= currentPlaybackTime;
			
			// If the music player was playing, get it playing again.
			if (wasPlaying) {
				[musicPlayer play];
			}
		}

		self.navigationController.navigationBarHidden = NO;
		[picker.navigationController popViewControllerAnimated:YES];

	}
}

// If the music player was paused, leave it paused. If it was playing, it will continue to
//		play on its own. The music player state is "stopped" only if the previous list of songs
//		had finished or if this is the first time the user has chosen songs after app 
//		launch--in which case, invoke play.
- (void) restorePlaybackState {

	if (musicPlayer.playbackState == MPMusicPlaybackStateStopped && userMediaItemCollection) {

		[addOrShowMusicButton	setTitle: NSLocalizedString (@"Show Music", @"Alternate title for 'Add Music' button, after user has chosen some music")
								forState: UIControlStateNormal];
		
		if (playedMusicOnce == NO) {
		
			[self setPlayedMusicOnce: YES];
			[musicPlayer play];
		}
	}

}



#pragma mark Media item picker delegate methods________

// Invoked when the user taps the Done button in the media item picker after having chosen
//		one or more media items to play.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
  

	
	// Apply the chosen songs to the music player's queue.
	[self updatePlayerQueueWithMediaCollection: mediaItemCollection];


}

// Invoked when the user taps the Done button in the media item picker having chosen zero
//		media items to play
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {


	L();
//	self.navigationController.navigationBarHidden = NO;
//	[picker.navigationController popViewControllerAnimated:YES];
    [_delegate ipodMusicLibraryDidCancel];
}



#pragma mark Music notification handlers__________________

// When the now-playing item changes, update the media item artwork and the now-playing label.
- (void) handle_NowPlayingItemChanged: (id) notification {

//	MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
//	
//	// Assume that there is no artwork for the media item.
//
//	
//	// Get the artwork from the current media item, if it has artwork.
//	MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
//	
//	// Obtain a UIBarButtonItem object and initialize it with the UIButton object
//		// Display the new media item artwork
////	[navigationBar.topItem setRightBarButtonItem: artworkItem animated: YES];
//	
//	// Display the artist and song name for the now-playing media item
//	[nowPlayingLabel setText: [
//			NSString stringWithFormat: @"%@ %@ %@ %@",
//			NSLocalizedString (@"Now Playing:", @"Label for introducing the now-playing song title and artist"),
//			[currentItem valueForProperty: MPMediaItemPropertyTitle],
//			NSLocalizedString (@"by", @"Article between song name and artist name"),
//			[currentItem valueForProperty: MPMediaItemPropertyArtist]]];
//
//	if (musicPlayer.playbackState == MPMusicPlaybackStateStopped) {
//		// Provide a suitable prompt to the user now that their chosen music has 
//		//		finished playing.
//		[nowPlayingLabel setText: [
//				NSString stringWithFormat: @"%@",
//				NSLocalizedString (@"Music-ended Instructions", @"Label for prompting user to play music again after it has stopped")]];
//
//	}
}



// When the playback state changes, set the play/pause button in the Navigation bar
//		appropriately.
- (void) handle_PlaybackStateChanged: (id) notification {

	MPMusicPlaybackState playbackState = [musicPlayer playbackState];
	
	if (playbackState == MPMusicPlaybackStatePaused) {
	
		self.navigationItem.leftBarButtonItem = playBarButton;
		
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
	
		self.navigationItem.leftBarButtonItem = pauseBarButton;

	} else if (playbackState == MPMusicPlaybackStateStopped) {
	
		self.navigationItem.leftBarButtonItem = playBarButton;
		
		// Even though stopped, invoking 'stop' ensures that the music player will play  
		//		its queue from the start.
		[musicPlayer stop];

	}
}

- (void) handle_iPodLibraryChanged: (id) notification {

	// Implement this method to update cached collections of media items when the 
	// user performs a sync while your application is running. This sample performs 
	// no explicit media queries, so there is nothing to update.
}



//
//
//
//#pragma mark AV Foundation delegate methods____________
//
//- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) appSoundPlayer successfully: (BOOL) flag {
//
//	playing = NO;
//	[appSoundButton setEnabled: YES];
//}
//
//- (void) audioPlayerBeginInterruption: player {
//
//	NSLog (@"Interrupted. The system has paused audio playback.");
//	
//	if (playing) {
//	
//		playing = NO;
//		interruptedOnPlayback = YES;
//	}
//}
//
//- (void) audioPlayerEndInterruption: player {
//
//	NSLog (@"Interruption ended. Resuming audio playback.");
//	
//	// Reactivates the audio session, whether or not audio was playing
//	//		when the interruption arrived.
//	[[AVAudioSession sharedInstance] setActive: YES error: nil];
//	
//	if (interruptedOnPlayback) {
//	
//		[appSoundPlayer prepareToPlay];
//		[appSoundPlayer play];
//		playing = YES;
//		interruptedOnPlayback = NO;
//	}
//}
//

// To learn about notifications, see "Notifications" in Cocoa Fundamentals Guide.
- (void) registerForMediaPlayerNotifications {

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter addObserver: self
						   selector: @selector (handle_NowPlayingItemChanged:)
							   name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
							 object: musicPlayer];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_PlaybackStateChanged:)
							   name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
							 object: musicPlayer];

/*
	// This sample doesn't use libray change notifications; this code is here to show how
	//		it's done if you need it.
	[notificationCenter addObserver: self
						   selector: @selector (handle_iPodLibraryChanged:)
							   name: MPMediaLibraryDidChangeNotification
							 object: musicPlayer];
	
	[[MPMediaLibrary defaultMediaLibrary] beginGeneratingLibraryChangeNotifications];
*/

	[musicPlayer beginGeneratingPlaybackNotifications];
}


@end
