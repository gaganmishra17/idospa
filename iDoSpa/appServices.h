//
//  appServices.h
//  mammam
//
//  Created by Shivam Jatamgiya on 17/12/16.
//  Copyright © 2016 Shivam Jotangiya. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "SBJSON.h"
#import "AsyncImageView.h"
#import "MBProgressHUD.h"
#import "FCAlertView.h"
#import "YActionSheet.h"
#import "Reachability.h"
#import "PayPalMobile.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "appConfig.h"

#pragma mark - DB
//#import "DBManager.h"

#pragma mark - HelperClass
#import "CCKFNavDrawer.h"

#define vcCCKFNavDrawer @"idCCKFNavDrawerVC"

#ifndef appServices_h
#define appServices_h

#pragma mark - VCs
#import "LoginRegister.h"
#import "Register.h"
#import "Login.h"
#import "Search.h"
#import "ListItem.h"
#import "SearchList.h"
#import "ItemDetails.h"
#import "SelectMasseur.h"
#import "PlaceOrder.h"
#import "TermsConditions.h"
#import "ForgotPassView.h"
#import "FavoriteList.h"
#import "SelectPayment.h"
#import "SelectCountry.h"
#import "BookingHistory.h"
#import "BookingDetails.h"
#import "UpComingBoolingList.h"
#import "UpComingBookingDetails.h"
#import "PaymentDone.h"
#import "ChangePassword.h"
#import "ConfirmBillingInfoView.h"
#import "CountryStateList.h"
#import "CalanderView.h"

#pragma mark - Storybord IDs
#define vcLoginRegister @"idLoginRegisterVC"
#define vcRegister @"idRegisterVC"
#define vcLogin @"idLoginVC"
#define vcSearch @"idSearchVC"
#define vcListItem @"idListItemVC"
#define vcSearchList @"idSearchListVC"
#define vcItemDetails @"idItemDetailsVC"
#define vcSelectMasseur @"idSelectMasseurVC"
#define vcPlaceOrder @"idPlaceOrderVC"
#define vcTermsConditions @"idTermsConditionsVC"
#define vcForgotPassView @"idForgotPassViewVC"
#define vcUpdateProfile @"idUpdateProfileViewVC"
#define vcFavoriteList @"idFavoriteListVC"
#define vcSelectPayment @"idSelectPaymentVC"
#define vcSelectCountry @"idSelectCountryVC"
#define vcBookingHistory @"idBookingHistoryVC"
#define vcBookingDetails @"idBookingDetailsVC"
#define vcUpComingBoolingList @"idUpComingBoolingListVC"
#define vcUpComingBookingDetails @"idUpComingBookingDetailsVC"
#define vcPaymentDone @"idPaymentDoneVC"
#define vcChangePassword @"idChangePasswordVC"
#define vcConfirmBillingInfoView @"idConfirmBillingInfoViewVC"
#define vcCountryStateList @"idCountryStateListVC"
#define vcCalanderView @"idCalanderViewVC"

#pragma mark - AppVariable
#define appColor [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:255.0/255.0 alpha:1.0]

#define pushToBack [self.navigationController popViewControllerAnimated:YES]
#define dismissCurrent [self dismissViewControllerAnimated:YES completion:nil]

#define showTabbar self.tabBarController.tabBar.hidden = NO
#define hideTabbar self.tabBarController.tabBar.hidden = YES

#define gotoLogin Login *viewControler = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcLogin]

#define pushController [self presentViewController:viewControler animated:YES completion:nil]
#define presetController [self presentViewController:viewControler animated:YES completion:nil]

#define selfWidth self.view.frame.size.width
#define selfHight self.view.frame.size.height

#define iTunesURL @"https://itunes.apple.com/us/app/idospa-my/id1281547428?ls=1&mt=8"

#pragma mark - Userdefoult Keys
#define keyUserDetails @"keyUsersDetails"

#pragma mark - API Header Value & Key

#define APIAcceptKey @"Accept"
#define APIAcceptValue @"application/json"
#define APIContentTypeKey @"Content-Type"
#define APIContentTypeValue @"application/x-www-form-urlencoded"
#define APIAuthorizationKey @"Authorization"

#define APIRequestPost @"POST"
#define APIRequestGet @"GET"

#pragma mark - APIs

//#define apiBase @"http://ids2.1s.my/" //test 1
//#define apiBase @"https://ids3.1s.my/" //test 2
#define apiBase @"https://idospa.my/"

#define apiSocialCheck @"?api=1&task=social_check&"

#define apiFavoriteList @"?api=1&task=favouritelist&accesstoken="
#define apiFavorite @"?api=1&task=favourite&accesstoken="
#define apiUnFavorite @"?api=1&task=removefavourite&accesstoken="

#define apiGetMassureDate @"?api=1&task=masseurdatetimeslot&"
#define apiGetMassureTime @"?api=1&task=masseurtimeslot&"

#define apiBookingHistory @"?api=1&task=bookinghistory&accesstoken="
#define apiUpComingBooking @"?api=1&task=upcomingbooking&accesstoken="

#define apiPromocode @"?api=1&task=promocode&"
#define apiBookingDataLast @"?api=1&task=booking"

//#define apiBookingUnPaid @""

#define apiLogin @"login"
#define apiSerchList @""

//PayPal
#pragma mark - PayPal

#define UrlPrivacyPolicy @"get-privacy-policy"
#define PayPalClientIDProduct @"AUnhktHNUCNyRbJpkIys1SvfJLMNEnI8ANmqulcuDwAqi35w8zzG8FQJfZe5sY9QSHd1-YKLQpq9k22c"
#define PayPalEnvSendbox @"AbooTSPXrNiUVD9Xxz8Bp8-6Q4zYuf4DmGtsOWExs4vwhf4ct-FMVYwHCcdklOEjZzTQcH1UvbzyAbe3"

//Location
#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)



#endif /* appServices_h */
