//
//  Register.m
//  iDoSpa
//
//  Created by CronyLog on 10/07/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "Register.h"

@interface Register ()

@end

@implementation Register

@synthesize DIC_SocialData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self HudMethod];
    
    DT_DOB.backgroundColor = [UIColor whiteColor];
    
    [self SocialDataSet];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    if ([[appConfig sharedInstance].STR_CountrySelectionType isEqualToString:@"dialCode"])
    {
        if ([appConfig sharedInstance].STR_SelectedDialCode.length == 0)
        {
            //Country Code
            [BTN_SelectCountry setTitle:@"+60" forState:UIControlStateNormal];
            [BTN_SelectCountry setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        else
        {
            //Country Code
            [BTN_SelectCountry setTitle:[appConfig sharedInstance].STR_SelectedDialCode forState:UIControlStateNormal];
            [BTN_SelectCountry setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    else
    {
        //Nationality
        if (!([appConfig sharedInstance].STR_SelectedCountry.length == 0))
        {
            [BTN_Nationality setTitle:[appConfig sharedInstance].STR_SelectedCountry forState:UIControlStateNormal];
            [BTN_Nationality setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(yourTextViewDoneButtonPressed)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    TXT_MobileNo.inputAccessoryView = keyboardToolbar;
}

-(void)yourTextViewDoneButtonPressed
{
    [TXT_MobileNo resignFirstResponder];
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

-(void)SocialDataSet
{
    LBL_SocialTitle.hidden = YES;
    
    if (DIC_SocialData)
    {
        TXT_EmailAdd.text = [DIC_SocialData valueForKey:@"Email"];
        TXT_EmailAdd.enabled = YES;
        
        Str_SocialID = [DIC_SocialData valueForKey:@"ID"];
        
        NSString *Str_SocialErrorStatus = [DIC_SocialData valueForKey:@"SocialErrorCode"];
        if ([Str_SocialErrorStatus isEqualToString:@"2"])
        {
            LBL_SocialTitle.hidden = NO;
        }
        else
        {
            LBL_SocialTitle.hidden = YES;
        }
        
        Str_SocialType = [DIC_SocialData valueForKey:@"SocialType"];
        
        TXT_Password.hidden = YES;
        IV_SepretorEmail.hidden = YES;
        //Email Y Set
        CGRect r = [TXT_EmailAdd frame];
        r.origin.y = TXT_Password.frame.origin.y;
        [TXT_EmailAdd setFrame:r];
    }
    else
    {
        TXT_EmailAdd.enabled = YES;
        TXT_Password.hidden = NO;
        IV_SepretorEmail.hidden = NO;
        Str_SocialID = @"";
        Str_SocialType = @"";
    }
}

-(void)RegisterAPI
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
        NSString *Str_PassWord;
        if ([TXT_Password.text length]==0) {
            Str_PassWord = @"";
        }else
        {
            Str_PassWord = [NSString stringWithFormat:@"%@",TXT_Password.text];
        }
        
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@",apiBase]];
        apiRegisterRequest = [ASIFormDataRequest requestWithURL:url];
        
        [apiRegisterRequest setRequestMethod:APIRequestPost];
        
        [apiRegisterRequest setPostValue:@"1" forKey:@"api"];
        [apiRegisterRequest setPostValue:@"registration" forKey:@"task"];
        
        [apiRegisterRequest setPostValue:[NSString stringWithFormat:@"%@",[appConfig sharedInstance].STR_DeviceToken] forKey:@"devicetoken"];
        [apiRegisterRequest setPostValue:@"iOS" forKey:@"devicetype"];
        
        //[apiRegisterRequest setPostValue:TXT_FullName.text forKey:@"user"];
        [apiRegisterRequest setPostValue:[NSString stringWithFormat:@"%@",TXT_FullName.text] forKey:@"member_name"];
        
        [apiRegisterRequest setPostValue:[NSString stringWithFormat:@"%@",TXT_EmailAdd.text] forKey:@"email"];
        [apiRegisterRequest setPostValue:Str_PassWord forKey:@"pass"];
        [apiRegisterRequest setPostValue:STR_Gender forKey:@"gender"];
        [apiRegisterRequest setPostValue:STR_DOB forKey:@"dob"];
        [apiRegisterRequest setPostValue:[appConfig sharedInstance].STR_SelectedCountry forKey:@"nationality"];
        
        [apiRegisterRequest setPostValue:[NSString stringWithFormat:@"%@",BTN_SelectCountry.titleLabel.text] forKey:@"phone_country_code"];
        
        [apiRegisterRequest setPostValue:[NSString stringWithFormat:@"%@",TXT_MobileNo.text] forKey:@"phone_no"];
        
        //Social
        [apiRegisterRequest setPostValue:Str_SocialID forKey:@"social_id"];
        [apiRegisterRequest setPostValue:Str_SocialType forKey:@"social_type"];
        [apiRegisterRequest setPostValue:[DIC_SocialData valueForKey:@"Image"] forKey:@"image_src"];
        
        [apiRegisterRequest setDidFinishSelector:@selector(RegisterAPIRespose:)];
        [apiRegisterRequest setDidFailSelector:@selector(FailRequest:)];
        
        [apiRegisterRequest setDelegate:self];
        [apiRegisterRequest startAsynchronous];
    }
}

-(void)RegisterAPIRespose:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
    NSLog(@"%@",parseDict);
    
    parseDict = [[appConfig sharedInstance] replaceNullInNested:parseDict];
    
    if (parseDict != NULL)
    {
        NSString *Status = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"status"]];
        if ([Status isEqualToString:@"false"])
        {
            [self errorAlert:@"oops !" Message:[parseDict valueForKey:@"message"]];
        }
        else
        {
            [self errorAlert:@"Congratulations" Message:[parseDict valueForKey:@"message"]];
            
            //NSLog(@"nonNull : %@",[[appConfig sharedInstance] replaceNullInNested:parseDict]);
            
            [appConfig sharedInstance].DIC_UserDetails=parseDict;
            [[appConfig sharedInstance] DIC_UserData:parseDict :keyUserDetails];
            
            [appConfig sharedInstance].STR_UserAccessType = @"Authorized";
            
            [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSearch] animated:YES];
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
-(IBAction)CLK_Back:(id)sender
{
    pushToBack;
}

-(IBAction)CLK_SelectCountry:(id)sender
{
    [appConfig sharedInstance].STR_CountrySelectionType = @"dialCode";
    
    SelectCountry *viewControler = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:vcSelectCountry];
    [self presentViewController:viewControler animated:YES completion:nil];
}

-(IBAction)CLK_DOB:(id)sender
{
    [self.view endEditing:YES];
    
    DT_DOB.hidden = false;
    
    [DT_DOB setMaximumDate:[NSDate date]];
    
    [DT_DOB addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    BTN_Done = [[UIButton alloc]initWithFrame:CGRectMake(0,DT_DOB.frame.origin.y-45, self.view.frame.size.width, 45)];
    [BTN_Done addTarget:self action:@selector(selectDateMethod)forControlEvents:UIControlEventTouchUpInside];
    [BTN_Done setTitle:@"Done" forState:UIControlStateNormal];
    [BTN_Done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    BTN_Done.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:159/255.0 blue:31.0/255.0 alpha:1.0];
    [self.view addSubview:BTN_Done];
}

-(IBAction)CLK_Nationality:(id)sender
{
    [appConfig sharedInstance].STR_CountrySelectionType = @"Nationality";
    
    SelectCountry *viewControler = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:vcSelectCountry];
    [self presentViewController:viewControler animated:YES completion:nil];
    
    /*STR_Nationality = @"India";
    [BTN_Nationality setTitle:@"India" forState:UIControlStateNormal];*/
}

-(IBAction)CLK_Male:(id)sender
{
    if (!BTN_Male.isSelected)
    {
        //Select
        [BTN_Male setBackgroundImage:[UIImage imageNamed:@"btn-registerSelectMale"] forState:UIControlStateNormal];
        [BTN_Female setBackgroundImage:[UIImage imageNamed:@"btn-registerUnSelectFemale"] forState:UIControlStateNormal];
        STR_Gender = @"Male";
    }
}

-(IBAction)CLK_Female:(id)sender
{
    if (!BTN_Female.isSelected)
    {
        //Select
        [BTN_Female setBackgroundImage:[UIImage imageNamed:@"btn-registerSelectFemale"] forState:UIControlStateNormal];
        [BTN_Male setBackgroundImage:[UIImage imageNamed:@"btn-registerUnSelectMale"] forState:UIControlStateNormal];
        
        STR_Gender = @"Female";
    }
}

-(IBAction)CLK_Continue:(id)sender
{
//    NSLog(@"Full Name : %@",TXT_FullName.text);
//    NSLog(@"Email Add : %@",TXT_EmailAdd.text);
//    NSLog(@"Password : %@",TXT_Password.text);
//    NSLog(@"DOB : %@",STR_DOB);
//    NSLog(@"Nationality : %@",STR_Nationality);
//    NSLog(@"Gender : %@",STR_Gender);
    [self.view endEditing:YES];
    
    if (DIC_SocialData)
    {
        if (![self isValidEmail:TXT_EmailAdd.text])
        {
            [self errorAlert:@"Register" Message:@"Please Enter Valid Email Address."];
        }
        else if (STR_DOB.length == 0)
        {
            [self errorAlert:@"Register" Message:@"Please Select Date of Birth."];
        }
        else if (STR_Gender.length == 0)
        {
            [self errorAlert:@"Register" Message:@"Please Select Gender."];
        }
        else if (![BTN_Nationality.titleLabel.textColor isEqual:[UIColor blackColor]])
        {
            [self errorAlert:@"Register" Message:@"Please Select Nationality."];
        }
        else if (![BTN_SelectCountry.titleLabel.textColor isEqual:[UIColor blackColor]])
        {
            [self errorAlert:@"Register" Message:@"Please Select Country Code."];
        }
        else
        {
            //Login API Call
            [self RegisterAPI];
        }
    }
    else
    {
        if (![self isValidEmail:TXT_EmailAdd.text])
        {
            [self errorAlert:@"Register" Message:@"Please Enter Valid Email Address."];
        }
        else if ([TXT_FullName.text length]==0)
        {
            [self errorAlert:@"Register" Message:@"Please Enter Full Name."];
        }
        else if ([TXT_Password.text length]==0)
        {
            [self errorAlert:@"Register" Message:@"Please Enter Password."];
        }
        else if (STR_DOB.length == 0)
        {
            [self errorAlert:@"Register" Message:@"Please Select Date of Birth."];
        }
        else if (STR_Gender.length == 0)
        {
            [self errorAlert:@"Register" Message:@"Please Select Gender."];
        }
        else if ([appConfig sharedInstance].STR_SelectedCountry.length == 0)
        {
            [self errorAlert:@"Register" Message:@"Please Select Nationality."];
        }
        else if (![BTN_SelectCountry.titleLabel.textColor isEqual:[UIColor blackColor]])
        {
            [self errorAlert:@"Register" Message:@"Please Select Country Code."];
        }
        else if ([TXT_MobileNo.text length]==0)
        {
            [self errorAlert:@"Register" Message:@"Please Enter Mobile No."];
        }
        else
        {
            //Login API Call
            [self RegisterAPI];
        }

    }
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    STR_DOB = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:DT_DOB.date]];
}

-(void)selectDateMethod
{
    BTN_Done.hidden = true;
    DT_DOB.hidden = true;
    
    [BTN_DOB setTitle:STR_DOB forState:UIControlStateNormal];
    [BTN_DOB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark - appMethods

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
    
    if (TXT_EmailAdd)
    {
        BTN_Done.hidden = true;
        DT_DOB.hidden = true;
    }
    else if (TXT_FullName)
    {
        BTN_Done.hidden = true;
        DT_DOB.hidden = true;
    }
    else if (TXT_Password)
    {
        BTN_Done.hidden = true;
        DT_DOB.hidden = true;
    }
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
