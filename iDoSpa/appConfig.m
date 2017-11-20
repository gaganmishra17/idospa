//
//  appConfig.m
//  mammam
//
//  Created by Shivam Jatamgiya on 17/12/16.
//  Copyright © 2016 Shivam Jotangiya. All rights reserved.
//

#import "appConfig.h"

static appConfig *applicationData = nil;

@implementation appConfig
@synthesize STR_UserAccessType,STR_CurrentView,DIC_UserDetails,STR_SelectedCountry,ARY_CurrentItemData,btnTag,STR_CurrentLat,STR_CurrentLong,DIC_BookingDetails,DIC_ItmeDetails,BookedTimer,counter,STR_CountrySelectionType,STR_SelectedDialCode,STR_CountryStateType,ARY_CountryStateData,apiCancelBookingRequest,STR_SelectPlaceGoogle,STR_SelectDate;

- (id)init
{
    if(self = [super init])
    {
        //Arry_AddressPlaceSelect=[[NSArray alloc]init];
        DIC_UserDetails = [[NSDictionary alloc]init];
        ARY_CurrentItemData = [[NSMutableArray alloc]init];
        DIC_ItmeDetails = [[NSMutableDictionary alloc]init];
        DIC_BookingDetails = [[NSMutableDictionary alloc]init];
        ARY_CountryStateData = [[NSArray alloc]init];
        
        _AppDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    }
    return self;
}

+ (appConfig*)sharedInstance
{
    if (applicationData == nil)
    {
        applicationData = [[super allocWithZone:NULL] init];
        [applicationData initialize];
    }
    return applicationData;
}

- (void)initialize
{
    
}

//Store UserData
-(void)DIC_UserData :(NSMutableDictionary *)userDIC :(NSString *)userDefaultKey
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userDIC forKey:userDefaultKey];
    [user synchronize];
}

-(NSDictionary *)DIC_RetriveDataFromUserDefault:(NSString *)UserDefaultKey
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *Dic_Data = [user objectForKey:UserDefaultKey];
    return Dic_Data;
}

//Store Area and Cuisine Data
-(void)ARY_StoreCurrentAreaCuisine :(NSArray *)userAry :(NSString *)userDefaultKey
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userAry forKey:userDefaultKey];
    [user synchronize];
}

//Retrive Data based on userDefoults
-(NSString *)STR_RetriveDataFromUserDefaoult :(NSString *)userDefaultKey
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *STR_Data = [user stringForKey:userDefaultKey];
    //NSLog(@"%@",STR_Data);
    return STR_Data;
}

- (NSString *)STR_LoadImages :(NSString *)strLoadImage :(NSString *)userDefaultKey
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:strLoadImage forKey:userDefaultKey];
    [user synchronize];
    //NSLog(@"%@",STR_Data);
    
    return strLoadImage;
}

- (NSString *)STR_PushNotification :(NSString *)strPushNotification :(NSString *)userDefaultKey
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:strPushNotification forKey:userDefaultKey];
    [user synchronize];
    //NSLog(@"%@",STR_Data);
    
    return strPushNotification;
}

-(NSMutableDictionary *)replaceNullInNested:(NSMutableDictionary *)targetDict
{
    //make it to be NSMutableDictionary in case that it is nsdictionary
    NSMutableDictionary *m = [targetDict mutableCopy];
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: m];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in [replaced allKeys])
    {
        const id object = [replaced objectForKey: key];
        //NSLog(@"---%@",object);
        if (object == nul)
        {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]])
        {
            NSMutableDictionary *m1 = [object mutableCopy];
            NSMutableDictionary *replaced1 = [NSMutableDictionary dictionaryWithDictionary: m1];
            const id nul1 = [NSNull null];
            const NSString *blank1 = @"";
            
            for (NSString *key1 in [replaced1 allKeys])
            {
                const id object1 = [replaced1 objectForKey: key1];
                if (object1 == nul1)
                {
                    [replaced1 setObject: blank1 forKey: key1];
                }
            }
            //NSLog(@"Dic = %@",replaced1);
            [replaced setObject:replaced1 forKey: key];
        }
        else if ([object isKindOfClass: [NSArray class]])
        {
            NSLog(@"found null inside and key is %@", key);
            //make it to be able to set value by create a new one
            NSMutableArray *a = [object mutableCopy];
            for (int i =0; i< [a count]; i++)
            {
                for (NSString *subKey in [[a objectAtIndex:i] allKeys])
                {
                    NSLog(@"key: %@", subKey);
                    NSLog(@"value: %@", [[object objectAtIndex:i] valueForKey:subKey]);
                    if ([[object objectAtIndex:i] valueForKey:subKey] == nul) {
                        [[object objectAtIndex:i] setValue:blank forKey:subKey];
                    }
                }
            }
            //replace the updated one with old one
            [replaced setObject:a forKey:key];
        }
    }
    return replaced;
}

//ResetDevice Data
- (void)resetDevice
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict)
    {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

#pragma mark - Timer

-(void)TimerStart:(NSString *)ServerTime
{
    int totalSec = [ServerTime intValue];
    
    counter = totalSec * 60;
    BookedTimer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(targetMethod:) userInfo:nil
                                                   repeats:YES];
}

