//
//  WXViewController.m
//  ios-demo
//
//  Created by 张歆琳 on 2020/9/22.
//  Copyright © 2020 张歆琳. All rights reserved.
//

#import "MineViewController.h"
#import "Login.h"
#import <SDWebImage.h>
#import "Screen.h"
//#import "CommentManager.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) UIView *tableViewHeaderView;
@property (nonatomic, strong, readwrite) UIImageView *headerImageView;

@end

@implementation MineViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"我的";
        self.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/home@2x.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon.bundle/home_selected@2x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView;
    })];
    
    // 搜索框临时加在这里，应该加在 News 的 Controller 里的，但显示不出来
//    MySearchBar *searchBar = [[MySearchBar alloc] initWithFrame:CGRectMake(0, 500, SCREEN_WIDTH - UI(20), 50)];
//    [self.view addSubview:searchBar];
    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 500, SCREEN_WIDTH - UI(20), 50)];
//    button.backgroundColor = [UIColor lightGrayColor];
//    [button addTarget:self action:@selector(_showCommentView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

// 虽然我们的 tableView 固定为 2 行，没有滚动，但板式代码要这么写，复用 cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mineTableViewCell"];
    }
    return cell;
}

// cell 高度固定为 60
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

// 头部图片
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _tableViewHeaderView.backgroundColor = [UIColor whiteColor];
        
        [_tableViewHeaderView addSubview:({
            _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 140)];
            _headerImageView.backgroundColor = [UIColor whiteColor];
            _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
            _headerImageView.clipsToBounds = YES;
            _headerImageView.userInteractionEnabled = YES;
            _headerImageView;
        })];
        
        [_tableViewHeaderView addGestureRecognizer:({
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapImage)];
            tapGesture;
        })];
    }
    
    return _tableViewHeaderView;
}

// 头图高度 200
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}

// 未登录时显示默认头图，登录后显示自己的图片
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (![[Login sharedLogin] isLogin]) {
        [_headerImageView setImage:[UIImage imageNamed:@"icon.bundle/icon_QQ.png"]];
    }else{
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[Login sharedLogin].avatarUrl]];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        cell.textLabel.text = [[Login sharedLogin] isLogin] ? [Login sharedLogin].nick: @"昵称";
    } else {
        cell.textLabel.text = [[Login sharedLogin] isLogin] ? [Login sharedLogin].address: @"地区";
    }
}

#pragma mark -

- (void)_tapImage {
    if (![[Login sharedLogin] isLogin]) {
        [[Login sharedLogin] loginWithFinishBlock:^(BOOL isLogin) {
            if (isLogin) {
                [self.tableView reloadData];
            }
        }];
    }else{
        [[Login sharedLogin] logOut];
        [self.tableView reloadData];
    }
}

- (void)_showCommentView {
//    [[CommentManager sharedManager] showCommentView];
}
@end
