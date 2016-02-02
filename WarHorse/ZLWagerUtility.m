//
//  ZLWagerUtility.m
//  WarHorse
//
//  Created by Jugs VN on 9/5/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLWagerUtility.h"
#import "ZLWager.h"

#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

static NSArray * num_leg_map;

static NSDictionary * betTypeMappings;
static int totalSelectionOfOT;

static int totalSelectionOfBK;

@implementation ZLWagerUtility

+(void) initialize{
    //New Bet Type Adding Veeru
    /*
    EXACTA BANKER – EXB
    TRIFECTA BANKER – TRB
    SUPERFECTA BANKER – SFB
    PENTAFECTA BANKER – PEB
    SWINGER BANKER – SWB*/

    num_leg_map = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1],  [NSNumber numberWithInt:1],  [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:2], [NSNumber numberWithInt:2], [NSNumber numberWithInt:1],  [NSNumber numberWithInt:3],  [NSNumber numberWithInt:3], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], [NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8], [NSNumber numberWithInt:9], [NSNumber numberWithInt:10],  [NSNumber numberWithInt:2], [NSNumber numberWithInt:2], [NSNumber numberWithInt:4], [NSNumber numberWithInt:4], [NSNumber numberWithInt:4], [NSNumber numberWithInt:4], [NSNumber numberWithInt:4], [NSNumber numberWithInt:4], [NSNumber numberWithInt:3],  [NSNumber numberWithInt:3],  [NSNumber numberWithInt:2], [NSNumber numberWithInt:4], [NSNumber numberWithInt:4], [NSNumber numberWithInt:4], [NSNumber numberWithInt:3], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:4], [NSNumber numberWithInt:7],  [NSNumber numberWithInt:7], [NSNumber numberWithInt:7], [NSNumber numberWithInt:7], [NSNumber numberWithInt:4], [NSNumber numberWithInt:4], [NSNumber numberWithInt:2], [NSNumber numberWithInt:2], [NSNumber numberWithInt:9], [NSNumber numberWithInt:6],[NSNumber numberWithInt:5],  [NSNumber numberWithInt:5], [NSNumber numberWithInt:6], nil];
    
    betTypeMappings = @{@"TRB":@"TRB",@"WIN":@"WIN",@"PLC":@"PLC",@"SHW":@"SHW",@"EW":@"EW",@"WPS":@"WPS",@"WS":@"WS",@"PS":@"PS",@"EXA":@"EXA",@"EBX":@"EBX",@"EXB":@"EXB",@"QNL":@"QNL",@"QBX":@"QBX",@"TRI":@"TRI",@"TBX":@"TBX",@"DBL":@"DBL",@"PK3":@"PK3",@"PK4":@"PK4",@"PK5":@"PK5",@"PK6":@"PK6",@"PK7":@"PK7",@"PK8":@"PK8",@"PK9":@"PK9",@"PK10":@"P10",@"PK11":@"P11",@"PK12":@"P12",@"PK13":@"P13",@"PK14":@"P14",@"PK15":@"P15",@"PK16":@"P16",@"TQN":@"TQN",@"TQX":@"TQX",@"DQL":@"DQL",@"DQX":@"DQX",@"DEX1":@"DEX_1",@"DEX2":@"DEX_2",@"CH6":@"CH_6",@"E5N":@"E_5_N",@"E5B":@"E_5_B",@"P10":@"P10",@"QPT":@"QPT",@"PLP":@"PLP",@"JPT":@"JPT",@"SP7":@"SP7",@"SFB":@"SFB",@"PEB":@"PEB",@"SWB":@"SWB",@"SC6":@"SC6",@"SWI":@"SWI",@"SWB":@"SWB"};

}

+(NSString*) getBetTypeIdFromString:(NSString*) typeId{
    
    NSString * betTypeId = [betTypeMappings objectForKey:typeId];
    if( betTypeId == nil && [betTypeId length] <= 0){
        return typeId;
    }
    return betTypeId;
}

