//
//  AppDelegate.m
//  iDoSpa
//
//  Created by CronyLog on 07/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "AppDelegate.h"

//Paypal
#import "PayPalMobile.h"

//Crashlist
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch
    
    /*if ([[appConfig sharedInstance] DIC_RetriveDataFromUserDefault:keyUserDetails])
    {
        NSLog(@"Authorised");
             
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:vcSearch];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
        
    }
    else
    {
        NSLog(@"No Login");
    }*/
    
    [Fabric with:@[[Crashlytics class]]];
    [self logUser];
    
    sleep(2);
    
    [self VersionDetailsAPICall];
    [self StartPushNotification];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //facebook Login
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    //Paypal
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox:PayPalClientIDProduct}];
    //PayPalClientIDProduct
    //PayPalEnvSendbox
    //[PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction:PayPalClientIDProduct}];
    
    //Google Auto Place Finder
    [GMSPlacesClient provideAPIKey:@"AIzaSyAd42PoBH8xY2UitCqDH5eoSRRMjVxicPw"];
    [GMSServices provideAPIKey:@"AIzaSyAd42PoBH8xY2UitCqDH5eoSRRMjVxicPw"];

    
    //Locaion get
    [self getCurrentLoc];
    
    return YES;
}

- (void) logUser
{
    // TODO: Use the current user's information
    // You can call any combination of these three methods
    
    if ([[appConfig sharedInstance]GetArrayFromNSDefaults:keyUserDetails])
    {
        [CrashlyticsKit setUserIdentifier:[NSString stringWithFormat:@"%@",[[[appConfig sharedInstance]GetArrayFromNSDefaults:keyUserDetails] valueForKeyPath:@"login_user_details.member_id"]]];
        
        [CrashlyticsKit setUserEmail:[NSString stringWithFormat:@"%@",[[[appConfig sharedInstance]GetArrayFromNSDefaults:keyUserDetails] valueForKeyPath:@"login_user_details.member_email"]]];
        
        [CrashlyticsKit setUserName:[NSString stringWithFormat:@"%@",[[[appConfig sharedInstance]GetArrayFromNSDefaults:keyUserDetails] valueForKeyPath:@"login_user_details.user_name"]]];
    }
    else
    {
        [CrashlyticsKit setUserIdentifier:[NSString stringWithFormat:@""]];
        [CrashlyticsKit setUserEmail:[NSString stringWithFormat:@""]];
        [CrashlyticsKit setUserName:[NSString stringWithFormat:@""]];
    }
}

-(void)VersionDetailsAPICall
{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        //[self appAlert:@"No Internet" Message:@"Please Check Your Internet Connections."];
        
        //[HUD hide:YES];
    }
    else
    {
        //connection available
        
        NSString *Str_AccessToken = @"";
        NSString *Str_DeviceToken = @"";
        
        NSDictionary *DIC_UserDetails = [[appConfig sharedInstance] DIC_RetriveDataFromUserDefault:keyUserDetails];
        if (DIC_UserDetails)
        {
            Str_AccessToken = [DIC_UserDetails valueForKey:@"accesstoken"];
            Str_DeviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken_Key"];
            
            if([Str_DeviceToken isEqualToString:@"<nil>"])
            {
                Str_DeviceToken = @"";
            }
        }
        
        NSString *Str_CurrentVersin = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        
        //NSString *STR_APIBody = [NSString stringWithFormat:@"api=1&task=vendor-version-detail&access_token=%@&device_token=%@",Str_AccessToken,Str_DeviceToken];
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@?api=1&task=version-detail&access_token=%@&device_token=%@",apiBase,Str_AccessToken,Str_DeviceToken]];
        ASIFormDataRequest *apiCheckUpdateRequest = [ASIFormDataRequest requestWithURL:url];
        
        [apiCheckUpdateRequest setPostFormat:ASIMultipartFormDataPostFormat];
        
        [apiCheckUpdateRequest setPostValue:Str_CurrentVersin forKey:@"current-version"];
        [apiCheckUpdateRequest setPostValue:@"2" forKey:@"device-type"];
        
        [apiCheckUpdateRequest setDidFinishSelector:@selector(checkUpdateRespose:)];
        [apiCheckUpdateRequest setDidFailSelector:@selector(FailRequest:)];
        
        [apiCheckUpdateRequest setDelegate:self];
        [apiCheckUpdateRequest startAsynchronous];
    }
}

-(void)checkUpdateRespose:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
    
    if (parseDict != NULL)
    {
        NSString *Status = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"status"]];
        if ([Status isEqualToString:@"1"])
        {
            //error
            NSString *Str_under_maintenance = [NSString stringWithFormat:@"%@",[parseDict valueForKeyPath:@"data.under_maintenance"]];
            
            if ([Str_under_maintenance isEqualToString:@"0"])
            {
                NSString *Str_is_latest = [NSString stringWithFormat:@"%@",[parseDict valueForKeyPath:@"data.is_latest"]];
                if ([Str_is_latest isEqualToString:@"1"])
                {
                    NSLog(@"is_latest = YES");
                }
                else
                {
                     NSLog(@"is_latest = NO");
                    NSString *Str_is_major_update = [NSString stringWithFormat:@"%@",[parseDict valueForKeyPath:@"data.is_major_update"]];
                    if ([Str_is_major_update isEqualToString:@"0"])
                    {
                         NSLog(@"is_major_update = NO");
                        NSString *Str_minor_update = [NSString stringWithFormat:@"%@",[parseDict valueForKeyPath:@"data.is_minor_update"]];
                        if ([Str_minor_update isEqualToString:@"1"])
                        {
                             NSLog(@"is_minor_update = YES");
                            NSString *Message = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"message"]];
                            [self appSkipUpdateAlert:@"idospa" Message:Message];
                        }
                        else
                        {
                            NSLog(@"is_minor_update = NO");
                        }
                    }
                    else
                    {
                       NSLog(@"is_major_update = YES");
                        NSString *Message = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"message"]];
                        [self appForceAlert:@"idospa" Message:Message];
                    }
                }
            }
            else
            {
                NSString *Message = [NSString stringWithFormat:@"%@",[parseDict valueForKeyPath:@"data.under_maintenance_msg"]];
                [self appUnderMaintenanceAlert:@"Under Maintenance" Message:Message];
            }
        }
        else
        {
            //Sucess
            NSLog(@"%@",parseDict);
        }
    }
    else
    {
        //error
    }
}

