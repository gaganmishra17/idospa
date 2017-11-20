//
//  PaymentDone.m
//  iDoSpa
//
//  Created by CronyLog on 24/08/17.
//  Copyright © 2017 CronyLog. All rights reserved.
//

#import "PaymentDone.h"

@interface PaymentDone ()

@end

@implementation PaymentDone

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    LBL_CompletePayment.text = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"TotalPrice"]];
    LBL_OrderNo.text = [NSString stringWithFormat:@"%@",[[appConfig sharedInstance].DIC_BookingDetails valueForKey:@"OrderNo"]];
}

-(IBAction)CLK_Done:(id)sender
{
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcSearch] animated:NO];
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
