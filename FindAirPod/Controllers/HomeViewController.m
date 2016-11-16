//
//  HomeViewController.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/9.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "HomeViewController.h"
#import "MapMainViewController.h"
#import "FillFirstViewController.h"


#define maginX      35
#define maginY      70
#define topSide     100
#define btnHeight   50


@interface HomeViewController ()

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIButton *wantBtn;

@property (nonatomic, strong) UIButton *giveBtn;

@property (nonatomic, strong) UIButton *myMsgBtn;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContentView_2];
    
}


#pragma mark - UI
- (void)loadContentView{
    
    //  底层布局
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(maginX, maginX + 64, kScreenW - 2*maginX, kScreenH - 64 - maginX - maginY)];
    [self.view addSubview:bgView];
    CGFloat bgWidth = bgView.frame.size.width;
    CGFloat bgHeight = bgView.frame.size.height;
    
    //  0.上方标题
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgWidth, 40)];
    titleLable.text = @"您希望寻求:";
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont boldSystemFontOfSize:18];
    titleLable.textColor = [UIColor blackColor];
    [bgView addSubview:titleLable];
    
    //  1.上方左右2个btn
    self.leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, topSide, topSide)];
    [self.leftBtn setTitle:@"左" forState:UIControlStateNormal];
    self.leftBtn.backgroundColor = color_InfoBlue;
    self.leftBtn.layer.cornerRadius = 5;
    self.leftBtn.layer.masksToBounds = YES;
    [bgView addSubview:self.leftBtn];
    
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(bgWidth - topSide, 60, topSide, topSide)];
    [self.rightBtn setTitle:@"右" forState:UIControlStateNormal];
    self.rightBtn.backgroundColor = color_InfoBlue;
    self.rightBtn.layer.cornerRadius = 5;
    self.rightBtn.layer.masksToBounds = YES;
    [bgView addSubview:self.rightBtn];
    
    //  2.我要btn
    self.wantBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, bgHeight/2.f - btnHeight/2.f, bgWidth, btnHeight)];
    [self.wantBtn setTitle:@"我要" forState:UIControlStateNormal];
    self.wantBtn.backgroundColor = color_WarningYellow;
    self.wantBtn.layer.cornerRadius = 10;
    self.wantBtn.layer.masksToBounds = YES;
    [bgView addSubview:self.wantBtn];
    
    CGFloat btnPadding = (bgHeight/2.f - 2.5*btnHeight)/2.f;
    //  3.我送btn
    self.giveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, bgHeight/2.f + btnPadding + btnHeight/2.f, bgWidth, btnHeight)];
    [self.giveBtn setTitle:@"我送" forState:UIControlStateNormal];
    self.giveBtn.backgroundColor = color_SuccessGreen;
    self.giveBtn.layer.cornerRadius = 5;
    self.giveBtn.layer.masksToBounds = YES;
    [bgView addSubview:self.giveBtn];
    
    //  4.我发布的信息
    self.myMsgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, bgHeight - btnHeight, bgWidth, btnHeight)];
    [self.myMsgBtn setTitle:@"我发布的信息" forState:UIControlStateNormal];
    [self.myMsgBtn setTitleColor:color_TestGray forState:UIControlStateNormal];
    [bgView addSubview:self.myMsgBtn];
}

- (void)loadContentView_2{
    
    CGFloat BigBtnSide = 100;
    if (kIsScreen5_5) {
        BigBtnSide = 120;
    }
    
    //    0.中间两个btn
    CGFloat paddingX  = (kScreenW - 2*BigBtnSide)/3.f;
    
    self.leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(paddingX, (kScreenH - 64 - BigBtnSide)/2.f, BigBtnSide, BigBtnSide)];
    self.leftBtn.backgroundColor = color_LinkBlue;
    [self.leftBtn setTitle:@"Left" forState:UIControlStateNormal];
    self.leftBtn.layer.cornerRadius = 10;
    self.leftBtn.layer.masksToBounds = YES;
    self.leftBtn.tag = 1000;
    [self.leftBtn addTarget:self action:@selector(leftOrRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftBtn];
    
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(2*paddingX + BigBtnSide, CGRectGetMinY(self.leftBtn.frame), BigBtnSide, BigBtnSide)];
    self.rightBtn.backgroundColor = color_LinkBlue;
    [self.rightBtn setTitle:@"Right" forState:UIControlStateNormal];
    self.rightBtn.layer.cornerRadius = 10;
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.tag = 1001;
    [self.rightBtn addTarget:self action:@selector(leftOrRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightBtn];
    
    //  1.上面的标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ((kScreenH - 64)/2.f - btnHeight)/2.f, kScreenW, btnHeight)];
    titleLabel.text = @"我在寻找:";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [self.view addSubview:titleLabel];
    
    //  2.赠送耳机
    self.giveBtn = [[UIButton alloc] initWithFrame:CGRectMake(paddingX, CGRectGetMaxY(self.leftBtn.frame) + 100, kScreenW - paddingX*2, 40)];
    self.giveBtn.backgroundColor = color_SuccessGreen;
    self.giveBtn.layer.cornerRadius = 10;
    self.giveBtn.layer.masksToBounds = YES;
    self.giveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.giveBtn setTitle:@"赠送手中的一只耳机给Ta~" forState:UIControlStateNormal];
    [self.giveBtn addTarget:self action:@selector(giveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.giveBtn];
    
}

#pragma mark - function
- (void)leftOrRightBtnAction:(UIButton *)btn{
    NSInteger tag = btn.tag;
    if (tag == 1000) {
        //  左
    }else{
        //  右
    }
    
    FillFirstViewController *fillVC = [[FillFirstViewController alloc] init];
    [self.navigationController pushViewController:fillVC animated:YES];
    
    
}

- (void)giveBtnAction:(UIButton *)btn{
    
    
    
    
    MapMainViewController *mapVC = [[MapMainViewController alloc] init];
    [self.navigationController pushViewController:mapVC animated:YES];
}


@end