-(void)FailRequest:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if ([error.localizedDescription isEqualToString:@"A connection failure occurred"])
    {
        
    }
    else
    {
        //NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    }
}

#pragma mark - Location get 

-(void)getCurrentLoc
{
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil)
    {
        NSLog(@"Long. : %@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        NSLog(@"Lat. : %@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
        
        [appConfig sharedInstance].STR_CurrentLong = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        [appConfig sharedInstance].STR_CurrentLat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    [locationManager stopUpdatingLocation];
}

#pragma mark - Alert

-(void)appSkipUpdateAlert:(NSString *)Title Message:(NSString *)Message
{
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:Title message:Message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Update"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //What we write here????????**
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://itunes.apple.com/us/app/idospa-my/id1281547428?ls=1&mt=8"] options:@{} completionHandler:nil];
                                    
                                    //NSLog(@"you pressed Yes, please button");
                                    topWindow.hidden = YES;
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Skip"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //What we write here????????**
                                   //NSLog(@"you pressed No, thanks button");
                                   // call method whatever u need
                                   topWindow.hidden = YES;
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

-(void)appForceAlert:(NSString *)Title Message:(NSString *)Message
{
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:Title message:Message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                      {
                          // continue your work
                          
                          //[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"SocialType"] options:@{} completionHandler:nil];
                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://itunes.apple.com/us/app/idospa-my/id1281547428?ls=1&mt=8"] options:@{} completionHandler:nil];
                          
                          topWindow.hidden = YES;
                      }]];
    
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

-(void)appUnderMaintenanceAlert:(NSString *)Title Message:(NSString *)Message
{
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:Title message:Message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                      {
                          // continue your work
                          exit(0);
                        }]];
    
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


#pragma mark - PushNotification_DeviceToken

-(void)StartPushNotification
{
    //Push Notifications
    NSString *isPushNotifications;
    //isPushNotifications = [[appConfig sharedInstance]STR_RetriveDataFromUserDefaoult:keyPushNotification];
    
    if ([isPushNotifications isEqualToString:@"off"])
    {
        //Notification off
    }
    else
    {
        //Notofication Start
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
        {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
             {
                 if(!error)
                 {
                     [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
                     NSLog( @"Push registration success." );
                 }
                 else
                 {
                     NSLog( @"Push registration FAILED" );
                     NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                     NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
                 }
             }];
        }
        else
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
        }
    }
}


//ios10
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSLog( @"Handle push from foreground" );
    // custom code to handle push while app is in the foreground
    NSLog(@"%@", notification.request.content.userInfo);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler
{
    NSLog( @"Handle push from background or closed" );
    // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
    NSLog(@"%@", response.notification.request.content.userInfo);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *STR_DeviceToken=[[NSString alloc] initWithFormat:@"%@",deviceToken];
    
    STR_DeviceToken = [STR_DeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    STR_DeviceToken = [STR_DeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    STR_DeviceToken = [STR_DeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"%@'s Device Token is : %@",[[UIDevice currentDevice] name],STR_DeviceToken);
    [appConfig sharedInstance].STR_DeviceToken = STR_DeviceToken;
    
    [[NSUserDefaults standardUserDefaults] setValue:STR_DeviceToken forKey:@"deviceToken_Key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userinfo : %@",userInfo);
    NSLog(@"value of id is : %@", [[userInfo valueForKey:@"aps"] valueForKey:@"alert"]);
    
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result)
     {
         
     }];
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void                                                                  (^)(UIBackgroundFetchResult))completionHandler
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        NSLog( @"iOS version >= 10. Let NotificationCenter handle this one." );
        // set a member variable to tell the new delegate that this is background
        return;
    }
    NSLog( @"HANDLE PUSH, didReceiveRemoteNotification: %@", userInfo );
    //custom code to handle notification content
    
    if( [UIApplication sharedApplication].applicationState == UIApplicationStateInactive )
    {
        NSLog( @"INACTIVE" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    else if( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground )
    {
        NSLog( @"BACKGROUND" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    else
    {
        NSLog( @"FOREGROUND" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
}

#pragma mark - Facebook login

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{    
    return ([[FBSDKApplicationDelegate sharedInstance] application:application
                                                           openURL:url
                                                 sourceApplication:sourceApplication
                                                        annotation:annotation]|| [[GIDSignIn sharedInstance] handleURL:url
                                                                                                     sourceApplication:sourceApplication
                                                                                                            annotation:annotation]);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
