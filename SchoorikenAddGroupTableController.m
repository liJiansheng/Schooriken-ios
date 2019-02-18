//
//  SchoorikenAddGroupsTableController.m
//  Schooriken
//
//  Created by Chin Zhan Xiong on 5/7/14.
//  Copyright (c) 2014 ri. All rights reserved.
//

#import "SchoorikenAddGroupTableController.h"
#import "SchoorikenUser.h"
#import "SchoorikenConstants.h"

@interface SchoorikenAddGroupTableController ()

@end

@implementation SchoorikenAddGroupTableController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadGroups
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groups count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    // Configure the cell...
    NSDictionary * group = [self.groups objectAtIndex:indexPath.row];
    cell.textLabel.text = group[@"group_name"];
    NSNumber * isMem = [self.isMember objectAtIndex:indexPath.row];
    if ([isMem boolValue] == YES) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * group = [self.groups objectAtIndex:indexPath.row];
    NSNumber * isMem = [self.isMember objectAtIndex:indexPath.row];
    [self.isMember replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:![isMem boolValue]]];
    //NSLog(@"SELECTED: %@",group[@"group_id"]);
    NSURL * url = [NSURL URLWithString:API_URL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    NSString * username = [SchoorikenUser shared].username;
    NSString * password = [SchoorikenUser shared].password;
    NSString * query;
    if ([isMem boolValue] == YES) {
        query = @"ri";
    } else {
        query = @"rd";
    }
    NSString * groupid = group[@"group_id"];
    
    NSString * str = [NSString stringWithFormat:@"user=%@&pass=%@&query=%@&groupid=%@",username,password,query,groupid];
    NSData * postData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if ([data length] > 0 && error == nil) {
            //Got data
            NSLog(@"Received: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } else if ([data length] == 0 && error == nil) {
            //Empty reply
            //NSLog(@"Got empty reply");
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
    });
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
