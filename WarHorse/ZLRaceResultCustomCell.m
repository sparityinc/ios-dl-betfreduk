//
//  ZLRaceResultCustomCell.m
//  WarHorse
//
//  Created by Jugs VN on 9/29/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLRaceResultCustomCell.h"
#import "ZLResultDetailCustomCell.h"
#import <QuartzCore/QuartzCore.h>

#define kcustomResultDetailCellIdentifierForSection0 @"customResultDetailCellIdentifierForSection0"
#define kcustomResultDetailCellIdentifierForSection1 @"customResultDetailCellIdentifierForSection1"
#define kcustomResultDetailCellIdentifierForSection2 @"customResultDetailCellIdentifierForSection2"
#define kcustomResultDetailCellIdentifierForSection3 @"customResultDetailCellIdentifierForSection3"

@interface ZLRaceResultCustomCell()

@property (nonatomic, retain) UITableView * tableViewResult;

@end

@implementation ZLRaceResultCustomCell

@synthesize trackResult;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void) setup{
    
    self.tableViewResult = [[UITableView alloc] initWithFrame:CGRectMake(10,0,224.0, 223) style:UITableViewStylePlain];
    self.tableViewResult.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableViewResult setShowsVerticalScrollIndicator:NO];
    self.tableViewResult.backgroundColor = [UIColor whiteColor];
    self.tableViewResult.delegate = self;
    self.tableViewResult.dataSource = self;
    
    UINib * resultDetailCustomCellNib = [UINib nibWithNibName:@"ZLResultDetailCustomCell" bundle:nil];
    [self.tableViewResult registerNib:resultDetailCustomCellNib forCellReuseIdentifier:kcustomResultDetailCellIdentifierForSection0];
    [self.tableViewResult registerNib:resultDetailCustomCellNib forCellReuseIdentifier:kcustomResultDetailCellIdentifierForSection1];
    [self.tableViewResult registerNib:resultDetailCustomCellNib forCellReuseIdentifier:kcustomResultDetailCellIdentifierForSection2];
    [self.tableViewResult registerNib:resultDetailCustomCellNib forCellReuseIdentifier:kcustomResultDetailCellIdentifierForSection3];
    
    [self addSubview:self.tableViewResult];
    
}


#pragma mark - DataSources

#pragma mark - TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    
    if( section == 0){
        return [self.trackResult.winnersByPosition count];
    }
    else if( section == 1){
        return [self.trackResult.betsForRendering count];
    }
    else if( section == 2){
        return [self.trackResult.finishers count];
    }
    else  if( section == 3){
        NSLog(@"Others %@",trackResult.otherInformation);
        return [self.trackResult.otherInformation count];
    }
    return 0;
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //    if (section == 0) {
    //        return @"Win, Place, Show Payoffs";
    //    }else if(section == 1) {
    //        return @"Other wagers";
    //    }else if (section == 2){
    //        return @"Order of finish";
    //    }else
    //        return @"Scratches(Reason)";
    return @"";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZLResultDetailCustomCell * resultDetailCustomCell = nil;
    if (indexPath.section == 0){
        resultDetailCustomCell  = [tableView dequeueReusableCellWithIdentifier:kcustomResultDetailCellIdentifierForSection0 forIndexPath:indexPath];
    }
    else if (indexPath.section == 1){
        resultDetailCustomCell  = [tableView dequeueReusableCellWithIdentifier:kcustomResultDetailCellIdentifierForSection1 forIndexPath:indexPath];
    }
    else if (indexPath.section == 2){
        resultDetailCustomCell  = [tableView dequeueReusableCellWithIdentifier:kcustomResultDetailCellIdentifierForSection2 forIndexPath:indexPath];
    }
    else if (indexPath.section == 3) {
        resultDetailCustomCell  = [tableView dequeueReusableCellWithIdentifier:kcustomResultDetailCellIdentifierForSection3 forIndexPath:indexPath];
    }
    
    if( self.trackResult != nil){
        resultDetailCustomCell.frame = CGRectMake(0,0,237,300);
        resultDetailCustomCell.trackResult = self.trackResult;
        [resultDetailCustomCell updateViewAtIndexPath:indexPath];
    }
    
    return resultDetailCustomCell;
}


#pragma mark - Delegates

#pragma mark - TableView Delegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return 39;
    }else if (indexPath.section==2){
        return 54;
    }else if (indexPath.section==3){
        return 24.5;
    }
    else{
        return 50.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 27.5;
            break;
        case 1:
            return 27.5;
            break;
        case 2:
            return 30.5;
            break;
        case 3:
            return 27;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
            
        case 3:
            return 7;
            break;
            
        default:
            return 0;
            break;
    }
}

// custom view for footer. will be adjusted to default or specified footer height

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 274, 7)];
    return footerBackground;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView=[[UIView alloc]init];
    UIView *sectionHeaderViewBackgroundView = [[UIView alloc] init];
    UILabel *tempLabel=[[UILabel alloc]init];
    
    switch (section) {
        case 0:
        {
            [sectionHeaderView setFrame:CGRectMake(0,0,220,29)];
            [sectionHeaderViewBackgroundView setFrame:CGRectMake(0, 0, 310, 27)];
            [tempLabel setFrame:CGRectMake(0,7,237,20)];
        }
            break;
        case 1:
        {
            [sectionHeaderView setFrame:CGRectMake(0,0,220,29)];
            [sectionHeaderViewBackgroundView setFrame:CGRectMake(0, 0, 310, 27)];
            [tempLabel setFrame:CGRectMake(0,7,227,20)];
        }
            break;
        case 2:
        {
            [sectionHeaderView setFrame:CGRectMake(0,0,220,29)];
            [sectionHeaderViewBackgroundView setFrame:CGRectMake(0, 0, 310, 27)];
            [tempLabel setFrame:CGRectMake(0,7.5,227,20)];
        }
            break;
        case 3:
        {
            [sectionHeaderView setFrame:CGRectMake(0,0,220,29)];
            [sectionHeaderViewBackgroundView setFrame:CGRectMake(0, 0, 310, 27)];
            [tempLabel setFrame:CGRectMake(0,7.5,227,20)];
        }
            break;
            
        default:
            break;
    }
    
    sectionHeaderView.backgroundColor=[UIColor clearColor];
    sectionHeaderViewBackgroundView.backgroundColor = [UIColor whiteColor];
    [sectionHeaderView addSubview:sectionHeaderViewBackgroundView];
    tempLabel.backgroundColor=[UIColor colorWithRed:217.0/255.0f green:217.0/255.0f blue:217.0/255.0f alpha:1.0];
    tempLabel.textAlignment=NSTextAlignmentCenter;
    [tempLabel setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    [tempLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    
    if (section==0) {
        tempLabel.text=@"Results";
    }else if (section==1){
        tempLabel.text=@"";
    }else if (section==2){
        tempLabel.text=@"Order of finish";
        
    }else{
        tempLabel.text=@"Other Information";
        
    }
    [sectionHeaderView addSubview:tempLabel];
    
    return sectionHeaderView;
}


@end
