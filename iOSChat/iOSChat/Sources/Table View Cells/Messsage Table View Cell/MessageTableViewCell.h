//
//  MessageTableViewCell.h
//  iOSChat
//
//  Created by Bogdan on 4/22/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel * senderNameLabel;
@property (retain, nonatomic) IBOutlet UILabel * dateLabel;
@property (retain, nonatomic) IBOutlet UILabel * messageLabel;

@end
