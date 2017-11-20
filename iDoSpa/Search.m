//
//  Search.m
//  iDoSpa
//
//  Created by CronyLog on 10/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "Search.h"



@interface Search ()
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@end

@implementation Search

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self HudMethod];
    
    [appConfig sharedInstance].STR_SelectPlaceGoogle = nil;
    
    [appConfig sharedInstance].DIC_UserDetails =  [[appConfig sharedInstance]DIC_RetriveDataFromUserDefault:keyUserDetails]; //keyUserDetails
        
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav UiDataSetForDrower];
    
    [self FooterBannerAPICall];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    //[self getCurrentLoc];
    [self checkLocationServicesAndStartUpdates];
    
    if ([appConfig sharedInstance].STR_SelectPlaceGoogle==nil) {
        
    }
    
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

-(void)setBannerScroll
{
    int setXBanner = 0;
    for (int b =0; b<ARY_FooterBanner.count; b++)
    {
        IMG_FooterBanner = [[AsyncImageView alloc]initWithFrame:CGRectMake(setXBanner, 0, SCRL_FooterBannerHolder.frame.size.width, SCRL_FooterBannerHolder.frame.size.height)];
        IMG_FooterBanner.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[ARY_FooterBanner objectAtIndex:b]]];
        
        [SCRL_FooterBannerHolder addSubview:IMG_FooterBanner];
        setXBanner = setXBanner+SCRL_FooterBannerHolder.frame.size.width;
    }
    
    [SCRL_FooterBannerHolder setContentSize:CGSizeMake(SCRL_FooterBannerHolder.frame.size.width*ARY_FooterBanner.count, 0)];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(autoRotedBannerMethod:) userInfo:nil repeats:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (sender == SCRL_FooterBannerHolder) {
        int pageNum = (int)(SCRL_FooterBannerHolder.contentOffset.x / SCRL_FooterBannerHolder.frame.size.width);
        ScrollIndex = pageNum;
    }
}

-(void)autoRotedBannerMethod:(NSTimer *)timer {
    //do smth
    //ScrollIndex
    
    if (ScrollIndex == ARY_FooterBanner.count-1) {
        ScrollIndex=0;
        //SCRL_FooterBannerHolder.contentOffset = CGPointMake(SCRL_FooterBannerHolder.frame.size.width*ScrollIndex,0);
        
        [SCRL_FooterBannerHolder setContentOffset:CGPointMake(SCRL_FooterBannerHolder.frame.size.width*ScrollIndex,0) animated:YES];
    }
    else
    {
        ScrollIndex++;
        //SCRL_FooterBannerHolder.contentOffset = CGPointMake(SCRL_FooterBannerHolder.frame.size.width*ScrollIndex,0);
        
        [SCRL_FooterBannerHolder setContentOffset:CGPointMake(SCRL_FooterBannerHolder.frame.size.width*ScrollIndex,0) animated:YES];
    }
}

-(void)getCurrentLoc
{
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil)
    {
        NSLog(@"Long. : %@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        NSLog(@"Lat. : %@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
        
        [appConfig sharedInstance].STR_CurrentLong = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        [appConfig sharedInstance].STR_CurrentLat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    [locationManager stopUpdatingLocation];
}

//-------------
-(void) checkLocationServicesAndStartUpdates
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    
    //Checking authorization status
    //[CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied
    //![CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied
    
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled!"
                                                            message:@"Please enable Location Based Services for better results! We promise to keep your location private"
                                                           delegate:self
                                                  cancelButtonTitle:@"Settings"
                                                  otherButtonTitles:@"Cancel", nil];
        
        //TODO if user has not given permission to device
        if (![CLLocationManager locationServicesEnabled])
        {
            alertView.tag = 100;
        }
        //TODO if user has not given permission to particular app
        else
        {
            alertView.tag = 200;
        }
        
        [alertView show];
        
        return;
    }
    else
    {
        //Location Services Enabled, let's start location updates
        [locationManager startUpdatingLocation];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)//Settings button pressed
    {
        if (alertView.tag == 100)
        {
            //This will open ios devices location settings
            NSString* url = SYSTEM_VERSION_LESS_THAN(@"10.0") ? @"prefs:root=LOCATION_SERVICES" : @"App-Prefs:root=Privacy&path=LOCATION";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
        }
        else if (alertView.tag == 200)
        {
            //This will opne particular app location settings
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
    else if(buttonIndex == 1)//Cancel button pressed.
    {
        //TODO for cancel
    }
}

#pragma mark - API call

-(void)FooterBannerAPICall
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
        //connection available
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@?api=1&task=appbannerimage",apiBase]];
        apiFooterBanner = [ASIFormDataRequest requestWithURL:url];
        
        [apiFooterBanner setRequestMethod:APIRequestGet];
        
        [apiFooterBanner setDidFinishSelector:@selector(FooterBannerRespose:)];
        [apiFooterBanner setDidFailSelector:@selector(FailRequest:)];
        
        [apiFooterBanner setDelegate:self];
        [apiFooterBanner startAsynchronous];
    }
}

-(void)FooterBannerRespose:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
    
    if (parseDict != NULL)
    {
        NSString *Status = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"status"]];
        if ([Status isEqualToString:@"false"])
        {
            [self errorAlert:@"oops !" Message:[parseDict valueForKey:@"message"]];
        }
        else
        {
            ARY_FooterBanner = [[parseDict valueForKey:@"data"]mutableCopy];
            
            [self setBannerScroll];
        }
    }
    [HUD hide:YES];
}

