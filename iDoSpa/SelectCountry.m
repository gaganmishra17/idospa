//
//  SelectCountry.m
//  iDoSpa
//
//  Created by CronyLog on 18/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "SelectCountry.h"

@interface SelectCountry ()

@end

@implementation SelectCountry

- (void)viewDidLoad
{
    [super viewDidLoad];
     ARY_CountryList = [NSMutableArray arrayWithCapacity: [[NSLocale ISOCountryCodes] count]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    sortedCountries = (NSArray *)parsedObject;
    
    NSLog(@"%@",parsedObject);
    [TBL_Country reloadData];
    
    /*for (NSString *countryCode in [NSLocale ISOCountryCodes])
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
        [ARY_CountryList addObject: country];
    }
    
    sortedCountries = [ARY_CountryList sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    */
}

#pragma mark - IBAction
-(IBAction)CLK_Okey:(id)sender
{
    dismissCurrent;
}


#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sortedCountries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"idCountryData";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *LBL_Code = (UILabel *)[cell viewWithTag:1];
    UILabel *LBL_CName = (UILabel *)[cell viewWithTag:2];
    
    if([[appConfig sharedInstance].STR_CountrySelectionType isEqualToString:@"dialCode"])
    {
        LBL_Code.text = [NSString stringWithFormat:@"%@",[sortedCountries valueForKey:@"dial_code"] [indexPath.row]];
        LBL_CName.text = [NSString stringWithFormat:@"%@",[sortedCountries valueForKey:@"name"] [indexPath.row]];
    }
    else
    {
        LBL_CName.frame = CGRectMake(LBL_Code.frame.origin.x, LBL_CName.frame.origin.y, LBL_CName.frame.size.width, LBL_CName.frame.size.height);
        LBL_CName.text = [NSString stringWithFormat:@"%@",[sortedCountries valueForKey:@"name"] [indexPath.row]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"Selected Country : %@",[sortedCountries objectAtIndex:indexPath.row]);
    
    if([[appConfig sharedInstance].STR_CountrySelectionType isEqualToString:@"dialCode"])
    {
        //dialCode
        [appConfig sharedInstance].STR_SelectedDialCode = [sortedCountries valueForKey:@"dial_code"][indexPath.row];
    }
    else
    {
        //Nationality
        [appConfig sharedInstance].STR_SelectedCountry = [sortedCountries valueForKey:@"name"][indexPath.row];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
