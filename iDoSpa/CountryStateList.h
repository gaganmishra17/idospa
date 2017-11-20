//
//  CountryStateList.h
//  iDoSpa
//
//  Created by CronyLog on 17/10/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface CountryStateList : UIViewController
{
    IBOutlet UILabel *LBL_Navigation;
    IBOutlet UITableView *TBL_DataList;
}

@property (nonatomic,retain) NSString *STR_DataType;
@property (nonatomic,retain) NSMutableArray *ARY_DataList;
@property (nonatomic,retain) NSMutableArray *ARY_DataListState;

@end
