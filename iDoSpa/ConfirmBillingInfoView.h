//
//  ConfirmBillingInfoView.h
//  iDoSpa
//
//  Created by CronyLog on 17/10/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface ConfirmBillingInfoView : UIViewController<MBProgressHUDDelegate,FCAlertViewDelegate>
{
    double animatedDistance;
    MBProgressHUD *HUD;
    
    IBOutlet UITextField *TXT_FullName;
    IBOutlet UITextField *TXT_MobileNo;
    IBOutlet UIButton *BTN_SelectCountry;
    IBOutlet UIButton *BTN_SelectCountryCode;
    IBOutlet UIButton *BTN_SelectCity;
    
    NSMutableArray *ARY_CountryList;
    NSMutableArray *ARY_StateList;
    
    ASIFormDataRequest *apiGetCountryList;
    ASIFormDataRequest *apiGetStateList;
    ASIFormDataRequest *apiUnPaidBooking;
}

@property (nonatomic,retain)NSDictionary *Dic_ListData;

@end
