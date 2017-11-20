//
//  ChangePassword.h
//  iDoSpa
//
//  Created by CronyLog on 28/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface ChangePassword : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    double animatedDistance;
    
    IBOutlet UITextField *TXT_OldPassword;
    IBOutlet UITextField *TXT_NewPassword;
    IBOutlet UITextField *TXT_ConfirmPassword;
    
    ASIFormDataRequest *apiUpdatePasswordRequest;
}
@end
