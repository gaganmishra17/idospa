//
//  appConfig.h
//  mammam
//
//  Created by Shivam Jatamgiya on 17/12/16.
//  Copyright © 2016 Shivam Jotangiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#import "appServices.h"

@class AppDelegate;

@interface appConfig : NSObject

@property (nonatomic,retain) ASIFormDataRequest *apiCancelBookingRequest;
-(void)CancelBookingAPI : (NSString *)bookingID;

//calander View
@property (nonatomic,retain) NSString *STR_SelectDate;

//Google Auto Search
@property (nonatomic,retain) NSString *STR_SelectPlaceGoogle;

//Booking API
@property (nonatomic,retain) NSMutableDictionary *DIC_BookingDetails;
//
@property (nonatomic,retain) NSString *STR_CountryStateType;
@property (nonatomic,retain) NSArray *ARY_CountryStateData;

//item Details
@property (nonatomic,retain) NSMutableDictionary *DIC_ItmeDetails;

@property (nonatomic, retain) NSString *STR_DeviceToken;
@property (nonatomic,retain) NSString *STR_TotalBadge;
@property (nonatomic,retain) NSString *STR_UserAccessType;
@property (nonatomic,retain) NSString *STR_CurrentView;
@property (nonatomic,retain) NSMutableArray *ARY_CurrentItemData;
@property (nonatomic) NSUInteger btnTag;
@property (nonatomic,retain) NSString *STR_CurrentLat;
@property (nonatomic,retain) NSString *STR_CurrentLong;

@property (nonatomic,retain) NSString *STR_SelectedCountry;
@property (nonatomic,retain) NSString *STR_SelectedDialCode;
@property (nonatomic,retain) NSString *STR_CountrySelectionType;

@property (nonatomic,retain) NSDictionary *DIC_UserDetails;

@property (nonatomic, retain) NSTimer *BookedTimer;
@property (nonatomic, assign) int counter;

+ (appConfig*)sharedInstance;
@property (nonatomic,retain) AppDelegate *AppDel;


// UserFefaults
-(NSMutableDictionary *)replaceNullInNested:(NSDictionary *)targetDict;

- (void)resetDevice;

-(NSDictionary *)DIC_RetriveDataFromUserDefault:(NSString *)UserDefaultKey;
- (void)DIC_UserData :(NSMutableDictionary *)userDIC :(NSString *)userDefaultKey;
- (void)ARY_StoreCurrentAreaCuisine :(NSArray *)userAry :(NSString *)userDefaultKey;
- (NSString *)STR_RetriveDataFromUserDefaoult :(NSString *)userDefaultKey;
- (NSString *)STR_LoadImages :(NSString *)strLoadImage :(NSString *)userDefaultKey;
- (NSString *)STR_PushNotification :(NSString *)strPushNotification :(NSString *)userDefaultKey;

-(void)ArrayStoreinNSDefaults:(NSArray *)Arry :(NSString *)Key;
-(NSArray *)GetArrayFromNSDefaults:(NSString *)Key;

-(void)FailAlertCall:(NSString *)Title Message:(NSString *)Message ViewContriller:(UIViewController *)VC;
-(void)SucessAlertCall:(NSString *)Title Message:(NSString *)Message ViewContriller:(UIViewController *)VC;

#pragma ValidationMethods
-(BOOL) isValidEmail:(NSString *)checkString;

#pragma mark - Timer
-(void)TimerStart:(NSString *)ServerTime;
-(void)SetTimerInvalid;
@end