-(void)targetMethod:(NSTimer *)timer
{
    //do smth
    //NSLog(@"%@",timer);
    
    counter--;
    if (counter <= 0) {
        [timer invalidate];
        //  Here the counter is 0 and you can take call another method to take action
        //[self handleCountdownFinished];
        
        NSMutableDictionary *Dic_Timer = [[NSMutableDictionary alloc]init];
        [Dic_Timer setObject:[NSString stringWithFormat:@"00"] forKey:@"Mint"];
        [Dic_Timer setObject:[NSString stringWithFormat:@"00"] forKey:@"Sec"];
        [Dic_Timer setObject:[NSString stringWithFormat:@"No"] forKey:@"Is_Start"];
        
        NSNotification* notification = [NSNotification notificationWithName:@"TimerNotify" object:Dic_Timer];
        [[NSNotificationCenter defaultCenter] postNotification:notification];

    }
    else
    {
        int seconds = counter % 60;
        int minutes = (counter / 60) % 60;
        
        NSMutableDictionary *Dic_Timer = [[NSMutableDictionary alloc]init];
        [Dic_Timer setObject:[NSString stringWithFormat:@"%d",minutes] forKey:@"Mint"];
        [Dic_Timer setObject:[NSString stringWithFormat:@"%d",seconds] forKey:@"Sec"];
        [Dic_Timer setObject:[NSString stringWithFormat:@"Yes"] forKey:@"Is_Start"];
        
        NSNotification* notification = [NSNotification notificationWithName:@"TimerNotify" object:Dic_Timer];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

-(void)SetTimerInvalid
{
    [BookedTimer invalidate];
}

#pragma mark - BookingAPI
-(void)CancelBookingAPI : (NSString *)bookingID
{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@?api=1&task=booking_incart_remove&accesstoken=%@&booking_id=%@",apiBase,[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"],bookingID]];
        
        apiCancelBookingRequest = [ASIFormDataRequest requestWithURL:url];
        
        [apiCancelBookingRequest setRequestMethod:APIRequestGet];
        [apiCancelBookingRequest setDidFinishSelector:@selector(BookingRespose:)];
        [apiCancelBookingRequest setDidFailSelector:@selector(FailRequest:)];
        
        [apiCancelBookingRequest setDelegate:self];
        [apiCancelBookingRequest startAsynchronous];
    }
}

-(void)BookingRespose:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
    NSLog(@"%@",parseDict);
    
    if (parseDict != NULL)
    {
        NSString *Status = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"status"]];
        if ([Status isEqualToString:@"false"])
        {
            //[self errorAlert:@"oops !" Message:[parseDict valueForKey:@"message"]];
        }
        else
        {
            //NSLog(@"nonNull : %@",[[appConfig sharedInstance] replaceNullInNested:parseDict]);
        }
    }
}

-(void)FailRequest:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    if ([error.localizedDescription isEqualToString:@"A connection failure occurred"])
    {
        //[self errorAlert:@"No Internet" Message:@"Please Check Your Internet Connections."];
    }
    else
    {
        NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
        //[self errorAlert:@"oops !" Message:[parseDict valueForKey:@"message"]];
    }
}


#pragma mark - Array Store In NSUserDefaults

-(void)ArrayStoreinNSDefaults:(NSArray *)Arry :(NSString *)Key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:Arry forKey:Key];
    [userDefaults synchronize];
}

-(NSArray *)GetArrayFromNSDefaults:(NSString *)Key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayData = [userDefaults objectForKey:Key];
    return arrayData;
}

#pragma ValidationMethods

-(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - AlertViewMethod

-(void)FailAlertCall:(NSString *)Title Message:(NSString *)Message ViewContriller:(UIViewController *)VC
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.delegate = nil;
    
    alert.avoidCustomImageTint = 1;
    alert.colorScheme = alert.flatRed;
    
    alert.titleColor = appColor;
    alert.subTitleColor = appColor;
    
    alert.cornerRadius = 15;
    alert.blurBackground = YES;
    
    //[alert makeAlertTypeWarning];
    
    [alert showAlertInView:VC
                 withTitle:Title
              withSubtitle:Message
           withCustomImage:[UIImage imageNamed:@"apilyAler-icon.png"]
       withDoneButtonTitle:@"Done"
                andButtons:nil
     ];
}

-(void)SucessAlertCall:(NSString *)Title Message:(NSString *)Message ViewContriller:(UIViewController *)VC
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.delegate = nil;
    
    alert.avoidCustomImageTint = 1;
    alert.colorScheme = alert.flatGreen;
    
    //alert.titleColor = appColor;
    //alert.subTitleColor = appColor;
    alert.titleColor = [UIColor blackColor];
    alert.subTitleColor = [UIColor blackColor];
    
    alert.cornerRadius = 15;
    alert.blurBackground = YES;
    
    //[alert makeAlertTypeWarning];
    
    [alert showAlertInView:VC
                 withTitle:Title
              withSubtitle:Message
           withCustomImage:[UIImage imageNamed:@"apilyAler-icon.png"]
       withDoneButtonTitle:@"Done"
                andButtons:nil
     ];
}

@end
