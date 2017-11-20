//
//  SelectMasseur.m
//  iDoSpa
//
//  Created by CronyLog on 29/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "SelectMasseur.h"

@interface SelectMasseur ()

@end

@implementation SelectMasseur

@synthesize Dic_ProductData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self HudMethod];
    
    [appConfig sharedInstance].STR_SelectDate = nil;
    
    //NSLog(@"DATA : %@",[appConfig sharedInstance].ARY_CurrentItemData);
    //NSLog(@"BTN-Tag : %ld",(long)[appConfig sharedInstance].btnTag);
    
    //-(void)TimerStart:(NSString *)ServerTime
        
    BTN_SelectMassure.layer.cornerRadius = BTN_SelectMassure.frame.size.height/2;
    BTN_SelectMassure.clipsToBounds = YES;
    
    BTN_PickDate.layer.cornerRadius = BTN_PickDate.frame.size.height/2;
    BTN_PickDate.clipsToBounds = YES;
    
    BTN_PickTime.layer.cornerRadius = BTN_PickDate.frame.size.height/2;
    BTN_PickTime.clipsToBounds = YES;
    
    BTN_BookNow.layer.cornerRadius = BTN_BookNow.frame.size.height/2;
    BTN_BookNow.clipsToBounds = YES;
    
    //Dic_ListData = [[NSArray alloc]init];
    //Dic_ListData = [Dic_ProductData allValues];
    Dic_ListData = Dic_ProductData;
    
    LBL_NavigationTitle.text = [NSString stringWithFormat:@"%@",[Dic_ListData valueForKey:@"post_title"]];
    
    if ([[Dic_ListData valueForKey:@"isfavourite"] isEqualToString:@"true"])
    {
        //NSLog(@"Favorite : %@",[Dic_ListData valueForKey:@"isfavourite"][[appConfig sharedInstance].btnTag]);
        
        [BTN_Fav setBackgroundImage:[UIImage imageNamed:@"btn-itemFav"] forState:UIControlStateNormal];
        isFavorite = @"true";
    }
    else
    {
        //NSLog(@"Favorite-False");
        [BTN_Fav setBackgroundImage:[UIImage imageNamed:@"btn-itemUnFav"] forState:UIControlStateNormal];
        isFavorite = @"false";
    }
    
    if ([[Dic_ListData valueForKey:@"image"] isEqualToString:@""])
    {
        NSLog(@"Null");
        
        IMG_ProductLogo.image = [UIImage imageNamed:[NSString stringWithFormat:@"img-noItemImage.png"]];
        IMG_ProductLogo.layer.cornerRadius = 8.0;
        IMG_ProductLogo.layer.borderWidth = 0.5;
        IMG_ProductLogo.layer.borderColor = [UIColor lightGrayColor].CGColor;
        IMG_ProductLogo.clipsToBounds = YES;
    }
    else
    {
        NSLog(@"No Null");
        
        IMG_ProductLogo.layer.cornerRadius = 8.0;
        IMG_ProductLogo.clipsToBounds = YES;
        IMG_ProductLogo.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[Dic_ListData valueForKey:@"image"]]];
    }
    
    LBL_ProductName.text = [NSString stringWithFormat:@"%@",[Dic_ListData valueForKey:@"post_title"]];
    
    LBL_Price.text = [NSString stringWithFormat:@"RM%@",[Dic_ListData valueForKey:@"price"]];
    
    IMG_Ratting.image = [UIImage imageNamed:[NSString stringWithFormat:@"img-startRatting%@",[Dic_ListData valueForKey:@"rating"]]];
    
    LBL_ProductDisc.text = [NSString stringWithFormat:@"%@",[Dic_ListData valueForKey:@"post_excerpt"]];
    
    //CGRect frame = LBL_ProductDisc.frame;
    //float height = [self getHeightForText:LBL_ProductDisc.textwithFont:LBL_ProductDisc.fontandWidth:LBL_ProductDisc.frame.size.width];
    //LBL_ProductDisc.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,height);
    
    ARY_MasseurList = [[NSArray alloc]init];
    ARY_MasseurList = [Dic_ListData valueForKey:@"booking_availability_masseur"];
    //NSLog(@"Data : %@",[ARY_MasseurList valueForKey:@"name"]);
    
    [appConfig sharedInstance].DIC_BookingDetails =[[NSMutableDictionary alloc]init];
    
    
    
}



