//
//  CalanderView.h
//  iDoSpa
//
//  Created by Shivam Jotangiya on 02/11/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appServices.h"
#import "FSCalendar.h"

@interface CalanderView : UIViewController<FSCalendarDataSource,FSCalendarDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *Arry_DateList;
    __weak IBOutlet UILabel *LBL_DateSelect;
    
     void * _KVOContext;
    
    BOOL Is_SelectedDate;
}
@property (nonatomic,retain)NSMutableArray *Arry_DateList;

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;

@end
