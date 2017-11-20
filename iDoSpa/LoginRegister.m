//
//  LoginRegister.m
//  iDoSpa
//
//  Created by CronyLog on 10/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "LoginRegister.h"

@interface LoginRegister ()

@end

@implementation LoginRegister

static NSString * const kClientId = @"775125905846-5vl764fsu9cn0qpsrtmnh6jqo3oua8i9.apps.googleusercontent.com";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self HudMethod];
    
    GIDSignIn *signin = [GIDSignIn sharedInstance];
    signin.clientID = kClientId;
    signin.shouldFetchBasicProfile = true;
    signin.delegate = self;
    signin.uiDelegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    if ([[appConfig sharedInstance] DIC_RetriveDataFromUserDefault:keyUserDetails])
    {
        NSLog(@"Authorised");
        
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSearch] animated:YES];
    }
}

-(void)HudMethod
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    NSString *str1=@""; // Tittle
    
    HUD.delegate = self;
    HUD.labelText = str1;
    HUD.detailsLabelText=@"Please Wait.!!";
    HUD.dimBackground = NO;
    
    [self.view addSubview:HUD];
}

#pragma mark - IBActions

-(IBAction)CLK_Facebook:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
         if (error)
         {
             //NSLog(@"FB Login Process error");
         }
         else if (result.isCancelled)
         {
             //NSLog(@"FB Cancelled");
         }
         else
         {
             //NSLog(@"FB Logged in");
             if ([result.grantedPermissions containsObject:@"email"])
             {
                 [self fetchUserInfo];
             }
         }
     }];
   
}

-(IBAction)CLK_Google:(id)sender
{
    [[GIDSignIn sharedInstance] signIn];
}

-(IBAction)CLK_TermsConditions:(id)sender
{
    TermsConditions *viewControler = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:vcTermsConditions];
    [self presentViewController:viewControler animated:YES completion:nil];
}

#pragma mark - Facebook LogIn

-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, about, email, first_name, last_name, picture.type(large), name, birthday ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error)
             {
                   NSLog(@"resultis:%@",result);
                 NSString *Email_Str = [NSString stringWithFormat:@"%@",[result valueForKey:@"email"]];
                 NSString *Name_Str = [result valueForKey:@"name"];
                 NSString *ID_Str = [result valueForKey:@"id"];
                 NSString *Avtar_Str = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",ID_Str];
                 DIC_SocialData = [[NSMutableDictionary alloc]init];
                 
                 if([Email_Str isEqualToString:@"(null)"])
                 {
                     [DIC_SocialData setObject:@"" forKey:@"Email"];
                 }
                 else
                 {
                     [DIC_SocialData setObject:Email_Str forKey:@"Email"];
                 }
                 
                 [DIC_SocialData setObject:ID_Str forKey:@"ID"];
                 [DIC_SocialData setObject:Name_Str forKey:@"Name"];
                 [DIC_SocialData setObject:Avtar_Str forKey:@"Image"];
                 [DIC_SocialData setObject:@"1" forKey:@"SocialType"];
                 //[[appConfig sharedInstance] FailAlertCall:@"FB ID" Message:ID_Str ViewContriller:self];
                 [self SocialLoginCheck];
            }
             else
             {
                 NSLog(@"Fb Profile Get Error: %@",error);
                 //[self errorAlert:@"Error" Message:error.localizedDescription];
             }
         }];
    }
}

#pragma mark - Google + LogIn

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
   // NSString *idToken = user.authentication.idToken; // Safe to send to the server
   // NSString *fullName = user.profile.name;
   // NSString *givenName = user.profile.givenName;
   // NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    
    
    NSLog(@"%@",email);
    NSString *AvtarImage = @"";
    if ([GIDSignIn sharedInstance].currentUser.profile.hasImage)
    {
        NSUInteger dimension = round(100 * [[UIScreen mainScreen] scale]);
        NSURL *imageURL = [user.profile imageURLWithDimension:dimension];
        AvtarImage = [NSString stringWithFormat:@"%@",imageURL];
    }
    
    DIC_SocialData = [[NSMutableDictionary alloc]init];
    [DIC_SocialData setObject:email forKey:@"Email"];
    [DIC_SocialData setObject:userId forKey:@"ID"];
    [DIC_SocialData setObject:AvtarImage forKey:@"Image"];
    [DIC_SocialData setObject:@"2" forKey:@"SocialType"];
    
    [self SocialLoginCheck];
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    //[myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Social Check

-(void)SocialLoginCheck
{
    [HUD show:YES];
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        //[self errorAlert:@"No Internet" Message:@"Please Check Your Internet Connections."];
        [HUD hide:YES];
    }
    else
    {
        NSString *Str_SocialData = [NSString stringWithFormat:@"social_id=%@&social_type=%@&devicetype=2&devicetoken=%@",[DIC_SocialData valueForKey:@"ID"],[DIC_SocialData valueForKey:@"SocialType"],[appConfig sharedInstance].STR_DeviceToken];
        
        //connection available
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@%@",apiBase,apiSocialCheck,Str_SocialData]];
        apiSocialCheckRequest = [ASIFormDataRequest requestWithURL:url];
        [apiSocialCheckRequest setRequestMethod:APIRequestGet];
        
        [apiSocialCheckRequest setDidFinishSelector:@selector(SocialCheckRespose:)];
        [apiSocialCheckRequest setDidFailSelector:@selector(FailRequest:)];
        
        [apiSocialCheckRequest setDelegate:self];
        [apiSocialCheckRequest startAsynchronous];
    }
}

-(void)SocialCheckRespose:(ASIHTTPRequest *)request
{
    //NSLog(@"%@",[request responseData]);
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
    
   parseDict = [[appConfig sharedInstance] replaceNullInNested:parseDict];
    
    NSLog(@"%@",parseDict);
    
    if (parseDict != NULL)
    {
        NSString *Status = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"status"]];
        if ([Status isEqualToString:@"false"])
        {
            //[[appConfig sharedInstance]FailAlertCall:@"oops !" Message:[parseDict valueForKey:@"message"] ViewContriller:self];
            NSString *Str_ErrorCode= [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"error_code"]];
            [DIC_SocialData setObject:Str_ErrorCode forKey:@"SocialErrorCode"];
            [self performSegueWithIdentifier:@"idREgisterCall" sender:self];
            
        }
        else
        {
            //[self performSegueWithIdentifier:@"idREgisterCall" sender:self];
            /*
            [appConfig sharedInstance].DIC_UserDetails=parseDict;
            [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSearch] animated:YES];
            
            [[appConfig sharedInstance] DIC_UserData:parseDict :keyUserDetails];
             */
            
            [appConfig sharedInstance].DIC_UserDetails=parseDict;
            [[appConfig sharedInstance] DIC_UserData:parseDict :keyUserDetails];
            
            [appConfig sharedInstance].STR_UserAccessType = @"Authorized";
            
            [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSearch] animated:YES];
        }
    }
    [HUD hide:YES];
}

-(void)FailRequest:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    if ([error.localizedDescription isEqualToString:@"A connection failure occurred"])
    {
        [[appConfig sharedInstance]FailAlertCall:@"No Internet" Message:@"Please Check Your Internet Connections." ViewContriller:self];
    }
    else
    {
        [[appConfig sharedInstance]FailAlertCall:@"oops !" Message:error.localizedDescription ViewContriller:self];
    }
    [HUD hide:YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"idREgisterCall"])
    {
        Register *RegisterView = segue.destinationViewController;
        RegisterView.DIC_SocialData = DIC_SocialData;
    }
}


@end
