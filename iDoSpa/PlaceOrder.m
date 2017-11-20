//
//  PlaceOrder.m
//  iDoSpa
//
//  Created by CronyLog on 29/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "PlaceOrder.h"

@interface PlaceOrder ()

@end

@implementation PlaceOrder

@synthesize Dic_ListData;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self HudMethod];
   // NSLog(@"Data : %@",[appConfig sharedInstance].ARY_CurrentItemData);
   // NSLog(@"BTN : %lu",(unsigned long)[appConfig sharedInstance].btnTag);
    
    NSLog(@"PlaceOrder : %@",[appConfig sharedInstance].DIC_BookingDetails);
    
    Dic_ItemDetails = [appConfig sharedInstance].DIC_ItmeDetails;
    Dic_ProductData = Dic_ListData;
    LBL_ProductName.text = [NSString stringWithFormat:@"%@",[Dic_ProductData valueForKey:@"post_title"]];
    
    LBL_NamePrice.text = [NSString stringWithFormat:@"RM%@",[Dic_ProductData valueForKey:@"price"]];
    
    LBL_ProductDisc.text = [NSString stringWithFormat:@"%@",[Dic_ProductData valueForKey:@"post_excerpt"]];
    
    /*CGRect frame = LBL_ProductDisc.frame;
    float height = [self getHeightForText:LBL_ProductDisc.text
                                 withFont:LBL_ProductDisc.font
                                 andWidth:LBL_ProductDisc.frame.size.width];
    LBL_ProductDisc.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,height);*/
    
    [TXT_PromoCode setValue:[UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    LBL_TotalPrice.text = [NSString stringWithFormat:@"RM%@",[Dic_ProductData valueForKey:@"price"]];
    
    NSString *str_TotalPrice = [NSString stringWithFormat:@"%@",[Dic_ProductData valueForKey:@"price"]];
    TotalPrice = [str_TotalPrice floatValue];
    
    NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", TotalPrice];
    [[appConfig sharedInstance].DIC_BookingDetails setObject:formattedNumber forKey:@"TotalPrice"];
    
    LBL_DiscountPrice.text = [NSString stringWithFormat:@"RM%@",@"0"];

    LBL_SubTotal.text = [NSString stringWithFormat:@"RM%@",[Dic_ProductData valueForKey:@"price"]];
    
    //
    LBL_TotalPayablePrice.text = [NSString stringWithFormat:@"RM%@",[Dic_ProductData valueForKey:@"price"]];
    
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TimerNotifyCall:)
                                                 name:@"TimerNotify"
                                               object:nil];
    
    
    [[appConfig sharedInstance]TimerStart:@"5"];//[Dic_ProductData valueForKey:@"booking_slot_duration"]
    
    LBL_TimerTitle.text = [NSString stringWithFormat:@"Your Order %@ will be expired with in",[Dic_ProductData valueForKey:@"post_title"]];
    
    LBL_MasseurName.text = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"masseur_name"]];
    LBL_DateSelected.text = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Date"]];
    LBL_SelectedTime.text = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"Time"]];
}

- (void)TimerNotifyCall:(NSNotification *) notification
{
    //NSLog(@"--%@",notification.object);
    NSDictionary *Dic_Data = notification.object;
    NSString *Status = [Dic_Data valueForKey:@"Is_Start"];
    NSString *Str_Time = [NSString stringWithFormat:@"%@:%@",[Dic_Data valueForKey:@"Mint"],[Dic_Data valueForKey:@"Sec"]];
    LBL_TimerCountDown.text = Str_Time;
    
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

-(void)HudMethod
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    NSString *str1=@""; // Tittle
    
    HUD.delegate = self;
    HUD.labelText = str1;
    HUD.detailsLabelText=@"Please Wait.!!";
    HUD.dimBackground = NO;
    
    [self.view addSubview:HUD];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

#pragma mark - IBAction
-(IBAction)CLK_Back:(id)sender
{
    [[appConfig sharedInstance] CancelBookingAPI:[NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"booking_id"]]];
    
    pushToBack;
}

-(IBAction)CLK_PlaceOrder:(id)sender
{
    [self.view endEditing:YES];
    
    [self SucessBookingAPI];
}

-(IBAction)CLK_PromocodeCheck:(id)sender
{
    [self.view endEditing:YES];
    if ([TXT_PromoCode.text length]==0)
    {
        [[appConfig sharedInstance] FailAlertCall:@"Error" Message:@"Please Enter Promocode." ViewContriller:self];
    }
    else
    {
        [self PromocodeCheckAPI];
    }
}
- (IBAction)CLK_CloseTimerView:(id)sender
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
- (IBAction)CLK_CheckOut:(id)sender
{
    SelectPayment *VC_SelectPayment = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSelectPayment];
    VC_SelectPayment.Dic_ProductData = Dic_ProductData;
    [self.navigationController pushViewController:VC_SelectPayment animated:YES];
}

#pragma mark - API call

-(void)PromocodeCheckAPI
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
        
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@promocode=%@&accesstoken=%@&price=%@",apiBase,apiPromocode,TXT_PromoCode.text,[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"],[Dic_ProductData valueForKey:@"price"]]];
        //NSLog(@"%@",url);
        
        apiPromocodeRequiest = [ASIFormDataRequest requestWithURL:url];
        
        [apiPromocodeRequiest setRequestMethod:APIRequestGet];
        
        [apiPromocodeRequiest setDidFinishSelector:@selector(getPromocodeDateRespose:)];
        [apiPromocodeRequiest setDidFailSelector:@selector(FailRequest:)];
        
        [apiPromocodeRequiest setDelegate:self];
        [apiPromocodeRequiest startAsynchronous];
    }
}

