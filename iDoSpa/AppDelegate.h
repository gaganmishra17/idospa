//
//  AppDelegate.h
//  iDoSpa
//
//  Created by CronyLog on 07/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

#import <UserNotifications/UserNotifications.h>

//Social
#import <FBSDKCoreKit/FBSDKCoreKit.h>

//Google+
//#import <GooglePlus/GooglePlus.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <GoogleMaps/GoogleMaps.h>

@import GooglePlaces;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property (strong, nonatomic) UIWindow *window;
-(void)StartPushNotification;

@end

