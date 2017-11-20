//
//  SelectPayment.m
//  iDoSpa
//
//  Created by CronyLog on 11/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "SelectPayment.h"

#define kPayPalEnvironment PayPalEnvironmentProduction

//PayPalEnvironmentProduction
//PayPalEnvironmentSandbox

@interface SelectPayment ()

@end

@implementation SelectPayment

@synthesize Dic_ProductData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self HudMethod];
    
    BTN_CardPay.selected = NO;
    BTN_NetBankingPay.selected = YES;
    BTN_PayPal.hidden = YES;
    
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TimerNotifyCall:)
                                                 name:@"TimerNotify"
                                               object:nil];
    
    LBL_TimerTitle.text = [NSString stringWithFormat:@"Your Order %@ will be expired with in",[Dic_ProductData valueForKey:@"post_title"]];
    LBL_Price.text = [NSString stringWithFormat:@"Total RM%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"TotalPrice"]];
}

- (void)TimerNotifyCall:(NSNotification *) notification
{
    //NSLog(@"--%@",notification.object);
    NSDictionary *Dic_Data = notification.object;
    NSString *Str_Time = [NSString stringWithFormat:@"%@:%@",[Dic_Data valueForKey:@"Mint"],[Dic_Data valueForKey:@"Sec"]];
    LBL_TimerCountDown.text = Str_Time;
    NSString *Status = [Dic_Data valueForKey:@"Is_Start"];
    if ([Status isEqualToString:@"No"])
    {
        NSArray *viewControllers = [[self navigationController] viewControllers];
        for( int i=0;i<[viewControllers count];i++){
            id obj=[viewControllers objectAtIndex:i];
            if([obj isKindOfClass:[Search class]])
            {
                [[self navigationController] popToViewController:obj animated:YES];
                return;
            }
        }
    }
    
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//
//    LBL_Price.text = [NSString stringWithFormat:@"Total RM%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"TotalPrice"]];
//}

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

#pragma mark - API call

-(void)BookingAPIcall
{
    //apiBookingRequiest
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [[appConfig sharedInstance] FailAlertCall:@"No Internet" Message:@"Please Check Your Internet Connections." ViewContriller:self];
        //[HUD hide:YES];
    }
    else
    {
        [HUD show:YES];
        
        //http://ids2.1s.my/?api=1&task=booking&aceesstoken=5e84ab8c86cd67eb63fa43e44&post_id=344&masseur_id=368&date=2017-09-06&time=15:00:00&payment_method=cod&payment_status=onhold&promocode=10
        
        NSString *Str_Postid = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Post_id"]];
        NSString *Str_masseur_id = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"masseur_id"]];
        NSString *Str_date = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Date"]];
        NSString *Str_time = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Time"]];
        NSString *STR_PromocodeID = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"PromocodeID"]];
        
        NSString *STR_BookingID = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"booking_id"]];
        
        if ([STR_PromocodeID isEqualToString:@"(null)"])
        {
            STR_PromocodeID = @"";
        }
        
        /*
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@aceesstoken=%@&post_id=%@&masseur_id=%@&date=%@&time=%@&payment_method=%@&payment_status=%@&promocode=%@&transaction_id=%@",apiBase,apiBookingDataLast,[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"],Str_Postid,Str_masseur_id,Str_date,Str_time,PaymentType,@"Sucess",STR_Promocode]];
        //NSLog(@"%@",url);
        
        apiBookingRequiest = [ASIFormDataRequest requestWithURL:url];
        
        [apiBookingRequiest setRequestMethod:APIRequestGet];
        
        [apiBookingRequiest setDidFinishSelector:@selector(BookingDateRespose:)];
        [apiBookingRequiest setDidFailSelector:@selector(FailRequest:)];
        
        [apiBookingRequiest setDelegate:self];
        [apiBookingRequiest startAsynchronous];
        */
        
        ///-------
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",apiBase,apiBookingDataLast]];
        NSLog(@"URL:%@",url);
        apiBookingRequiest = [ASIFormDataRequest requestWithURL:url];
        NSLog(@"apiBookingRequiest:%@",apiBookingRequiest);
        [apiBookingRequiest setRequestMethod:APIRequestPost];
        
        [apiBookingRequiest setPostValue:[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"] forKey:@"accesstoken"];
          //NSLog(@"URL:%@",url);
        //[apiBookingRequiest setPostValue:Str_Postid forKey:@"post_id"];
        //[apiBookingRequiest setPostValue:Str_masseur_id forKey:@"masseur_id"];
        //[apiBookingRequiest setPostValue:Str_date forKey:@"date"];
        
        //[apiBookingRequiest setPostValue:Str_time forKey:@"time"];
        [apiBookingRequiest setPostValue:PaymentType forKey:@"payment_method"];//PaymentType
          NSLog(@"PaymentType:%@",PaymentType);
        [apiBookingRequiest setPostValue:@"payment_success" forKey:@"payment_status"];
        
        //[apiBookingRequiest setPostValue:STR_PromocodeID forKey:@"promocode"];
        [apiBookingRequiest setPostValue:str_TransectionID forKey:@"transaction_id"];
        
        NSLog(@"str_TransectionID:%@",str_TransectionID);
        
        [apiBookingRequiest setPostValue:STR_BookingID forKey:@"booking_id"];
          NSLog(@"STR_BookingID:%@",STR_BookingID);
        [apiBookingRequiest setDidFinishSelector:@selector(BookingDateRespose:)];
        
        [apiBookingRequiest setDidFailSelector:@selector(FailRequest:)];
         
        
        [apiBookingRequiest setDelegate:self];
        [apiBookingRequiest startAsynchronous];
    }
}



