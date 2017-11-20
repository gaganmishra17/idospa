//
//  CCKFNavDrawer.m
//  CCKFNavDrawer
//
//  Created by calvin on 23/1/14.
//  Copyright (c) 2014年 com.calvin. All rights reserved.
//

#import "CCKFNavDrawer.h"
#import "DrawerView.h"

#define SHAWDOW_ALPHA 0.5
#define MENU_DURATION 0.3
#define MENU_TRIGGER_VELOCITY 350

@interface CCKFNavDrawer ()

@property (nonatomic) BOOL isOpen;
@property (nonatomic) float meunHeight;
@property (nonatomic) float menuWidth;
@property (nonatomic) CGRect outFrame;
@property (nonatomic) CGRect inFrame;
@property (strong, nonatomic) UIView *shawdowView;
@property (strong, nonatomic) DrawerView *drawerView;

@end

@implementation CCKFNavDrawer

#pragma mark - VC lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setUpDrawer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - push & pop

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    // disable gesture in next vc
    [self.pan_gr setEnabled:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    
    // enable gesture in root vc
    if ([self.viewControllers count]==1){
        [self.pan_gr setEnabled:YES];
    }
    return vc;
}

#pragma mark - IBAction
-(IBAction)CLK_Logout:(id)sender
{
    NSLog(@"Logout");
    
    [self closeNavigationDrawer];
    
    [[appConfig sharedInstance] resetDevice];
    
    UINavigationController *navigationController = (UINavigationController *)[appConfig sharedInstance].AppDel.window.rootViewController;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    Login *LoginViewpage = (Login *)[mainStoryboard instantiateViewControllerWithIdentifier: vcLoginRegister];
    [navigationController pushViewController:LoginViewpage animated:NO];
    
}

-(IBAction)CLK_SearchMenu:(id)sender
{
    NSLog(@"Search");
    
    [self closeNavigationDrawer];
    
    UINavigationController *navigationController = (UINavigationController *)[appConfig sharedInstance].AppDel.window.rootViewController;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    Login *LoginViewpage = (Login *)[mainStoryboard instantiateViewControllerWithIdentifier: vcSearch];
    [navigationController pushViewController:LoginViewpage animated:YES];
}

-(IBAction)CLK_Account:(id)sender
{
    NSLog(@"MyAccount");
    [self closeNavigationDrawer];
    
    UINavigationController *navigationController = (UINavigationController *)[appConfig sharedInstance].AppDel.window.rootViewController;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    Login *LoginViewpage = (Login *)[mainStoryboard instantiateViewControllerWithIdentifier: vcUpdateProfile];
    [navigationController pushViewController:LoginViewpage animated:YES];
}

-(IBAction)CLK_FavoriteList:(id)sender
{
    NSLog(@"Favorite");
    [self closeNavigationDrawer];
    
    UINavigationController *navigationController = (UINavigationController *)[appConfig sharedInstance].AppDel.window.rootViewController;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    FavoriteList *Viewpage = (FavoriteList *)[mainStoryboard instantiateViewControllerWithIdentifier: vcFavoriteList];
    [navigationController pushViewController:Viewpage animated:YES];
}

-(IBAction)CLK_BookingHistoryList:(id)sender
{
    NSLog(@"Order History");
    [self closeNavigationDrawer];
    
    UINavigationController *navigationController = (UINavigationController *)[appConfig sharedInstance].AppDel.window.rootViewController;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    BookingHistory *Viewpage = (BookingHistory *)[mainStoryboard instantiateViewControllerWithIdentifier:vcBookingHistory];
    [navigationController pushViewController:Viewpage animated:YES];
}

-(IBAction)CLK_upComingBooking:(id)sender
{
    NSLog(@"cart");
    [self closeNavigationDrawer];
    
    UINavigationController *navigationController = (UINavigationController *)[appConfig sharedInstance].AppDel.window.rootViewController;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UpComingBoolingList *Viewpage = (UpComingBoolingList *)[mainStoryboard instantiateViewControllerWithIdentifier:vcUpComingBoolingList];
    [navigationController pushViewController:Viewpage animated:YES];
}

-(IBAction)CLK_Help:(id)sender
{
    [self closeNavigationDrawer];
    
    UINavigationController *navigationController = (UINavigationController *)[appConfig sharedInstance].AppDel.window.rootViewController;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TermsConditions *Viewpage = (TermsConditions *)[mainStoryboard instantiateViewControllerWithIdentifier:vcTermsConditions];
    Viewpage.Str_ComeFrom = @"Help";
    [navigationController pushViewController:Viewpage animated:YES];
}

#pragma mark - drawer

-(void)UpdateSideMenu
{
    [self UiDataSetForDrower];
}

