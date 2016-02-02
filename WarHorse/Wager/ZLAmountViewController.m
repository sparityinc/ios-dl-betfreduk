//
//  ZLAmountViewController.m
//  WarHorse
//
//  Created by Sparity on 7/9/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLAmountViewController.h"
#import "ZLAmount_CustomCell.h"
#import "ZLBetTypeViewController.h"
#import "ZLSelectedValues.h"
#import "ZLAppDelegate.h"
#import "ZLAppData.h"
#import "ZLBetType.h"
#import "ZLRaceCard.h"
#import <QuartzCore/QuartzCore.h>
#import "WarHorseSingleton.h"


@interface ZLAmountViewController ()

@end

@implementation ZLAmountViewController
@synthesize amount_Array=_amount_Array;
@synthesize bet_Label=_bet_Label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _amount_Array=[[NSMutableArray alloc]init];
    
    [self loadData];

    [self.amount_CollectionView registerClass:[ZLAmount_CustomCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
    int numberOfRows = (self.amount_Array.count%4 == 0) ? self.amount_Array.count/4 : (self.amount_Array.count/4) + 1;
    
    if (numberOfRows > 6)
    {
        numberOfRows = 6;
    }
    
    
    [self.bet_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    
    self.customAmountView = [[ZLCustomAmountView alloc] initWithFrame:CGRectMake(0, 36, 236.5, 390)];
    self.customAmountView.hidden = YES;
    self.customAmountView.delegate = self;
    //self.customAmountView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.customAmountView];
    
    self.defaultButton.layer.borderWidth = 0.5;//12
    self.defaultButton.layer.borderColor = [UIColor colorWithRed:2.0/255 green:55.0/255 blue:84.0/255 alpha:1.0].CGColor;
    [self.defaultButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-BoldCondensed" size:12]];
    
    self.customButton.layer.borderWidth = 0.5;
    self.customButton.layer.borderColor = [UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0].CGColor;
    [self.customButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-BoldCondensed" size:12]];
}

-(void)loadData{
    //NSLog(@"Bet type - %@",self.view);
    
    ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
    if(_race_card){
        ZLRaceDetails * _race_details = [_race_card findRaceDeatilsByRaceId:[ZLAppDelegate getAppData].currentWager.selectedRaceId];
        if(_race_details){
            ZLBetType* _bet_type = [_race_details findBetTypeWithName:[ZLAppDelegate getAppData].currentWager.selectedBetType];
            self.amount_Array = [_bet_type.betAmounts allObjects];
        }
    }
}

-(void) refreshAmountsFromServer{
    
    [self loadData];
    [self.amount_CollectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark--
#pragma UICollectionView Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.amount_Array count];
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLAmount_CustomCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    
    NSString * amount = [self.amount_Array objectAtIndex:indexPath.row];
    int amt = [amount intValue];
    double _amt = amt / 100.0;
    NSString *amountValue =[NSString stringWithFormat:@"%.0f", _amt];
    
    float amountInt = [amountValue floatValue];
    if (1<=amountInt){
        cell.amount_Label.text = [NSString stringWithFormat:@"%@%.0f",[[WarHorseSingleton sharedInstance] currencySymbel], _amt];

    }else{
        cell.amount_Label.text = [NSString stringWithFormat:@"%d%@", amt,@"p"];



    }
    
    /*
     NSLog(@"amount view %0.2f",_amt);
     
     
     cell.amount_Label.text = [NSString stringWithFormat:@"$%0.2f", _amt];
     */
    
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor colorWithRed:146.0/255 green:159.0/255 blue:165.0/255 alpha:1.0].CGColor;
    if ( [ZLAppDelegate getAppData].currentWager.amount == _amt)
    {
        cell.backgroundColor = [UIColor blackColor];
        cell.amount_Label.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithRed:207.0/255 green:220.0/255 blue:226.0/255 alpha:1.0];
        cell.amount_Label.textColor = [UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0];
    }
    
    
    return cell;
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(52, 48);
//}
//
//
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [collectionView reloadData];

    //Handling selections
    NSString * amount = [self.amount_Array objectAtIndex:indexPath.row];
    int amt = [amount intValue];
    [ZLAppDelegate getAppData].currentWager.amount = amt / 100.0;
  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadWagerView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:WagerAmount] forKey:@"currentLoadedIndex"]];
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(IBAction)defaultButtonClicked:(id)sender
{
    if (![self.defaultButton isSelected])
    {
        [self.defaultButton setSelected:YES];
        [self.customButton setSelected:NO];
        
        self.defaultButton.layer.borderColor = [UIColor colorWithRed:2.0/255 green:55.0/255 blue:84.0/255 alpha:1.0].CGColor;
        self.customButton.layer.borderColor = [UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0].CGColor;
        
        [self.defaultButton setBackgroundColor:[UIColor colorWithRed:35.0/255 green:108.0/255 blue:142.0/255 alpha:1.0]];
        [self.customButton setBackgroundColor:[UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0]];

        self.customAmountView.hidden = YES;
        self.amount_CollectionView.hidden = NO;
    }
    else{
    }
}
-(IBAction)customButtonClicked:(id)sender
{
    if (![self.customButton isSelected])
    {
        [self.defaultButton setSelected:NO];
        [self.customButton setSelected:YES];
        
        self.defaultButton.layer.borderColor = [UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0].CGColor;
        self.customButton.layer.borderColor = [UIColor colorWithRed:2.0/255 green:55.0/255 blue:84.0/255 alpha:1.0].CGColor;

        [self.customButton setBackgroundColor:[UIColor colorWithRed:35.0/255 green:108.0/255 blue:142.0/255 alpha:1.0]];
        [self.defaultButton setBackgroundColor:[UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0]];
        
        self.customAmountView.hidden = NO;
        self.amount_CollectionView.hidden = YES;
    }
    else{

    }
}

#pragma mark -
#pragma CustomAmountDelegate Method

- (void) selectedAmount:(NSString *)amount
{
    amount = [amount stringByReplacingOccurrencesOfString:[[WarHorseSingleton sharedInstance] currencySymbel] withString:@""];
    float amt = [amount floatValue];
    [ZLAppDelegate getAppData].currentWager.amount = amt;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadWagerView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:WagerAmount] forKey:@"currentLoadedIndex"]];

}

#pragma mark -

-(void) viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAmountsFromServer) name:@"ZLWagerRacesDidLoad" object:nil];
    [super viewDidAppear:animated];
    
}

-(void) viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

-(void)viewDidUnload{
    self.amount_CollectionView=nil;
    self.amount_Array=nil;
    self.bet_Label=nil;
}

@end
