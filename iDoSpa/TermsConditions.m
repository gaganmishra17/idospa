//
//  TermsConditions.m
//  iDoSpa
//
//  Created by CronyLog on 01/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "TermsConditions.h"

@interface TermsConditions ()

@end

@implementation TermsConditions

@synthesize Str_ComeFrom;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self HudMethod];
    
    //Side Menu
    if ([Str_ComeFrom isEqualToString:@"Help"]) {
        self.rootNav = (CCKFNavDrawer *)self.navigationController;
        [self.rootNav setCCKFNavDrawerDelegate:self];
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
    
    [WV_TermsCondition addSubview:HUD];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [HUD show:YES];
    
    NSString *url;
    if ([Str_ComeFrom isEqualToString:@"Help"])
    {
        url =[NSString stringWithFormat:@"%@%@",apiBase,@"?api=1&task=help"];
        LBL_Title.text = @"Help";
        BTN_OK.hidden = YES;
        BTN_Menu.hidden = NO;
    }
    else
    {
        url =[NSString stringWithFormat:@"%@%@",apiBase,@"?api=1&task=terms_condition"];
        BTN_OK.hidden = NO;
        BTN_Menu.hidden = YES;
    }
    //NSString *url = @"http://ids2.1s.my/?api=1&task=terms_condition";
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [WV_TermsCondition loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD hide:YES];
}

#pragma mark - IBAction
-(IBAction)CLK_Okey:(id)sender
{
    dismissCurrent;
}

-(IBAction)CLK_Menu:(id)sender
{
    [self.rootNav drawerToggle];
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