+(int) getNumCombos:(ZLWager*) _wager{

    int legs_count = (int)[_wager.selectedRunners count];
    
    
    NSMutableArray * legs = [NSMutableArray array];
    
    for( NSString * _key in _wager.selectedRunners){
        
        NSMutableArray * _arr = [_wager.selectedRunners objectForKey:_key];
        if(_arr)
            [legs addObject:_arr];
    }

    
    if( [_wager.selectedBetType isEqualToString:(@"EBX")] || [_wager.selectedBetType isEqualToString:(@"34")] || [_wager.selectedBetType isEqualToString:(@"TBX")] || [_wager.selectedBetType isEqualToString:(@"32")] ||[_wager.selectedBetType isEqualToString:(@"38")] || [_wager.selectedBetType isEqualToString:(@"SFX")] || [_wager.selectedBetType isEqualToString:(@"SPX")] ||[_wager.selectedBetType isEqualToString:(@"40")] || [_wager.selectedBetType isEqualToString:(@"46")]){
        NSMutableArray * newLegs = [NSMutableArray array];
        NSMutableArray * firstLeg = [NSMutableArray array];
        for( NSArray * array in legs){
            for( NSString * runnerNumber in array){
                if( [firstLeg indexOfObject:runnerNumber] == NSNotFound)
                    [firstLeg addObject:runnerNumber];
            }
        }
        [newLegs addObject:firstLeg];
        legs = newLegs;
    }
    
    int numLegs = 0;
    for( int i=0;i<[legs count];i++){
        
        NSArray * _runners = [legs objectAtIndex:i];
        
        if( i == 0 && [_runners count] == 0){
            numLegs++;
            break;
        }
        else if ( [_runners count] > 0 ){
            numLegs++;
        }
    }
    
    if ( numLegs == 0 ) numLegs = legs_count;
    
	if ( numLegs < 1 )
	{
    	return 0;
    }
    
    int numCombos 	= 0;
    int	leg 		= 0;
    int bitMap0 = [ZLWagerUtility convertToBitmap:legs forLeg:0];
    NSLog(@"bitMap0 %d",bitMap0);

    if( [_wager.selectedBetType isEqualToString:(@"WIN")] || [_wager.selectedBetType isEqualToString:(@"PLC")] ||[_wager.selectedBetType isEqualToString:(@"SHW")] ){
        numCombos = [ZLWagerUtility count:bitMap0];
    }
    else if( [_wager.selectedBetType isEqualToString:(@"WS")] || [_wager.selectedBetType isEqualToString:(@"PS")] ||[_wager.selectedBetType isEqualToString:(@"EW")] ){
        numCombos = 2 * [ZLWagerUtility count:bitMap0];
    }
    else if( [_wager.selectedBetType isEqualToString:(@"WPS")]){
        numCombos = 3 * [ZLWagerUtility count:bitMap0];
    }
    else if( [_wager.selectedBetType isEqualToString:(@"EXA")] || [_wager.selectedBetType isEqualToString:(@"33")] ){
        
        NSLog(@"legs==== %@",legs);
        
        NSLog(@"bitMap0 %d",bitMap0);
        
        NSLog(@"[ZLWagerUtility count:bitMap0] %d",[ZLWagerUtility count:bitMap0]);
        
        NSLog(@"[ZLWagerUtility count: [ZLWagerUtility convertToBitmap:legs forLeg:1] ] %d",[ZLWagerUtility count: [ZLWagerUtility convertToBitmap:legs forLeg:1] ]);

        
        int idx = [ZLWagerUtility getBetId:_wager.selectedBetType];
        
        if (numLegs == [[num_leg_map objectAtIndex:idx ] intValue]){
            
            int _temp = bitMap0 & [ZLWagerUtility convertToBitmap:legs forLeg:1];
            
	    	numCombos = ( [ZLWagerUtility count:bitMap0] * [ZLWagerUtility count: [ZLWagerUtility convertToBitmap:legs forLeg:1] ] ) - [ZLWagerUtility count:_temp];
        }
    }
    
    else if( [_wager.selectedBetType isEqualToString:(@"SWI")]){
        
        
        
        int idx = [ZLWagerUtility getBetId:_wager.selectedBetType];
        
        if (numLegs == [[num_leg_map objectAtIndex:idx ] intValue]){
            
            int _temp = bitMap0 & [ZLWagerUtility convertToBitmap:legs forLeg:1];
            
            numCombos = ( [ZLWagerUtility count:bitMap0] * [ZLWagerUtility count: [ZLWagerUtility convertToBitmap:legs forLeg:1] ] ) - [ZLWagerUtility count:_temp];
        }
    }
    
    //Veeru
    /*
    else if( [_wager.selectedBetType isEqualToString:(@"EXB")] || [_wager.selectedBetType isEqualToString:(@"33")] ){
        int idx = [ZLWagerUtility getBetId:_wager.selectedBetType];
        if (numLegs == [[num_leg_map objectAtIndex:idx ] intValue]){
            int _temp = bitMap0 & [ZLWagerUtility convertToBitmap:legs forLeg:1];
            numCombos = ( [ZLWagerUtility count:bitMap0] * [ZLWagerUtility count: [ZLWagerUtility convertToBitmap:legs forLeg:1] ] ) - [ZLWagerUtility count:_temp];
        }
    }*/
    else if( [_wager.selectedBetType isEqualToString:(@"EBX")] || [_wager.selectedBetType isEqualToString:(@"34")]){
        if ( numLegs == 1) {
	    	numCombos = [ZLWagerUtility count: bitMap0 ] * ( [ZLWagerUtility count:bitMap0 ] - 1 );
            //deal with entry
		}
        else {
            int idx = [ZLWagerUtility getBetId:_wager.selectedBetType];
		    if ( numLegs == [[num_leg_map objectAtIndex:idx ] intValue] ){
                int _temp = bitMap0 & [ZLWagerUtility convertToBitmap:legs forLeg:1];
                numCombos = ( [ZLWagerUtility count:bitMap0] * [ZLWagerUtility count: [ZLWagerUtility convertToBitmap:legs forLeg:1] ] ) - [ZLWagerUtility count:_temp];
				numCombos *= 2;
	    	}
		}
    }
    else if( [_wager.selectedBetType isEqualToString:(@"QNL")] || [_wager.selectedBetType isEqualToString:(@"23")] ||[_wager.selectedBetType isEqualToString:(@"47")] ){
        int idx = [ZLWagerUtility getBetId:_wager.selectedBetType];

        if ( numLegs == [[num_leg_map objectAtIndex:idx ] intValue] ){
            int _temp = bitMap0 & [ZLWagerUtility convertToBitmap:legs forLeg:1];
            numCombos = ( [ZLWagerUtility count:bitMap0] * [ZLWagerUtility count: [ZLWagerUtility convertToBitmap:legs forLeg:1] ]) - (( [ZLWagerUtility count:_temp] * ([ZLWagerUtility count:_temp] + 1 ) ) / 2.0 );
        }
    }
    else if( [_wager.selectedBetType isEqualToString:(@"QBX")]){
        if ( numLegs == 1 ) {
            if ( [ZLWagerUtility count:bitMap0] >= 3 ) {
                numCombos = ( [ZLWagerUtility count:bitMap0] * ( [ZLWagerUtility count:bitMap0] - 1 ) ) / 2.0;
            }
        }
    }
    else if( [_wager.selectedBetType isEqualToString:(@"24")] || [_wager.selectedBetType isEqualToString:(@"48")]){
        if ( numLegs == 1 ) {
            if ( [ZLWagerUtility count:bitMap0] > 2 ) {
                numCombos = ( [ZLWagerUtility count:bitMap0] * ( [ZLWagerUtility count:bitMap0] - 1 ) ) / 2.0;
            }
        }
    }
    else if( [_wager.selectedBetType isEqualToString:(@"DBL")] || [_wager.selectedBetType isEqualToString:(@"PK3")] || [_wager.selectedBetType isEqualToString:(@"PK4")] || [_wager.selectedBetType isEqualToString:(@"PK5")] || [_wager.selectedBetType isEqualToString:(@"PK6")] || [_wager.selectedBetType isEqualToString:(@"PK7")] || [_wager.selectedBetType isEqualToString:(@"PK8")] || [_wager.selectedBetType isEqualToString:(@"PK9")] || [_wager.selectedBetType isEqualToString:(@"P10")] || [_wager.selectedBetType isEqualToString:(@"123")] ||[_wager.selectedBetType isEqualToString:(@"QPT")]||[_wager.selectedBetType isEqualToString:(@"PLP")]||[_wager.selectedBetType isEqualToString:(@"JPT")]||[_wager.selectedBetType isEqualToString:(@"SP7")]||[_wager.selectedBetType isEqualToString:(@"SC6")])
    {
        int idx = [ZLWagerUtility getBetId:_wager.selectedBetType];
        if ( numLegs == [[num_leg_map objectAtIndex:idx ] intValue] ){
            
            numCombos = 1;
		    
		    for(leg=0; leg<numLegs; leg++){
                int _temp = [ZLWagerUtility convertToBitmap:legs forLeg:leg];
                numCombos *= [ZLWagerUtility count:_temp];
			}
        }
    }
    else if( [_wager.selectedBetType isEqualToString:(@"TRI")] || [_wager.selectedBetType isEqualToString:(@"31")] ||[_wager.selectedBetType isEqualToString:(@"37")] ){
        int idx = [ZLWagerUtility getBetId:_wager.selectedBetType];
        if ( numLegs == [[num_leg_map objectAtIndex:idx ] intValue] ){
		    numCombos = [ZLWagerUtility tri_bet:bitMap0 withMap2:[ZLWagerUtility convertToBitmap:legs forLeg:1] andMap3:[ZLWagerUtility convertToBitmap:legs forLeg:2]];
        }
    }
    //Veeru TRB
    else if( [_wager.selectedBetType isEqualToString:(@"EXB")]||[_wager.selectedBetType isEqualToString:(@"TRB")] || [_wager.selectedBetType isEqualToString:(@"SFB")]||[_wager.selectedBetType isEqualToString:(@"PEB")]||[_wager.selectedBetType isEqualToString:(@"SWB")]){
        
        
        
        NSLog(@"legs==== %@",legs);
        
        NSLog(@"bitMap0 %d",bitMap0);
        
        NSLog(@"[ZLWagerUtility count:bitMap0] %d",[ZLWagerUtility count:bitMap0]);
        
        
        int req_selection;
        req_selection = -1;
        //Exacta-Banker
        if ([_wager.selectedBetType isEqualToString:(@"EXB")]){
            req_selection = 2;
        }else if([_wager.selectedBetType isEqualToString:(@"TRB")]){//Tri-Banker
            req_selection = 3;

        }
        else if([_wager.selectedBetType isEqualToString:(@"SFB")]){//Superfact-Banker
            req_selection = 4;
            
        }else if([_wager.selectedBetType isEqualToString:(@"PEB")]){//Pentafact-Banker
            req_selection = 5;
            
        }else if([_wager.selectedBetType isEqualToString:(@"SWB")]){//Swinger-Banker
            req_selection = 2;
            
        }
        BOOL isBK = NO;
        BOOL isOT = NO;
        int idx = [ZLWagerUtility getBetId:_wager.selectedBetType];
        
        
//        if (numLegs == [[num_leg_map objectAtIndex:idx ] intValue]){
           // int _temp = bitMap0 & [ZLWagerUtility convertToBitmap:legs forLeg:1];
        int _temp =  [ZLWagerUtility count:(bitMap0 & [ZLWagerUtility convertToBitmap:legs forLeg:1])];
        NSLog(@"_temp %d",_temp);
            
            isBK = [ZLWagerUtility selectionBK:req_selection legs:legs];
            isOT = [ZLWagerUtility selectionOT:req_selection duplicates:_temp legs:legs];
            
            if (isBK == YES && isOT == YES){
                for (int i =0; i<(totalSelectionOfOT-_temp);i++){
                    int localCombos = 1;
                    for (int k=1; k<=req_selection; k++) {
                        localCombos = localCombos*k;
                    }
                    //numCombos = numCombos+localCombos;
                    if([_wager.selectedBetType isEqualToString:(@"SWB")]){
                        numCombos = numCombos+localCombos/2;
                        
                    }else{
                        numCombos = numCombos+localCombos;
                        
                    }
                    
                }
                
            }
            

        //}

        
        
        
    }

    else if( [_wager.selectedBetType isEqualToString:(@"TBX")] || [_wager.selectedBetType isEqualToString:(@"32")] ||[_wager.selectedBetType isEqualToString:(@"38")] ){
        if(numLegs == 1) {
		    if ( [ZLWagerUtility count:bitMap0] > 2 ) {
                numCombos = ( [ZLWagerUtility count:bitMap0] ) * ( [ZLWagerUtility count:bitMap0] - 1) * ( [ZLWagerUtility count:bitMap0] - 2);
            }
		} else {
            int idx = [ZLWagerUtility getBetId:_wager.selectedBetType];
            if ( numLegs == [[num_leg_map objectAtIndex:idx ] intValue] ){
                numCombos = [ZLWagerUtility tri_bet:bitMap0 withMap2:[ZLWagerUtility convertToBitmap:legs forLeg:1] andMap3:[ZLWagerUtility convertToBitmap:legs forLeg:2]];
                numCombos *=6;

		    }
		}        
    }
    else if( [_wager.selectedBetType isEqualToString:(@"SFC")] || [_wager.selectedBetType isEqualToString:(@"SPR")] ||[_wager.selectedBetType isEqualToString:(@"39")] || [_wager.selectedBetType isEqualToString:(@"45")] ){
        if ( numLegs == [[num_leg_map objectAtIndex:[ZLWagerUtility getBetId:_wager.selectedBetType] ] intValue] ){
            numCombos = [ZLWagerUtility sup_bet:0 withMap1:bitMap0 andMap2:[ZLWagerUtility convertToBitmap:legs forLeg:1] andMap3:[ZLWagerUtility convertToBitmap:legs forLeg:2] andMap4:[ZLWagerUtility convertToBitmap:legs forLeg:3]];
        }
    }
    else if( [_wager.selectedBetType isEqualToString:(@"SFX")] || [_wager.selectedBetType isEqualToString:(@"SPX")] ||[_wager.selectedBetType isEqualToString:(@"40")] || [_wager.selectedBetType isEqualToString:(@"46")] ){
        
        if (numLegs == 1) {
		    if ( [ZLWagerUtility count:bitMap0] > 3 ){
                numCombos = ( [ZLWagerUtility count:bitMap0] ) * ( [ZLWagerUtility count:bitMap0] - 1) * ( [ZLWagerUtility count:bitMap0] - 2 ) * ( [ZLWagerUtility count:bitMap0] - 2 );
                NSLog(@"SFX numCombos1 %d",numCombos);
                
            }
		}
        else {
		    if ( numLegs == [[num_leg_map objectAtIndex:[ZLWagerUtility getBetId:_wager.selectedBetType] ] intValue] ){
                
                numCombos = [ZLWagerUtility sup_bet:0 withMap1:bitMap0 andMap2:[ZLWagerUtility convertToBitmap:legs forLeg:1] andMap3:[ZLWagerUtility convertToBitmap:legs forLeg:2] andMap4:[ZLWagerUtility convertToBitmap:legs forLeg:3]];
                NSLog(@"SFX numCombos2 %d",numCombos);

				numCombos *=24;
                
            }
		}
    }
    //Veeru
    /*
    else if( [_wager.selectedBetType isEqualToString:(@"SFB")]||[_wager.selectedBetType isEqualToString:(@"41")] || [_wager.selectedBetType isEqualToString:(@"47")] ){
        
        if (numLegs == 1) {
            if ( [ZLWagerUtility count:bitMap0] > 3 ){
                numCombos = ( [ZLWagerUtility count:bitMap0] ) * ( [ZLWagerUtility count:bitMap0] - 1) * ( [ZLWagerUtility count:bitMap0] - 2 ) * ( [ZLWagerUtility count:bitMap0] - 3 );
                NSLog(@"SFB numCombos1 %d",numCombos);

            }
        }
        else {
            if ( numLegs == [[num_leg_map objectAtIndex:[ZLWagerUtility getBetId:_wager.selectedBetType] ] intValue] ){
                
                numCombos = [ZLWagerUtility sup_bet:0 withMap1:bitMap0 andMap2:[ZLWagerUtility convertToBitmap:legs forLeg:1] andMap3:[ZLWagerUtility convertToBitmap:legs forLeg:2] andMap4:[ZLWagerUtility convertToBitmap:legs forLeg:3]];
                NSLog(@"SFB numCombos2 %d",numCombos);
                numCombos *=24;
            }
        }
    }*/
    
    
    else if( [_wager.selectedBetType isEqualToString:(@"25")] || [_wager.selectedBetType isEqualToString:(@"26")] ){
        numCombos = 0;
    }
    else if( [_wager.selectedBetType isEqualToString:(@"27")] || [_wager.selectedBetType isEqualToString:(@"30")] ){ //dex, deb
        numCombos = 0;
    }
    else if( [_wager.selectedBetType isEqualToString:(@"PEN")] || [_wager.selectedBetType isEqualToString:(@"E5N")] ||[_wager.selectedBetType isEqualToString:(@"HI5")] ){ //PEB
        numCombos = [self e5n_count:bitMap0 withMap2:[ZLWagerUtility convertToBitmap:legs forLeg:1] andMap3:[ZLWagerUtility convertToBitmap:legs forLeg:2] andMap4:[ZLWagerUtility convertToBitmap:legs forLeg:3] andMap5:[ZLWagerUtility convertToBitmap:legs forLeg:4]];
    }
    else if( [_wager.selectedBetType isEqualToString:(@"PEX")] || [_wager.selectedBetType isEqualToString:(@"PBX")] || [_wager.selectedBetType isEqualToString:(@"PFX")] ){ //PEX
        numCombos = 0;
        if (numLegs == 1) {
		    if ( [ZLWagerUtility count:bitMap0] > 4)
                numCombos = ( [ZLWagerUtility count:bitMap0] ) * ( [ZLWagerUtility count:bitMap0] - 1 ) * ( [ZLWagerUtility count:bitMap0] - 2 ) * ( [ZLWagerUtility count:bitMap0] - 3 ) * ([ZLWagerUtility count:bitMap0] - 4 );
		} else {
		    if ( numLegs == [[num_leg_map objectAtIndex:[ZLWagerUtility getBetId:_wager.selectedBetType] ] intValue] ){
				numCombos = [self e5n_count:bitMap0 withMap2:[ZLWagerUtility convertToBitmap:legs forLeg:1] andMap3:[ZLWagerUtility convertToBitmap:legs forLeg:2] andMap4:[ZLWagerUtility convertToBitmap:legs forLeg:3] andMap5:[ZLWagerUtility convertToBitmap:legs forLeg:4]];
				numCombos *=120;
		    }
		}
    }
    
    return numCombos;
}
+ (BOOL)selectionBK:(int)req_selection legs:(NSArray *)legs
{
    int _temp = [ZLWagerUtility count: [ZLWagerUtility convertToBitmap:legs forLeg:0] ];
    if (_temp <= (req_selection-1)&&_temp>0){
        totalSelectionOfBK = _temp;
        return YES;

    }

    return NO;
}
+ (BOOL)selectionOT:(int)req_Min_Selection duplicates:(int)duplicates legs:(NSArray *)legs
{
    int _temp = [ZLWagerUtility count: [ZLWagerUtility convertToBitmap:legs forLeg:1] ];
    
    
    if (_temp >= req_Min_Selection-totalSelectionOfBK+duplicates){
        
        totalSelectionOfOT = _temp;
        return YES;


    }
    return NO;

    
}