-(float) getHeightForText:(NSString*) text withFont:(UIFont*) font andWidth:(float) width
{
    CGSize constraint = CGSizeMake(width , 20000.0f);
    CGSize title_size;
    float totalHeight;
    
    SEL selector = @selector(boundingRectWithSize:options:attributes:context:);
    if ([text respondsToSelector:selector])
    {
        title_size = [text boundingRectWithSize:constraint
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName : font}
                                        context:nil].size;
        
        totalHeight = ceil(title_size.height);
    }
    else
    {
        title_size = [text sizeWithFont:font
                      constrainedToSize:constraint
                          lineBreakMode:NSLineBreakByWordWrapping];
        totalHeight = title_size.height ;
    }
    
    CGFloat height = MAX(totalHeight, 40.0f);
    return height;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([appConfig sharedInstance].STR_SelectDate != nil)
    {
        SelectDateSlot = [NSString stringWithFormat:@"%@",[appConfig sharedInstance].STR_SelectDate];
        [BTN_PickDate setTitle:[NSString stringWithFormat:@"%@",[appConfig sharedInstance].STR_SelectDate] forState:UIControlStateNormal];
        [BTN_PickDate setBackgroundImage:[UIImage imageNamed:@"btn-search-showMeNearby"] forState:UIControlStateNormal];
        [self getMassureTime];
    }
}

#pragma mark - API call

-(void)ChangeFavStatus
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
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@%@&post_id=%@",apiBase,apiFavorite,[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"],[Dic_ListData valueForKey:@"post_id"]]];
        
        apiFavRequest = [ASIFormDataRequest requestWithURL:url];
        
        [apiFavRequest setRequestMethod:APIRequestGet];
    
        [apiFavRequest setDidFinishSelector:@selector(FavRespose:)];
        [apiFavRequest setDidFailSelector:@selector(FailRequest:)];
        
        [apiFavRequest setDelegate:self];
        [apiFavRequest startAsynchronous];
    }
}

-(void)FavRespose:(ASIHTTPRequest *)request
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
            isFavorite = @"true";
            [BTN_Fav setBackgroundImage:[UIImage imageNamed:@"btn-itemFav"] forState:UIControlStateNormal];
            [[appConfig sharedInstance]SucessAlertCall:Status Message:[parseDict valueForKey:@"message"] ViewContriller:self];
        }
    }
    [HUD hide:YES];
}

-(void)ChangeUnFavStatus
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
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@%@&post_id=%@",apiBase,apiUnFavorite,[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"],[Dic_ListData valueForKey:@"post_id"]]];
        
        apiFavRequest = [ASIFormDataRequest requestWithURL:url];
        [apiFavRequest setRequestMethod:APIRequestGet];
        
        [apiFavRequest setDidFinishSelector:@selector(unFavRespose:)];
        [apiFavRequest setDidFailSelector:@selector(FailRequest:)];
        
        [apiFavRequest setDelegate:self];
        [apiFavRequest startAsynchronous];
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
            isFavorite = @"false";
            [BTN_Fav setBackgroundImage:[UIImage imageNamed:@"btn-itemUnFav"] forState:UIControlStateNormal];
            [[appConfig sharedInstance]SucessAlertCall:Status Message:[parseDict valueForKey:@"message"] ViewContriller:self];
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
//        NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
//        NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
        [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:error.localizedDescription ViewContriller:self];
    }
    [HUD hide:YES];
}


#pragma mark - IBAction

-(IBAction)CLK_Back:(id)sender
{
    pushToBack;
}

-(IBAction)CLK_ItemFavChange:(id)sender
{
    if ([isFavorite isEqualToString:@"true"])
    {
        [self ChangeUnFavStatus];
    }
    else
    {
        [self ChangeFavStatus];
    }
}

-(IBAction)CLK_SelectMassure:(id)sender
{    
    if ([ARY_MasseurList isEqual:[NSNull null]] || ARY_MasseurList.count == 0)
    {
        NSLog(@"No Data");
    }
    else
    {
        YActionSheet *options = [[YActionSheet alloc] initWithTitle:@"SELECT MASSEUR"
                                                 dismissButtonTitle:@"DONE"
                                                  otherButtonTitles:[ARY_MasseurList valueForKey:@"name"]
                                                    dismissOnSelect:YES];
        [options setSelectedIndex:0];
        [options showInViewController:self withYActionSheetBlock:^(NSInteger buttonIndex, BOOL isCancel)
        {
             if (isCancel)
             {
                 NSLog(@"cancelled");
             }
             else
             {
                 NSLog(@"masseur_id : %@",[ARY_MasseurList valueForKey:@"masseur_id"][buttonIndex]);
                 NSLog(@"post_id : %@",[NSString stringWithFormat:@"%@",[Dic_ListData valueForKey:@"post_id"]]);

                 STR_getDateMassureID = [ARY_MasseurList valueForKey:@"masseur_id"][buttonIndex];
                 [BTN_SelectMassure setTitle:[NSString stringWithFormat:@"%@",[ARY_MasseurList valueForKey:@"name"][buttonIndex]] forState:UIControlStateNormal];
                 
                 [BTN_PickDate setTitle:[NSString stringWithFormat:@"Pick a Date"] forState:UIControlStateNormal];
                 [BTN_PickTime setTitle:[NSString stringWithFormat:@"Pick a Time"] forState:UIControlStateNormal];
                 
                 [BTN_PickDate setBackgroundImage:nil forState:UIControlStateNormal];
                 [BTN_PickTime setBackgroundImage:nil forState:UIControlStateNormal];
                 [BTN_BookNow setBackgroundImage:nil forState:UIControlStateNormal];
                 
                 [self getMassureDate];
             }
        }];
    }
}

