//
//  OfferEditVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 15.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "OfferEditVC.h"
#import "OfferEditTableViewCell.h"
#import "testTableTableViewController.h"

@interface OfferEditVC ()


@end

static NSString* kCellIdentifier = @"OfferEdiTableViewCell";

@implementation OfferEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [_tableView registerClass:[OfferEditTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark UITableView Delegate & DataSource



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toEditOffer"]) {
        testTableTableViewController* tstvc = (testTableTableViewController*)segue.destinationViewController;
    }
}


@end
