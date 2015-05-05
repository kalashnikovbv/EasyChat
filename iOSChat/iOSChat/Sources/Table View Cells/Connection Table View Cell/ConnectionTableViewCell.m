//
//  ConnectionTableViewCell.m
//  iOSChat
//
//  Created by Bogdan on 4/22/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import "ConnectionTableViewCell.h"

@implementation ConnectionTableViewCell

- (void) awakeFromNib
{
    // Initialization code
}

- (void) setSelected: (BOOL) selected animated: (BOOL) animated
{
    [super setSelected: selected animated: animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_peerNameLabel release];
    [_peerStatusLabel release];
    [super dealloc];
}
@end
