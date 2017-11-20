//
//  SelectCountry.h
//  iDoSpa
//
//  Created by CronyLog on 18/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"

@interface SelectCountry : UIViewController
{
    NSMutableArray *ARY_CountryList;
    NSArray *sortedCountries;
    
    IBOutlet UITableView *TBL_Country;
}
@end
