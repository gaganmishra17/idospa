//
//  ForgotPassView.h
//  iDoSpa
//
//  Created by CronyLog on 24/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface ForgotPassView : UIViewController<FCAlertViewDelegate,MBProgressHUDDelegate>
{
    __weak IBOutlet UIButton *Btn_ForgotPass;
    __weak IBOutlet UITextField *TF_EnterEmail;
    
    MBProgressHUD *HUD;
    
    ASIFormDataRequest *ForgotPasswordRequest;
}
@end
