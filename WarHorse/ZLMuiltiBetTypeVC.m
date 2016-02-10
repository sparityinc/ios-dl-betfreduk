//
//  ZLMuiltiBetTypeVC.m
//  WarHorse
//
//  Created by Veeru on 12/11/15.
//  Copyright (c) 2015 Zytrix Labs. All rights reserved.
//

#import "ZLMuiltiBetTypeVC.h"
#import "ZLBetType_CustomCell.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"

@interface ZLMuiltiBetTypeVC ()
@property (nonatomic,strong) NSMutableArray *muiltiHourses;

@end

@implementation ZLMuiltiBetTypeVC
@synthesize betType_CollectionView=_betType_CollectionView;
@synthesize betTypeName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Straight Permutation Bankker
    self.muiltiHourses = [NSMutableArray new];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];


    [dic1 setValue:@"Straight" forKey:@"BetType"];
    
    if ([betTypeName isEqualToString:@"Exacta"]){
        [dic1 setValue:@"EXA" forKey:@"typeID"];
        [dic2 setValue:@"EBX" forKey:@"typeID"];
        [dic3 setValue:@"EXB" forKey:@"typeID"];

        

    }else if ([betTypeName isEqualToString:@"Trifecta"]){
        [dic1 setValue:@"TRI" forKey:@"typeID"];
        [dic2 setValue:@"TBX" forKey:@"typeID"];
        [dic3 setValue:@"TRB" forKey:@"typeID"];


    }else if ([betTypeName isEqualToString:@"Superfecta"]){
        [dic1 setValue:@"SFC" forKey:@"typeID"];
        [dic2 setValue:@"SFX" forKey:@"typeID"];
        [dic3 setValue:@"SFB" forKey:@"typeID"];

        
        
    }else if ([betTypeName isEqualToString:@"Pentafecta"]){
        [dic1 setValue:@"PEN" forKey:@"typeID"];
        [dic2 setValue:@"PBX" forKey:@"typeID"];
        [dic3 setValue:@"PEB" forKey:@"typeID"];

       
        
    }else if ([betTypeName isEqualToString:@"Swinger"]){
        [dic1 setValue:@"SWI" forKey:@"typeID"];
        [dic2 setValue:@"SWX" forKey:@"typeID"];
       // [dic3 setValue:@"SWB" forKey:@"typeID"];
    }
    
    [self.muiltiHourses addObject:dic1];
    
    
//    [dic2 setValue:@"Permutation" forKey:@"BetType"];

    if (![betTypeName isEqualToString:@"Swinger"])
     {
    [dic3 setValue:@"Banker" forKey:@"BetType"];
         
     }
    
    //if (![betTypeName isEqualToString:@"Swinger"])
   // {
        [dic2 setValue:@"Permutation" forKey:@"BetType"];
        
        [self.muiltiHourses addObject:dic2];
        
        
   // }


    if ([[WarHorseSingleton sharedInstance] kLegBetting] == YES){
        if (![betTypeName isEqualToString:@"Swinger"])
        {
        [self.muiltiHourses addObject:dic3];
        }

    }
    
    
    
    

    
    [self.betType_CollectionView registerClass:[ZLBetType_CustomCell class] forCellWithReuseIdentifier:@"MY_CELL"];

    
    
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
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark--
#pragma UICollectionView Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.muiltiHourses.count;
   
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLBetType_CustomCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    /*
    ZLBetType * _bet_type = nil;
    //Single Horse
    if (indexPath.section == 0)
    {
        //        NSLog(@"self.singleHorseArray %@",self.singleHorseArray);
        _bet_type = [self.singleHorseArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor colorWithRed:69.0/255 green:138.0/255 blue:234.0/255 alpha:1.0];
    }//MultiHorse
    else if (indexPath.section == 1){
        
        _bet_type = [self.multiHorseArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor colorWithRed:92.0/255 green:140.0/255 blue:26.0/255 alpha:1.0];
    }//MutiRace
    else
    {
        _bet_type = [self.multiRaceArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor colorWithRed:236.0/255 green:106.0/255 blue:62.0/255 alpha:1.0];
    }
    
    if ([_bet_type.name isEqualToString:[ZLAppDelegate getAppData].currentWager.selectedBetType]) {
        cell.backgroundColor = [UIColor blackColor];
    }
    
    
    cell.betType_Label.text = _bet_type.longName;//_bet_type.name;
    cell.betType_Label.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2);*/
    
    
    NSDictionary *tempDict = [self.muiltiHourses objectAtIndex:indexPath.row];
    
    NSLog(@"tempDict %@",tempDict);
    
    
    if ([[tempDict valueForKey:@"BetType"] isEqualToString:@"Banker"]){
        [ZLAppDelegate getAppData].currentWager.isBankarBetType = @"Banker";
        

    }else{
        [ZLAppDelegate getAppData].currentWager.isBankarBetType = @"";

    }

    cell.betType_Label.text = [tempDict valueForKey:@"BetType"];//_bet_type.name;

    cell.betType_Label.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2);

    cell.backgroundColor = [UIColor colorWithRed:69.0/255 green:138.0/255 blue:234.0/255 alpha:1.0];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(225.0, 48);
}


//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //[collectionView reloadData];
    
    //NSLog(@"multiHorseArray %@",self.multiHorseArray);
    /*
    ZLBetType * _bet_type = nil;
    if (indexPath.section == 0) {
        _bet_type = [self.singleHorseArray objectAtIndex:indexPath.row];
        // NSLog(@"betType %@",_bet_type.typeID);
        [[WarHorseSingleton sharedInstance] setBetType:@"SingleHorseType"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadWagerView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:WagerBetType] forKey:@"currentLoadedIndex"]];
        
    }
    else if (indexPath.section == 1){
        [[WarHorseSingleton sharedInstance] setBetType:@"MultiBetsType"];
        _bet_type = [self.multiHorseArray objectAtIndex:indexPath.row];
        
        ZLMuiltiBetTypeVC *muiltiBetsVC= [[ZLMuiltiBetTypeVC alloc] init];
        [self.navigationController pushViewController:muiltiBetsVC animated:NO];
    }
    else{
        [[WarHorseSingleton sharedInstance] setBetType:@"MultiHorseType"];
        
        _bet_type = [self.multiRaceArray objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadWagerView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:WagerBetType] forKey:@"currentLoadedIndex"]];
        
    }*/
    /*
    if (indexPath.row == 2){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Comming soon" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }*/
    NSDictionary *tempDict = [self.muiltiHourses objectAtIndex:indexPath.row];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadWagerView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:WagerBetType] forKey:@"currentLoadedIndex"]];
    if ([[tempDict valueForKey:@"BetType"] isEqualToString:@"Banker"]){
        [ZLAppDelegate getAppData].currentWager.isBankarBetType = @"Banker";
        
        
    }else{
        [ZLAppDelegate getAppData].currentWager.isBankarBetType = @"";
        
    }
    
    [ZLAppDelegate getAppData].currentWager.selectedBetType = [tempDict valueForKey:@"typeID"];


    //[ZLAppDelegate getAppData].currentWager.selectedBetType = _bet_type.typeID;
    
}


@end
