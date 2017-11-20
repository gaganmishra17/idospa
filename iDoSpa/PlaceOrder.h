//
//  PlaceOrder.h
//  iDoSpa
//
//  Created by CronyLog on 29/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface PlaceOrder : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
    NSDictionary *Dic_ItemDetails;
    NSDictionary *Dic_ProductData;
    
    double animatedDistance;
    
    __weak IBOutlet UILabel *LBL_NavigationTitel;
    __weak IBOutlet UILabel *LBL_ProductName;
    __weak IBOutlet UILabel *LBL_NamePrice;
    __weak IBOutlet UILabel *LBL_ProductDisc;
    __weak IBOutlet UITextField *TXT_PromoCode;
    __weak IBOutlet UILabel *LBL_TotalPrice;
    __weak IBOutlet UILabel *LBL_DiscountPrice;
    __weak IBOutlet UILabel *LBL_SubTotal;
    __weak IBOutlet UILabel *LBL_PromoDiscountPrice;
    __weak IBOutlet UILabel *LBL_TotalPayablePrice;
    
    __weak IBOutlet UILabel *LBL_MasseurName;
    __weak IBOutlet UILabel *LBL_DateSelected;
    __weak IBOutlet UILabel *LBL_SelectedTime;
    
    ASIFormDataRequest *apiPromocodeRequiest;
    
    float TotalPrice;
    
    NSDictionary *Dic_ListData;
    
    //Timer
    __weak IBOutlet UIView *VW_Timer;
    __weak IBOutlet UILabel *LBL_TimerTitle;
    __weak IBOutlet UILabel *LBL_TimerCountDown;
    __weak IBOutlet UIButton *BTN_CheckOut;
    __weak IBOutlet UIButton *BTN_CloseTimer;
    
}
@property (nonatomic ,retain)NSDictionary *Dic_ListData;
@end