+(int) tri_bet:(int)map1 withMap2:(int) map2 andMap3:(int) map3 {
    int numCombos = 0;
    numCombos = ( [ZLWagerUtility count:map1] * [ZLWagerUtility count:map2] * [ZLWagerUtility count:map3]) -
    ( [ZLWagerUtility count:(map1 & map2)] * [ZLWagerUtility count:map3] ) -
    ( [ZLWagerUtility count:(map1 & map3)] * [ZLWagerUtility count:map2] ) -
    ( [ZLWagerUtility count:(map2 & map3)] * [ZLWagerUtility count:map1]) +
    ( 2 * [ZLWagerUtility count:(map1 & map2 & map3)]);
    return numCombos;
}

+(int) sup_bet:(int)legs withMap1:(int) map1 andMap2:(int) map2 andMap3:(int) map3 andMap4:(int) map4 {
	
	int numCombos = 0;
    
	for(int i=1; i<=32; i++)
	{
		if( ( map1 >>i ) & 1 ){
            
			int hideMe	= ( map1 | map2 | map3 | map4 ) - ( 1 << i );
			int use2	= map2 & hideMe;
			int use3	= map3 & hideMe;
			int use4	= map4 & hideMe;
			numCombos += [ZLWagerUtility tri_bet:use2 withMap2:use3 andMap3:use4];
		}
	}
    
    return numCombos;
}

