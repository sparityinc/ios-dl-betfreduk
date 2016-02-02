//
//  ZLBetTypeViewController.m
//  WarHorse
//
//  Created by Sparity on 7/9/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLBetTypeViewController.h"
#import "ZLBetType_CustomCell.h"
#import "ZLRunnersViewController.h"
#import "ZLSelectedValues.h"
#import "ZLAppDelegate.h"
#import "ZLAppData.h"
#import "ZLBetType.h"
#import "ZLRaceCard.h"
#import "WarHorseSingleton.h"
#import "ZLMuiltiBetTypeVC.h"


@interface ZLBetTypeViewController ()

@end

@implementation ZLBetTypeViewController
@synthesize betType_CollectionView=_betType_CollectionView;

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
    
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:18]];

    // Do any additional setup after loading the view from its nib.
    [[WarHorseSingleton sharedInstance] setIsWINByte:NO];
    [[WarHorseSingleton sharedInstance] setIsPLCByte:NO];
    [[WarHorseSingleton sharedInstance] setIsSHWByte:NO];
    
    [[WarHorseSingleton sharedInstance] setNoColumsOddBoard:1];
    

    
    [self.betType_CollectionView registerClass:[ZLBetType_CustomCell class] forCellWithReuseIdentifier:@"MY_CELL"];

    self.singleHorseArray = [[NSMutableArray alloc] init];
    self.multiHorseArray = [[NSMutableArray alloc] init];
    self.multiRaceArray = [[NSMutableArray alloc] init];
    
    self.newmultiHorseArray = [[NSMutableArray alloc] init];


    
    [self loadData];
}

-(void) refreshBetTypesFromServer{
    
    self.singleHorseArray = [[NSMutableArray alloc] init];
    self.multiHorseArray = [[NSMutableArray alloc] init];
    self.multiRaceArray = [[NSMutableArray alloc] init];
    self.newmultiHorseArray = [[NSMutableArray alloc] init];

    [self loadData];
    [self.betType_CollectionView reloadData];
}

- (void)loadData
{
    

    ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
    if(_race_card){
        ZLRaceDetails * _race_details = [_race_card findRaceDeatilsByRaceId:[ZLAppDelegate getAppData].currentWager.selectedRaceId];
        if(_race_details){
            NSArray * _bet_types = [_race_details.betTypes allObjects];
            for(ZLBetType * _bet_type in _bet_types){
                if([_bet_type.name isEqualToString:@"WIN"]){
                    [[WarHorseSingleton sharedInstance] setIsWINByte:YES];
                    [[WarHorseSingleton sharedInstance] setNoColumsOddBoard:[[WarHorseSingleton sharedInstance] noColumsOddBoard] + 1];

                    [self.singleHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"PLC"]){
                    [[WarHorseSingleton sharedInstance] setNoColumsOddBoard:[[WarHorseSingleton sharedInstance] noColumsOddBoard] + 1];

                    [[WarHorseSingleton sharedInstance] setIsPLCByte:YES];
                    
                    [self.singleHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"SHW"]){
                    [[WarHorseSingleton sharedInstance] setNoColumsOddBoard:[[WarHorseSingleton sharedInstance] noColumsOddBoard] + 1];

                    [[WarHorseSingleton sharedInstance] setIsSHWByte:YES];
                    [self.singleHorseArray addObject:_bet_type];
                }
                //Win/PLace
                /*
                else if([_bet_type.name isEqualToString:@"WP"]){
                    [self.singleHorseArray addObject:_bet_type];
                }*/
                else if([_bet_type.name isEqualToString:@"EW"]){
                    [self.singleHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"WPS"]){
                    [self.singleHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"WS"]){
                    [self.singleHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"PS"]){
                    [self.singleHorseArray addObject:_bet_type];
                }
                
                else if([_bet_type.name isEqualToString:@"EXA"]){
                    [self.multiHorseArray addObject:_bet_type];
                    [self.newmultiHorseArray addObject:_bet_type];

                    
                }else if([_bet_type.name isEqualToString:@"EBX"]){
                    [self.multiHorseArray addObject:_bet_type];
                }
                
                else if([_bet_type.name isEqualToString:@"EXB"]){
                    [self.multiHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"SWI"]){
                    [self.multiHorseArray addObject:_bet_type];
                    [self.newmultiHorseArray addObject:_bet_type];
                    
                    
                }
                
                
                else if([_bet_type.name isEqualToString:@"TRI"]){
                    [self.multiHorseArray addObject:_bet_type];
                    [self.newmultiHorseArray addObject:_bet_type];

                }
                else if([_bet_type.name isEqualToString:@"TBX"]){
                    [self.multiHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"TRB"]){
                    [self.multiHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"SFC"]){
                    [self.newmultiHorseArray addObject:_bet_type];

                    [self.multiHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"SBX"]){
                    [self.multiHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"SFB"]){
                    [self.multiHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"SFK"]){
                    [self.multiHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"SFX"]){
                    [self.multiHorseArray addObject:_bet_type];
                }
//                else if([_bet_type.name isEqualToString:@"SKB"]){
//                    //[self.multiHorseArray addObject:_bet_type];
//                }
                else if([_bet_type.name isEqualToString:@"SWB"]){
                    [self.multiHorseArray addObject:_bet_type];
                }
                
                else if([_bet_type.name isEqualToString:@"PFC"]){
                    [self.multiHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"PBX"]){
                    [self.multiHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"PEB"]){
                    [self.multiHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"PFK"]){
                    [self.multiHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"QNL"]){
                    [self.newmultiHorseArray addObject:_bet_type];

                    [self.multiHorseArray addObject:_bet_type];
                }else if([_bet_type.name isEqualToString:@"QBX"]){
//                    [self.newmultiHorseArray addObject:_bet_type];

                    [self.multiHorseArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"PEN"]||[_bet_type.name isEqualToString:@"HI5"] || [_bet_type.name isEqualToString:@"HI5"]){
                    [self.multiHorseArray addObject:_bet_type];
                    [self.newmultiHorseArray addObject:_bet_type];

                }
                
                else if([_bet_type.name isEqualToString:@"DBL"]){
                    [self.multiRaceArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"PK3"]){
                    [self.multiRaceArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"PK4"]){
                    [self.multiRaceArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"PK5"]){
                    [self.multiRaceArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"PK6"]){
                    [self.multiRaceArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"PK7"]){
                    [self.multiRaceArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"PK8"]){
                    [self.multiRaceArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"PK9"]){
                    [self.multiRaceArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"P10"]){
                    [self.multiRaceArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"QPT"]){
                    [self.multiRaceArray addObject:_bet_type];
                }else if([_bet_type.name isEqualToString:@"PLP"]){
                    [self.multiRaceArray addObject:_bet_type];
                }else if([_bet_type.name isEqualToString:@"JPT"]){
                    [self.multiRaceArray addObject:_bet_type];
                }else if([_bet_type.name isEqualToString:@"SP7"]){
                    [self.multiRaceArray addObject:_bet_type];
                }
                else if([_bet_type.name isEqualToString:@"SC6"]){
                    [self.multiRaceArray addObject:_bet_type];
                }
            }
        }
    }
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
    if (section == 0) {
        return self.singleHorseArray.count;
    }
    else if (section == 1){
        return self.newmultiHorseArray.count;
    }
    else{
        return self.multiRaceArray.count;
    }
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLBetType_CustomCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    
    ZLBetType * _bet_type = nil;
    //Single Horse
    if (indexPath.section == 0)
    {
//        NSLog(@"self.singleHorseArray %@",self.singleHorseArray);
        _bet_type = [self.singleHorseArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor colorWithRed:69.0/255 green:138.0/255 blue:234.0/255 alpha:1.0];
    }//MultiHorse
    else if (indexPath.section == 1){

        _bet_type = [self.newmultiHorseArray objectAtIndex:indexPath.row];
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
    cell.betType_Label.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2);
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(111.0, 48);//(53.0, 47)
}


