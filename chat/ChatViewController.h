//
//  ChatViewController.h
//  chat
//
//  Created by Rishit Shroff on 10/29/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "ViewController.h"

@interface ChatViewController : ViewController <UITableViewDataSource, UITableViewDelegate>
- (IBAction)onSend:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *chatMessages;
@property (weak, nonatomic) IBOutlet UITextField *message;

@end

