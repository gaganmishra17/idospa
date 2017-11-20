//
//  ChangePassword.m
//  iDoSpa
//
//  Created by CronyLog on 28/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "ChangePassword.h"

@interface ChangePassword ()

@end

@implementation ChangePassword

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self HudMethod];
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

#pragma mark - IBAction

-(IBAction)CLK_Back:(id)sender
{
    pushToBack;
}

-(IBAction)CLK_ChangePassword:(id)sender
{
    if (TXT_OldPassword.text.length == 0)
    {
        [self errorAlert:@"oops !" Message:@"Please Enter Old Password."];
    }
    else if (TXT_NewPassword.text.length == 0)
    {
        [self errorAlert:@"oops !" Message:@"Please Enter New Password."];
    }
    else if (TXT_ConfirmPassword.text.length == 0)
    {
        [self errorAlert:@"oops !" Message:@"Please Enter Confirm Password."];
    }
    else if (![TXT_NewPassword.text isEqualToString:TXT_ConfirmPassword.text])
    {
        [self errorAlert:@"oops !" Message:@"New Password and Confirm Password Must be same."];
    }
    else
    {
        [self ChangePassword];
    }
}

#pragma mark - API call
-(void)ChangePassword
{
    [HUD show:YES];
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [self errorAlert:@"No Internet" Message:@"Please Check Your Internet Connections."];
        //[HUD hide:YES];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",apiBase,@"/?api=1&task=changepassword"]];
        apiUpdatePasswordRequest = [ASIFormDataRequest requestWithURL:url];
        
        [apiUpdatePasswordRequest setRequestMethod:APIRequestPost];
        
        [apiUpdatePasswordRequest setPostValue:[[appConfig sharedInstance].DIC_UserDetails valueForKey:@"accesstoken"] forKey:@"accesstoken"];
        [apiUpdatePasswordRequest setPostValue:TXT_OldPassword.text forKey:@"oldpass"];
        [apiUpdatePasswordRequest setPostValue:TXT_NewPassword.text forKey:@"newpass"];
                
        [apiUpdatePasswordRequest setDidFinishSelector:@selector(ChangePasswordRespose:)];
        [apiUpdatePasswordRequest setDidFailSelector:@selector(FailRequest:)];
        
        [apiUpdatePasswordRequest setDelegate:self];
        [apiUpdatePasswordRequest startAsynchronous];
    }
}

-(void)ChangePasswordRespose:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parseDict = (NSMutableDictionary *)[responseString JSONValue];
    //NSLog(@"%@",parseDict);
    
    if (parseDict != NULL)
    {
        NSString *Status = [NSString stringWithFormat:@"%@",[parseDict valueForKey:@"status"]];
        if ([Status isEqualToString:@"false"])
        {
            [self errorAlert:@"oops !" Message:[parseDict valueForKey:@"message"]];
        }
        else
        {
            //[self errorAlert:@"Congratulations" Message:[parseDict valueForKey:@"message"]];
            //NSLog(@"Sucess");
            [self successAlert:@"Sucess" Message:@"Password Updated Sucessfully."];
            pushToBack;
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

