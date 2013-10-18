





#define kManagerShareSaveImgs LString(@"Save  images in photo album")
#define kManagerShareFB       LString(@"Share images to Facebook")
#define kManagerSharePDF      LString(@"Share PDF per Email")
#define kManagerShareApp      LString(@"Share PDF to other Apps")
#define kManagerShareSendImgs LString(@"Share images per Email")

#define SEnterAlbumName       LString(@"Enter the name of the album")
#define SDefaultAlbumName     LString(@"Default Album name")
#define SSetupPW              LString(@"Setup password")
#define SEnterPWAgain         LString(@"Enter the password again")
#define SEnterPWToLock        LString(@"Unlock this album")
#define SEnterPWToValidate    LString(@"Enter the password")
#define SDeleteAlbum          LString(@"Delete this album?")
#define SPWNotMatch           LString(@"Error: Passwords don't match")
#define SEnterWrongPW         LString(@"Error: wrong password")
#define SNoFavoritedAlbum     LString(@"Warning: No favorited album")
#define SShowFavoriteList     LString(@"Show favorites")
#define SAddToFavorite        LString(@"Add to favorites")
#define SRemoveFromFavorite   LString(@"Remove from favorites")
#define SAlbumNameAlreadyUsed LString(@"This name is already used")

#define SChangePhotoTitle     LString(@"Change Cover Photo")

#define STextVCTitle          LString(@"Add Text")

#define SEnterCaption         LString(@"Enter the Caption")
#define SDefaultCaptionText   LString(@"Add Caption")

#define SMomentChangeBG       LString(@"Background")


///----------------- Export -------------------//
#pragma mark - Export


/// Everalbum 没有rate的机制
#define SRateMsgPad @"If you like TinyKitchen and want more free updates, please rate or write your 5-star review on the App Store. This helps and takes less than a minute. Thank you!"
#define SRateMsgPhone @"If you like Everalbum, please rate it on the App Store. Thank you!"

#define SShareImageEmailSubject @"A nice photo collage for you" 
#define SSharePDFEmailSubject @"A nice photo collage album for you" 
#define SShareFBNewAlbumMsg @"Created via Everalbum"


///----------------- Manager -------------------//
#pragma mark - Manager

#define SChoosePhoto @"Add your Photo"


///-------------------  Edit  ---------------------//
#pragma mark - Edit

#define SSaveAlbumAlert @"Saved!"
#define SMemoryWarningMsg @"Memory Warning!"
#define SEditPhotoMsg @"Add the same effect or frame to multiple photos by tapping on them."



/// ------------------ IAP -----------------//
#pragma mark - IAP

#define SIAPTitlePad @"In App Purchase"
#define SIAPMsgPhone @"Unlock the full version with albums and pages unlimited?"
#define SIAPMsgPad @"With this free version you can only use limited number of albums and pages.\nIf you have fun with our app and want to enjoy an unlimited usage, please unlock the full version."
#define SIAPTitle (isPad?@"In App Purchase":nil)
#define SIAPMsg (isPad?@"With this free version you can only use limited number of albums and pages.\nIf you have fun with our app and want to enjoy an unlimited usage, please unlock the full version.":@"Unlock the full version with albums and pages unlimited?")



#define SShareImageEmailSubject @"A Nice Photo Collage for You"
#define SSharePDFEmailSubject @"A Nice Photo Collage Album for You"