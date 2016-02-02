//
//  SPQuestionsCell.m
//  WarHorse
//
//  Created by sekhar on 22/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "SPQuestionsCell.h"

@implementation SPQuestionsCell
@synthesize qusLbl,redioBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)redioBtnAction:(id)sender
{
    if ([sender isSelected]) {
        
        [sender setSelected:NO];
    }
    else{
        [sender setSelected:YES];
    }
}

@end
