//
//  NewsItemVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 26.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "NewsItemVC.h"

@interface NewsItemVC ()

@end

@implementation NewsItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCustomNavigationItems];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];

    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://moyoutlet.ru/news.html"]]];
    // Do any additional setup after loading the view from its nib.
}

-(void)initCustomNavigationItems {

    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];

    NSString* titleText = [NSString stringWithFormat:@"Сообщение от Moyoutlet"];
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

    UIImage *image = [[UIImage imageNamed:@"leftMenuBackButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBarButtonWithLogo setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBarButtonWithLogo setImage:image forState:UIControlStateNormal];
    [leftBarButtonWithLogo addTarget:self
                              action:@selector(backButtonPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* but = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonWithLogo];
    NSArray* leftBarItems = [[NSArray alloc] initWithObjects:but, nil];

    self.navigationItem.leftBarButtonItems = leftBarItems;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

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
- (IBAction)backButtonPressed:(id)sender {

[self.navigationController popViewControllerAnimated:YES];
}
@end
