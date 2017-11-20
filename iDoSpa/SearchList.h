//
//  SearchList.h
//  iDoSpa
//
//  Created by CronyLog on 23/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface SearchList : UIViewController <CCKFNavDrawerDelegate,MBProgressHUDDelegate,FCAlertViewDelegate>
{
    MBProgressHUD *HUD;
    
    __weak IBOutlet UILabel *LBL_NavTitle;
    IBOutlet UITableView *TBL_DataList;
    
    NSMutableArray *ARY_Data;
    AsyncImageView  *IMG_Item;
    ASIFormDataRequest *apiSearchListRequest;
    
    NSString *IS_LocationOrMerchant;

    __weak IBOutlet UITextField *TF_SearchHere;
    BOOL isSearchHere;
    
    NSUInteger CurrentPage;
    NSUInteger TotalPage;
}
@property (nonatomic,retain)NSString *IS_LocationOrMerchant;
@property (nonatomic,retain)NSString *STR_MurchantNameSearch;
@end
