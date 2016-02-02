//
//  ZLWagerLeftViewController.m
//  WarHorse
//
//  Created by Sparity on 7/5/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLLeftSideMenuViewController.h"
#import "WarHorseSingleton.h"

@interface ZLLeftSideMenuViewController ()

@end

@implementation ZLLeftSideMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Left_Menu_BG.png"]]];
    
    [self.nameLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    [self.leftSideMenuTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Left_Menu_BG.png"]]];
    
    self.itemsArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"Home" forKey:@"title"];
    [dic setObject:[UIImage imageNamed:@"home.png"] forKey:@"logo"];
    [dic setObject:[NSNumber numberWithInt:DashBoardHome] forKey:@"enumValue"];
    [self.itemsArray addObject:dic];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setValue:@"My Bets" forKey:@"title"];
    [dic2 setObject:[UIImage imageNamed:@"currentbets.png"] forKey:@"logo"];
    [dic2 setObject:[NSNumber numberWithInt:DashBoardMyBets] forKey:@"enumValue"];
    [self.itemsArray addObject:dic2];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setValue:@"Wallet" forKey:@"title"];
    [dic3 setObject:[UIImage imageNamed:@"wallet.png"] forKey:@"logo"];
    [dic3 setObject:[NSNumber numberWithInt:DashBoardWallet] forKey:@"enumValue"];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"user_type"] isEqualToString:@"DV"]){
        [dic3 setValue:@"Voucher" forKey:@"title"];
    }else{
        [dic3 setValue:@"Wallet" forKey:@"title"];
    }
    [self.itemsArray addObject:dic3];
    
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setValue:@"Wager" forKey:@"title"];
    [dic1 setObject:[UIImage imageNamed:@"wagerLogo.png"] forKey:@"logo"];
    [dic1 setObject:[NSNumber numberWithInt:DashBoardWager] forKey:@"enumValue"];
    [self.itemsArray addObject:dic1];
    

    if ([[WarHorseSingleton sharedInstance] isVideoSteamingEnable] == YES){
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    [dic4 setValue:@"Live Videos" forKey:@"title"];
    [dic4 setObject:[UIImage imageNamed:@"videos.png"] forKey:@"logo"];
    [dic4 setObject:[NSNumber numberWithInt:DashBoardVideoReplay] forKey:@"enumValue"];
    [self.itemsArray addObject:dic4];
    
    }
     if ([[WarHorseSingleton sharedInstance] isQRCodeEnable]==YES){
         if ([[[WarHorseSingleton sharedInstance] isOntEnable] isEqualToString:@"true"]){
             NSMutableDictionary *dic11 = [NSMutableDictionary dictionary];
             [dic11 setValue:@"Digital Link" forKey:@"title"];
             [dic11 setObject:[UIImage imageNamed:@"leftmenudigitallink.png"] forKey:@"logo"];
             [dic11 setObject:[NSNumber numberWithInt:DashBoardQRCode] forKey:@"enumValue"];
             [self.itemsArray addObject:dic11];
         }
     }
    
    
    
    
    
    NSMutableDictionary *dic7 = [NSMutableDictionary dictionary];
    [dic7 setValue:@"Results/Payoffs" forKey:@"title"];
    [dic7 setObject:[UIImage imageNamed:@"results.png"] forKey:@"logo"];
    [dic7 setObject:[NSNumber numberWithInt:DashBoardResults] forKey:@"enumValue"];
    [self.itemsArray addObject:dic7];
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
        if ([[WarHorseSingleton sharedInstance] isRewordsEnable] == YES){
        NSMutableDictionary *dic9 = [NSMutableDictionary dictionary];
        [dic9 setValue:@"Redeem Rewards" forKey:@"title"];
        [dic9 setObject:[UIImage imageNamed:@"rewardssidemenu.png"] forKey:@"logo"];
        [dic9 setObject:[NSNumber numberWithInt:DashBoardRedeem] forKey:@"enumValue"];
        [self.itemsArray addObject:dic9];
        }
    }

    
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionary];
    [dic6 setValue:@"Non Runners" forKey:@"title"];
    [dic6 setObject:[UIImage imageNamed:@"scrchanges_leftmenu.png"] forKey:@"logo"];
    
    [dic6 setObject:[NSNumber numberWithInt:DashBoardScrChanges] forKey:@"enumValue"];
    [self.itemsArray addObject:dic6];
    
    NSMutableDictionary *dic8 = [NSMutableDictionary dictionary];
    [dic8 setValue:@"Tutorial" forKey:@"title"];
    [dic8 setObject:[UIImage imageNamed:@"getstarted_leftmenu.png"] forKey:@"logo"];
    
    [dic8 setObject:[NSNumber numberWithInt:DashBoardTutorial] forKey:@"enumValue"];
    
    [self.itemsArray addObject:dic8];
    
    
    
    
    //    NSMutableDictionary *dic8 = [NSMutableDictionary dictionary];
    //    [dic8 setValue:@"Odds Board" forKey:@"title"];
    //    [dic8 setObject:[UIImage imageNamed:@"oddsboard.png"] forKey:@"logo"];
    //    [dic8 setObject:[NSNumber numberWithInt:DashBoardOddsBoard] forKey:@"enumValue"];
    //    [self.itemsArray addObject:dic8];
    
    //    NSMutableDictionary *dic9 = [NSMutableDictionary dictionary];
    //    [dic9 setValue:@"Settings" forKey:@"title"];
    //    [dic9 setObject:[UIImage imageNamed:@"settings.png"] forKey:@"logo"];
    //    [dic9 setObject:[NSNumber numberWithInt:DashBoardSettings] forKey:@"enumValue"];
    //    [self.itemsArray addObject:dic9];
    
    NSMutableDictionary *dic10 = [NSMutableDictionary dictionary];
    [dic10 setValue:@"Logout" forKey:@"title"];
    [dic10 setObject:[UIImage imageNamed:@"logout.png"] forKey:@"logo"];
    [dic10 setObject:[NSNumber numberWithInt:DashBoardLogOut] forKey:@"enumValue"];
    [self.itemsArray addObject:dic10];
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
        [self.nameLabel setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
        
        
    }else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ODP"]){
        [self.nameLabel setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"AccountID"]];
        
        
    }else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"DV"])
    {
        [self.nameLabel setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"CplUserName"]];
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"Cell";
    self.objCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.objCell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ZLLeftSideMenuCell" owner:self options:nil];
    }
    
    if (indexPath.row < self.itemsArray.count)
    {
        NSMutableDictionary *dic = [self.itemsArray objectAtIndex:indexPath.row];
        
        [self.objCell.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
        
        self.objCell.titleLabel.text = [dic valueForKey:@"title"];
        self.objCell.logoImageView.image = [dic objectForKey:@"logo"];
    }
    self.objCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return self.objCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImage *selectionBackground;
    selectionBackground = [UIImage imageNamed:@"bg_background.png"];
    //cell.backgroundView =   [[UIImageView alloc] init] ;
    cell.selectedBackgroundView =   [[UIImageView alloc] init];
    ((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
    
    if (indexPath.row < self.itemsArray.count)
    {
        NSMutableDictionary *dic = [self.itemsArray objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[dic objectForKey:@"enumValue"] forKey:@"viewNumber"]];
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37;
}

-(void)viewDidUnload{
    self.itemsArray=nil;
    self.objCell=nil;
    self.nameLabel=nil;
    self.objCell.titleLabel=nil;
    self.objCell.logoImageView=nil;
    
}

@end
