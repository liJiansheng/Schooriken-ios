//
//  SchoorikenDashboardViewController.m
//  Schooriken
//
//  Created by Chin Zhan Xiong on 5/5/14.
//  Copyright (c) 2014 ri. All rights reserved.
//

#import "SchoorikenDashboardViewController.h"
#import "SchoorikenUnjoinedEventCell.h"
#import "SchoorikenJoinedEventCell.h"
#import "SchoorikenAssignmentCell.h"
#import "SchoorikenConstants.h"
#import "SchoorikenUser.h"

#import <QuartzCore/QuartzCore.h>

@interface SchoorikenDashboardViewController ()
- (void)initNavigationBar;
- (UIBarButtonItem *) createSquareUIBarButtonItem:(UIImage*)image width:(CGFloat)width;

- (void)getEvents;
- (void)updateEventsFromJSON:(NSData*)data;

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

@end

@implementation SchoorikenDashboardViewController

NSArray * dashboardItems;
NSDateFormatter * dateFormatter;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   
    if (self) {
        // Custom initialization
        //[self initNavigationBar];
        
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self initNavigationBar];
    //[self getEvents];
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self getEvents];
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dashboardItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.tableView layoutIfNeeded]
    //self.
    //CGSize size =[self. systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat ret = 0;
    NSDictionary * event = [dashboardItems objectAtIndex:indexPath.row];
    
   
    if ([event[@"type"] isEqualToString:@"Event"]) {
        NSString * flag = event[@"flag"];
        //Event
        if ([flag isEqualToString:@"0"]) {
            SchoorikenUnjoinedEventCell * cell = (SchoorikenUnjoinedEventCell*)[self tableView:tableView cellByIdentifier:@"UnjoinedEventCell"];
        cell.detailsLabel.text = event[@"description"];
            [cell layoutIfNeeded];
            CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
             if (event[@"image"] != [NSNull null] && event[@"image"] != nil) {
            ret = size.height+100;
             }else{
                 ret = size.height;
             }
            NSLog(@"%@",event[@"title"]);
            NSLog(@"%f",ret);
            NSLog(@"height unjoin image");

        }else if([flag isEqualToString:@"1"]){
             SchoorikenJoinedEventCell * cell = (SchoorikenJoinedEventCell*)[self tableView:tableView cellByIdentifier:@"JoinedEventCell"];
            cell.detailsLabel.text = event[@"description"];
            [cell layoutIfNeeded];
            CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            if (event[@"image"] != [NSNull null] && event[@"image"] != nil) {
                ret = size.height;
            }else{
                ret = size.height-80;
            }
            NSLog(@"%@",event[@"title"]);
            NSLog(@"%f",ret);
            NSLog(@"height join  image");

        }
    }else if ([event[@"type"] isEqualToString:@"Assignment"]) {
        SchoorikenAssignmentCell * cell = (SchoorikenAssignmentCell*)[self tableView:tableView cellByIdentifier:@"AssignmentCell"];
        cell.detailsLabel.text = event[@"description"];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        ret = size.height;
    }else if ([event[@"type"] isEqualToString:@"Announcement"]) {
        SchoorikenJoinedEventCell * cell = (SchoorikenJoinedEventCell*)[self tableView:tableView cellByIdentifier:@"JoinedEventCell"];
     cell.detailsLabel.text = event[@"description"];
        [cell layoutIfNeeded];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        if (event[@"image"] != [NSNull null] && event[@"image"] != nil) {
            ret = size.height;
        }else{
            ret = size.height-80;
        }

    }
    
    
    return ret;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellByIdentifier:(NSString*)identifier
{
    UITableViewCell * cell = nil;//[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    return cell;
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents * conv = [cal components:NSDayCalendarUnit fromDate:fromDateTime toDate:toDateTime options:kNilOptions];
    return [conv day]+1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * item = [dashboardItems objectAtIndex:indexPath.row];
    NSString * itemType = item[@"type"];
    UITableViewCell * ret = nil;
    
    
    if ([itemType isEqualToString:@"Event"]) {
        NSString * flag = item[@"flag"];
        
        //Event
        if ([flag isEqualToString:@"0"]) {
            SchoorikenUnjoinedEventCell * cell = (SchoorikenUnjoinedEventCell*)[self tableView:tableView cellByIdentifier:@"UnjoinedEventCell"];
            
            //Unjoined event
            cell.nameLabel.text = item[@"title"];
            cell.detailsLabel.text = item[@"description"];
            CGSize maximumLabelSize = CGSizeMake(280, FLT_MAX);
            CGSize expectedLabelSize = [item[@"description"] sizeWithFont:cell.detailsLabel.font constrainedToSize:maximumLabelSize lineBreakMode:cell.detailsLabel.lineBreakMode];
            cell.detailsLabel.numberOfLines = 0;
            
            //adjust the label the the new height.
            CGRect newFrame = cell.detailsLabel.frame;
            newFrame.size.height = expectedLabelSize.height;
            cell.detailsLabel.frame = newFrame;

            cell.groupLabel.text = item[@"group_name"];
            NSDate * date = [dateFormatter dateFromString:item[@"evtDate"]];
            NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
            [fmt setDateFormat:@"dd-MM-yyyy"];
            cell.dateLabel.text = [fmt stringFromDate:date];
            [cell.groupLabel sizeToFit];
            if (item[@"image"] != [NSNull null] && item[@"image"] != nil) {
                NSURL * imgUrl = [NSURL URLWithString:item[@"image"]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData * imageData = [NSData dataWithContentsOfURL:imgUrl];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 240, 100);
                        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                        cell.imageView.image = [UIImage imageWithData:imageData];
                    });
                });
            
                NSLog(@"%@",item[@"title"]);
                NSLog(@"%f",cell.frame.size.height);
                 NSLog(@"yes image");
                [cell layoutIfNeeded];
                           } else {
                cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 240, 0);
                [cell layoutIfNeeded];
                NSLog(@"%@",item[@"title"]);
                NSLog(@"%f",cell.frame.size.height);
                NSLog(@"no image");
                
            }
            //CGSize size
            ret = cell;
            
        } else if ([flag isEqualToString:@"1"]) {
            SchoorikenJoinedEventCell * cell = (SchoorikenJoinedEventCell*)[self tableView:tableView cellByIdentifier:@"JoinedEventCell"];
            
            //Joined event
            cell.nameLabel.text = item[@"title"];
            cell.detailsLabel.text = item[@"description"];
            CGSize maximumLabelSize = CGSizeMake(280, FLT_MAX);
            
            CGSize expectedLabelSize = [item[@"description"] sizeWithFont:cell.detailsLabel.font constrainedToSize:maximumLabelSize lineBreakMode:cell.detailsLabel.lineBreakMode];
            cell.detailsLabel.numberOfLines = 0;
            
            //adjust the label the the new height.
            CGRect newFrame = cell.detailsLabel.frame;
            newFrame.size.height = expectedLabelSize.height;
            cell.detailsLabel.frame = newFrame;

            cell.groupLabel.text = item[@"group_name"];
            NSDate * date = [dateFormatter dateFromString:item[@"evtDate"]];
            NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
            [fmt setDateFormat:@"dd-MM-yyyy"];
            cell.dateLabel.text = [fmt stringFromDate:date];
            //NSLog(@"%@",item[@"evtDate"]);
            NSDate * now = [NSDate date];
            if ([date compare:now] == NSOrderedAscending) {
                cell.daysLeftLabel.text = @"0";
            } else {
                cell.daysLeftLabel.text = [[NSString alloc] initWithFormat:@"%d",[self daysBetweenDate:now andDate:date]];
            }
            if (item[@"image"] != [NSNull null] && item[@"image"] != nil) {
                NSURL * imgUrl = [NSURL URLWithString:item[@"image"]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData * imageData = [NSData dataWithContentsOfURL:imgUrl];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 240, 100);
                        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                        cell.imageView.image = [UIImage imageWithData:imageData];
                    });
                });
                NSLog(@"%@",item[@"title"]);
                NSLog(@"%f",cell.frame.size.height);
                NSLog(@"join yes image");

                
            } else {
                cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 240, 0);
                NSLog(@"%@",item[@"title"]);
                NSLog(@"%f",cell.frame.size.height);
                NSLog(@"join no image");

            }
            //NSLog(@"%@",cell.daysLeftLabel.text);
            [cell layoutIfNeeded];
            ret = cell;
        }
        
    } else if ([itemType isEqualToString:@"Assignment"]) {
        SchoorikenAssignmentCell * cell = (SchoorikenAssignmentCell*)[self tableView:tableView cellByIdentifier:@"AssignmentCell"];
      
        //Assignment
        cell.nameLabel.text = item[@"title"];
        cell.detailsLabel.text = item[@"description"];
        CGSize maximumLabelSize = CGSizeMake(280, FLT_MAX);
        CGSize expectedLabelSize = [item[@"description"] sizeWithFont:cell.detailsLabel.font constrainedToSize:maximumLabelSize lineBreakMode:cell.detailsLabel.lineBreakMode];
        cell.detailsLabel.numberOfLines = 0;
       
        //adjust the label the the new height.
        CGRect newFrame = cell.detailsLabel.frame;
        newFrame.size.height = expectedLabelSize.height;
        cell.detailsLabel.frame = newFrame;
        cell.groupLabel.text = item[@"group_name"];
        NSDate * date = [dateFormatter dateFromString:item[@"evtDate"]];
        NSDate * now = [NSDate date];
        NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"dd-MM-yyyy"];
        cell.dateLabel.text = [fmt stringFromDate:date];
        NSLog(@"%@",[fmt stringFromDate:date]);
        //NSLog(@"%@",item[@"evtDate"]);
        if ([date compare:now] == NSOrderedAscending) {
            cell.daysLeftLabel.text = @"0";
        } else {
            cell.daysLeftLabel.text = [[NSString alloc] initWithFormat:@"%d",[self daysBetweenDate:now andDate:date]];
        }
            [cell layoutIfNeeded];
            ret = cell;

    } else if ([itemType isEqualToString:@"Announcement"]) {
        SchoorikenJoinedEventCell * cell = (SchoorikenJoinedEventCell*)[self tableView:tableView cellByIdentifier:@"JoinedEventCell"];
        
        NSString * flag = item[@"isShow"];
        
        //Event
        if ([flag isEqualToString:@"1"]) {
        cell.nameLabel.text = item[@"title"];
        cell.detailsLabel.text = item[@"description"];
        CGSize maximumLabelSize = CGSizeMake(280, FLT_MAX);
        
        CGSize expectedLabelSize = [item[@"description"] sizeWithFont:cell.detailsLabel.font constrainedToSize:maximumLabelSize lineBreakMode:cell.detailsLabel.lineBreakMode];
        cell.detailsLabel.numberOfLines = 0;
        
        //adjust the label the the new height.
        CGRect newFrame = cell.detailsLabel.frame;
        newFrame.size.height = expectedLabelSize.height;
        cell.detailsLabel.frame = newFrame;

        cell.groupLabel.text = item[@"group_name"];
        NSDate * date = [dateFormatter dateFromString:item[@"evtDate"]];
        NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"dd-MM-yyyy"];
        cell.dateLabel.text = [fmt stringFromDate:date];
        [cell.groupLabel sizeToFit];
        
       // [cell.detailsLabel sizeToFit];
        if (item[@"image"] != [NSNull null] && item[@"image"] != nil) {
            NSURL * imgUrl = [NSURL URLWithString:item[@"image"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData * imageData = [NSData dataWithContentsOfURL:imgUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 240, 100);
                    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                    cell.imageView.image = [UIImage imageWithData:imageData];
                });
            });
        } else {
            cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 240, 0);
        }
        }
        [cell layoutIfNeeded];
        ret = cell;
    }
    
    return ret;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIBarButtonItem *) createSquareUIBarButtonItem:(UIImage*)image width:(CGFloat)width
{
    UIImageView * retView = [[UIImageView alloc] initWithImage:image];
    [retView setContentMode:UIViewContentModeScaleAspectFit];
    CGPoint origin = retView.frame.origin;
    [retView setFrame:CGRectMake(origin.x, origin.y, width, width)];
    UIBarButtonItem * ret = [[UIBarButtonItem alloc] initWithCustomView:retView];
    return ret;
}

