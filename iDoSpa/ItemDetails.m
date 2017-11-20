//
//  ItemDetails.m
//  iDoSpa
//
//  Created by CronyLog on 28/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "ItemDetails.h"

@interface ItemDetails ()

@end

@implementation ItemDetails

@synthesize  Dic_itemDetails;

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    //NSLog(@"%@",Dic_itemDetails);
    
    LBL_ItemName.text = [NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKey:@"member_name"]];
    LBL_Location.text = [NSString stringWithFormat:@"%@,%@,%@",[Dic_itemDetails valueForKey:@"member_city"],[Dic_itemDetails valueForKey:@"member_state"],[Dic_itemDetails valueForKey:@"member_country"]];
    LBL_ItemDisc.text = [NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKey:@"member_description"]];
    
    IMG_ItemLogo.layer.cornerRadius = 8.0;
    IMG_ItemLogo.clipsToBounds = YES;
    
    IMG_ItemLogo.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKey:@"member_image_url"]]];
    IMG_RattingStar.image = [UIImage imageNamed:[NSString stringWithFormat:@"img-%@Star",[Dic_itemDetails valueForKey:@"member_ratings"]]];
    
    ARY_Gallary = [[NSArray alloc]init];
    ARY_Gallary = [Dic_itemDetails valueForKey:@"member_gallery_image"];
        
    [self setGallaryScroll];
    
    //ProductList Get
    [self GetProductList];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [SCRL_MarchantDataHolder setContentSize:CGSizeMake(SCRL_MarchantDataHolder.frame.size.width*3, 0)];
    [self setAboutData];
    
    if (![[NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKeyPath:@"female_only"]] isEqualToString:@"false"])
    {
        LBL_FemaleOnly.hidden = false;
    }
    
    if (![[NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKeyPath:@"muslim_friendly"]] isEqualToString:@"false"])
    {
        LBL_MuslimFriendly.hidden = false;
    }
    else
    {
        if (![[NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKeyPath:@"female_only"]] isEqualToString:@"false"])
        {
            LBL_FemaleOnly.frame = LBL_MuslimFriendly.frame;
        }
    }
    
    LBL_DirectionAdd.text = [NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKey:@"member_address"]];
    CGRect frame = LBL_DirectionAdd.frame;
    float height = [self getHeightForText:LBL_DirectionAdd.text
                                 withFont:LBL_DirectionAdd.font
                                 andWidth:LBL_DirectionAdd.frame.size.width];
    LBL_DirectionAdd.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,height);
    
    [SCRL_DirectionData setContentSize:CGSizeMake(0,LBL_DirectionAdd.frame.origin.y+LBL_DirectionAdd.frame.size.height+10)];
}

-(void)setGallaryScroll
{
    int setXBanner = 0;
    for (int b =0; b<ARY_Gallary.count; b++)
    {
        IMG_GallaryItem = [[AsyncImageView alloc]initWithFrame:CGRectMake(setXBanner, 0, SCRL_ImageGallary.frame.size.width, SCRL_ImageGallary.frame.size.height)];
        IMG_GallaryItem.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[ARY_Gallary objectAtIndex:b]]];
        //IMG_GallaryItem.backgroundColor = [UIColor redColor];
        
        [SCRL_ImageGallary addSubview:IMG_GallaryItem];
        
        setXBanner = setXBanner+SCRL_ImageGallary.frame.size.width;
    }
    
    [SCRL_ImageGallary setContentSize:CGSizeMake(SCRL_ImageGallary.frame.size.width*ARY_Gallary.count, 0)];
}

