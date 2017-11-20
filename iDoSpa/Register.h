//
//  Register.h
//  iDoSpa
//
//  Created by CronyLog on 10/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface Register : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate,FCAlertViewDelegate,UIPickerViewDelegate>
{
    double animatedDistance;
    MBProgressHUD *HUD;
    
    __weak IBOutlet UILabel *LBL_SocialTitle;
    
    __weak IBOutlet UITextField *TXT_FullName;
    __weak IBOutlet UITextField *TXT_EmailAdd;
    __weak IBOutlet UIImageView *IV_SepretorEmail;
    
    __weak IBOutlet UITextField *TXT_Password;
    IBOutlet UITextField *TXT_MobileNo;
    __weak IBOutlet UIImageView *IV_SepretorPassword;
    
    __weak IBOutlet UIButton *BTN_DOB;
    IBOutlet UIButton *BTN_SelectCountry;
    __weak IBOutlet UIButton *BTN_Nationality;
    __weak IBOutlet UIButton *BTN_Male;
    __weak IBOutlet UIButton *BTN_Female;
    
    NSString *STR_Gender;
    NSString *STR_DOB;
    NSString *STR_Nationality;
    
    UIButton *BTN_Done;
    IBOutlet UIDatePicker *DT_DOB;
    
    ASIFormDataRequest *apiRegisterRequest;

    //
    NSDictionary *DIC_SocialData;
    
    NSString *Str_SocialID;
    NSString *Str_SocialType;
}
@property(nonatomic,retain)NSDictionary *DIC_SocialData;


@end