-(void)getMassureDate
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
        //NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://ids2.1s.my/?api=1&task=masseurdatetimeslot&post_id=1197&masseur_id=1198"]]; // Test-URL
        
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@post_id=%@&masseur_id=%@",apiBase,apiGetMassureDate,[Dic_ListData valueForKey:@"post_id"],STR_getDateMassureID]];
        
        apiGetDateTime = [ASIFormDataRequest requestWithURL:url];
        
        [apiGetDateTime setRequestMethod:APIRequestGet];
        
        [apiGetDateTime setDidFinishSelector:@selector(getDateRespose:)];
        [apiGetDateTime setDidFailSelector:@selector(FailRequest:)];
        
        [apiGetDateTime setDelegate:self];
        [apiGetDateTime startAsynchronous];
    }
}

-(void)getDateRespose:(ASIHTTPRequest *)request
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
            ARY_MassureDateSlote = [[NSMutableArray alloc]init];
            ARY_MassureDateSlote = [parseDict valueForKeyPath:@"data.bookable_days.available_day"];
            //NSLog(@"date : %@ == %lu",ARY_MassureDateSlote,(unsigned long)ARY_MassureDateSlote.count);
        }
    }
    [HUD hide:YES];
}

-(IBAction)CLK_PickDate:(id)sender
{
    if ([ARY_MassureDateSlote isEqual:[NSNull null]] || ARY_MassureDateSlote.count == 0)
    {
        NSLog(@"No Data");
    }
    else
    {
        [appConfig sharedInstance].STR_SelectDate = nil;
        
        CalanderView *CalanderView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcCalanderView];
        CalanderView.Arry_DateList = ARY_MassureDateSlote;
        [self.navigationController pushViewController:CalanderView animated:YES];
        
        
        /*
        YActionSheet *options = [[YActionSheet alloc] initWithTitle:@"SELECT DATE"
                                                 dismissButtonTitle:@"DONE"
                                                  otherButtonTitles:ARY_MassureDateSlote
                                                    dismissOnSelect:YES];
        [options setSelectedIndex:0];
        [options showInViewController:self withYActionSheetBlock:^(NSInteger buttonIndex, BOOL isCancel)
         {
             if (isCancel)
             {
                 NSLog(@"cancelled");
             }
             else
             {
                //NSLog(@"Selected Date : %@",ARY_MassureDateSlote[buttonIndex]);
                 
                 SelectDateSlot = [NSString stringWithFormat:@"%@",ARY_MassureDateSlote[buttonIndex]];
                 [BTN_PickDate setTitle:[NSString stringWithFormat:@"%@",[ARY_MassureDateSlote objectAtIndex:buttonIndex]] forState:UIControlStateNormal];
                 
                 [BTN_PickDate setBackgroundImage:[UIImage imageNamed:@"btn-search-showMeNearby"] forState:UIControlStateNormal];
                 
                 [self getMassureTime];
             }
        }];
         */
    }
}

-(void)getMassureTime
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
        
       //NSLog(@"%@",[[NSString alloc] initWithFormat:@"%@%@post_id=%@&masseur_id=%@&date=%@",apiBase,apiGetMassureTime,[Dic_ListData valueForKey:@"post_id"][[appConfig sharedInstance].btnTag],STR_getDateMassureID,SelectDateSlot]);
        
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@post_id=%@&masseur_id=%@&date=%@",apiBase,apiGetMassureTime,[Dic_ListData valueForKey:@"post_id"],STR_getDateMassureID,SelectDateSlot]];
        
        //.my/?api=1&task=masseurtimeslot&post_id=87&masseur_id=88&date=24/08/2017
        
        apiGetDateTime = [ASIFormDataRequest requestWithURL:url];
        
        [apiGetDateTime setRequestMethod:APIRequestGet];
        
        [apiGetDateTime setDidFinishSelector:@selector(getTimeRespose:)];
        [apiGetDateTime setDidFailSelector:@selector(FailRequest:)];
        
        [apiGetDateTime setDelegate:self];
        [apiGetDateTime startAsynchronous];
    }
}