-(void)Apicalling
{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [[appConfig sharedInstance] FailAlertCall:@"No Internet" Message:@"Please Check Your Internet Connections." ViewContriller:self];
        //[HUD hide:YES];
    }
    else
    {
        [HUD show:YES];
        
        //http://ids2.1s.my/?api=1&task=booking&aceesstoken=5e84ab8c86cd67eb63fa43e44&post_id=344&masseur_id=368&date=2017-09-06&time=15:00:00&payment_method=cod&payment_status=onhold&promocode=10
        
        NSString *Str_Postid = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Post_id"]];
        NSString *Str_masseur_id = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"masseur_id"]];
        NSString *Str_date = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Date"]];
        NSString *Str_time = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Time"]];
        NSString *STR_PromocodeID = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"PromocodeID"]];
        
        NSString *STR_BookingID = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"booking_id"]];
        
        if ([STR_PromocodeID isEqualToString:@"(null)"])
        {
            STR_PromocodeID = @"";
        }
        //NSString *str_TransectionID = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"transaction_id"]];
        
        
        
    NSDictionary *DIC_UserDetails = [[appConfig sharedInstance] DIC_RetriveDataFromUserDefault:keyUserDetails];
    NSString *theBody = [NSString stringWithFormat:@"accesstoken=%@&booking_id=%@&transaction_id=%@&payment_method=%@&payment_status=payment_success",[DIC_UserDetails valueForKey:@"accesstoken"],STR_BookingID,str_TransectionID,PaymentType];
    
    //    //URL CONFIG
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",apiBase,apiBookingDataLast]];
        NSLog(@"URL:%@",url);
    NSString *downloadUrl = [NSString stringWithFormat:@"%@",url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: downloadUrl]];
    //POST DATA SETUP
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[theBody dataUsingEncoding:NSUTF8StringEncoding]];
    //DEBUG MESSAGE
    NSLog(@"URL %@",downloadUrl);
        NSLog(@"Body %@",theBody);
    //EXEC CALL
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Download Error:%@",error.description);
            if ([error.localizedDescription isEqualToString:@"A connection failure occurred"])
            {
                [[appConfig sharedInstance] FailAlertCall:@"No Internet" Message:@"Please Check Your Internet Connections." ViewContriller:self];
            }
            else
            {
                NSString *returnString = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
                NSLog(@"Response:%@",returnString);
                NSMutableDictionary *parseDict = (NSMutableDictionary *)[returnString JSONValue];
                [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:[parseDict valueForKey:@"message"] ViewContriller:self];
            }
            [HUD hide:YES];
        }
        if (data) {
            
            //
            // THIS CODE IS FOR PRINTING THE RESPONSE
            //
            NSString *returnString = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
            NSLog(@"Response:%@",returnString);
            NSMutableDictionary *parseDict = (NSMutableDictionary *)[returnString JSONValue];
            NSLog(@"PArse:%@",parseDict);
            //PARSE JSON RESPONSE
            NSDictionary *json_response = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:NULL];
            
            if (parseDict != NULL)
            {
                NSString *Status = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"status"]];
                if ([Status isEqualToString:@"false"])
                {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:[parseDict valueForKey:@"message"] ViewContriller:self];
                    
                    
//                    [[AppConfig sharedInstance]errorAlert:@"oops !" Message:[parseDict valueForKey:@"message"] ViewController:self];
//                    Lbl_GetText.text = nil;
                }
                else
                {
                    NSLog(@"%@",parseDict);
                    
                    
                   
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                    [[appConfig sharedInstance].DIC_BookingDetails setValue:[parseDict valueForKey:@"order_number"] forKey:@"OrderNo"];
                    
                    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcPaymentDone] animated:YES];
                    
                    
                }
                
                
            }
        
            else {
                NSLog(@"Error serializing JSON: %@", error);
                NSLog(@"RAW RESPONSE: %@",data);
                NSString *returnString2 = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
                NSLog(@"Response:%@",returnString2);
            }
             [HUD hide:YES];
        }
    }];
}
}