//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView reloadData];
    
    //NSLog(@"multiHorseArray %@",self.multiHorseArray);
    
    ZLBetType * _bet_type = nil;
    if (indexPath.section == 0) {
        _bet_type = [self.singleHorseArray objectAtIndex:indexPath.row];
        
       // NSLog(@"betType %@",_bet_type.typeID);
        [[WarHorseSingleton sharedInstance] setBetType:@"SingleHorseType"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadWagerView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:WagerBetType] forKey:@"currentLoadedIndex"]];
        [ZLAppDelegate getAppData].currentWager.selectedBetType = _bet_type.typeID;
        [ZLAppDelegate getAppData].currentWager.isBankarBetType = @"";


    }
    else if (indexPath.section == 1){
        [[WarHorseSingleton sharedInstance] setBetType:@"MultiBetsType"];
        
        _bet_type = [self.newmultiHorseArray objectAtIndex:indexPath.row];
        
        ZLMuiltiBetTypeVC *muiltiBetsVC= [[ZLMuiltiBetTypeVC alloc] init];
        muiltiBetsVC.betTypeName = _bet_type.longName;
        [self.navigationController pushViewController:muiltiBetsVC animated:NO];
    }
    else{
        [[WarHorseSingleton sharedInstance] setBetType:@"MultiHorseType"];

        _bet_type = [self.multiRaceArray objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadWagerView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:WagerBetType] forKey:@"currentLoadedIndex"]];
        [ZLAppDelegate getAppData].currentWager.selectedBetType = _bet_type.typeID;
        [ZLAppDelegate getAppData].currentWager.isBankarBetType = @"";


    }
    [ZLAppDelegate getAppData].currentWager.raceTimeRange = _bet_type.raceTimeRange;


}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)viewDidUnload{
    self.betType_CollectionView=nil;
    self.titleLabel=nil;
}

-(void) viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBetTypesFromServer) name:@"ZLWagerRacesDidLoad" object:nil];

    [super viewDidAppear:animated];
    
}

-(void) viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

@end
