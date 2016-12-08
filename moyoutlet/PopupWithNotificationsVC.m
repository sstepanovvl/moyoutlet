//
//  PopupWithNotificationsVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 26.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "PopupWithNotificationsVC.h"
#import "NotificationCell.h"
#import "NewsItemVC.h"

@interface PopupWithNotificationsVC ()

@end

@implementation PopupWithNotificationsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [_mainTableView registerNib:[UINib nibWithNibName:@"NotificationCell" bundle:nil]
         forCellReuseIdentifier:@"NotificationCell"];
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.estimatedRowHeight = 140;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NotificationCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NotificationCell alloc] init];
    }

    cell.mainTextLabel.text = @"Новое сообщение от Аутлета: Дарим бонусы за просмотр объявлений!";
    cell.daysAgoLabel.text = @"10 дней назад";

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NewsItemVC* nivc = [[NewsItemVC alloc] initWithNibName:@"NewsItemVC" bundle:nil];

    [self.navigationController pushViewController:nivc animated:YES];
}

@end
