//
//  LeftViewController.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/23.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "LeftViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"
#import "EditViewController.h"
#import "AboutUsViewController.h"

@interface LeftViewController ()

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *myPublish;

@property (nonatomic, assign) BOOL hasLogin;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContentView];
}

#pragma mark - UI
- (void)loadContentView{
    //0.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1.
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxLeftWidth, kScreenH)];
    [self.view addSubview:self.mainView];
    
    //2.    logo
    CGFloat iconSide = 82;
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake((maxLeftWidth - iconSide)/2.f, 60, iconSide, iconSide)];
    logoImgView.image = [UIImage imageNamed:@"icon"];
    [self.mainView addSubview:logoImgView];
    
    if ([self checkHasLogin]) {
        self.hasLogin = YES;
    }else{
        self.hasLogin = NO;
    }
    
    //3.    name
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(logoImgView.frame), maxLeftWidth - 20, 50)];
    self.nameLabel.textColor = RGB(174, 174, 174);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:19];
    [self.mainView addSubview:self.nameLabel];
    if (self.hasLogin) {
        //  判断本地是否有本地
        NSDictionary *dic = [self getUserLoginInfoDic];
        self.nameLabel.text = [dic objectForKey:@"title"];
    }
    
    CGFloat maginX = 24;
    CGFloat btnWidth = 120;
    CGFloat btnHeight = 45;
    //4.    我发布的
    self.myPublish = [[UILabel alloc] initWithFrame:CGRectMake(maginX, CGRectGetMaxY(self.nameLabel.frame) + 25, btnWidth, btnHeight)];
    [self.myPublish addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushBtnAction:)]];
    self.myPublish.userInteractionEnabled = YES;
    self.myPublish.font = [UIFont systemFontOfSize:19];
    self.myPublish.textColor = color_TestGray;
    [self.mainView addSubview:self.myPublish];
    if (self.hasLogin) {
        self.myPublish.text = @"我发布的";
    }else{
        self.myPublish.text = @"去发布";
        self.myPublish.frame = CGRectMake(maginX, CGRectGetMaxY(self.nameLabel.frame) + 10, btnWidth, btnHeight);

    }
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(maginX, CGRectGetMaxY(self.myPublish.frame) + 10, maxLeftWidth - 2*maginX, 1)];
    lineLabel.backgroundColor = color_QuoteBgGray;
    [self.mainView addSubview:lineLabel];
    
    
    //5.    关于我们
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(maginX, CGRectGetMaxY(self.myPublish.frame) + 25, btnWidth, btnHeight)];
    aboutLabel.userInteractionEnabled = YES;
    [aboutLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutBtnAction:)]];
    aboutLabel.font = [UIFont systemFontOfSize:19];
    aboutLabel.textColor = color_TestGray;
    aboutLabel.text = @"关于我们";
    [self.mainView addSubview:aboutLabel];
    
    //  版本信息
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenH - btnHeight - 10, maxLeftWidth, btnHeight)];
    versionLabel.text = [NSString stringWithFormat:@"寻音  v%@",kAppVersion];
    versionLabel.textColor = color_mainColor;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:14];
    [self.mainView addSubview:versionLabel];
    
}

#pragma mark - function
- (void)pushBtnAction:(UIButton *)btn{
    if (self.hasLogin) {
        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        EditViewController *editVC = [[EditViewController alloc] init];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            [nav pushViewController:editVC animated:YES];
        }];
    }else{
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            [delegate showHomeVC];
        }];
    }
}

- (void)aboutBtnAction:(UIButton *)btn{
    UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
    AboutUsViewController *abooutVC = [[AboutUsViewController alloc] init];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [nav pushViewController:abooutVC animated:YES];
    }];
}

#pragma mark - public
- (void)reloadData{
    for (UIView *subView in self.view.subviews) {
        [subView removeFromSuperview];
    }
    
    [self loadContentView];
}

@end
