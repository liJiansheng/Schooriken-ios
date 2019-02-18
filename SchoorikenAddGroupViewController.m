//
//  SchoorikenAddGroupViewController.m
//  Schooriken
//
//  Created by Chin Zhan Xiong on 5/7/14.
//  Copyright (c) 2014 ri. All rights reserved.
//

#import "SchoorikenAddGroupViewController.h"
#import "SchoorikenConstants.h"
#import "SchoorikenUser.h"
#import "SchoorikenAddGroupTableController.h"

@interface SchoorikenAddGroupViewController ()

@end

@implementation SchoorikenAddGroupViewController

SchoorikenAddGroupTableController * classController;
SchoorikenAddGroupTableController * ccaController;
SchoorikenAddGroupTableController * othersController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)reloadGroups
{
    [classController.groups removeAllObjects];
    [classController.isMember removeAllObjects];
    [ccaController.groups removeAllObjects];
    [ccaController.isMember removeAllObjects];
    [othersController.groups removeAllObjects];
    [othersController.isMember removeAllObjects];
    
    NSURL * url = [NSURL URLWithString:API_URL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    NSString * username = [SchoorikenUser shared].username;
    NSString * password = [SchoorikenUser shared].password;
    
    NSString * str = [NSString stringWithFormat:@"user=%@&pass=%@&query=group",username,password];
    NSData * postData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if ([data length] > 0 && error == nil) {
            //Got data
            NSError * err;
            NSDictionary * dat = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            NSArray * arr = dat[@"data"];
            if (err) {
                NSLog(@"%@",[err localizedDescription]);
            }
            
            //aNSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            if ((id)arr != (id)[NSNull null]) {
                for (NSDictionary * group in arr) {
                    NSString * type =  group[@"type"];
                    SchoorikenAddGroupTableController * t;
                    if ([type isEqualToString:@"Class"]) {
                        t = classController;
                    } else if ([type isEqualToString:@"CCA"]) {
                        t = ccaController;
                    } else {
                        t = othersController;
                    }
                    
                    [t.groups addObject:group];
                    [t.isMember addObject:[NSNumber numberWithBool:YES]];
                    NSLog(@"%d",[t.groups count]);
                }
            }
            
            NSString * str = [NSString stringWithFormat:@"user=%@&pass=%@&query=nongroup",username,password];
            NSData * postData = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                if ([data length] > 0 && error == nil) {
                    //Got data
                    NSError * err;
                    NSDictionary * dat = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                    NSArray * arr = dat[@"data"];
                    if (err) {
                        NSLog(@"%@",[err localizedDescription]);
                    }
                    //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    if ((id)arr != (id)[NSNull null]) {
                        for (NSDictionary * group in arr) {
                            NSString * type =  group[@"type"];
                            SchoorikenAddGroupTableController * t;
                            if ([type isEqualToString:@"Class"]) {
                                t = classController;
                            } else if ([type isEqualToString:@"CCA"]) {
                                t = ccaController;
                            } else {
                                t = othersController;
                            }
                            [t.groups addObject:group];
                            [t.isMember addObject:[NSNumber numberWithBool:NO]];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [classController.tableView reloadData];
                        [ccaController.tableView reloadData];
                        [othersController.tableView reloadData];
                    });
                } else if ([data length] == 0 && error == nil) {
                    //Empty reply
                    NSLog(@"Got empty reply");
                } else {
                    NSLog(@"ERROR: %@", error);
                }
            }];
        } else if ([data length] == 0 && error == nil) {
            //Empty reply
            NSLog(@"Got empty reply");
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for (SchoorikenAddGroupTableController * vc in self.viewControllers)
    {
        if ([vc.title isEqualToString:@"Class"]) {
            classController = vc;
        } else if ([vc.title isEqualToString:@"CCA"]) {
            ccaController = vc;
        } else if ([vc.title isEqualToString:@"Others"]) {
            othersController = vc;
        }
        vc.groups = [[NSMutableArray alloc] init];
        vc.isMember = [[NSMutableArray alloc] init];
    }
    [self reloadGroups];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
