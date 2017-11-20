//
//  UpComingBoolingList.h
//  iDoSpa
//
//  Created by CronyLog on 19/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface UpComingBoolingList : UIViewController<CCKFNavDrawerDelegate,MBProgressHUDDelegate,FCAlertViewDelegate>
{
    MBProgressHUD *HUD;
    IBOutlet UITableView *TBL_DataList;
    
    NSMutableArray *ARY_Data;
    AsyncImageView  *IMG_Item;
    ASIFormDataRequest *apiBookingListGet;
}
@end
