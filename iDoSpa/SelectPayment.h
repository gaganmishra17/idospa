//
//  SelectPayment.h
//  iDoSpa
//
//  Created by CronyLog on 11/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"
#import <MOLPayXDK/MOLPayLib.h>

@interface SelectPayment : UIViewController<PayPalPaymentDelegate,PayPalFuturePaymentDelegate,PayPalProfileSharingDelegate,MOLPayLibDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;

    
    IBOutlet UILabel *LBL_Price;
    IBOutlet UILabel *LBL_PaymentType;
    
    __weak IBOutlet UIButton *BTN_CardPay;
    __weak IBOutlet UIButton *BTN_NetBankingPay;
    
    IBOutlet UIButton *BTN_Payment;
    IBOutlet UIButton *BTN_CreditCard;
    IBOutlet UIButton *BTN_Visa;
    IBOutlet UIButton *BTN_MasterCard;
    IBOutlet UIButton *BTN_AmericanExpress;
    
    IBOutlet UIButton *BTN_PayPal;
    IBOutlet UIButton *BTN_MolPay;
    
    NSString *Str_PayPalTransactionID;
    
    MOLPayLib *mp;
    
    NSString *PaymentType;
    ASIFormDataRequest *apiBookingRequiest;
    
    NSString *str_TransectionID;
    
    //Timer
    __weak IBOutlet UIView *VW_Timer;
    __weak IBOutlet UILabel *LBL_TimerTitle;
    __weak IBOutlet UILabel *LBL_TimerCountDown;
    __weak IBOutlet UIButton *BTN_CheckOut;
    __weak IBOutlet UIButton *BTN_CloseTimer;

}
//Paypal
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic,retain)NSDictionary *Dic_ProductData;

@end