+(int) e5n_count:(int) m1 withMap2:(int) m2 andMap3:(int) m3 andMap4:(int) m4 andMap5:(int) m5 {
    
	int numCombos = 0;
    
	int r1 = [ZLWagerUtility count:m1];
	int r2 = [ZLWagerUtility count:m2];
	int r3 = [ZLWagerUtility count:m3];
	int r4 = [ZLWagerUtility count:m4];
	int r5 = [ZLWagerUtility count:m5];
    
	int dup45 = [ZLWagerUtility count:(m4 & m5)];
	int dup35 = [ZLWagerUtility count:(m3 & m5)];
	int dup25 = [ZLWagerUtility count:(m2 & m5)];
	int dup15 = [ZLWagerUtility count:(m1 & m5)];
	int dup34 = [ZLWagerUtility count:(m3 & m4)];
	int dup24 = [ZLWagerUtility count:(m2 & m4)];
	int dup14 = [ZLWagerUtility count:(m1 & m4)];
	int dup23 = [ZLWagerUtility count:(m2 & m3)];
	int dup13 = [ZLWagerUtility count:(m1 & m3)];
	int dup12 = [ZLWagerUtility count:(m1 & m2)];
	int dup345 = [ZLWagerUtility count:(m3 & (m4 & m5))];
	int dup245 = [ZLWagerUtility count:(m2 & (m4 & m5))];
	int dup145 = [ZLWagerUtility count:(m1 & (m4 & m5))];
	int dup235 = [ZLWagerUtility count:(m2 & (m3 & m5))];
	int dup135 = [ZLWagerUtility count:(m1 & (m3 & m5))];
	int dup125 = [ZLWagerUtility count:(m1 & (m2 & m5))];
	int dup234 = [ZLWagerUtility count:(m2 & (m3 & m4))];
	int dup134 = [ZLWagerUtility count:(m1 & (m3 & m4))];
	int dup124 = [ZLWagerUtility count:(m1 & (m2 & m4))];
	int dup123 = [ZLWagerUtility count:(m1 & (m2 & m3))];
    
	int dup2345 = [ZLWagerUtility count:((m2&m3) & (m4&m5))];
	int dup1345 = [ZLWagerUtility count:((m1&m3) & (m4&m5))];
	int dup1245 = [ZLWagerUtility count:((m1&m2) & (m4&m5))];
	int dup1235 = [ZLWagerUtility count:( (m1&m2) & (m3&m5) )];
	int dup1234 = [ZLWagerUtility count:((m1&m2) & (m3&m4))];
    
	int dup12345 = [ZLWagerUtility count:(m1 & ( (m2&m3) & (m4&m5) ) )];
    
	numCombos = (r1 * r2 * r3 * r4 * r5) -
    (r1 * r2 * r3 * dup45) -
    (r1 * r2 * r4 * dup35) -
    (r1 * r3 * r4 * dup25) -
    (r2 * r3 * r4 * dup15) -
    (r1 * r2 * r5 * dup34) -
    (r1 * r3 * r5 * dup24) -
    (r2 * r3 * r5 * dup14) -
    (r1 * r4 * r5 * dup23) -
    (r2 * r4 * r5 * dup13) -
    (r3 * r4 * r5 * dup12) +
    (r1 * dup23 * dup45) +
    (r2 * dup13 * dup45) +
    (r3 * dup12 * dup45) +
    (r1 * dup24 * dup35) +
    (r2 * dup14 * dup35) +
    (r4 * dup12 * dup35) +
    (r3 * dup14 * dup25) +
    (r4 * dup13 * dup25) +
    (r1 * dup25 * dup34) +
    (r2 * dup15 * dup34) +
    (r5 * dup12 * dup34) +
    (r3 * dup15 * dup24) +
    (r5 * dup13 * dup24) +
    (r4 * dup15 * dup23) +
    (r5 * dup14 * dup23) -
    (2 * dup12 * dup345) -
    (2 * dup13 * dup245) -
    (2 * dup14 * dup235) -
    (2 * dup15 * dup234) -
    (2 * dup23 * dup145) -
    (2 * dup24 * dup135) -
    (2 * dup25 * dup134) -
    (2 * dup34 * dup125) -
    (2 * dup35 * dup124) -
    (2 * dup45 * dup123) +
    (2 * r1 * r2 * dup345) +
    (2 * r1 * r3 * dup245) +
    (2 * r2 * r3 * dup145) +
    (2 * r1 * r4 * dup235) +
    (2 * r2 * r4 * dup135) +
    (2 * r3 * r4 * dup125) +
    (2 * r1 * r5 * dup234) +
    (2 * r2 * r5 * dup134) +
    (2 * r3 * r5 * dup124) +
    (2 * r4 * r5 * dup123) -
    (6 * r1 * dup2345) -
    (6 * r2 * dup1345) -
    (6 * r3 * dup1245) -
    (6 * r4 * dup1235) -
    (6 * r5 * dup1234) +
    (24 * dup12345);
    
	return numCombos;
}

