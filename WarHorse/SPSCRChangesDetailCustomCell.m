//
//  SPSCRChangesDetailCustomCell.m
//  WarHorse
//
//  Created by Enterpi on 23/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPSCRChangesDetailCustomCell.h"
#import "SPSCRChangesDetail.h"

@interface SPSCRChangesDetailCustomCell ()

@property (strong, nonatomic) IBOutlet UILabel *raceNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *raceChangeDescriptionLabel;

@end

@implementation SPSCRChangesDetailCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    
}

#pragma mark - Private API

- (CGFloat)calculateHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *changesString = @"";
    
    for (int i = 0; i < [self.scrChangesDetail.changesArray count]; i++) {
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"JockeyChange"] isEqualToString:@""])) {
            
                changesString  = [NSString stringWithFormat:@"%@ %@ - JockeyChange - %@",(![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"] ,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"JockeyChange"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"WeightChange"] isEqualToString:@""])) {
            
                changesString  = [NSString stringWithFormat:@"%@ %@ - WeightChange - %@",(![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"],[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"WeightChange"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"BlinkersChange"] isEqualToString:@""])) {
            
                changesString = [NSString stringWithFormat:@"%@ %@", (![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"BlinkersChange"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"ScratchedChange"] isEqualToString:@""])) {
            
                changesString = [NSString stringWithFormat:@"%@ %@ - Scratched", (![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"MedicationChange"] isEqualToString:@""])) {
            
                changesString = [NSString stringWithFormat:@"%@ %@ - MedicationChange - %@", (![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"],[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"MedicationChange"]];
            
        }
        /*
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"Sex"] isEqualToString:@""])) {
            
                changesString = [NSString stringWithFormat:@"%@ %@ - SexChange - %@", (![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"],[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"SexChange"]];
            
        }*/
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"NasalStripChange"] isEqualToString:@""])) {
            
                changesString = [NSString stringWithFormat:@"%@ %@ - NasalStrip On", (![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"FrontShoesChange"] isEqualToString:@""])) {
            
                changesString = [NSString stringWithFormat:@"%@ %@ - FrontShoesChange - %@",(![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"], [[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"FrontShoesChange"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"RearShoesChange"] isEqualToString:@""])) {
            
            if (![changesString isEqualToString:@""]) {
                changesString = [NSString stringWithFormat:@"%@ \n %@ - RearShoesChange - %@", changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"],[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"RearShoesChange"]];
            }
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"GeneralChange"] isEqualToString:@""])) {
            
            if (![changesString isEqualToString:@""]) {
                changesString = [NSString stringWithFormat:@"%@ \n %@ - GeneralChange - %@", changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"],[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"GeneralChange"]];
                //NSLog(@"changesString %@",changesString);
            }
            
        }
        
    }
    
    
    [self.raceChangeDescriptionLabel  setFont:[UIFont fontWithName:@"Roboto-Light" size:13.0]];
    self.raceChangeDescriptionLabel.numberOfLines = 10;
        
    [self.raceChangeDescriptionLabel setText:changesString];
    self.raceChangeDescriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;

    CGSize maximumRaceChangeDescriptionLabelSize = CGSizeMake(231,9999);
    
    CGSize expectedRaceChangeDescriptionLabelSize = [self.raceChangeDescriptionLabel.text sizeWithFont:self.raceChangeDescriptionLabel.font constrainedToSize:maximumRaceChangeDescriptionLabelSize lineBreakMode:self.raceChangeDescriptionLabel.lineBreakMode];
    
    /*
     
    CGSize expectedRaceChangeDescriptionLabelSize =  [self.raceChangeDescriptionLabel.text boundingRectWithSize: maximumRaceChangeDescriptionLabelSize options: NSStringDrawingUsesLineFragmentOrigin
                                                                attributes: @{ NSFontAttributeName: self.raceChangeDescriptionLabel.font } context: nil].size;
     */
    
    //adjust the label the the new height.
    CGRect raceChangeDescriptionLabelNewFrame = self.raceChangeDescriptionLabel.frame;
    raceChangeDescriptionLabelNewFrame.size.height = expectedRaceChangeDescriptionLabelSize.height;
    self.raceChangeDescriptionLabel.frame = raceChangeDescriptionLabelNewFrame;

    return self.raceChangeDescriptionLabel.frame.origin.y + self.raceChangeDescriptionLabel.frame.size.height+30;
}

- (void)updateViewAtIndexPath:(NSIndexPath *) indexPath
{
    
    if (indexPath.row % 2 != 0) {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:235.0/255.0f green:234.0/255.0f blue:234/255.0f alpha:1.0]];
    }
    else
    {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0f alpha:1.0]];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [self.raceNumberLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.raceNumberLabel setTextColor:[UIColor colorWithRed:4.0/255.0f green:4.0/255.0f blue:4.0f/255.0f alpha:1.0]];
    self.raceNumberLabel.text = [NSString stringWithFormat:@"Race %@", self.scrChangesDetail.race];
    [self.raceNumberLabel setTextAlignment:NSTextAlignmentLeft];
    
    CGSize maximumRaceNumberLabelSize = CGSizeMake(299,9999);
    
    CGSize expectedRaceNumberLabelSize = [self.raceNumberLabel.text sizeWithFont:self.raceNumberLabel.font constrainedToSize:maximumRaceNumberLabelSize lineBreakMode:self.raceNumberLabel.lineBreakMode];
    /*
    CGSize expectedRaceNumberLabelSize =  [self.raceNumberLabel.text boundingRectWithSize: maximumRaceNumberLabelSize options: NSStringDrawingUsesLineFragmentOrigin
                                                                                                     attributes: @{ NSFontAttributeName: self.raceNumberLabel.font } context: nil].size;
     */


    NSString *changesString = @"";
    
    
    for (int i = 0; i < [self.scrChangesDetail.changesArray count]; i++) {
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"JockeyChange"] isEqualToString:@""])) {
            
            changesString  = [NSString stringWithFormat:@"%@ %@ - JockeyChange - %@",(![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"] ,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"JockeyChange"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"WeightChange"] isEqualToString:@""])) {
            
            changesString  = [NSString stringWithFormat:@"%@ %@ - WeightChange - %@",(![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"],[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"WeightChange"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"BlinkersChange"] isEqualToString:@""])) {
            
            changesString = [NSString stringWithFormat:@"%@ %@", (![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"BlinkersChange"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"ScratchedChange"] isEqualToString:@""])) {
            
            changesString = [NSString stringWithFormat:@"%@ %@ - Scratched", (![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"MedicationChange"] isEqualToString:@""])) {
            
            changesString = [NSString stringWithFormat:@"%@ %@ - MedicationChange - %@", (![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"],[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"MedicationChange"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"SexChange"] isEqualToString:@""])) {
            
            changesString = [NSString stringWithFormat:@"%@ %@ - Sex - %@", (![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"],[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"SexChange"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"NasalStripChange"] isEqualToString:@""])) {
            
            changesString = [NSString stringWithFormat:@"%@ %@ - NasalStrip On", (![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"FrontShoesChange"] isEqualToString:@""])) {
            
            changesString = [NSString stringWithFormat:@"%@ %@ - FrontShoesChange - %@",(![changesString isEqualToString:@""])? [NSString stringWithFormat:@"%@ \n",changesString]:changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"], [[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"FrontShoesChange"]];
            
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"RearShoesChange"] isEqualToString:@""])) {
            
            if (![changesString isEqualToString:@""]) {
                changesString = [NSString stringWithFormat:@"%@ \n %@ - RearShoesChange - %@", changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"],[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"RearShoesChange"]];
            }
        }
        
        if ((![[[self.scrChangesDetail.changesArray objectAtIndex:i] objectForKey:@"GeneralChange"] isEqualToString:@""])) {
            
            if (![changesString isEqualToString:@""]) {
                changesString = [NSString stringWithFormat:@"%@ \n %@ - GeneralChange - %@", changesString,[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"ProgramNumber"],[[self.scrChangesDetail.changesArray objectAtIndex:i] valueForKey:@"GeneralChange"]];
            }
            //NSLog(@"changesString111 %@",changesString);

        }
        
    }
   
    [self.raceChangeDescriptionLabel setText:changesString];
    [self.raceChangeDescriptionLabel  setFont:[UIFont fontWithName:@"Roboto-Light" size:13.0]];
    self.raceChangeDescriptionLabel.numberOfLines = 40;
    
        
    CGSize maximumRaceChangeDescriptionLabelSize = CGSizeMake(231,9999);
    
    //CGSize expectedRaceChangeDescriptionLabelSize = [self.raceChangeDescriptionLabel.text sizeWithFont:self.raceChangeDescriptionLabel.font constrainedToSize:maximumRaceChangeDescriptionLabelSize lineBreakMode:self.raceChangeDescriptionLabel.lineBreakMode];
    
    CGSize expectedRaceChangeDescriptionLabelSize =  [self.raceChangeDescriptionLabel.text boundingRectWithSize: maximumRaceChangeDescriptionLabelSize options: NSStringDrawingUsesLineFragmentOrigin
                                                                               attributes: @{ NSFontAttributeName: self.raceChangeDescriptionLabel.font } context: nil].size;
    
    //CGSize size = [self.raceChangeDescriptionLabel.text textRectForBounds:self.raceChangeDescriptionLabel.frame limitedToNumberOfLines:self.raceChangeDescriptionLabel.numberOfLines].size;


    
    //adjust the label the the new height.
    CGRect raceChangeDescriptionLabelNewFrame = self.raceChangeDescriptionLabel.frame;
    raceChangeDescriptionLabelNewFrame.size.height = expectedRaceChangeDescriptionLabelSize.height+25;
    raceChangeDescriptionLabelNewFrame.size.width = expectedRaceChangeDescriptionLabelSize.width + 15.0f;

    self.raceChangeDescriptionLabel.frame = raceChangeDescriptionLabelNewFrame;
        
    //self.raceChangeDescriptionLabel.backgroundColor = [UIColor redColor];
    //adjust the label the the new height.
    CGRect raceNumberLabelNewFrame = self.raceNumberLabel.frame;
    raceNumberLabelNewFrame.origin.y = (self.raceChangeDescriptionLabel.frame.origin.y + self.raceChangeDescriptionLabel.frame.size.height + 11.5 - self.raceNumberLabel.frame.size.height)/2;
    raceNumberLabelNewFrame.size.width = expectedRaceNumberLabelSize.width + 5.0f;
    self.raceNumberLabel.frame = raceNumberLabelNewFrame;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
