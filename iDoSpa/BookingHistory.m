//
//  BookingHistory.m
//  iDoSpa
//
//  Created by CronyLog on 19/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "BookingHistory.h"

@interface BookingHistory ()
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end

@implementation BookingHistory

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self HudMethod];
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    [self GetBookingHistoryList];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)HudMethod
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    NSString *str1=@""; // Tittle
    
    HUD.delegate = self;
    HUD.labelText = str1;
    HUD.detailsLabelText=@"Please Wait.!!";
    HUD.dimBackground = NO;
    
    [self.view addSubview:HUD];
}

-(IBAction)CLK_Menu:(id)sender
{
    NSLog(@"Menu");
    [self.rootNav drawerToggle];
}

#pragma mark - API call

-(void)GetBookingHistoryList
{
    [HUD show:YES];
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [[appConfig sharedInstance] FailAlertCall:@"No Internet" Message:@"Please Check Your Internet Connections." ViewContriller:self];
        [HUD hide:YES];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@%@",apiBase,apiBookingHistory,[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"]]];
        
        //NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://ids2.1s.my/?api=1&task=bookinghistory&accesstoken=5e84ab8c86cd67eb63fa43e44"]]; //Test-URL
        
        apiBookingListGet = [ASIFormDataRequest requestWithURL:url];
        
        [apiBookingListGet setRequestMethod:APIRequestGet];
        
        [apiBookingListGet setDidFinishSelector:@selector(BookingListRespose:)];
        [apiBookingListGet setDidFailSelector:@selector(FailRequest:)];
        
        [apiBookingListGet setDelegate:self];
        [apiBookingListGet startAsynchronous];
    }
}

-(void)BookingListRespose:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
    //NSLog(@"%@",parseDict);
    
    if (parseDict != NULL)
    {
        NSString *Status = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"status"]];
        if ([Status isEqualToString:@"false"])
        {
            [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:[parseDict valueForKey:@"message"] ViewContriller:self];
        }
        else
        {
            NSString *Str_dataCheck = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"data"]];
            //NSLog(@"Data : %@",parseDict);
            if ([Str_dataCheck isEqualToString:@""])
            {
                //NSLog(@"No Data");
                [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:@"You have no order history.." ViewContriller:self];
            }
            else
            {
                ARY_Data = [[NSMutableArray alloc]init];
                ARY_Data = [[parseDict valueForKey:@"data"] mutableCopy];
                
                [TBL_DataList reloadData];
            }
        }
    }
    [HUD hide:YES];
}

-(void)FailRequest:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    if ([error.localizedDescription isEqualToString:@"A connection failure occurred"])
    {
        [[appConfig sharedInstance] FailAlertCall:@"No Internet" Message:@"Please Check Your Internet Connections." ViewContriller:self];
    }
    else
    {
        NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
        [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:[parseDict valueForKey:@"message"] ViewContriller:self];
    }
    [HUD hide:YES];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ARY_Data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"idCellBookingList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    IMG_Item = (AsyncImageView *)[cell viewWithTag:1];
    
    if ([[ARY_Data valueForKey:@"image"][indexPath.row] isEqualToString:@""])
    {
        //NSLog(@"Null");
        
        IMG_Item.layer.cornerRadius = 8.0;
        IMG_Item.image = [UIImage imageNamed:[NSString stringWithFormat:@"img-noItemImage.png"]];
        IMG_Item.backgroundColor = [UIColor whiteColor];
        IMG_Item.layer.borderWidth = 0.5;
        IMG_Item.layer.borderColor = [UIColor lightGrayColor].CGColor;
        IMG_Item.clipsToBounds = YES;
    }
    else
    {
        //NSLog(@"No Null");
        
        IMG_Item.layer.cornerRadius = 8.0;
        IMG_Item.clipsToBounds = YES;
        IMG_Item.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[ARY_Data valueForKey:@"image"][indexPath.row]]];
        IMG_Item.backgroundColor = [UIColor whiteColor];
        IMG_Item.clipsToBounds = YES;
    }
    
    UILabel *LBL_Name = (UILabel *)[cell viewWithTag:2];
    LBL_Name.text = [NSString stringWithFormat:@"%@",[ARY_Data valueForKey:@"item_name"][indexPath.row]];
    
    UILabel *LBL_Location = (UILabel *)[cell viewWithTag:3];
    LBL_Location.text = [NSString stringWithFormat:@"%@",[ARY_Data valueForKey:@"address"][indexPath.row]];
    
    UILabel *LBL_Price = (UILabel *)[cell viewWithTag:4];
    LBL_Price.text = [NSString stringWithFormat:@"Booking Status : %@",[ARY_Data valueForKeyPath:@"booking_status"][indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     
     BookingDetails *viewControler = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcBookingDetails];
     viewControler.ARY_BookingDetails = ARY_Data[indexPath.row];
     [self.navigationController pushViewController:viewControler animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 4;
    
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex))
    {
        
    }
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    /*NSLog(@"CCKFNavDrawerSelection = %i", selectionIndex);
     self.selectionIdx.text = [NSString stringWithFormat:@"%i",selectionIndex];*/
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
