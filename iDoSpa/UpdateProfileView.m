//
//  UpdateProfileView.m
//  iDoSpa
//
//  Created by CronyLog on 02/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "UpdateProfileView.h"

@interface UpdateProfileView ()
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end

@implementation UpdateProfileView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self HudMethod];

    NSLog(@"%@",[appConfig sharedInstance].DIC_UserDetails);
    //Side Menu
    
    IV_ProfileImg.layer.cornerRadius = IV_ProfileImg.frame.size.width / 2;
    IV_ProfileImg.clipsToBounds = YES;
    
    STR_Avtar64 = @"";
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    [self DataSetFromLocal];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[appConfig sharedInstance].STR_CountrySelectionType isEqualToString:@"dialCode"])
    {
        //Country Code
        [BTN_CountryCode setTitle:[appConfig sharedInstance].STR_SelectedDialCode forState:UIControlStateNormal];
        
        [BTN_CountryCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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

-(void)DataSetFromLocal
{
    TXT_FullName.text = [[appConfig sharedInstance].DIC_UserDetails valueForKeyPath:@"login_user_details.member_name"];
    
    TF_Email.text = [[appConfig sharedInstance].DIC_UserDetails valueForKeyPath:@"login_user_details.member_email"];
    
    TF_PhoneNo.text = [[appConfig sharedInstance].DIC_UserDetails valueForKeyPath:@"login_user_details.member_phone"];
    
    NSString *phoneCode=[[appConfig sharedInstance].DIC_UserDetails valueForKeyPath:@"login_user_details.phone_country_code"];
    
    if (phoneCode.length!=0 ) {
        [BTN_CountryCode setTitle:[NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_UserDetails valueForKeyPath:@"login_user_details.phone_country_code"]] forState:UIControlStateNormal];
        
    }
    
    
    NSString *Str_Avtar = [[appConfig sharedInstance].DIC_UserDetails valueForKeyPath:@"login_user_details.member_image_url"];
    IV_ProfileImg.imageURL = [NSURL URLWithString:Str_Avtar];
    STR_Avtar64 = [self encodeToBase64String:IV_ProfileImg.image];
}

#pragma mark - API call
-(void)updateProfileAPI
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
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",apiBase,@"/?api=1&task=update-profile"]];
        apiUpdateProfileRequest = [ASIFormDataRequest requestWithURL:url];
        
        [apiUpdateProfileRequest setRequestMethod:APIRequestPost];
        
        [apiUpdateProfileRequest setPostValue:[[appConfig sharedInstance].DIC_UserDetails valueForKeyPath:@"login_user_details.member_id"] forKey:@"user_id"];
        [apiUpdateProfileRequest setPostValue:TF_Email.text forKey:@"email"];
        
        [apiUpdateProfileRequest setPostValue:[NSString stringWithFormat:@"%@",TXT_FullName.text] forKey:@"member_name"];
        
        [apiUpdateProfileRequest setPostValue:[NSString stringWithFormat:@"%@",[appConfig sharedInstance].STR_SelectedDialCode] forKey:@"phone_country_code"];
        
        [apiUpdateProfileRequest setPostValue:TF_PhoneNo.text forKey:@"phone"];
        
        [apiUpdateProfileRequest setPostValue:STR_Avtar64 forKey:@"photo"];
        
        [apiUpdateProfileRequest setDidFinishSelector:@selector(updateProfileRespose:)];
        [apiUpdateProfileRequest setDidFailSelector:@selector(updateProfileFailRequest:)];
        
        [apiUpdateProfileRequest setDelegate:self];
        [apiUpdateProfileRequest startAsynchronous];
    }
}

-(void)updateProfileRespose:(ASIHTTPRequest *)request
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
            [self successAlert:@"Sucess" Message:@"Profile Updated Sucessfully."];
            
            [appConfig sharedInstance].DIC_UserDetails=parseDict;
            [[appConfig sharedInstance] DIC_UserData:parseDict :keyUserDetails];
            
            [self.rootNav UpdateSideMenu];

        }
    }
    [HUD hide:YES];
}

-(void)updateProfileFailRequest:(ASIHTTPRequest *)request
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
-(IBAction)CLK_CountryCode:(id)sender
{
    [appConfig sharedInstance].STR_CountrySelectionType = @"dialCode";
    
    SelectCountry *viewControler = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:vcSelectCountry];
    [self presentViewController:viewControler animated:YES completion:nil];
}

- (IBAction)CLK_Update:(id)sender
{
    if (![[appConfig sharedInstance]isValidEmail:TF_Email.text])
    {
        [self errorAlert:@"oops !" Message:@"Please Enter Valid Email Address."];
    }
    /*else if ([TF_PhoneNo.text length]==0)
    {
        [self errorAlert:@"oops !" Message:@"Please Enter Phone Number."];
    }
    else if ([TF_Password.text length]==0)
    {
        [self errorAlert:@"oops !" Message:@"Please Enter Password."];
    }*/
    else
    {
        [self updateProfileAPI];
    }
    
}

- (IBAction)CLK_ChangePRofileImg:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Select Photo"]
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *BTN_TakePhoto = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        //code to run once button is pressed
                                        [self TakePhoto];
                                    }];
    
    UIAlertAction *BTN_ImageFromGallery = [UIAlertAction actionWithTitle:@"Choose Existing Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                           {
                                               //code to run once button is pressed
                                               [self FromGallery];
                                           }];
    
    UIAlertAction *BTN_Cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                 {
                                     //code to run once button is pressed
                                 }];
    
    [alert addAction:BTN_TakePhoto];
    [alert addAction:BTN_ImageFromGallery];
    [alert addAction:BTN_Cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)CLK_ChangePassword:(id)sender
{
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcChangePassword] animated:YES];
}

#pragma mark - Image Picker

-(void)FromGallery
{
    IMG_PickerController= [[UIImagePickerController alloc] init];
    IMG_PickerController.delegate = self;
    IMG_PickerController.allowsEditing=YES;
    IMG_PickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:IMG_PickerController animated:YES completion:nil];
}

-(void)TakePhoto
{
    IMG_PickerController = [[UIImagePickerController alloc] init];
    IMG_PickerController.delegate=self;
    IMG_PickerController.allowsEditing=YES;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        IMG_PickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:IMG_PickerController animated:YES completion:NULL];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Camera Available." message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    IV_ProfileImg.image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *Img_Avtar =[self imageWithImage:IV_ProfileImg.image convertToSize:CGSizeMake(150, 150)];
    STR_Avtar64 = [self encodeToBase64String:Img_Avtar];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

- (NSString *)encodeToBase64String:(UIImage *)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

#pragma mark - Side Menu

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    
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


#pragma mark -

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