- (void)initNavigationBar
{
    UINavigationBar * navBar = self.navigationController.navigationBar;
    CGFloat btnSize = navBar.frame.size.height*0.9;
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    UIBarButtonItem * logo = [self createSquareUIBarButtonItem:[UIImage imageNamed:@"logo.png"]
                                                         width:btnSize];
    self.navigationItem.leftBarButtonItem = logo;
    
    /*
    UIBarButtonItem * settings = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:nil
                                                                 action:nil];
     */
    UIImage * addGroupImage = [UIImage imageNamed:@"glyphicons_plus.png"];
    UIBarButtonItem * addGroup = [[UIBarButtonItem alloc] initWithImage:addGroupImage
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(goToAddGroup:)];
    UIImage * refreshImage = [UIImage imageNamed:@"glyphicons_refresh.png"];
    UIBarButtonItem * refresh = [[UIBarButtonItem alloc] initWithImage:refreshImage
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(getEvents)];
    UIImage * logoutImage = [UIImage imageNamed:@"glyphicons_logout.png"];
    UIBarButtonItem * logout = [[UIBarButtonItem alloc] initWithImage:logoutImage
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(doLogout:)];
    
    NSArray * rightItems = [[NSArray alloc] initWithObjects: logout, addGroup, refresh, nil];
    self.navigationItem.rightBarButtonItems = rightItems;
    
    return;
}

