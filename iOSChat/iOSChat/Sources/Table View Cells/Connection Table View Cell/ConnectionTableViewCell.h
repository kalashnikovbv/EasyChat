//
//  ConnectionTableViewCell.h
//  iOSChat
//
//  Created by Bogdan on 4/22/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel * peerNameLabel;
@property (retain, nonatomic) IBOutlet UILabel * peerStatusLabel;

@end
