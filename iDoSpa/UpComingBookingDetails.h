//
//  UpComingBookingDetails.h
//  iDoSpa
//
//  Created by CronyLog on 19/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface UpComingBookingDetails : UIViewController
{
    IBOutlet UIImageView *IMG_BG;
    
    __weak IBOutlet AsyncImageView *IMG_ItemLogo;
    __weak IBOutlet AsyncImageView *IMG_QRCode;
    IBOutlet UIView *VW_QRHolder;
    
    IBOutlet UIButton *BTN_QRCode;
    
    __weak IBOutlet UILabel *LBL_BookingName;
    __weak IBOutlet UILabel *LBL_BookingAddress;
    __weak IBOutlet UILabel *LBL_Date;
    __weak IBOutlet UILabel *LBL_Time;
    __weak IBOutlet UILabel *LBL_Service;
    __weak IBOutlet UILabel *LBL_Massure;
    __weak IBOutlet UILabel *LBL_Price;
    __weak IBOutlet UILabel *LBL_GSTCharge;
    __weak IBOutlet UILabel *LBL_SubTotal;
    __weak IBOutlet UILabel *LBL_OrderNo;
    __weak IBOutlet UILabel *LBL_MurchantName;
    
}

@property (nonatomic,retain) NSMutableArray *ARY_BookingDetails;

@end
