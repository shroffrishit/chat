//
//  ChatViewController.m
//  chat
//
//  Created by Rishit Shroff on 10/29/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "MessageCell.h"

@interface ChatViewController ()
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) NSArray* messages;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.chatMessages.delegate = self;
    self.chatMessages.dataSource = self;
    [self.chatMessages registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];
    NSLog(@"Initializing timer");
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshMessages) userInfo:nil repeats:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell* cell = [self.chatMessages dequeueReusableCellWithIdentifier:@"MessageCell"];
    
    NSDictionary *messageData = self.messages[indexPath.row];
    
    [cell.messageText setText:messageData[@"text"]];
    PFUser *user = messageData[@"user"];
    
    if (user != nil && user.username != nil) {
        [cell.userName setText:[NSString stringWithFormat:@"%@:", user.username]];
    } else {
        [cell.userName setText:@""];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query orderByAscending:@"createdAt"];
    [query includeKey:@"user"];
    
    // [query whereKey:@"username" equalTo:@"Dan Stemkoski"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > self.messages.count) {
                self.messages = objects;
                [self.chatMessages reloadData];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSend:(id)sender {
    
    PFObject *message = [PFObject objectWithClassName:@"Message"];
    message[@"text"] = self.message.text;
    message[@"user"] = [PFUser currentUser];
    
    [message saveInBackgroundWithBlock:
     ^(BOOL succeeded, NSError *error) {}];
    [self.message setText:@""];
}
@end
