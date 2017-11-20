//
//  SearchList.m
//  iDoSpa
//
//  Created by CronyLog on 23/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "SearchList.h"

@interface SearchList ()
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end

@implementation SearchList

@synthesize IS_LocationOrMerchant,STR_MurchantNameSearch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self HudMethod];
    
    //NSLog(@"Murachant Name : %@",[appConfig sharedInstance].DIC_UserDetails);
    
    CurrentPage = 1;
    
    TF_SearchHere.hidden = YES;
    LBL_NavTitle.hidden = NO;
    isSearchHere = NO;
    
//NSDictionary *DIC_Userdata = [[appConfig sharedInstance] DIC_RetriveDataFromUserDefault:keyUserDetails];
    
    NSLog(@"%@",IS_LocationOrMerchant);
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    [self SearchListAPI];
    
    //------TF
//    UIToolbar *ViewForDoneButtonOnKeyboard = [[UIToolbar alloc] init];
//    [ViewForDoneButtonOnKeyboard sizeToFit];
//    UIBarButtonItem *btnDoneOnKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Done"
//                                                                          style:UIBarButtonItemStylePlain target:self
//                                                                         action:@selector(doneBtnFromKeyboardClicked:)];
//    [ViewForDoneButtonOnKeyboard setItems:[NSArray arrayWithObjects:btnDoneOnKeyboard, nil]];
//    
//    TF_SearchHere.inputAccessoryView = ViewForDoneButtonOnKeyboard;
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

#pragma mark - Text Field

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField.returnKeyType==UIReturnKeySearch)
    {
        //Your search key code
        [textField resignFirstResponder];
        if ([TF_SearchHere.text length]==0)
        {
            [self.view endEditing:YES];
            TF_SearchHere.hidden = YES;
            LBL_NavTitle.hidden = NO;
            isSearchHere = NO;
        }
        else
        {
            [self SearchListAPI];
        }
    }
    return YES;
}

#pragma mark - IBAction

- (IBAction)doneBtnFromKeyboardClicked:(id)sender
{
    //NSLog(@"Done Button Clicked.");
    
    //Hide Keyboard by endEditing or Anything you want.
    [self.view endEditing:YES];
}

-(IBAction)CLK_Menu:(id)sender
{
    //NSLog(@"Menu");
    [self.rootNav drawerToggle];
}

-(IBAction)CLK_FavoriteList:(id)sender
{
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcFavoriteList] animated:YES];
}

- (IBAction)CLK_SearchHere:(id)sender
{
    if (isSearchHere==YES)
    {
        [self.view endEditing:YES];
        TF_SearchHere.hidden = YES;
        LBL_NavTitle.hidden = NO;
        isSearchHere = NO;
    }
    else
    {
        TF_SearchHere.hidden = NO;
        LBL_NavTitle.hidden = YES;
        isSearchHere = YES;
        CurrentPage = 1;
        [TF_SearchHere becomeFirstResponder];
    }
}

#pragma mark - API call

