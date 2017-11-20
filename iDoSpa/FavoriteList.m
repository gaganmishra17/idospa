//
//  FavoriteList.m
//  iDoSpa
//
//  Created by CronyLog on 10/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "FavoriteList.h"

@interface FavoriteList ()
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end

@implementation FavoriteList

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self HudMethod];
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    [self GetFavoriteList];
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

-(void)GetFavoriteList
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
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@%@",apiBase,apiFavoriteList,[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"]]];
        
        apiFavoriteListGet = [ASIFormDataRequest requestWithURL:url];
        
        [apiFavoriteListGet setRequestMethod:APIRequestGet];
        
        [apiFavoriteListGet setDidFinishSelector:@selector(FavoriteListRespose:)];
        [apiFavoriteListGet setDidFailSelector:@selector(FailRequest:)];
        
        [apiFavoriteListGet setDelegate:self];
        [apiFavoriteListGet startAsynchronous];
    }
}

-(void)FavoriteListRespose:(ASIHTTPRequest *)request
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
            //NSLog(@"Data : %@",parseDict);
            ARY_Data = [[NSMutableArray alloc]init];
            ARY_Data = [[parseDict valueForKey:@"favourit_post_id_list"] mutableCopy];
            
            [TBL_DataList reloadData];
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

-(void)RemoveFavouritItem:(NSString *)Str_PostID
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
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@%@&post_id=%@",apiBase,apiUnFavorite,[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"],Str_PostID]];
        
        apiFavoriteListGet = [ASIFormDataRequest requestWithURL:url];
        [apiFavoriteListGet setRequestMethod:APIRequestGet];
        
        [apiFavoriteListGet setDidFinishSelector:@selector(unFavRespose:)];
        [apiFavoriteListGet setDidFailSelector:@selector(FailRequest:)];
        
        [apiFavoriteListGet setDelegate:self];
        [apiFavoriteListGet startAsynchronous];
    }
}

-(void)unFavRespose:(ASIHTTPRequest *)request
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
            [self GetFavoriteList];
        }
    }
    [HUD hide:YES];
}

#pragma mark - IBActions

-(void)CLK_RemoveFav:(id)sender
{
    NSIndexPath  *indexPath = [TBL_DataList indexPathForCell: (UITableViewCell *)[sender superview].superview];
    Index_Select = indexPath;
    [self RemoveFavAlertCall];
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
    
    IMG_Item = (AsyncImageView *)[cell viewWithTag:1];
    
    if ([[ARY_Data valueForKey:@"image"][indexPath.row] isEqualToString:@""])
    {
        NSLog(@"Null");
        IMG_Item.layer.cornerRadius = 8.0;
        IMG_Item.image = [UIImage imageNamed:[NSString stringWithFormat:@"img-noItemImage.png"]];
        IMG_Item.backgroundColor = [UIColor whiteColor];
        IMG_Item.layer.borderWidth = 0.5;
        IMG_Item.layer.borderColor = [UIColor lightGrayColor].CGColor;
        IMG_Item.clipsToBounds = YES;
    }
    else
    {
        NSLog(@"No Null");
        IMG_Item.layer.cornerRadius = 8.0;
        IMG_Item.clipsToBounds = YES;
        IMG_Item.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[ARY_Data valueForKey:@"image"][indexPath.row]]];
        IMG_Item.backgroundColor = [UIColor whiteColor];
        IMG_Item.clipsToBounds = YES;
    }
    
    UILabel *LBL_Name = (UILabel *)[cell viewWithTag:2];
    LBL_Name.text = [NSString stringWithFormat:@"%@",[ARY_Data valueForKey:@"post_title"][indexPath.row]];
    
    UILabel *LBL_Location = (UILabel *)[cell viewWithTag:3];
    LBL_Location.text = [NSString stringWithFormat:@"%@",[ARY_Data valueForKey:@"post_excerpt"][indexPath.row]];
    
    UILabel *LBL_Price = (UILabel *)[cell viewWithTag:4];
    LBL_Price.text = [NSString stringWithFormat:@"Start From RM%@",[ARY_Data valueForKeyPath:@"price"][indexPath.row]];
    
    UIButton *BTN_RemoveFav = (UIButton *)[cell viewWithTag:5];
    [BTN_RemoveFav addTarget:self action:@selector(CLK_RemoveFav:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *IMG_Star = (UIImageView *)[cell viewWithTag:6];
    IMG_Star.image = [UIImage imageNamed:[NSString stringWithFormat:@"img-%@Star",[ARY_Data valueForKey:@"rating"][indexPath.row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    SelectMasseur *viewControler = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSelectMasseur];
    [appConfig sharedInstance].btnTag = indexPath.row;
    viewControler.Dic_ProductData = ARY_Data[indexPath.row];
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

#pragma mark - Other Method

-(void)RemoveFavAlertCall
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.delegate = self;
    alert.tag = 100;
    
    alert.bounceAnimations = YES;
    alert.blurBackground = YES;
    //alert.fullCircleCustomImage = YES;
    alert.detachButtons = YES;
    //alert.animateAlertInFromTop = YES;
    alert.hideDoneButton = YES;
    //[alert makeAlertTypeProgress];
    
    [alert showAlertInView:self
                 withTitle:@"Are You Sure To Remove Favourite Item ?"
              withSubtitle:nil
           withCustomImage:nil
       withDoneButtonTitle:nil
                andButtons:@[@"Cancel", @"OK"]];
    
    alert.firstButtonBackgroundColor = [UIColor redColor];
    alert.secondButtonBackgroundColor = appColor;
    
    alert.firstButtonTitleColor = [UIColor whiteColor];
    alert.secondButtonTitleColor = [UIColor whiteColor];
    
    alert.firstButtonHighlightedBackgroundColor = [UIColor blackColor];
}

#pragma mark - Alert

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
                andButtons:nil];
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

- (void)FCAlertView:(FCAlertView *)alertView clickedButtonIndex:(NSInteger)index buttonTitle:(NSString *)title
{
    if(alertView.tag == 100)
    {
        if ([title isEqualToString:@"OK"])
        {
            //NSLog(@"OK");
            NSString *Str_ProductID = [NSString stringWithFormat:@"%@",[ARY_Data valueForKey:@"post_id"][Index_Select.row]];
            [self RemoveFavouritItem:Str_ProductID];
            //Index_Select
        }
        if ([title isEqualToString:@"Cancel"])
        {
            //NSLog(@"Cancel");
        }
    }
}

#pragma mark -


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