- (void)setUpDrawer
{
    self.isOpen = NO;
    
    // load drawer view
    self.drawerView = [[[NSBundle mainBundle] loadNibNamed:@"DrawerView" owner:self options:nil] objectAtIndex:0];
    
    self.meunHeight = self.view.frame.size.height;//
    self.menuWidth = self.drawerView.frame.size.width;
    self.outFrame = CGRectMake(-self.menuWidth,0,self.menuWidth,self.meunHeight);
    self.inFrame = CGRectMake (0,0,self.menuWidth,self.meunHeight);
    
    // drawer shawdow and assign its gesture
    self.shawdowView = [[UIView alloc] initWithFrame:self.view.frame];
    self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.shawdowView.hidden = YES;
    UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapOnShawdow:)];
    [self.shawdowView addGestureRecognizer:tapIt];
    self.shawdowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.shawdowView];
    
    // add drawer view
    [self.drawerView setFrame:self.outFrame];
    [self.view addSubview:self.drawerView];
    
    // drawer list
//    [self.drawerView.drawerTableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)]; // statuesBarHeight+navBarHeight
//    self.drawerView.drawerTableView.dataSource = self;
//    self.drawerView.drawerTableView.delegate = self;
    
    // gesture on self.view
    /*
    self.pan_gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveDrawer:)];
    self.pan_gr.maximumNumberOfTouches = 1;
    self.pan_gr.minimumNumberOfTouches = 1;
    //self.pan_gr.delegate = self;
    [self.view addGestureRecognizer:self.pan_gr];
     */
    
    [self.view bringSubviewToFront:self.navigationBar];
    [self UiDataSetForDrower];
  
//    for (id x in self.view.subviews){
//        NSLog(@"%@",NSStringFromClass([x class]));
//    }
}

- (void)drawerToggle
{
    if (!self.isOpen)
    {
        [self openNavigationDrawer];
    }
    else
    {
        [self closeNavigationDrawer];
    }
}

-(void)UiDataSetForDrower
{
    NSDictionary *DIC_Userdata = [[appConfig sharedInstance] DIC_RetriveDataFromUserDefault:keyUserDetails];
    self.drawerView.Lbl_UserName.text = [DIC_Userdata valueForKeyPath:@"login_user_details.member_email"];
    
    NSString *Str_AvtarUrl = [NSString stringWithFormat:@"%@",[DIC_Userdata valueForKeyPath:@"login_user_details.member_image_url"]];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:Str_AvtarUrl]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            self.drawerView.IV_Avtar.image = [UIImage imageWithData: data];
        });
    });
    
    self.drawerView.IV_Avtar.layer.cornerRadius = self.drawerView.IV_Avtar.frame.size.width / 2;
    self.drawerView.IV_Avtar.clipsToBounds = YES;
}

#pragma open and close action

- (void)openNavigationDrawer{
//    NSLog(@"open x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*abs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    self.shawdowView.hidden = NO;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:SHAWDOW_ALPHA];
                     }
                     completion:nil];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.inFrame;
                     }
                     completion:nil];
    
    self.isOpen= YES;
}

- (void)closeNavigationDrawer{
//    NSLog(@"close x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*abs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         self.shawdowView.hidden = YES;
                     }];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.outFrame;
                     }
                     completion:nil];
    self.isOpen= NO;
}

#pragma gestures

- (void)tapOnShawdow:(UITapGestureRecognizer *)recognizer {
    [self closeNavigationDrawer];
}

-(void)moveDrawer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)recognizer velocityInView:self.view];
//    NSLog(@"velocity x=%f",velocity.x);
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan) {
//        NSLog(@"start");
        if ( velocity.x > MENU_TRIGGER_VELOCITY && !self.isOpen) {
            [self openNavigationDrawer];
        }else if (velocity.x < -MENU_TRIGGER_VELOCITY && self.isOpen) {
            [self closeNavigationDrawer];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateChanged) {
//        NSLog(@"changing");
        float movingx = self.drawerView.center.x + translation.x;
        if ( movingx > -self.menuWidth/2 && movingx < self.menuWidth/2){
            
            self.drawerView.center = CGPointMake(movingx, self.drawerView.center.y);
            [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
            
            float changingAlpha = SHAWDOW_ALPHA/self.menuWidth*movingx+SHAWDOW_ALPHA/2; // y=mx+c
            self.shawdowView.hidden = NO;
            self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:changingAlpha];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
//        NSLog(@"end");
        if (self.drawerView.center.x>0){
            [self openNavigationDrawer];
        }else if (self.drawerView.center.x<0){
            [self closeNavigationDrawer];
        }
    }

}

@end
