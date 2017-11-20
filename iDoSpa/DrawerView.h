//
//  Drawer.h
//  CCKFNavDrawer
//
//  Created by calvin on 2/2/14.
//  Copyright (c) 2014年 com.calvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"
#import "AsyncImageView.h"

@interface DrawerView : UIView
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *Lbl_UserName;
@property (weak, nonatomic) IBOutlet AsyncImageView *IV_Avtar;

@property (weak, nonatomic) IBOutlet UIButton *BTN_Profile;
@property (weak, nonatomic) IBOutlet UIButton *BTN_Favourite;
@property (weak, nonatomic) IBOutlet UIButton *BTN_Search;
@property (weak, nonatomic) IBOutlet UIButton *BTN_Cart;
@property (weak, nonatomic) IBOutlet UIButton *BTN_OrderHistory;
@property (weak, nonatomic) IBOutlet UIButton *BTN_Settings;
@property (weak, nonatomic) IBOutlet UIButton *BTN_Account;
@property (weak, nonatomic) IBOutlet UIButton *BTN_Help;
@property (weak, nonatomic) IBOutlet UIButton *BTN_Logout;

@property (weak, nonatomic) IBOutlet UITableView *drawerTableView;
@end
