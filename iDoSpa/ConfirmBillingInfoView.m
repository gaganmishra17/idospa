//
//  ConfirmBillingInfoView.m
//  iDoSpa
//
//  Created by CronyLog on 17/10/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "ConfirmBillingInfoView.h"

@interface ConfirmBillingInfoView ()

@end

@implementation ConfirmBillingInfoView
@synthesize Dic_ListData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self HudMethod];
    
    NSLog(@"UserDetails : %@",[appConfig sharedInstance].DIC_UserDetails);
    
    TXT_FullName.text = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_UserDetails valueForKeyPath:@"login_user_details.member_name"]];
    TXT_MobileNo.text = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_UserDetails valueForKeyPath:@"login_user_details.member_phone"]];
    
    NSString *STR_BillingCName = [[appConfig sharedInstance].DIC_UserDetails valueForKeyPath:@"login_user_details.billing_country"];
    
    NSString *STR_BillingSName = [[appConfig sharedInstance].DIC_UserDetails valueForKeyPath:@"login_user_details.billing_state"];
    
    NSString *STR_BillingCountryCode = [[appConfig sharedInstance].DIC_UserDetails valueForKeyPath:@"login_user_details.phone_country_code"];
    
    if (STR_BillingCountryCode.length !=0)
    {
        [BTN_SelectCountryCode setTitle:STR_BillingCountryCode forState:UIControlStateNormal];
        [BTN_SelectCountryCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
//    else
//    {
//        [BTN_SelectCountryCode setTitle:@"+60" forState:UIControlStateNormal];
//        [BTN_SelectCountryCode setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    }
//
    if (STR_BillingCName.length !=0)
    {
        [BTN_SelectCountry setTitle:STR_BillingCName forState:UIControlStateNormal];
        [BTN_SelectCountry setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [BTN_SelectCity setTitle:@"Select State" forState:UIControlStateNormal];
        [BTN_SelectCity setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [self getCountryAPI];
    }
    
    if (STR_BillingSName.length !=0)
    {
        BTN_SelectCity.enabled = true;
        [BTN_SelectCity setTitle:STR_BillingSName forState:UIControlStateNormal];
        [BTN_SelectCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([[appConfig sharedInstance].STR_CountrySelectionType isEqualToString:@"dialCode"])
    {
        if ([appConfig sharedInstance].STR_SelectedDialCode.length == 0)
        {
            //Country Code
            [BTN_SelectCountryCode setTitle:@"+60" forState:UIControlStateNormal];
            [BTN_SelectCountryCode setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        else
        {
            //Country Code
            [BTN_SelectCountryCode setTitle:[appConfig sharedInstance].STR_SelectedDialCode forState:UIControlStateNormal];
            [BTN_SelectCountryCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    if ([[appConfig sharedInstance].STR_CountryStateType isEqualToString:@"Country"])
    {
        if ([[appConfig sharedInstance].ARY_CountryStateData isEqual:[NSNull null]] || [appConfig sharedInstance].ARY_CountryStateData.count == 0)
        {
            NSLog(@"No Data");
            
            [BTN_SelectCountry setTitle:@"Select Country" forState:UIControlStateNormal];
            [BTN_SelectCountry setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            [BTN_SelectCity setTitle:@"Select State" forState:UIControlStateNormal];
            [BTN_SelectCity setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        else
        {
            [BTN_SelectCountry setTitle:[NSString stringWithFormat:@"%@",[[appConfig sharedInstance].ARY_CountryStateData valueForKey:@"countries_name"]] forState:UIControlStateNormal];
            [BTN_SelectCountry setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [BTN_SelectCity setTitle:@"Select State" forState:UIControlStateNormal];
            [BTN_SelectCity setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            [self GetStateAPI];
        }
    }
    else if ([[appConfig sharedInstance].STR_CountryStateType isEqualToString:@"State"])
    {
        NSLog(@"Data : %@",[appConfig sharedInstance].ARY_CountryStateData);
        
        if ([[appConfig sharedInstance].ARY_CountryStateData isEqual:[NSNull null]] || [appConfig sharedInstance].ARY_CountryStateData.count == 0)
        {
            NSLog(@"No Data");
            
            [BTN_SelectCity setTitle:@"Select State" forState:UIControlStateNormal];
            [BTN_SelectCity setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        else
        {
            [BTN_SelectCity setTitle:[NSString stringWithFormat:@"%@",[[appConfig sharedInstance].ARY_CountryStateData valueForKey:@"states_name"]] forState:UIControlStateNormal];
            [BTN_SelectCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
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

#pragma mark - IBAction

-(IBAction)CLK_Back:(id)sender
{
    pushToBack;
}

-(IBAction)CLK_CountryCode:(id)sender
{
    [appConfig sharedInstance].STR_CountrySelectionType = @"dialCode";
    
    SelectCountry *viewControler = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:vcSelectCountry];
    [self presentViewController:viewControler animated:YES completion:nil];
}

-(IBAction)CLK_SelectCountry:(id)sender
{
    if ([ARY_CountryList isEqual:[NSNull null]] || ARY_CountryList.count == 0)
    {
        NSLog(@"No Data");
        [BTN_SelectCountry setTitle:@"Select Country" forState:UIControlStateNormal];
        [BTN_SelectCountry setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [self getCountryAPI];
    }
    else
    {
        [appConfig sharedInstance].STR_CountryStateType = @"Country";
        CountryStateList *viewControler = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:vcCountryStateList];
        viewControler.ARY_DataList = ARY_CountryList;
        [self presentViewController:viewControler animated:YES completion:nil];
    }
}

-(IBAction)CLK_SelectState:(id)sender
{
    if ([BTN_SelectCountry.titleLabel.text isEqualToString:@"Select Country"])
    {
        [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:@"Please Select Country First" ViewContriller:self];
    }
    else
    {
        if ([ARY_CountryList isEqual:[NSNull null]] || ARY_CountryList.count == 0)
        {
            NSLog(@"No Data");
            [self getCountryAPI];
            
            if(!ARY_StateList || !ARY_StateList.count)
            {
                [BTN_SelectCity setTitle:@"Select State" forState:UIControlStateNormal];
                [BTN_SelectCity setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                
                [BTN_SelectCountry setTitle:@"Select Country" forState:UIControlStateNormal];
                [BTN_SelectCountry setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
        }
        else
        {
            if(!ARY_StateList || !ARY_StateList.count)
            {
                [BTN_SelectCity setTitle:@"Select State" forState:UIControlStateNormal];
                [BTN_SelectCity setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            else
            {
                [appConfig sharedInstance].STR_CountryStateType = @"State";
                CountryStateList *viewControler = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:vcCountryStateList];
                viewControler.ARY_DataList = ARY_StateList;
                [self presentViewController:viewControler animated:YES completion:nil];
            }
        }
    }
}

-(IBAction)CLK_Continue:(id)sender
{
    NSLog(@"Name : %@",TXT_FullName.text);
    NSLog(@"Phone : %@",TXT_MobileNo.text);
    NSLog(@"Country : %@",BTN_SelectCountry.titleLabel.text);
    NSLog(@"State : %@",BTN_SelectCity.titleLabel.text);
    
    if (TXT_FullName.text.length == 0)
    {
        [self errorAlert:@"Please Full Name" Message:nil];
    }
    else if (TXT_MobileNo.text.length == 0)
    {
        [self errorAlert:@"Please Enter Mobile No" Message:nil];
    }
    else if (![BTN_SelectCountry.titleLabel.textColor isEqual:[UIColor blackColor]])
    {
        [self errorAlert:@"Please Select Country" Message:nil];
    }
    /*else if (![BTN_SelectCity.titleLabel.textColor isEqual:[UIColor blackColor]])
    {
        [self errorAlert:@"Please Select State" Message:nil];
    }*/
    else
    {
        [self BookingUnPaidAPIcall];
    }
}

#pragma mark - API Call
-(void)getCountryAPI
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
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@?api=1&task=get_all_countries",apiBase]];
        
        apiGetCountryList = [ASIFormDataRequest requestWithURL:url];
        
        [apiGetCountryList setRequestMethod:APIRequestGet];
        
        [apiGetCountryList setDidFinishSelector:@selector(getCountryRespose:)];
        [apiGetCountryList setDidFailSelector:@selector(FailRequest:)];
        
        [apiGetCountryList setDelegate:self];
        [apiGetCountryList startAsynchronous];
    }
}

-(void)getCountryRespose:(ASIHTTPRequest *)request
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
            NSLog(@"%@",parseDict);
            ARY_CountryList = [[parseDict valueForKey:@"data"] mutableCopy];
            
            [BTN_SelectCity setTitle:@"Select State" forState:UIControlStateNormal];
            [BTN_SelectCity setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            BTN_SelectCity.enabled = true;
            
            [appConfig sharedInstance].ARY_CountryStateData = [[NSMutableArray alloc]init];
        }
    }
    [HUD hide:YES];
}

//
-(void)GetStateAPI
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
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@?api=1&task=get_all_state&countries_code=%@",apiBase,[[appConfig sharedInstance].ARY_CountryStateData valueForKey:@"countries_code"]]];
        
        
        
        apiGetStateList = [ASIFormDataRequest requestWithURL:url];
        
        [apiGetStateList setRequestMethod:APIRequestGet];
        
        [apiGetStateList setDidFinishSelector:@selector(getStateRespose:)];
        [apiGetStateList setDidFailSelector:@selector(FailRequest:)];
        
        [apiGetStateList setDelegate:self];
        [apiGetStateList startAsynchronous];
    }
}

-(void)getStateRespose:(ASIHTTPRequest *)request
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
            ARY_StateList = [[parseDict valueForKey:@"data"] mutableCopy];
            [appConfig sharedInstance].ARY_CountryStateData = [[NSMutableArray alloc]init];
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
        [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:error.localizedDescription ViewContriller:self];
    }
    [HUD hide:YES];
}

#pragma mark - Booking API call

-(void)BookingUnPaidAPIcall
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
        NSString *Str_Postid = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Post_id"]];
        NSString *Str_masseur_id = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"masseur_id"]];
        NSString *Str_date = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Date"]];
        NSString *Str_time = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Time"]];
        
        NSString *Str_SelectState = [NSString stringWithFormat:@"%@",BTN_SelectCity.titleLabel.text];
        
        if ([Str_SelectState isEqualToString:@"Select State"])
        {
            Str_SelectState = @"";
        }
        
        
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",apiBase,apiBookingDataLast]];
        
        apiUnPaidBooking = [ASIFormDataRequest requestWithURL:url];
        
        apiUnPaidBooking.timeOutSeconds = 60;
        
        [apiUnPaidBooking setRequestMethod:APIRequestPost];
        
        [apiUnPaidBooking setPostValue:[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"] forKey:@"accesstoken"];
        [apiUnPaidBooking setPostValue:Str_Postid forKey:@"post_id"];
        [apiUnPaidBooking setPostValue:Str_masseur_id forKey:@"masseur_id"];
        [apiUnPaidBooking setPostValue:Str_date forKey:@"date"];
        [apiUnPaidBooking setPostValue:Str_time forKey:@"time"];
        [apiUnPaidBooking setPostValue:@"unpaid" forKey:@"payment_status"];
        
        [apiUnPaidBooking setPostValue:[NSString stringWithFormat:@"%@",TXT_FullName.text] forKey:@"bill_user_name"];
        [apiUnPaidBooking setPostValue:[NSString stringWithFormat:@"%@",TXT_MobileNo.text] forKey:@"bill_user_phone_no"];
        [apiUnPaidBooking setPostValue:[NSString stringWithFormat:@"%@",BTN_SelectCountry.titleLabel.text] forKey:@"bill_user_country"];
        [apiUnPaidBooking setPostValue:[NSString stringWithFormat:@"%@",Str_SelectState] forKey:@"bill_user_state"];
        
        [apiUnPaidBooking setDidFinishSelector:@selector(UnPaidBookingRespose:)];
        [apiUnPaidBooking setDidFailSelector:@selector(FailRequest:)];
        
        [apiUnPaidBooking setDelegate:self];
        [apiUnPaidBooking startAsynchronous];
    }
}

-(void)UnPaidBookingRespose:(ASIHTTPRequest *)request
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
            //NSLog(@"%@",parseDict);
            
            [[appConfig sharedInstance].DIC_BookingDetails setObject:[parseDict valueForKey:@"booking_id"] forKey:@"booking_id"];
            
            PlaceOrder *PlaceOrderView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcPlaceOrder];
            PlaceOrderView.Dic_ListData = Dic_ListData ;
            [self.navigationController pushViewController:PlaceOrderView animated:YES];
        }
    }
    [HUD hide:YES];
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
