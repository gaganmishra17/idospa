//
//  CountryStateList.m
//  iDoSpa
//
//  Created by CronyLog on 17/10/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "CountryStateList.h"

@interface CountryStateList ()

@end

@implementation CountryStateList
@synthesize ARY_DataList,STR_DataType;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [appConfig sharedInstance].ARY_CountryStateData = [[NSMutableArray alloc]init];
    
    if([[appConfig sharedInstance].STR_CountryStateType isEqualToString:@"Country"])
    {
        LBL_Navigation.text = @"Select Country";
    }
    else
    {
        LBL_Navigation.text = @"Select State";
    }
}

#pragma mark - IBAction
-(IBAction)CLK_Okey:(id)sender
{
    dismissCurrent;
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ARY_DataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"idCountryStateData";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *LBL_Name = (UILabel *)[cell viewWithTag:1];
    
    if([[appConfig sharedInstance].STR_CountryStateType isEqualToString:@"Country"])
    {
        LBL_Name.text = [NSString stringWithFormat:@"%@",[ARY_DataList valueForKey:@"countries_name"] [indexPath.row]];
    }
    else
    {
        LBL_Name.text = [NSString stringWithFormat:@"%@",[ARY_DataList valueForKey:@"states_name"] [indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"Selected Country : %@",[ARY_DataList objectAtIndex:indexPath.row]);
    
    if([[appConfig sharedInstance].STR_CountryStateType isEqualToString:@"Country"])
    {
        [appConfig sharedInstance].ARY_CountryStateData = [ARY_DataList objectAtIndex:indexPath.row];
    }
    else
    {
        [appConfig sharedInstance].ARY_CountryStateData = [ARY_DataList objectAtIndex:indexPath.row];
    }
    
    dismissCurrent;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 4;
    
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex))
    {
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
