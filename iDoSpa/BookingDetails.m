//
//  BookingDetails.m
//  iDoSpa
//
//  Created by CronyLog on 19/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "BookingDetails.h"

@interface BookingDetails ()

@end

@implementation BookingDetails
@synthesize ARY_BookingDetails;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Details : %@",ARY_BookingDetails);
    
    IMG_BG.layer.cornerRadius = 15.0;
    IMG_BG.layer.borderWidth = 1.0;
    IMG_BG.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //IMG_BG.clipsToBounds = YES;
    
    IMG_ItemLogo.layer.cornerRadius = 8.0;
    IMG_ItemLogo.clipsToBounds = YES;
    
    IMG_ItemLogo.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[ARY_BookingDetails valueForKey:@"image"]]];
    IMG_QRCode.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[ARY_BookingDetails valueForKey:@"qr_code_image"]]];;
    
    //merchant_name
    LBL_MurchantName.text =
    [NSString stringWithFormat:@"%@",[ARY_BookingDetails valueForKey:@"merchant_name"]];
    
    LBL_BookingName.text = [NSString stringWithFormat:@"%@",[ARY_BookingDetails valueForKey:@"item_name"]];
    LBL_BookingAddress.text = [NSString stringWithFormat:@"%@",[ARY_BookingDetails valueForKey:@"address"]];;
    LBL_Date.text = [NSString stringWithFormat:@"%@",[[ARY_BookingDetails valueForKey:@"booking_start"] componentsSeparatedByString:@" "][0]];
    
    LBL_Time.text = [NSString stringWithFormat:@"%@",[[ARY_BookingDetails valueForKey:@"booking_start"] componentsSeparatedByString:@" "][1]];
    LBL_Service.text = [NSString stringWithFormat:@"%@",[ARY_BookingDetails valueForKey:@"booking_type"]];;
    LBL_Massure.text = [NSString stringWithFormat:@"%@",[ARY_BookingDetails valueForKey:@"masseur_name"]];;
    LBL_Price.text = [NSString stringWithFormat:@"RM%@",[ARY_BookingDetails valueForKey:@"booking_cost"]];;
    LBL_GSTCharge.text = [NSString stringWithFormat:@"RM%@",[ARY_BookingDetails valueForKey:@"gst_charge"]];;
    LBL_SubTotal.text = [NSString stringWithFormat:@"RM%@",[ARY_BookingDetails valueForKey:@"sub_total"]];;
    LBL_OrderNo.text = [NSString stringWithFormat:@"ORDER : #%@",[ARY_BookingDetails valueForKey:@"booking_id"]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

#pragma mark - IBAction

-(IBAction)CLK_Back:(id)sender
{
    pushToBack;
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
