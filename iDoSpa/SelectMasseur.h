//
//  SelectMasseur.h
//  iDoSpa
//
//  Created by CronyLog on 29/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface SelectMasseur : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
    NSDictionary *Dic_ItemDetails;
    
    __weak IBOutlet UILabel *LBL_NavigationTitle;
    __weak IBOutlet AsyncImageView *IMG_ProductLogo;
    __weak IBOutlet UILabel *LBL_ProductName;
    __weak IBOutlet UILabel *LBL_Price;
    __weak IBOutlet UILabel *LBL_ProductDisc;
    IBOutlet UIImageView *IMG_Ratting;
    
    NSDictionary *Dic_ListData;
    NSArray *ARY_ListData;
    NSArray *ARY_MasseurList;
    
    IBOutlet UIButton *BTN_SelectMassure;
    IBOutlet UIButton *BTN_PickDate;
    IBOutlet UIButton *BTN_PickTime;
    IBOutlet UIButton *BTN_BookNow;
    
    NSString *STR_getDateMassureID;
    
    IBOutlet UIButton *BTN_Fav;
    NSString *isFavorite;
    ASIFormDataRequest *apiFavRequest;
    
    ASIFormDataRequest *apiGetDateTime;
    NSMutableArray *ARY_MassureDateSlote;
    NSMutableArray *ARY_MassureTimeSlote;
    
    NSString *SelectDateSlot;
    NSString *SelectTimeSlot;
    
    NSDictionary *Dic_ProductData;
}
@property(nonatomic ,retain)NSDictionary *Dic_ProductData;
@end
