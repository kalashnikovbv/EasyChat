//
//  MessageTableViewCell.m
//  iOSChat
//
//  Created by Bogdan on 4/22/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

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
    [_senderNameLabel release];
    [_dateLabel release];
    [_messageLabel release];
    
    [super dealloc];
}
@end