-(void)setAboutData
{
    int xCord = 8;
    int yCord=8;
    
    LBL_AboutDisc = [[UILabel alloc]initWithFrame:CGRectMake(8, yCord, SCRL_AboutData.frame.size.width-xCord*2, 150)];
    LBL_AboutDisc.text = [NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKey:@"member_description"]];
    [LBL_AboutDisc setFont:[UIFont fontWithName:@"Hero" size:15]];
    
    //Dynamic LableSize
    CGRect frame = LBL_AboutDisc.frame;
    float height = [self getHeightForText:LBL_AboutDisc.text
                                 withFont:LBL_AboutDisc.font
                                 andWidth:LBL_AboutDisc.frame.size.width];
    LBL_AboutDisc.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,height);//
    
    LBL_AboutDisc.lineBreakMode = NSLineBreakByWordWrapping;
    LBL_AboutDisc.numberOfLines = 0;
    [SCRL_AboutData addSubview:LBL_AboutDisc];
    
    LBL_OpeningHoursTitle = [[UILabel alloc]initWithFrame:CGRectMake(8, yCord+height+15, SCRL_AboutData.frame.size.width-xCord*2, 25)];
    LBL_OpeningHoursTitle.text = [NSString stringWithFormat:@"Opening Hours"];
    [LBL_OpeningHoursTitle setFont:[UIFont fontWithName:@"Hero" size:16]];
    [SCRL_AboutData addSubview:LBL_OpeningHoursTitle];
    
    //MondayRow
    LBL_Monday = [[UILabel alloc]initWithFrame:CGRectMake(xCord, yCord+LBL_OpeningHoursTitle.frame.origin.y+LBL_OpeningHoursTitle.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord*2, 25)];
    [LBL_Monday setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_Monday.text = @"Monday";
    [SCRL_AboutData addSubview:LBL_Monday];
    
    LBL_MondayData = [[UILabel alloc]initWithFrame:CGRectMake(LBL_Monday.frame.size.width+xCord*2, yCord+LBL_OpeningHoursTitle.frame.origin.y+LBL_OpeningHoursTitle.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord, 25)];
    [LBL_MondayData setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_MondayData.textColor = [UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0];
    LBL_MondayData.text = [NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKeyPath:@"member_openinghours.monday"]];
    [SCRL_AboutData addSubview:LBL_MondayData];
    
    //Tuesday
    LBL_Tuesday = [[UILabel alloc]initWithFrame:CGRectMake(xCord,LBL_Monday.frame.origin.y+LBL_Monday.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord*2, 25)];
    [LBL_Tuesday setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_Tuesday.text = @"Tuesday";
    [SCRL_AboutData addSubview:LBL_Tuesday];
    
    LBL_TuesdayData = [[UILabel alloc]initWithFrame:CGRectMake(LBL_Monday.frame.size.width+xCord*2, LBL_Monday.frame.origin.y+LBL_Monday.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord, 25)];
    [LBL_TuesdayData setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_TuesdayData.textColor = [UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0];
    LBL_TuesdayData.text = [NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKeyPath:@"member_openinghours.tuesday"]];
    [SCRL_AboutData addSubview:LBL_TuesdayData];
    
    //LBL_Wednesday
    LBL_Wednesday = [[UILabel alloc]initWithFrame:CGRectMake(xCord,LBL_Tuesday.frame.origin.y+LBL_Tuesday.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord*2, 25)];
    [LBL_Wednesday setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_Wednesday.text = @"Wednesday";
    [SCRL_AboutData addSubview:LBL_Wednesday];
    
    LBL_WednesdayData = [[UILabel alloc]initWithFrame:CGRectMake(LBL_Monday.frame.size.width+xCord*2, LBL_Tuesday.frame.origin.y+LBL_Tuesday.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord, 25)];
    [LBL_WednesdayData setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_WednesdayData.textColor = [UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0];
    LBL_WednesdayData.text = [NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKeyPath:@"member_openinghours.wednesday"]];
    [SCRL_AboutData addSubview:LBL_WednesdayData];
    
    //thursday
    LBL_Thursday = [[UILabel alloc]initWithFrame:CGRectMake(xCord,LBL_Wednesday.frame.origin.y+LBL_Wednesday.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord*2, 25)];
    [LBL_Thursday setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_Thursday.text = @"Thursday";
    [SCRL_AboutData addSubview:LBL_Thursday];
    
    LBL_ThursdayData = [[UILabel alloc]initWithFrame:CGRectMake(LBL_Monday.frame.size.width+xCord*2, LBL_Wednesday.frame.origin.y+LBL_Wednesday.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord, 25)];
    [LBL_ThursdayData setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_ThursdayData.textColor = [UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0];
    LBL_ThursdayData.text = [NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKeyPath:@"member_openinghours.thursday"]];
    [SCRL_AboutData addSubview:LBL_ThursdayData];
    
    //FriDay
    LBL_Friday = [[UILabel alloc]initWithFrame:CGRectMake(xCord,LBL_ThursdayData.frame.origin.y+LBL_ThursdayData.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord*2, 25)];
    [LBL_Friday setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_Friday.text = @"Friday";
    [SCRL_AboutData addSubview:LBL_Friday];
    
    LBL_FridayData = [[UILabel alloc]initWithFrame:CGRectMake(LBL_Monday.frame.size.width+xCord*2, LBL_ThursdayData.frame.origin.y+LBL_ThursdayData.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord, 25)];
    [LBL_FridayData setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_FridayData.textColor = [UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0];
    LBL_FridayData.text = [NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKeyPath:@"member_openinghours.friday"]];
    [SCRL_AboutData addSubview:LBL_FridayData];
    
    //saturday
    LBL_Saturday = [[UILabel alloc]initWithFrame:CGRectMake(xCord,LBL_FridayData.frame.origin.y+LBL_FridayData.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord*2, 25)];
    [LBL_Saturday setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_Saturday.text = @"Saturday";
    [SCRL_AboutData addSubview:LBL_Saturday];
    
    LBL_SaturdayData = [[UILabel alloc]initWithFrame:CGRectMake(LBL_Monday.frame.size.width+xCord*2, LBL_FridayData.frame.origin.y+LBL_FridayData.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord, 25)];
    [LBL_SaturdayData setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_SaturdayData.textColor = [UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0];
    LBL_SaturdayData.text = [NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKeyPath:@"member_openinghours.saturday"]];
    [SCRL_AboutData addSubview:LBL_SaturdayData];
    
    //sunday
    LBL_Sunday = [[UILabel alloc]initWithFrame:CGRectMake(xCord,LBL_SaturdayData.frame.origin.y+LBL_SaturdayData.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord*2, 25)];
    [LBL_Sunday setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_Sunday.text = @"Sunday";
    [SCRL_AboutData addSubview:LBL_Sunday];
    
    LBL_SundayData = [[UILabel alloc]initWithFrame:CGRectMake(LBL_Monday.frame.size.width+xCord*2, LBL_SaturdayData.frame.origin.y+LBL_SaturdayData.frame.size.height, SCRL_AboutData.frame.size.width/2-xCord, 25)];
    [LBL_SundayData setFont:[UIFont fontWithName:@"Hero" size:15]];
    LBL_SundayData.textColor = [UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0];
    LBL_SundayData.text = [NSString stringWithFormat:@"%@",[Dic_itemDetails valueForKeyPath:@"member_openinghours.sunday"]];
    [SCRL_AboutData addSubview:LBL_SundayData];
    
    [SCRL_AboutData setContentSize:CGSizeMake(0,LBL_SundayData.frame.origin.y+LBL_SundayData.frame.size.height+10)];
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
                                     attributes:@{ NSFontAttributeName : font }
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

#pragma mark - API call Product List

-(void)GetProductList
{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        //[self errorAlert:@"No Internet" Message:@"Please Check Your Internet Connections."];
        [HUD hide:YES];
    }
    else
    {
       // http://ids2.1s.my/?api=1&task=member_product_list&member_id=12&accesstoken=9c52b58e456dsrf541e89c439
        
            NSString *STR_GetURL;
            STR_GetURL =
            [NSString stringWithFormat:@"?api=1&task=member_product_list&member_id=%@&accesstoken=%@",[Dic_itemDetails valueForKey:@"member_id"],[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"]];
            
            STR_GetURL = [STR_GetURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",apiBase,STR_GetURL]];
            apiProductListListRequest = [ASIFormDataRequest requestWithURL:url];
            
            [apiProductListListRequest setRequestMethod:APIRequestGet];
            
            [apiProductListListRequest setDidFinishSelector:@selector(ProductListRespose:)];
            [apiProductListListRequest setDidFailSelector:@selector(FailRequest:)];
            
            [apiProductListListRequest setDelegate:self];
            [apiProductListListRequest startAsynchronous];
    }
}

-(void)ProductListRespose:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
    //NSLog(@"%@",parseDict);
    
    if (parseDict != NULL)
    {
        NSString *Status = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"status"]];
        if ([Status isEqualToString:@"false"])
        {
            //[self errorAlert:@"oops !" Message:[parseDict valueForKey:@"message"]];
            [[appConfig sharedInstance]FailAlertCall:@"oops !" Message:[parseDict valueForKey:@"message"] ViewContriller:self];
        }
        else
        {
            ARY_ProductData = [[NSArray alloc]init];
            ARY_ProductData = [parseDict valueForKeyPath:@"data.member_product_list"];
//            //NSLog(@"Product : %@",ARY_ProductData);
            [TBL_ServiceData reloadData];
        }
    }
    [HUD hide:YES];
}

-(void)FailRequest:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if ([error.localizedDescription isEqualToString:@"A connection failure occurred"])
    {
        [[appConfig sharedInstance]FailAlertCall:@"No Internet" Message:@"Please Check Your Internet Connections." ViewContriller:self];
    }
    else
    {
        [[appConfig sharedInstance]FailAlertCall:@"oops !" Message:error.localizedDescription ViewContriller:self];
    }
    [HUD hide:YES];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == SCRL_MarchantDataHolder)
    {
        //Banner
        int pageNum = (int)(SCRL_MarchantDataHolder.contentOffset.x / SCRL_MarchantDataHolder.frame.size.width);
        
        if (pageNum == 1)
        {
            //NSLog(@"About");
            [BTN_Service setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [BTN_About setTitleColor:[UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [BTN_Direction setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        else if (pageNum == 2)
        {
            //NSLog(@"Direction");
            [BTN_Service setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [BTN_About setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [BTN_Direction setTitleColor:[UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        else
        {
            //NSLog(@"Service");
            [BTN_Service setTitleColor:[UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [BTN_About setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [BTN_Direction setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - IBAction

-(IBAction)CLK_Back:(id)sender
{
    pushToBack;
}

-(IBAction)CLK_FavoriteList:(id)sender
{
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcFavoriteList] animated:YES];
}

-(IBAction)CLK_Service:(id)sender
{
    [BTN_Service setTitleColor:[UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [BTN_About setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [BTN_Direction setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    STR_ShowDataStatus = @"Service";
    
    [SCRL_MarchantDataHolder setContentOffset:CGPointMake(VW_ServiceHolder.frame.origin.x, VW_ServiceHolder.frame.origin.y) animated:YES];
}

-(IBAction)CLK_About:(id)sender
{
    [BTN_Service setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [BTN_About setTitleColor:[UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [BTN_Direction setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    STR_ShowDataStatus = @"About";
    
    [SCRL_MarchantDataHolder setContentOffset:CGPointMake(VW_AboutHolder.frame.origin.x, VW_AboutHolder.frame.origin.y) animated:YES];
}

-(IBAction)CLK_Direction:(id)sender
{
    [BTN_Service setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [BTN_About setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [BTN_Direction setTitleColor:[UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    STR_ShowDataStatus = @"Direction";
    [self SetPlace];
    
    [SCRL_MarchantDataHolder setContentOffset:CGPointMake(VW_DirectionHolder.frame.origin.x, VW_DirectionHolder.frame.origin.y) animated:YES];
}

-(IBAction)CLK_DirectionWeb:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.idospa.my/"]];
}

-(IBAction)CLK_DirectionMaps:(id)sender
{
    //Dic_itemDetails
    
    float lat = [[Dic_itemDetails valueForKey:@"member_lat"] floatValue];
    float lng = [[Dic_itemDetails valueForKey:@"member_long"] floatValue];
    
    CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake(lat, lng);
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    
    [endingItem openInMapsWithLaunchOptions:launchOptions];
}

-(void)SetPlace
{
    [MP_Address removeAnnotations:MP_Address.annotations];
    
    CLLocationCoordinate2D  ctrpoint;
    ctrpoint.latitude= [[Dic_itemDetails valueForKey:@"member_lat"] doubleValue];
    ctrpoint.longitude=[[Dic_itemDetails valueForKey:@"member_long"] doubleValue];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake([[Dic_itemDetails valueForKey:@"member_lat"] doubleValue], [[Dic_itemDetails valueForKey:@"member_long"] doubleValue]);
    //annotation.title = [User_det valueForKey:@"username"];
    //annotation.subtitle = location[@"address"];
    [MP_Address addAnnotation:annotation];
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in MP_Address.annotations)
    {
        NSLog(@"annotation : %@",annotation);
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        if (MKMapRectIsNull(zoomRect))
        {
            zoomRect = pointRect;
        }
        else
        {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [MP_Address setVisibleMapRect:zoomRect animated:YES];
}


#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ARY_ProductData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"idProductData";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *LBL_Name = (UILabel *)[cell viewWithTag:1];
    LBL_Name.text = [NSString stringWithFormat:@"%@",[ARY_ProductData valueForKey:@"post_title"][indexPath.row]];
    
    UILabel *LBL_OldPrice = (UILabel *)[cell viewWithTag:2];
    NSAttributedString * title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"RM%@",[ARY_ProductData valueForKey:@"price"][indexPath.row]] attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
    [LBL_OldPrice setAttributedText:title];
    
    UILabel *LBL_NewPrice = (UILabel *)[cell viewWithTag:3];
    LBL_NewPrice.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"RM%@",[ARY_ProductData valueForKey:@"price"][indexPath.row]]];
    
    UIButton *BTN_BookNow = (UIButton *)[cell viewWithTag:4];
    [BTN_BookNow addTarget:self action:@selector(CLK_BookNowProduct:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *IMG_Star = (UIImageView *)[cell viewWithTag:5];//img-startRatting0
    IMG_Star.image = [UIImage imageNamed:[NSString stringWithFormat:@"img-startRatting%@",[ARY_ProductData valueForKey:@"rating"][indexPath.row]]];
    
    return cell;
}

-(void)CLK_BookNowProduct:(id)sender
{
    NSIndexPath  *indexPath = [TBL_ServiceData indexPathForCell: (UITableViewCell *)[sender superview].superview];
    
    SelectMasseur *viewControler = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSelectMasseur];
    [appConfig sharedInstance].btnTag = indexPath.row;
    viewControler.Dic_ProductData = ARY_ProductData[indexPath.row];
    [self.navigationController pushViewController:viewControler animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
