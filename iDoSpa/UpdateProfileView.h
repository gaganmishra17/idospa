//
//  UpdateProfileView.h
//  iDoSpa
//
//  Created by CronyLog on 02/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface UpdateProfileView : UIViewController<CCKFNavDrawerDelegate,FCAlertViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
    double animatedDistance;
    
    IBOutlet UITextField *TXT_FullName;
    IBOutlet UIButton *BTN_CountryCode;
    
    __weak IBOutlet UIImageView *IV_ProfileImg;
    __weak IBOutlet UITextField *TF_Email;
    __weak IBOutlet UITextField *TF_PhoneNo;
    __weak IBOutlet UITextField *TF_Password;
    
    ASIFormDataRequest *apiUpdateProfileRequest;
    
    UIImagePickerController *IMG_PickerController;
    
    NSString *STR_Avtar64;
}
@end
