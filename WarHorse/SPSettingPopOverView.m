//
//  SPSettingPopOverView.m
//  WarHorse
//
//  Created by EnterPi on 23/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPSettingPopOverView.h"

@interface SPSettingPopOverView () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *popoverTable;
@property (strong, nonatomic) NSMutableArray *listArry;
@property NSInteger index;
@property (strong, nonatomic) NSString *orderBy;
@property (strong, nonatomic) NSString *weeklyOrderBy;

@end

@implementation SPSettingPopOverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 //Drawing code
 }
*/

#pragma mark - Private API

- (void)tableReloadDataInTable:(NSString *)popOverFlagStr
{
    //checking in-app-purchased then change tableview frames
    if (!self.popoverTable){
        self.popoverTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 168, 94)];
        
    }
    
    //Schedule
    if ([popOverFlagStr isEqualToString:@"Schedule"]){
        self.listArry = [[NSMutableArray alloc] initWithObjects:@"Order By:",@"Alphabet",@"Post Time", nil];
    }else{
        self.listArry = [[NSMutableArray alloc] initWithObjects:@"Order By:",@"Alphabet",@"Price", nil];
    }
    
    
    self.popoverTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.popoverTable.backgroundColor=[UIColor clearColor];
    self.popoverTable.dataSource = self;
    self.popoverTable.delegate = self;
    self.popoverTable.scrollEnabled = NO;
    
    [self addSubview:self.popoverTable];
    [self.popoverTable reloadData];
}

#pragma mark - DataSources

#pragma mark Tableview DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArry count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //UIImageView *checkMark;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *checkMark = [[UIImageView alloc] initWithFrame:CGRectMake(6,15,10,9)];
        checkMark.image=[UIImage imageNamed:@"checkmark.png"];
        checkMark.tag = 200;
        [cell.contentView addSubview:checkMark];
        if (indexPath.row == 0){
            UILabel *orderByLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 3, 112, 16)];
            [orderByLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
            orderByLabel.textColor=[UIColor colorWithRed:(43/255.0) green:(43/255.0) blue:(43/255.0) alpha:1];
            [orderByLabel setBackgroundColor:[UIColor clearColor]];
            orderByLabel.tag = 100;
            [cell.contentView addSubview:orderByLabel];
            [checkMark setHidden:YES];
        }
        if (indexPath.row == 1){
            UILabel *alphabetLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 11, 112, 16)];
            [alphabetLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
            alphabetLabel.textColor=[UIColor colorWithRed:(43/255.0) green:(43/255.0) blue:(43/255.0) alpha:1];
            [alphabetLabel setBackgroundColor:[UIColor clearColor]];
            alphabetLabel.tag = 101;
            [cell.contentView addSubview:alphabetLabel];
        }
        if (indexPath.row == 2){
            UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 11, 112, 16)];
            [defaultLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
            [defaultLabel setBackgroundColor:[UIColor clearColor]];
            defaultLabel.tag = 102;
            [cell.contentView addSubview:defaultLabel];
        }
        
        UIImageView *lineImg =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 168,2)] ;
        lineImg.tag = 202;
        [cell.contentView addSubview:lineImg];
        
    }
    UILabel *orderByLabel = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *alphabetLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *defaultLabel = (UILabel *)[cell.contentView viewWithTag:102];
    UIImageView *checkMark = (UIImageView *)[cell.contentView viewWithTag:200];
    UIImageView *lineImg =(UIImageView *)[cell.contentView viewWithTag:202];
    lineImg.image = [UIImage imageNamed:@"seperator-line.png"];
    //seperator-line
    
    if (indexPath.row == 0){
        orderByLabel.text = [self.listArry objectAtIndex:indexPath.row];
    }
    if (indexPath.row == 1){
        alphabetLabel.text =[self.listArry objectAtIndex:indexPath.row];
    }
    if (indexPath.row == 2){
        defaultLabel.text =[self.listArry objectAtIndex:indexPath.row];
    }
    
    orderByLabel.textColor = [UIColor whiteColor];
    alphabetLabel.textColor = [UIColor whiteColor];
    defaultLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    self.orderBy = [[NSUserDefaults standardUserDefaults] objectForKey:_globalOrderBy];
    
    if ([self.orderBy isEqualToString:@"Defaluts"]){
        
        if (indexPath.row == 1){
            [checkMark setHidden:YES];
        }
        if (indexPath.row == 2){
            [checkMark setHidden:NO];
        }
        
    }else{
        if (indexPath.row == 1){
            [checkMark setHidden:NO];
        }
        if (indexPath.row == 2){
            [checkMark setHidden:YES];
        }
        
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropdown-bg.png"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - TableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 22;
    }
    else
        return 36;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImageView *checkMark = (UIImageView *)[cell.contentView viewWithTag:200];
    if ([self.globalOrderBy isEqualToString:@"OrderBy"]){
        
        if ([self.orderBy isEqualToString:@"Defaluts"]) {
        if (indexPath.row == 1){
            
            [[NSUserDefaults standardUserDefaults]setObject:@"Alpha" forKey:@"OrderBy"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [checkMark setHidden:NO];
        }
    }else {
        if (indexPath.row == 2){
            [[NSUserDefaults standardUserDefaults]setObject:@"Defaluts" forKey:@"OrderBy"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [checkMark setHidden:NO];
        }
    }
    }
    
    if ([self.globalOrderBy isEqualToString:@"WeeklyOrderBy"] ){
        
        if ([self.orderBy isEqualToString:@"Defaluts"]) {
            
        if (indexPath.row == 1){
            
            [[NSUserDefaults standardUserDefaults]setObject:@"Alpha" forKey:@"WeeklyOrderBy"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [checkMark setHidden:NO];
        }
    }else {
        if (indexPath.row == 2){
            [[NSUserDefaults standardUserDefaults]setObject:@"Defaluts" forKey:@"WeeklyOrderBy"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [checkMark setHidden:NO];
        }
    }
    }
    
    
    if ([self.globalOrderBy isEqualToString:@"carryOverOrderBy"] ){
        
        if ([self.orderBy isEqualToString:@"Defaluts"]) {
            
            if (indexPath.row == 1){
                
                [[NSUserDefaults standardUserDefaults]setObject:@"Alpha" forKey:@"carryOverOrderBy"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [checkMark setHidden:NO];
            }
        }else {
            if (indexPath.row == 2){
                [[NSUserDefaults standardUserDefaults]setObject:@"Defaluts" forKey:@"carryOverOrderBy"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [checkMark setHidden:NO];
            }
        }
    }
    
    [self.popOverDelegate didChangeComboBoxValue:self selectedIndexPath:indexPath.row];
}

@end
