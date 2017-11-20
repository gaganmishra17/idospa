//
//  Login.h
//  iDoSpa
//
//  Created by CronyLog on 10/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface Login : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate,FCAlertViewDelegate>
{
    double animatedDistance;
    MBProgressHUD *HUD;
    
    __weak IBOutlet UITextField *TXT_UserName;
    __weak IBOutlet UITextField *TXT_Password;
    
    ASIFormDataRequest *apiLoginRequest;
}
@end
