//
//  ScanIt-Constant.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 24/02/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#ifndef ScanIt_Constant_h
#define ScanIt_Constant_h

#define BASEURL @"http://scanit.in/wslogincontroller/"

//#define BASEURL @"http://thelolstories.com/scanit/wslogincontroller/"

#define BASEURL_FOR_SUGGESTEDRETAIL_AND_PURCHASELIST @"http://scanit.in/wscontroller/"

//#define BASEURL_FOR_SUGGESTEDRETAIL_AND_PURCHASELIST @"http://thelolstories.com/scanit/wscontroller/"

#define FLIPKART_AFFILIATE_LINK @"https://affiliate-api.flipkart.net/affiliate/search/json?"

#define AMAZON_AFFILIATE_LINK @"http://webservices.amazon.in/onca/xml?"

/////********************************************//////

#define DEVICETOKEN @"deviceToken"
#define IMEI @"IMEI"
#define USERID @"UserID"
#define FIRSTNAME @"FirstName"
#define LASTNAME @"LastName"
#define EMAIL @"Email"
#define PHONENUMBER @"ContactNo"
#define PROFILEIMAGE @"ProfileImage"
#define REGISTRATIONTYPE @"reg_type"
#define PASSWORD @"Password"
#define UNIQUEUSERID @"unique_userid"
#define DEVICETYPE @"deviceType"
#define PROFILEIMAGE @"ProfileImage"
#define PRIVATEPROFILE @"PrivateProfile"
#define FACEBOOKCONNECT @"FacebookConnect"
#define CITY @"City"
#define COUNTRY @"Country"
#define ADDRESS @"Address"

////******REGISTRATION AND LOGIN*****////

#define REGISTRATION @"registration"
#define LOGIN @"login"
#define ISLOGGEDIN @"IsLoggedIn"

////*********************************////


////******ADD DEVICE TOKEN*****////

#define ADD_DEVICE_TOKEN @"AddDevicetoken"

////*********************************////


////******FORGOT PASSWORD****////

#define FORGOTPASSWORD @"passForgot"

////**************************///

////*******LOGOUT********////

#define LOGOUT @"Logout"

////*********************////


////*******ADD HISTORY OR LIKE DETAILS TO SERVER********////

#define POST_HISTORY_OR_LIKE @"addhistory"

////*********************////


////*******GET HISTORY OR LIKE DETAILS FROM SERVER********////

#define GET_HISTORY_OR_LIKE @"historylist"

////*********************////


////*******SUGGESTED RETAILERS LIST********////

#define SUGGESTEDRETAILERS @"Suggested_Retail"

////*********************////


////*******PURCHASE LIST********////

#define PURCHASELIST @"purchase_list"

////*********************////


////*******EDIT PROFILE********////

#define EDITPROFILE @"EditProfile"

////*********************////


////*******REFERRAL CODE********////

#define REFERRALCODE @"addreferrel"

////*********************////


////*******WHATS NEW********////

#define WHATSNEW @"newproductlist"

////*********************////



#pragma mark- Screen And Version ➡️ ➡️

#define hRatio [UIScreen mainScreen].bounds.size.height / 568
#define wRatio [UIScreen mainScreen].bounds.size.width / 320

#define iOSSystemVersionStr [[UIDevice currentDevice] systemVersion];

#pragma mark - ▶︎▶︎▶︎▶︎

#define showToast(toastMessage); \
\
[self.view makeToast:toastMessage duration:1.5 position:CSToastPositionCenter]; \

#pragma mark - showToastOnTopPosition 😄 ▶︎
#define showToastOnTopPosition(strMessage) \
UIViewController * currentVc = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController; \
[currentVc.view makeToast:strMessage duration:1.5 position:CSToastPositionTop]; \

#pragma mark - showToastOnBottomPosition 😄 ▶︎
#define showToastOnBottomPosition(strMessage) \
UIViewController * currentVc = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController; \
[currentVc.view makeToast:strMessage duration:1.5 position:CSToastPositionBottom]; \

#pragma mark showToastOnCenter
#define showToastOnCenter(strMessage,time) \
UIViewController *currentVc = [(UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController topViewController]; \
[currentVc.view makeToast:strMessage duration:time position:CSToastPositionCenter]; \


#pragma mark-

#define is_Reachable [[AFNetworkReachabilityManager sharedManager] isReachable]


#pragma mark - Device Information ▶︎▶︎▶︎▶︎

#define isLandScape UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)

#define isiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
#define NavigationBar_HEIGHT 44
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 || [[[UIDevice currentDevice] systemVersion] floatValue] <= 8.4)
#define IS_OS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)


#endif /* ScanIt_Constant_h */