-(void)getPromocodeDateRespose:(ASIHTTPRequest *)request
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
            NSString *Str_DicountPrice = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"discount_value"]];
            float DiscountPrice = [Str_DicountPrice floatValue];
            
            NSString *str_TotalPrice = [NSString stringWithFormat:@"%@",[Dic_ProductData valueForKey:@"price"]];
            TotalPrice = [str_TotalPrice floatValue];
            
            TotalPrice = TotalPrice - DiscountPrice;
            
            if(TotalPrice<0)
            {
                TotalPrice = 00.00;
            }
            
            NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", TotalPrice];
            [[appConfig sharedInstance].DIC_BookingDetails setObject:formattedNumber forKey:@"TotalPrice"];
            NSString *Str_PromocodeID = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"promocode_id"]];
            [[appConfig sharedInstance].DIC_BookingDetails setObject:Str_PromocodeID forKey:@"PromocodeID"];
            
            LBL_TotalPrice.text =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"RM%@",[Dic_ProductData valueForKey:@"price"]]];
            
            NSString *Str_discountPrice = [NSString stringWithFormat:@"%.02f", DiscountPrice];
            [[appConfig sharedInstance].DIC_BookingDetails setObject:Str_discountPrice forKey:@"DiscountPrice"];
            LBL_DiscountPrice.text = [NSString stringWithFormat:@"-RM%@",Str_discountPrice];
            
            LBL_SubTotal.text = [NSString stringWithFormat:@"RM%@",formattedNumber];;
            
             LBL_TotalPayablePrice.text = [NSString stringWithFormat:@"RM%@",formattedNumber];
            
            //NSLog(@"%@",parseDict);
            //[[appConfig sharedInstance] FailAlertCall:Status Message:[parseDict valueForKey:@"message"] ViewContriller:self];
            
            [[appConfig sharedInstance]SucessAlertCall:@"Success" Message:[parseDict valueForKey:@"message"] ViewContriller:self];
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

#pragma mark - Sucess API call

-(void)SucessBookingAPI
{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [[appConfig sharedInstance] FailAlertCall:@"No Internet" Message:@"Please Check Your Internet Connections." ViewContriller:self];
        //[HUD hide:YES];
    }
    else
    {
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
        
        [HUD show:YES];
        
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",apiBase,apiBookingDataLast]];
        //NSLog(@"%@",url);
        
        apiPromocodeRequiest = [ASIFormDataRequest requestWithURL:url];
        
        [apiPromocodeRequiest setTimeOutSeconds:120];
        
        [apiPromocodeRequiest setRequestMethod:APIRequestPost];
        
        [apiPromocodeRequiest setPostValue:[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"] forKey:@"accesstoken"];
        [apiPromocodeRequiest setPostValue:Str_Postid forKey:@"post_id"];
        [apiPromocodeRequiest setPostValue:Str_masseur_id forKey:@"masseur_id"];
        [apiPromocodeRequiest setPostValue:Str_date forKey:@"date"];

        [apiPromocodeRequiest setPostValue:Str_time forKey:@"time"];
        [apiPromocodeRequiest setPostValue:@"molpay" forKey:@"payment_method"];//PaymentType
        
        //IF Total Amt is "0"
        if(TotalPrice == 0){
            [apiPromocodeRequiest setPostValue:@"0" forKey:@"payment_status"];
        }
        else
        {
            [apiPromocodeRequiest setPostValue:@"success" forKey:@"payment_status"];
        }
        
        [apiPromocodeRequiest setPostValue:STR_PromocodeID forKey:@"promocode"];
        
        [apiPromocodeRequiest setPostValue:STR_BookingID forKey:@"booking_id"];
        
        [apiPromocodeRequiest setPostValue:@"2" forKey:@"devicetype"];
        
        [apiPromocodeRequiest setDidFinishSelector:@selector(SucessBookingRespose:)];
        [apiPromocodeRequiest setDidFailSelector:@selector(FailRequest:)];
        
        [apiPromocodeRequiest setDelegate:self];
        [apiPromocodeRequiest startAsynchronous];
    }
}

-(void)SucessBookingRespose:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
    //NSLog(@"%@",parseDict);
    
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

            if(TotalPrice ==0){
                
                [[appConfig sharedInstance].DIC_BookingDetails setValue:[parseDict valueForKey:@"order_number"] forKey:@"OrderNo"];
                
                [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcPaymentDone] animated:YES];
            }
            else
            {
                
            
            [[appConfig sharedInstance].DIC_BookingDetails setObject:[parseDict valueForKey:@"order_number"] forKey:@"order_number"];
            [[appConfig sharedInstance].DIC_BookingDetails setObject:[parseDict valueForKey:@"total"] forKey:@"total"];
            
            SelectPayment *VC_SelectPayment = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSelectPayment];
            VC_SelectPayment.Dic_ProductData = Dic_ProductData;
            [self.navigationController pushViewController:VC_SelectPayment animated:YES];
            
//            [self dismissViewControllerAnimated:YES completion:nil];
//            
//            [[appConfig sharedInstance].DIC_BookingDetails setValue:[parseDict valueForKey:@"order_number"] forKey:@"OrderNo"];
//            
//            [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcPaymentDone] animated:YES];
            }
        }
    }
    [HUD hide:YES];
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
