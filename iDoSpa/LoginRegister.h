//
//  LoginRegister.h
//  iDoSpa
//
//  Created by CronyLog on 10/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

//Facebook
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

//Google+
//#import <GooglePlus/GooglePlus.h>
//#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface LoginRegister : UIViewController<GIDSignInDelegate,GIDSignInUIDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
    IBOutlet UIImageView *IV_TestImage;
    
    //Google
    GIDSignIn *signIn;
    
    ASIFormDataRequest *apiSocialCheckRequest;
    
    NSMutableDictionary *DIC_SocialData;
}
@property (retain, nonatomic) IBOutlet GIDSignInButton *signInButton;

@end
