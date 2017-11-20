//
//  ItemDetails.h
//  iDoSpa
//
//  Created by CronyLog on 28/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface ItemDetails : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MBProgressHUD *HUD;
    
    __weak IBOutlet UILabel *LBL_ItemName;
    __weak IBOutlet AsyncImageView *IMG_ItemLogo;
    __weak IBOutlet UILabel *LBL_Location;
    __weak IBOutlet UILabel *LBL_ItemDisc;
    __weak IBOutlet UIImageView *IMG_RattingStar;
    
    NSArray *ARY_Gallary;
    IBOutlet UILabel *LBL_FemaleOnly;
    IBOutlet UILabel *LBL_MuslimFriendly;
    
    IBOutlet UIScrollView *SCRL_ImageGallary;
    AsyncImageView *IMG_GallaryItem;
    
    __weak IBOutlet UIButton *BTN_Service;
    __weak IBOutlet UIButton *BTN_About;
    __weak IBOutlet UIButton *BTN_Direction;
    
    IBOutlet UITableView *TBL_ServiceData;
    NSArray *ARY_ProductData;
    
    NSString *STR_ShowDataStatus;
    
    IBOutlet UIScrollView *SCRL_MarchantDataHolder;
    IBOutlet UIView *VW_ServiceHolder;
    
    IBOutlet UIView *VW_AboutHolder;
    IBOutlet UIScrollView *SCRL_AboutData;
    
    UILabel *LBL_AboutDisc;
    UILabel *LBL_OpeningHoursTitle;
    UILabel *LBL_Monday;
    UILabel *LBL_MondayData;
    UILabel *LBL_Tuesday;
    UILabel *LBL_TuesdayData;
    UILabel *LBL_Wednesday;
    UILabel *LBL_WednesdayData;
    UILabel *LBL_Thursday;
    UILabel *LBL_ThursdayData;
    UILabel *LBL_Friday;
    UILabel *LBL_FridayData;
    UILabel *LBL_Saturday;
    UILabel *LBL_SaturdayData;
    UILabel *LBL_Sunday;
    UILabel *LBL_SundayData;

    IBOutlet UIView *VW_DirectionHolder;
    IBOutlet UIScrollView *SCRL_DirectionData;
    IBOutlet UILabel *LBL_DirectionAdd;
    
    IBOutlet MKMapView *MP_Address;
    
    ASIFormDataRequest *apiProductListListRequest;
    
}
@property (nonatomic ,retain)NSDictionary *Dic_itemDetails;
@end
