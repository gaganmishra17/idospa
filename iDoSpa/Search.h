//
//  Search.h
//  iDoSpa
//
//  Created by CronyLog on 10/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"
#import "CCKFNavDrawer.h"
#import <GooglePlaces/GooglePlaces.h>

@interface Search : UIViewController <CCKFNavDrawerDelegate,UITextFieldDelegate,CLLocationManagerDelegate,FCAlertViewDelegate,MBProgressHUDDelegate,GMSAutocompleteViewControllerDelegate>
{
    MBProgressHUD *HUD;
    double animatedDistance;
    
    NSMutableArray *ARY_FooterBanner;
    NSMutableArray *ARY_LocationList;
    IBOutlet UIScrollView *SCRL_FooterBannerHolder;
    AsyncImageView *IMG_FooterBanner;
    
    CLLocationManager *locationManager;
    IBOutlet UITextField *TXT_MurchantName;
    IBOutlet UITextField *TXT_LocationSearch;
    
    ASIFormDataRequest *apiFooterBanner;
    ASIFormDataRequest *apiSearchSuggestionListReq;
    
    int ScrollIndex;
}
//@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end