+(int) count:(int)piBitmap
{
	int count = 0;
    
	for(int i=0; i<32; i++)
	{
		int bit = 1<<i;
		count += (bit & piBitmap) !=0;
	}
	return count;
}

+(int) getBetId:(NSString*) psBetID{
    
    SWITCH(psBetID) {
        CASE(@"WIN"){return 1;}
        CASE(@"PLC"){return 2;}
        CASE(@"SHW"){return 3;}
        CASE(@"EW"){return 4;}
        CASE(@"WPS"){return 5;}
        CASE(@"WS"){return 6;}
        CASE(@"PS"){return 7;}
        CASE(@"EXA"){return 8;}

        CASE(@"PER"){return 8;}

        CASE(@"EBX"){return 9;}
        CASE(@"PBX"){return 9;}
        CASE(@"QNL"){return 10;}
        CASE(@"QBX"){return 11;}
        CASE(@"TRI"){return 12;}

        CASE(@"TBX"){return 13;}


        CASE(@"DBL"){return 14;}
        CASE(@"PK3"){return 15;}
        CASE(@"PK4"){return 16;}
        CASE(@"QPT"){return 16;}//Veeru

        CASE(@"PK5"){return 17;}
        CASE(@"PK6"){return 18;}
        CASE(@"PLP"){return 18;}
        CASE(@"JPT"){return 18;}

        CASE(@"PK7"){return 19;}
        CASE(@"SP7"){return 19;}

        CASE(@"PK8"){return 20;}
        CASE(@"PK9"){return 21;}
        CASE(@"P10"){return 22;}
        CASE(@"SPR"){return 34;}
        CASE(@"SFC"){return 34;}
        CASE(@"SPX"){return 35;}
        CASE(@"SFX"){return 35;}


        CASE(@"CH6"){return 50;}
        CASE(@"PEN"){return 51;}
        CASE(@"PEX"){return 52;}
        CASE(@"PEX"){return 52;}
        CASE(@"PEB"){return 1;}//Veeru
        CASE(@"SWB"){return 1;}
        CASE(@"TRB"){return 1;}
        CASE(@"EXB"){return 1;}
        CASE(@"SWB"){return 1;}
        CASE(@"SWI"){return 8;}


        CASE(@"SFB"){return 9;}
        CASE(@"SC6"){return 18;}



        CASE(@"123"){return 53;}
	}
    
}

