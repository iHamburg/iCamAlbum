
// free: 699053198
// paid: 699048547

///------------------ Info -------------------//
#pragma mark - Info

#ifdef FREE //free version
	#define kAppID 699053198
    #define SRecommendEmailBody @"<br/>Check it out! <a href=\"http://bit.ly/UT3Uqs\">bit.ly/UT3Uqs</a>"


#else   // paid version
    #define kAppID 699048547

    #define SRecommendEmailBody @"<br/>Check it out! <a href=\"http://bit.ly/SntNjm\">bit.ly/SntNjm</a>"

#endif


#define STwitter @"iCamAlbum - Album your photos \nCheck it out!"
#define SSupportEmailTitle @"Feedback for iCamAlbum"
#define SRecommendEmailTitle @"iCamAlbum -- Amazing App for Photo Collage Album"

// Facebook
#define SFBCaption @"Album your photos" 
#define SFBPostImageMsg @"via iCamAlbum"
#define SFBDescription @" "


///----------------- Export -------------------//
#pragma mark - Export

#ifdef FREE //free version




#else   // paid version


#endif
#define STwitterPostImageMsg @"\nvia iCamAlbum"
#define SShareImageEmailBody @"Created via <a href=https://itunes.apple.com/de/app/id699053198?l=en&mt=8>iCamAlbum</a> for iPhone, iPad, and iPod Touch."
#define SSharePDFEmailBody @"Created via <a href=https://itunes.apple.com/de/app/id699053198?l=en&mt=8>iCamAlbum</a> for iPhone, iPad, and iPod Touch."

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

