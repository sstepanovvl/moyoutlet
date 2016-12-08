//
//  NewsVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 16.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "NewsVC.h"
#import "UIWebView+Additional.h"

@interface NewsVC ()

@end

@implementation NewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItems];

    [_tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 140.0f;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    NSLog(@"NewsVC viewWillDisappear");

}

-(void)initNavigationItems {

    [super initNavigationItems];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];



    NSString* titleText = [NSString stringWithFormat:@"Новости"];
    UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
    CGSize requestedTitleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    CGFloat titleWidth = MIN(100, requestedTitleSize.width);

    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, requestedTitleSize.height)];
    navLabel.backgroundColor = [UIColor whiteColor];
    navLabel.textColor = [UIColor appRedColor];
    navLabel.font = titleFont;
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.text = titleText;

    self.navigationItem.titleView = navLabel;


    UIButton* leftBarButtonWithLogo = [[UIButton alloc] init];

    UIImage *image = [[UIImage imageNamed:@"leftMenuItemImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBarButtonWithLogo setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBarButtonWithLogo setImage:image forState:UIControlStateNormal];
    [leftBarButtonWithLogo addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* but = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonWithLogo];
    NSArray* leftBarItems = [[NSArray alloc] initWithObjects:but, nil];
    self.navigationItem.leftBarButtonItems = leftBarItems;

    [self.navigationItem.rightBarButtonItems objectAtIndex:1 ].badgeValue = @"3";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60.0f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NewsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];

    if (!cell) {
        cell = [[NewsCell alloc] init];
    }

    cell.text.text = @"Сообщение от Moyoutlet: Пожалуйста обновите ваше объявление";
    cell.dateLabel.text = @"04.06.2016 18:03";

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NewsItemVC* nivc = [[NewsItemVC alloc] initWithNibName:@"NewsItemVC" bundle:nil];

    [self.navigationController pushViewController:nivc animated:YES];

}

@end