-(void)GetLocationSuggestionList
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
        //connection available
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyCh5YgaM1PEMvRvdgCHgMcM6GmVzFXhBVA&components=country:MY&input=me"]];
        
        apiSearchSuggestionListReq = [ASIFormDataRequest requestWithURL:url];
        
        [apiSearchSuggestionListReq setRequestMethod:APIRequestGet];
        
        [apiSearchSuggestionListReq setDidFinishSelector:@selector(LocationSuggestionListRespose:)];
        [apiSearchSuggestionListReq setDidFailSelector:@selector(FailRequest:)];
        
        [apiSearchSuggestionListReq setDelegate:self];
        [apiSearchSuggestionListReq startAsynchronous];
    }
}

-(void)LocationSuggestionListRespose:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
    
    if (parseDict != NULL)
    {
        NSString *Status = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"status"]];
        if ([Status isEqualToString:@"false"])
        {
            [self errorAlert:@"oops !" Message:[parseDict valueForKey:@"message"]];
        }
        else
        {
            NSLog(@"List : %@",[parseDict valueForKeyPath:@"predictions.description"]);
            
            ARY_LocationList = [[NSMutableArray alloc]init];
            ARY_LocationList = [[parseDict valueForKeyPath:@"predictions.description"] mutableCopy];
            
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
        NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
        [self errorAlert:@"oops !" Message:[parseDict valueForKey:@"message"]];
    }
    [HUD hide:YES];
}

#pragma mark - IBAction

-(IBAction)CLK_Menu:(id)sender
{
    NSLog(@"Menu");
    [self.rootNav drawerToggle];
}

-(IBAction)CLK_FavoriteList:(id)sender
{
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcFavoriteList] animated:YES];
}

-(IBAction)CLK_Search:(id)sender
{
    [self.view endEditing:YES];
    
    if (TXT_MurchantName.text.length == 0)
    {
        if (TXT_LocationSearch.text.length == 0)
        {
            NSLog(@"Enter Data");
            [self errorAlert:@"Search" Message:@"Please Enter Merchant Name or Location."];
        }
        else
        {
            NSLog(@"Location Data");
            SearchList *searchList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSearchList];
            
            searchList.IS_LocationOrMerchant = @"SearchOnLocationText";
            
            searchList.STR_MurchantNameSearch = TXT_LocationSearch.text;
            [self.navigationController pushViewController:searchList animated:YES];
        }
    }
    else
    {
        NSLog(@"Merchant Data");
        SearchList *searchList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSearchList];
        
        searchList.IS_LocationOrMerchant = @"SearchOnMerchant";
        
        searchList.STR_MurchantNameSearch = TXT_MurchantName.text;
        [self.navigationController pushViewController:searchList animated:YES];
    }
    
    /*if (TXT_MurchantName.text.length == 0)
    {
        [self errorAlert:@"Search" Message:@"Please Enter Merchant Name or Location."];
    }
    else
    {
        SearchList *searchList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSearchList];
        
        searchList.IS_LocationOrMerchant = @"SearchOnText";
        
        searchList.STR_MurchantNameSearch = TXT_MurchantName.text;
        [self.navigationController pushViewController:searchList animated:YES];
    }*/
}

-(IBAction)CLK_ShowNear:(id)sender
{
    //[self GetLocationSuggestionList];
    
    [self.view endEditing:YES];
    SearchList *searchList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSearchList];
    
    searchList.IS_LocationOrMerchant = @"SearchOnLocation";
     
    [self.navigationController pushViewController:searchList animated:YES];
}

- (IBAction)CLK_PickadateTime:(id)sender
{
    SearchList *searchList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSearchList];
    searchList.IS_LocationOrMerchant = @"SearchDateTime";
    [self.navigationController pushViewController:searchList animated:YES];
}

- (IBAction)CLK_SearchLocation:(id)sender
{
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

#pragma mark - Google Search

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
//    NSLog(@"Place name %@", place.name);
//    NSLog(@"Place address %@", place.formattedAddress);
//    NSLog(@"Place attributions %@", place.attributions.string);
//    NSLog(@"Place attributions %f", place.coordinate.longitude);
//    NSLog(@"Place attributions %f", place.coordinate.latitude);
    
    [appConfig sharedInstance].STR_SelectPlaceGoogle = place.name;
    TXT_LocationSearch.text = place.name;
    
    SearchList *searchList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSearchList];
    searchList.IS_LocationOrMerchant = @"SearchOnLocationText";
    searchList.STR_MurchantNameSearch = TXT_LocationSearch.text;
    [self.navigationController pushViewController:searchList animated:YES];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController
{
    [appConfig sharedInstance].STR_SelectPlaceGoogle = nil;
    TXT_LocationSearch.text = nil;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -


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


#pragma mark - KeyboardDelegate Methods

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if(heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    if (textField == TXT_MurchantName)
    {
        TXT_LocationSearch.text = @"";
    }
    else
    {
        TXT_MurchantName.text = @"";
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextView *)textView
{
    // TableView.hidden=YES;
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField * )textField
{
    // [TitleOfPosting resignFirstResponder];
    [textField resignFirstResponder];
    return YES;
    // Do the search...
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =[touches anyObject];
    if (touch.phase ==UITouchPhaseBegan)
    {
        [self.view endEditing:YES];
    }
}

-(void)threadStartAnimat:(id) data
{
    // [HUD show:YES];
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