-(void)getTimeRespose:(ASIHTTPRequest *)request
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
            
            [BTN_PickTime setTitle:[NSString stringWithFormat:@"Pick a Time"] forState:UIControlStateNormal];
            [BTN_PickTime setBackgroundImage:nil forState:UIControlStateNormal];
            [BTN_BookNow setBackgroundImage:nil forState:UIControlStateNormal];
        }
        else
        {
            
            //NSLog(@"date : %@",[parseDict valueForKeyPath:@"data.db_value"]);
            
            ARY_MassureTimeSlote = [[NSMutableArray alloc]init];
            ARY_MassureTimeSlote = [[parseDict valueForKeyPath:@"data.db_value"] mutableCopy];
            
//            NSString *STR_Data = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"data"]];
//            
//            if ([STR_Data isEqualToString:@"No time is available"])
//            {
//                [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:[parseDict valueForKey:@"data"] ViewContriller:self];
//            }
//            else
//            {
//                NSLog(@"date : %@",[parseDict valueForKeyPath:@"data.db_value"]);
//                
//                ARY_MassureTimeSlote = [[NSMutableArray alloc]init];
//                ARY_MassureTimeSlote = [[parseDict valueForKeyPath:@"data.db_value"] mutableCopy];
//            }
        }
    }
    [HUD hide:YES];
}


-(IBAction)CLK_PickTime:(id)sender
{
    if ([ARY_MassureTimeSlote isEqual:[NSNull null]] || ARY_MassureTimeSlote.count == 0)
    {
        NSLog(@"No Data");
    }
    else
    {
        YActionSheet *options = [[YActionSheet alloc] initWithTitle:@"SELECT TIME"
                                                 dismissButtonTitle:@"DONE"
                                                  otherButtonTitles:ARY_MassureTimeSlote
                                                    dismissOnSelect:YES];
        [options setSelectedIndex:0];
        [options showInViewController:self withYActionSheetBlock:^(NSInteger buttonIndex, BOOL isCancel)
         {
             if (isCancel)
             {
                 NSLog(@"cancelled");
             }
             else
             {
                 NSLog(@"Selected Time : %@",[ARY_MassureTimeSlote objectAtIndex:buttonIndex]);
                 
                 SelectTimeSlot = [NSString stringWithFormat:@"%@",[ARY_MassureTimeSlote objectAtIndex:buttonIndex]];
                 [BTN_PickTime setTitle:[NSString stringWithFormat:@"%@",[ARY_MassureTimeSlote objectAtIndex:buttonIndex]] forState:UIControlStateNormal];
                 [BTN_PickTime setBackgroundImage:[UIImage imageNamed:@"btn-search-showMeNearby"] forState:UIControlStateNormal];
                 [BTN_BookNow setBackgroundImage:[UIImage imageNamed:@"btn-search-showMeNearby"] forState:UIControlStateNormal];
            }
        }];
    }
}

-(IBAction)CLK_BookNow:(id)sender
{
    if ([BTN_PickDate.titleLabel.text isEqualToString:@"Pick a Date"])
    {
        [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:@"Select Pick Date" ViewContriller:self];
    }
    else if ([BTN_PickTime.titleLabel.text isEqualToString:@"Pick a Time"])
    {
        [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:@"Select Pick Time" ViewContriller:self];
    }
    else if ([BTN_SelectMassure.titleLabel.text isEqualToString:@"Select Masseur"])
    {
        [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:@"Select Pick Masseur" ViewContriller:self];
    }
    else
    {
        [[appConfig sharedInstance].DIC_BookingDetails setObject:STR_getDateMassureID forKey:@"masseur_id"];
        [[appConfig sharedInstance].DIC_BookingDetails setObject:SelectDateSlot forKey:@"Date"];
        [[appConfig sharedInstance].DIC_BookingDetails setObject:SelectTimeSlot forKey:@"Time"];
        [[appConfig sharedInstance].DIC_BookingDetails setObject:[Dic_ListData valueForKey:@"post_id"] forKey:@"Post_id"];
        [[appConfig sharedInstance].DIC_BookingDetails setObject:BTN_SelectMassure.titleLabel.text forKey:@"masseur_name"];
       
        //NSLog(@"%@",[appConfig sharedInstance].DIC_BookingDetails);
        
        ConfirmBillingInfoView *PlaceOrderView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcConfirmBillingInfoView];
        
        PlaceOrderView.Dic_ListData = Dic_ProductData;
        [self.navigationController pushViewController:PlaceOrderView animated:YES];
        
        //[self BookingUnPaidAPIcall];
        
    }
    //[self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcPlaceOrder] animated:YES];
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
