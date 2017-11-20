//
//  FavoriteList.h
//  iDoSpa
//
//  Created by CronyLog on 10/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface FavoriteList : UIViewController<CCKFNavDrawerDelegate,MBProgressHUDDelegate,FCAlertViewDelegate>
{
    MBProgressHUD *HUD;
    IBOutlet UITableView *TBL_DataList;
    
    NSMutableArray *ARY_Data;
    AsyncImageView  *IMG_Item;
    ASIFormDataRequest *apiFavoriteListGet;
    
    NSIndexPath *Index_Select;
}
@end