-(void)SearchListAPI
{
    [HUD show:YES];
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [self errorAlert:@"No Internet" Message:@"Please Check Your Internet Connections."];
        [HUD hide:YES];
    }
    else
    {
        if (isSearchHere == YES)
        {
            NSString *STR_GetURL;
            
            if ([IS_LocationOrMerchant isEqualToString:@"SearchOnMerchant"])
            {
                STR_GetURL = [NSString stringWithFormat:@"?api=1&task=itemlist&search_merchant_list=%@&gmw_address=&curr_lat=&curr_long=&page=%@&accesstoken=%@",STR_MurchantNameSearch,[NSString stringWithFormat:@"%lu",(unsigned long)CurrentPage],[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"]];
            }
            else if ([IS_LocationOrMerchant isEqualToString:@"SearchOnLocationText"])
            {
                STR_GetURL = [NSString stringWithFormat:@"?api=1&task=itemlist&search_merchant_list=&gmw_address=%@&curr_lat=&curr_long=&page=%@&accesstoken=%@",STR_MurchantNameSearch,[NSString stringWithFormat:@"%lu",(unsigned long)CurrentPage],[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"]];
            }
            else if ([IS_LocationOrMerchant isEqualToString:@"SearchOnLocation"])
            {
                STR_GetURL = [NSString stringWithFormat:@"?api=1&task=itemlist&search_merchant_list=%@&gmw_address=&curr_lat=&curr_long=&page=%@&accesstoken=%@",STR_MurchantNameSearch,[NSString stringWithFormat:@"%lu",(unsigned long)CurrentPage],[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"]];
            }
            
            //STR_GetURL = [NSString stringWithFormat:@"?api=1&task=itemlist&search_data=%@&curr_lat=&curr_long=&page=%@&accesstoken=%@",TF_SearchHere.text,[NSString stringWithFormat:@"%lu",(unsigned long)CurrentPage],[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"]];
            
            STR_GetURL = [STR_GetURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",apiBase,STR_GetURL]];
            apiSearchListRequest = [ASIFormDataRequest requestWithURL:url];
            
            [apiSearchListRequest setRequestMethod:APIRequestGet];
            
            [apiSearchListRequest setDidFinishSelector:@selector(SearchListRespose:)];
            [apiSearchListRequest setDidFailSelector:@selector(FailRequest:)];
            
            [apiSearchListRequest setDelegate:self];
            [apiSearchListRequest startAsynchronous];
        }
        else
        {
            NSString *STR_GetURL;
            
            if ([IS_LocationOrMerchant isEqualToString:@"SearchOnMerchant"])
            {
                //STR_GetURL = [NSString stringWithFormat:@"?api=1&task=itemlist&search_data=%@&curr_lat=&curr_long=&page=%@&accesstoken=%@",STR_MurchantNameSearch,[NSString stringWithFormat:@"%lu",(unsigned long)CurrentPage],[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"]];
                
                STR_GetURL =
                [NSString stringWithFormat:@"?api=1&task=itemlist&search_merchant_list=%@&gmw_address=&curr_lat=&curr_long=&page=%@&accesstoken=%@",STR_MurchantNameSearch,[NSString stringWithFormat:@"%lu",(unsigned long)CurrentPage],[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"]];
                STR_GetURL = [STR_GetURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
            }
            else if ([IS_LocationOrMerchant isEqualToString:@"SearchOnLocationText"])
            {
                STR_GetURL =
                [NSString stringWithFormat:@"?api=1&task=itemlist&search_merchant_list=&gmw_address=%@&curr_lat=&curr_long=&page=%@&accesstoken=%@",STR_MurchantNameSearch,[NSString stringWithFormat:@"%lu",(unsigned long)CurrentPage],[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"]];
                STR_GetURL = [STR_GetURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
            }
            else if ([IS_LocationOrMerchant isEqualToString:@"SearchOnLocation"])
            {
                //STR_GetURL = [NSString stringWithFormat:@"?api=1&task=itemlist&search_data=&curr_lat=%@&curr_long=%@&page=%@&accesstoken=%@",[appConfig sharedInstance].STR_CurrentLat,[appConfig sharedInstance].STR_CurrentLong,[NSString stringWithFormat:@"%lu",(unsigned long)CurrentPage],[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"]];
                
                STR_GetURL = [NSString stringWithFormat:@"?api=1&task=itemlist&search_merchant_list=&gmw_address=&curr_lat=%@&curr_long=%@&page=%@&accesstoken=%@",[appConfig sharedInstance].STR_CurrentLat,[appConfig sharedInstance].STR_CurrentLong,[NSString stringWithFormat:@"%lu",(unsigned long)CurrentPage],[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"]];
                
                STR_GetURL = [STR_GetURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
                //STR_GetURL = [NSString stringWithFormat:@"/?api=1&task=itemlist&search_data=&curr_lat=13.7563&curr_long=100.5018&page=1"];
                //Bangkok Location
            }
            
            NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",apiBase,STR_GetURL]];
            apiSearchListRequest = [ASIFormDataRequest requestWithURL:url];
            
            [apiSearchListRequest setRequestMethod:APIRequestGet];
            
            [apiSearchListRequest setDidFinishSelector:@selector(SearchListRespose:)];
            [apiSearchListRequest setDidFailSelector:@selector(FailRequest:)];
            
            [apiSearchListRequest setDelegate:self];
            [apiSearchListRequest startAsynchronous];
        }
    }
}

-(void)SearchListRespose:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
    NSLog(@"%@",parseDict);
    
    if (parseDict != NULL)
    {
        NSString *Status = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"status"]];
        if ([Status isEqualToString:@"false"])
        {
            if ([[parseDict valueForKey:@"message"] isEqualToString:@"No members found."])
            {
                [self errorAlert:@"oops !" Message:[parseDict valueForKey:@"message"]];
                pushToBack;
            }
            else
            {
                [self errorAlert:@"oops !" Message:[parseDict valueForKey:@"message"]];
            }
        }
        else
        {
            NSDictionary *Dic_pageData = [parseDict valueForKey:@"paginator"];
            TotalPage = [[Dic_pageData valueForKey:@"total_pages"] integerValue];
            if (CurrentPage == 1)
            {
                ARY_Data = [[NSMutableArray alloc]init];
                ARY_Data = [parseDict valueForKeyPath:@"data.member_items"];
                //NSLog(@"Data : %@",ARY_Data);
                [TBL_DataList reloadData];
            }
            else
            {
                [ARY_Data addObjectsFromArray:[parseDict valueForKeyPath:@"data.member_items"]];
                [TBL_DataList reloadData];
            }
            //[self errorAlert:@"Congratulations" Message:[parseDict valueForKey:@"message"]];
        }
    }
    [HUD hide:YES];
}

-(void)FailRequest:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    if ([error.localizedDescription isEqualToString:@"A connection failure occurred"])
    {
        [self errorAlert:@"No Internet" Message:@"Please Check Your Internet Connections."];
    }
    else
    {
        [self errorAlert:@"oops !" Message:error.localizedDescription];
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
    static NSString *simpleTableIdentifier = @"idSearchList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    IMG_Item = (AsyncImageView *)[cell viewWithTag:1];
    IMG_Item.layer.cornerRadius = 8.0;
    IMG_Item.clipsToBounds = YES;    
    IMG_Item.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[ARY_Data valueForKey:@"member_image_url"][indexPath.row]]];
    IMG_Item.backgroundColor = [UIColor whiteColor];
    
    UILabel *LBL_Name = (UILabel *)[cell viewWithTag:2];
    LBL_Name.text = [NSString stringWithFormat:@"%@",[ARY_Data valueForKey:@"member_name"][indexPath.row]];
    
    UILabel *LBL_Location = (UILabel *)[cell viewWithTag:3];
    LBL_Location.text = [NSString stringWithFormat:@"%@",[ARY_Data valueForKey:@"member_address"][indexPath.row]];
    
    UILabel *LBL_Price = (UILabel *)[cell viewWithTag:4];
    LBL_Price.text = [NSString stringWithFormat:@"Start From RM%@",[ARY_Data valueForKeyPath:@"member_minimum_price"][indexPath.row]];
    
    UIButton *BTN_Promotion = (UIButton *)[cell viewWithTag:5];
    NSString *Str_IsPromotion = [NSString stringWithFormat:@"%@",[ARY_Data valueForKey:@"is_promotion"][indexPath.row]];
    if ([Str_IsPromotion isEqualToString:@"false"]) {
        BTN_Promotion.hidden = YES;
    }
    else
    {
        BTN_Promotion.hidden = NO;
    }
    
    UIImageView *IMG_Star = (UIImageView *)[cell viewWithTag:6];
    IMG_Star.image = [UIImage imageNamed:[NSString stringWithFormat:@"img-%@Star",[ARY_Data valueForKey:@"member_ratings"][indexPath.row]]];
    
    UILabel *LBL_FemaleOnly = (UILabel *)[cell viewWithTag:7];
    UILabel *LBL_MuslimFriendly = (UILabel *)[cell viewWithTag:8];
    
    if (![[NSString stringWithFormat:@"%@",[ARY_Data valueForKeyPath:@"female_only"][indexPath.row]] isEqualToString:@"false"])
    {
        LBL_FemaleOnly.hidden = false;
    }
    
    if (![[NSString stringWithFormat:@"%@",[ARY_Data valueForKeyPath:@"muslim_friendly"][indexPath.row]] isEqualToString:@"false"])
    {
        LBL_MuslimFriendly.hidden = false;
    }
    else
    {
        if (![[NSString stringWithFormat:@"%@",[ARY_Data valueForKeyPath:@"female_only"][indexPath.row]] isEqualToString:@"false"])
        {
            LBL_FemaleOnly.frame = LBL_MuslimFriendly.frame;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [appConfig sharedInstance].DIC_ItmeDetails = ARY_Data[indexPath.row];
    
    [appConfig sharedInstance].ARY_CurrentItemData = ARY_Data;
    
    ItemDetails *viewControler = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcItemDetails];
    viewControler.Dic_itemDetails = ARY_Data[indexPath.row];
    [self.navigationController pushViewController:viewControler animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 4;
    
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex))
    {
        if(CurrentPage == TotalPage)
        {
            
        }
        else
        {
            CurrentPage++;
            [self SearchListAPI];
        }
    }
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    /*NSLog(@"CCKFNavDrawerSelection = %i", selectionIndex);
     self.selectionIdx.text = [NSString stringWithFormat:@"%i",selectionIndex];*/
}


#pragma mark - AlertMethods -- start

-(void)doneAlert:(NSString *)Title Message:(NSString *)Message
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.delegate = self;
    
    alert.avoidCustomImageTint = 1;
    alert.colorScheme = [UIColor colorWithRed:244.0f/255.0f green:152.0f/255.0f blue:47.0f/255.0f alpha:1];
    
    alert.titleColor = [UIColor colorWithRed:244.0f/255.0f green:152.0f/255.0f blue:47.0f/255.0f alpha:1];
    //alert.subTitleColor = alert.flatBlue;
    
    alert.cornerRadius = 15;
    
    alert.hideAllButtons = YES;
    alert.autoHideSeconds = 1;
    alert.blurBackground = YES;
    
    [alert showAlertInView:self
                 withTitle:Title
              withSubtitle:Message
           withCustomImage:[UIImage imageNamed:@"mmAlterIcon.png"]
       withDoneButtonTitle:@"Done"
                andButtons:nil
     ];
}

-(void)successAlert:(NSString *)Title Message:(NSString *)Message
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.delegate = self;
    
    alert.avoidCustomImageTint = 1;
    alert.colorScheme = [UIColor colorWithRed:244.0f/255.0f green:152.0f/255.0f blue:47.0f/255.0f alpha:1];
    
    alert.titleColor = [UIColor colorWithRed:244.0f/255.0f green:152.0f/255.0f blue:47.0f/255.0f alpha:1];
    //alert.subTitleColor = alert.flatBlue;
    alert.cornerRadius = 15;
    //[alert makeAlertTypeSuccess];
    
    [alert showAlertInView:self
                 withTitle:Title
              withSubtitle:Message
           withCustomImage:[UIImage imageNamed:@"mmAlterIcon.png"]
       withDoneButtonTitle:@"Done"
                andButtons:nil
     ];
}

-(void)warningAlert:(NSString *)Title Message:(NSString *)Message
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.delegate = self;
    
    alert.avoidCustomImageTint = 1;
    alert.colorScheme = [UIColor colorWithRed:244.0f/255.0f green:152.0f/255.0f blue:47.0f/255.0f alpha:1];
    
    alert.titleColor = [UIColor colorWithRed:244.0f/255.0f green:152.0f/255.0f blue:47.0f/255.0f alpha:1];
    //alert.subTitleColor = alert.flatBlue;
    
    alert.cornerRadius = 15;
    
    [alert makeAlertTypeCaution];
    
    [alert showAlertInView:self
                 withTitle:Title
              withSubtitle:Message
           withCustomImage:[UIImage imageNamed:@"mmAlterIcon.png"]
       withDoneButtonTitle:@"Done"
                andButtons:nil
     ];
}

-(void)errorAlert:(NSString *)Title Message:(NSString *)Message
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.delegate = self;
    
    alert.avoidCustomImageTint = 1;
    alert.colorScheme = alert.flatRed;
    
    alert.titleColor = [UIColor colorWithRed:244.0f/255.0f green:152.0f/255.0f blue:47.0f/255.0f alpha:1];
    alert.subTitleColor = appColor;
    
    alert.cornerRadius = 15;
    alert.blurBackground = YES;
    
    //[alert makeAlertTypeWarning];
    
    [alert showAlertInView:self
                 withTitle:Title
              withSubtitle:Message
           withCustomImage:[UIImage imageNamed:@"mmAlterIcon.png"]
       withDoneButtonTitle:@"Done"
                andButtons:nil
     ];
}

- (void)FCAlertDoneButtonClicked:(FCAlertView *)alertView
{
    NSLog(@"Done BTN Clicked");
    // Done Button was Pressed, Perform the Action you'd like here.
}

- (void)FCAlertViewDismissed:(FCAlertView *)alertView
{
    NSLog(@"Dismiss BTN Clicked");
    // Your FCAlertView was Dismissed, Perform the Action you'd like here.
}

- (void)FCAlertViewWillAppear:(FCAlertView *)alertView
{
    NSLog(@"AlertView Appear");
    // Your FCAlertView will be Presented, Perform the Action you'd like here.
}

- (void) FCAlertView:(FCAlertView *)alertView clickedButtonIndex:(NSInteger)index buttonTitle:(NSString *)title
{
    if ([title isEqualToString:@"Button 1"])
    { // Change "Button 1" to the title of your first button
        // Perform Action for Button 1
    }
    
    if ([title isEqualToString:@"Button 2"])
    {
        // Perform Action for Button 2
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
