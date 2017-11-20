//
//  CalanderView.m
//  iDoSpa
//
//  Created by Shivam Jotangiya on 02/11/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "CalanderView.h"

@interface CalanderView ()

@end

@implementation CalanderView

@synthesize Arry_DateList;

#pragma mark - Life cycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        //self.dateFormatter.dateFormat = @"yyyy/MM/dd";
        self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.calendar selectDate:[NSDate date] scrollToDate:YES];

    /*
    for (NSString *Str_Date in Arry_DateList)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSDate *date = [dateFormat dateFromString:Str_Date];
        [self.calendar selectDate:date scrollToDate:YES];
        
        //NSLog(@"string date :%@  ------  Date :%@ ---- current :%@",Str_Date,date,[NSDate date]);
    }*/
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;
    
    // While the scope gesture begin, the pan gesture of tableView should cancel.
    //--[self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
    
    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    
    self.calendar.scope = FSCalendarScopeWeek;
    
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
    
    NSLog(@"%@",Arry_DateList);
    Is_SelectedDate=NO;
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == _KVOContext) {
        FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
        FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        NSLog(@"From %@ to %@",(oldScope==FSCalendarScopeWeek?@"week":@"month"),(newScope==FSCalendarScopeWeek?@"week":@"month"));
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

// Whether scope gesture should begin
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
//    if (shouldBegin) {
//        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
//        switch (self.calendar.scope) {
//            case FSCalendarScopeMonth:
//                return velocity.y < 0;
//            case FSCalendarScopeWeek:
//                return velocity.y > 0;
//        }
//    }
//    return shouldBegin;
//}

#pragma mark - <FSCalendarDelegate>

//- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
//{
//    //    NSLog(@"%@",(calendar.scope==FSCalendarScopeWeek?@"week":@"month"));
//    _calendarHeightConstraint.constant = CGRectGetHeight(bounds);
//    [self.view layoutIfNeeded];
//}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    
    NSString *Str_Date = [self.dateFormatter stringFromDate:date];
    if ([Arry_DateList containsObject:Str_Date]) {
        NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
        [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [selectedDates addObject:[self.dateFormatter stringFromDate:obj]];
        }];
        NSLog(@"selected dates is %@",selectedDates);
        if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious)
        {
            [calendar setCurrentPage:date animated:YES];
        }
        
        LBL_DateSelect.text = [NSString stringWithFormat:@"You Have Selected \"%@\" Date.",Str_Date];
        LBL_DateSelect.textColor = [UIColor blueColor];
        
        Is_SelectedDate = YES;
        
        [appConfig sharedInstance].STR_SelectDate = Str_Date;
    }
    else
    {
        LBL_DateSelect.text = [NSString stringWithFormat:@"This \"%@\" Date Is NOT Available !",Str_Date];
        LBL_DateSelect.textColor = [UIColor redColor];
        Is_SelectedDate=NO;
    }
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"%s %@", __FUNCTION__, [self.dateFormatter stringFromDate:calendar.currentPage]);
}


#pragma mark - IBAction

- (IBAction)CLK_Back:(id)sender
{
    [appConfig sharedInstance].STR_SelectDate = nil;
    pushToBack;
}

- (IBAction)CLK_Done:(id)sender
{
    if (Is_SelectedDate)
    {
        pushToBack;
    }
    else
    {
        [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:@"Please Select Another Date This Date Is NOT Available !" ViewContriller:self];
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