-(void)BookingDateRespose:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
    //NSLog(@"%@",parseDict);
    NSLog(@"PArse:%@",parseDict);
    if (parseDict != NULL)
    {
        NSString *Status = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"status"]];
        if ([Status isEqualToString:@"false"])
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            [[appConfig sharedInstance] FailAlertCall:@"oops !" Message:[parseDict valueForKey:@"message"] ViewContriller:self];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [[appConfig sharedInstance].DIC_BookingDetails setValue:[parseDict valueForKey:@"order_number"] forKey:@"OrderNo"];
            
            [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcPaymentDone] animated:YES];
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

#pragma mark - IBAction

-(IBAction)CLK_Back:(id)sender
{
    pushToBack;
}

- (IBAction)CLK_MOLpay:(id)sender
{
    [[appConfig sharedInstance]SetTimerInvalid];
    
    NSString *Str_price = [[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"TotalPrice"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDictionary *DIC_Userdata = [[appConfig sharedInstance] DIC_RetriveDataFromUserDefault:keyUserDetails];
    
    //str_TransectionID = [NSString stringWithFormat:@"iOS_I%@_U%@_%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Post_id"],[DIC_Userdata valueForKeyPath:@"login_user_details.member_id"],[dateFormatter stringFromDate:[NSDate date]]];
    
    NSLog(@"Booking Details : %@",[appConfig sharedInstance].DIC_BookingDetails);
    //Pratishtha
    str_TransectionID = [[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"order_number"];
    
    NSString *Str_UserEmail = [NSString stringWithFormat:@"%@",[DIC_Userdata valueForKey:@"user_email"]];
    NSString *Str_UserName = [NSString stringWithFormat:@"%@",[DIC_Userdata valueForKeyPath:@"login_user_details.member_name"]];
    NSString *Str_UserNumber = [NSString stringWithFormat:@"%@",[DIC_Userdata valueForKeyPath:@"login_user_details.member_phone"]];
    
    NSString *STR_Discription = [NSString stringWithFormat:@"item_id : %@ , masseur_id : %@ , date : %@ , time : %@ , price : %@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Post_id"],[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"masseur_id"],                                 [[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Date"],                                 [[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Time"],                                 [[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"TotalPrice"]];
    
    //merchant id = idospa
    //verification key is =ddae7d9328fe48dbba934d694ca8f86b
    
    
    PaymentType = @"molpay";
    NSDictionary * paymentRequestDict = @{
                                          @"mp_amount": Str_price, // Mandatory
                                          @"mp_username": @"api_idospa", // Mandatory
                                          @"mp_password": @"api_idOA134a@", // Mandatory
                                          @"mp_merchant_ID": @"idospa", // Mandatory //idospa_Dev
                                          @"mp_app_name": @"Idospa", // Mandatory
                                          @"mp_order_ID": str_TransectionID, // Mandatory
                                          @"mp_currency": @"MYR", // Mandatory
                                          @"mp_country": @"MY", // Mandatory
                                          @"mp_verification_key": @"ddae7d9328fe48dbba934d694ca8f86b", // Mandatory //f66bbc1a499bd964eeea7cfe166fdd55
                                          @"mp_channel": @"multi", // Optional
                                          @"mp_bill_description": [NSString stringWithFormat:@"%@",STR_Discription], // Optional
                                          @"mp_bill_name": Str_UserName, // Optional
                                          @"mp_bill_email": Str_UserEmail, // Optional
                                          @"mp_bill_mobile": Str_UserNumber, // Optional
                                          @"mp_channel_editing": [NSNumber numberWithBool:NO], // Optional
                                          @"mp_editing_enabled": [NSNumber numberWithBool:NO], // Optional
                                          @"mp_transaction_id": @"", // Optional, provide a valid cash channel transaction id here will display a payment instruction screen.
                                          @"mp_request_type": @"" // Optional, set 'Status' when performing a transactionRequest
                                         
                                          };
    
    mp = [[MOLPayLib alloc] initWithDelegate:self andPaymentDetails:paymentRequestDict];
    mp.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(closemolpay:)];
    mp.navigationItem.hidesBackButton = YES;
    
    // Push method (This requires host navigation controller to be available at this point of runtime process,
    // refer AppDelegate.m for sample Navigation Controller implementations)
    //    [self.navigationController pushViewController:mp animated:YES];
    
    // Present method (Simple mode)
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mp];
    
    [self presentViewController:nc animated:NO completion:nil];
    
    
    //[self BookingAPIcall];
}

- (IBAction)CLK_Paypal:(id)sender
{
    [[appConfig sharedInstance]SetTimerInvalid];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    
    NSDictionary *DIC_Userdata = [[appConfig sharedInstance] DIC_RetriveDataFromUserDefault:keyUserDetails];
    
    //str_TransectionID = [NSString stringWithFormat:@"iOS_I%@_U%@_%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Post_id"],[DIC_Userdata valueForKeyPath:@"login_user_details.member_id"],[dateFormatter stringFromDate:[NSDate date]]];
    
    str_TransectionID = [[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"order_number"];
    
    PaymentType = @"paypal";
    [self paypalConfigration];
}

-(IBAction)CLK_Card:(id)sender
{
    [[appConfig sharedInstance]SetTimerInvalid];
    
    BTN_PayPal.hidden = YES;
    BTN_MolPay.hidden = NO;
    
    BTN_CardPay.selected = YES;
    BTN_NetBankingPay.selected = NO;
    
    [BTN_MolPay setTitle:@"Credit and Debit Card" forState:UIControlStateNormal];
}

-(IBAction)CLK_NetBanking:(id)sender
{
    [[appConfig sharedInstance]SetTimerInvalid];
    
    BTN_PayPal.hidden = YES;
    BTN_MolPay.hidden = NO;
    
    BTN_CardPay.selected = NO;
    BTN_NetBankingPay.selected = YES;
    
    [BTN_MolPay setTitle:@"Malaysia Online Banking" forState:UIControlStateNormal];
}

- (IBAction)CLK_CloseTimerVW:(id)sender
{
    [[appConfig sharedInstance] CancelBookingAPI:[NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"booking_id"]]];
    
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for( int i=0;i<[viewControllers count];i++)
    {
        id obj=[viewControllers objectAtIndex:i];
        if([obj isKindOfClass:[Search class]])
        {
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
}

#pragma mark - MOLPay Delegate

- (IBAction)closemolpay:(id)sender
{
    // Closes MOLPay
    [mp closemolpay];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)transactionResult: (NSDictionary *)result
{
    // Payment status results returned here
    NSLog(@"transactionResult result = %@", result);
    
    // All success cash channel payments will display a payment instruction, we will let the user to close manually
    
    NSString *status = [NSString stringWithFormat:@"%@",[result valueForKey:@"status_code"]];
    
    if ([status isEqualToString:@"00"]) {
        //Sucess
          [self dismissViewControllerAnimated:YES completion:nil];
        [self Apicalling];
        //[self BookingAPIcall];
    }
    else if ([status isEqualToString:@"11"])
    {
        //failed
    }
    else if ([status isEqualToString:@"22"])
    {
        //pending
    }
    
//    if ([[result objectForKey:@"pInstruction"] integerValue] == 1 && isPaymentInstructionPresent == NO && isCloseButtonClick == NO)
//    {
//        isPaymentInstructionPresent = YES;
//    }
//    else
//    {
//        // Push method
//        //        [self.navigationController popViewControllerAnimated:NO];
//        
//        // Present method
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}

#pragma mark - PayPay

-(void)paypalConfigration
{
    NSString *PrivacyPolicyStr = [NSString stringWithFormat:@"%@%@",apiBase,@"?api=1&task=private_policy"];
    NSString *AgreementStr = [NSString stringWithFormat:@"%@%@",apiBase,@"?api=1&task=private_policy"];
    
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"iDOspa";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:PrivacyPolicyStr];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:AgreementStr];
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    [self setPayPalEnvironment:self.environment];
    
    [self PayPalCall];
}

-(void)PayPalCall
{
    NSLog(@"%@",[appConfig sharedInstance].DIC_BookingDetails);
    
    NSString *Str_price = [[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"TotalPrice"];
    
    NSString *Str_PostID = [NSString stringWithFormat:@"P_%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Post_id"]];
    
    PayPalItem *item1 = [PayPalItem itemWithName:Str_PostID
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:Str_price]
                                    withCurrency:@"MYR"
                                         withSku:str_TransectionID];
    
    NSArray *items = @[item1]; //@[item1, item2, item3];
   // NSArray *items = Arry_ItemList;
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal withShipping:shipping withTax:tax];
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"MYR";
    
    Str_PayPalTransactionID = str_TransectionID;
    
    payment.shortDescription = Str_PayPalTransactionID;
    //payment.shortDescription = [NSString stringWithFormat:@"U_%@",[[GlobalFile sharedInstance].DIC_UserDetailsGlobal valueForKey:@"user_id"]];
    payment.items = items; //if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    if (!payment.processable)
    {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    //Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = YES;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfig delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
    
}

#pragma mark - PayPal Methods

- (void)setPayPalEnvironment:(NSString *)environment
{
    self.environment = environment;//environment; //live sandbox
    [PayPalMobile preconnectWithEnvironment:environment];
}

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"PayPal Payment Success!");
    NSLog(@"%@",[completedPayment description]);
    //[self BookingAPIcall];
    [self Apicalling];
   
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    NSLog(@"PayPal Payment Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment
{
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
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
