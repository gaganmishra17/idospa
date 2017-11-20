//
//  TermsConditions.h
//  iDoSpa
//
//  Created by CronyLog on 01/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface TermsConditions : UIViewController<MBProgressHUDDelegate,CCKFNavDrawerDelegate>
{
    MBProgressHUD *HUD;
    
    IBOutlet UIWebView *WV_TermsCondition;
    
    NSString *Str_ComeFrom;
    
    
    __weak IBOutlet UILabel *LBL_Title;
    __weak IBOutlet UIButton *BTN_OK;
    __weak IBOutlet UIButton *BTN_Menu;
}
@property (nonatomic,retain)NSString *Str_ComeFrom;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@end
