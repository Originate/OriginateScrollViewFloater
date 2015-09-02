//
//  ViewController.m
//  OriginateScrollViewFloaterExample
//
//  Created by Allen Wu on 9/1/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

#import "ViewController.h"
#import "OriginateScrollViewFloater.h"

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) OriginateScrollViewFloater* floater;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.floater = ({
        UIControl* floaterView = [[OriginateScrollViewFloaterDefaultView alloc] initWithTitle:@"OriginateScrollViewFloater!"
                                                                                         font:[UIFont systemFontOfSize:14]
                                                                                    textColor:[UIColor whiteColor]
                                                                              backgroundColor:[UIColor blueColor]];
        
        [[OriginateScrollViewFloater alloc] initWithScrollView:self.tableView floaterView:floaterView];
    });
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.floater];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
    [self.tableView setContentOffset:CGPointMake(5, 600) animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.floater showAtContentOffset:CGPointMake(0, 300)
                            fromDirection:OriginateScrollViewFloaterDirectionTop
                      hideWhenApproaching:CGPointMake(0, 0)
                               tapHandler:^(void) {
                                   [self scrollToTop];
                               }];
    });
}

- (void)scrollToTop
{
    CGPoint top = CGPointMake(0, -self.tableView.contentInset.top);
    [self.tableView setContentOffset:top animated:YES];
}


#pragma mark - Properties

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.rowHeight = 150;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])
                                                            forIndexPath:indexPath];

    cell.backgroundColor = ({
        CGFloat red   = fmin(drand48() * 2, 1);
        CGFloat blue  = fmin(drand48() * 2, 1);
        CGFloat green = fmin(drand48() * 2, 1);
        [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    });
    
    return cell;
}

@end