- (void) goToAddGroup:(id)sender
{
    [self performSegueWithIdentifier:@"goToAddGroup" sender:self];
    return;
}
- (void) doLogout:(id)sender
{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"username"];
    [prefs removeObjectForKey:@"password"];
    NSLog(@"LOGOUT");
    [self.parentViewController viewWillAppear:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
}

- (void)getEvents
{
    NSURL * url = [NSURL URLWithString:API_URL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    NSString * username = [SchoorikenUser shared].username;
    NSString * password = [SchoorikenUser shared].password;
    
    NSString * str = [NSString stringWithFormat:@"user=%@&pass=%@&query=event",username,password];
    NSData * postData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if ([data length] > 0 && error == nil) {
            //Got data
            //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            //if (![[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] isEqualToString:@"null"]) {
            [self updateEventsFromJSON:data];
            //}
        } else if ([data length] == 0 && error == nil) {
            //Empty reply
            NSLog(@"Got empty reply");
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
}

- (void)updateEventsFromJSON:(NSData*)data
{
    NSError * err;
    dashboardItems = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (err || (dashboardItems == nil)) {
        NSLog(@"Error reading JSON: %@",[err localizedDescription]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[SchoorikenUnjoinedEventCell class]])
    {
        SchoorikenUnjoinedEventCell * c = (SchoorikenUnjoinedEventCell*) cell;
        c.joinButton.itemIndex = indexPath.row;
        [c.joinButton addTarget:self action:@selector(joinEventButtonPress:) forControlEvents:UIControlEventTouchDown];
    }else if ([cell isKindOfClass:[SchoorikenAssignmentCell class]])
    {
        
        SchoorikenAssignmentCell * c = (SchoorikenAssignmentCell*) cell;
        c.completeButton.itemIndex = indexPath.row;
        [c.completeButton addTarget:self action:@selector(completeButtonPress:) forControlEvents:UIControlEventTouchDown];
    }

}

- (void)joinEventButtonPress:(id)sender
{
    SchoorikenJoinButton * button = (SchoorikenJoinButton*)sender;
    NSMutableDictionary * dict = dashboardItems[button.itemIndex];
    
    
    NSURL * url = [NSURL URLWithString:API_URL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    NSString * username = [SchoorikenUser shared].username;
    NSString * password = [SchoorikenUser shared].password;
    
    NSString * str = [NSString stringWithFormat:@"user=%@&pass=%@&query=trueflagarr&eventidarr=%@",username,password,[[NSString alloc] initWithFormat:@"[%@]",dict[@"event_id"]]];
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
    
    [dict setValue:@"1" forKey:@"flag"];
    [self.tableView reloadData];
}

- (void)completeButtonPress:(id)sender
{
    SchoorikenCompleteButton * button = (SchoorikenCompleteButton*)sender;
    NSMutableDictionary * dict = dashboardItems[button.itemIndex];
    
     NSLog(@"Complete Press");
    
    NSURL * url = [NSURL URLWithString:API_URL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    NSString * username = [SchoorikenUser shared].username;
    NSString * password = [SchoorikenUser shared].password;
    
    NSString * str = [NSString stringWithFormat:@"user=%@&pass=%@&query=trueflagarr&eventidarr=%@",username,password,[[NSString alloc] initWithFormat:@"[%@]",dict[@"event_id"]]];
    NSData * postData = [str dataUsingEncoding:NSUTF8StringEncoding];
     NSLog(@"eventid: %@",dict[@"event_id"]);
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
            NSLog(@"Got empty reply");
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    
    [dict setValue:@"1" forKey:@"flag"];
    [self.tableView reloadData];
}

@end