+(int) convertToBitmap2:(ZLWager *) _wager forLeg:(int) _leg{
    
    
    NSMutableArray * _arr = [_wager.selectedRunners objectForKey:[NSString stringWithFormat:@"%d", _leg]];
    int retVal = 0;
    if( _arr != nil){
        for( NSString * runnerNumber in _arr){
            int number = [runnerNumber intValue];
            retVal |= (1<<number);
        }
    }
    NSLog(@"retVal %d",retVal);

    return retVal;
}

+(int) convertToBitmap:(NSArray *) _runnersArray forLeg:(int) _leg{
    
    NSLog(@"_runnersArray %@ _leg %d",_runnersArray,_leg);
    NSMutableArray * _arr = [_runnersArray objectAtIndex:_leg];
    int retVal = 0;
    if( _arr != nil){
        for( NSString * runnerNumber in _arr){
            int number = [runnerNumber intValue];
            retVal |= (1<<number);
        }
    }
    NSLog(@"retVal %d",retVal);
    
    return retVal;
}

+(NSArray *) getSelectedRunner:(ZLWager *) _wager forLeg:(int) _leg{
    
    NSMutableArray * _arr = [_wager.selectedRunners objectForKey:[NSString stringWithFormat:@"%d", _leg]];
    if( _arr != nil){
        return _arr;
    }
    
    return [NSArray array];
}

@end
