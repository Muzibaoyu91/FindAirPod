
//
//  NewHomeViewController.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/26.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "NewHomeViewController.h"
#import "pop.h"
#import "FillZeroViewController.h"
#import "AppDelegate.h"



#define btnTagBase      1000

@interface NewHomeViewController ()

#pragma mark - UI

@property (nonatomic, strong) UIImageView *logoImgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *findBtn;

@property (nonatomic, strong) UIButton *giveBtn;



@end

@implementation NewHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContentView];
    
    //延时1s 动画
    [self performSelector:@selector(beginAnmation) withObject:nil afterDelay:0.8f];
    
}

#pragma mark - UI
- (void)loadContentView{
    //0.logo
    CGFloat logoSide = kScreenW*0.36;
    self.logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logoSide, logoSide)];
    self.logoImgView.center = CGPointMake(kScreenW/2.f, (kScreenH-64)/2.f-64);
    self.logoImgView.layer.cornerRadius = 20;
    self.logoImgView.layer.masksToBounds = YES;
    self.logoImgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.logoImgView.layer.shadowOffset = CGSizeMake(4, 4);
    self.logoImgView.layer.shadowRadius = 20;
    self.logoImgView.layer.shadowOpacity = 0.2;
    self.logoImgView.layer.cornerRadius = 5;
    self.logoImgView.image = [UIImage imageNamed:@"main-logo"];
    [self.view addSubview:self.logoImgView];
    
    
    //1.title
    CGFloat buttomMagin = 40;
    CGFloat titleHeight  = 80;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenH - 64 - buttomMagin - titleHeight, kScreenW, titleHeight)];
    self.titleLabel.text = @"欢迎来到 寻音";
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:26];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = color_mainColor;
    [self.view addSubview:self.titleLabel];
    
    
    //2.btn
    CGFloat btnWidth = kScreenW*0.67;
    CGFloat btnHeitht = kScreenW*0.12;
    self.findBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenW - btnWidth)/2.f, kScreenH +10, btnWidth, btnHeitht)];
    [self creatBtnStyleWithBtn:self.findBtn withTttle:@"我要寻找" withTag:0];
    
    self.giveBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenW - btnWidth)/2.f, CGRectGetMaxY(self.findBtn.frame) + 10, btnWidth, btnHeitht)];
    [self creatBtnStyleWithBtn:self.giveBtn withTttle:@"我要赠送" withTag:1];
    
    
}

- (void)creatBtnStyleWithBtn:(UIButton *)btn withTttle:(NSString *)title withTag:(NSInteger)tag{
    CGFloat btnHeight = btn.frame.size.height;
    
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:24];
    if (kIsScreen4) {
        btn.titleLabel.font = [UIFont systemFontOfSize:22];
    }
    [btn setTitleColor:color_mainColor forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = btnHeight/2.f;
    btn.layer.borderWidth = 2.5;
    btn.layer.borderColor = color_mainColor.CGColor;
    btn.tag = btnTagBase + tag;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - function
- (void)beginAnmation{
    CGFloat centerY = (kScreenH-64)/2.f - 64;
    CGFloat Bounciness = 11;    //振动幅度
    CGFloat speed = 9;     //动画速度
    if (kIsScreen5_5) {
        speed = 16;
    }
    
    POPSpringAnimation *anSpring_logo = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring_logo.toValue = @(kScreenH/6.f);
    anSpring_logo.beginTime = CACurrentMediaTime();
    anSpring_logo.springBounciness = Bounciness;
    anSpring_logo.springSpeed = speed;
    [self.logoImgView pop_addAnimation:anSpring_logo forKey:@"position"];
    
    POPSpringAnimation *anSpring_title = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring_title.toValue = @(centerY);
    anSpring_title.beginTime = CACurrentMediaTime() + 0.05f;
    anSpring_title.springBounciness = Bounciness + 1;
    anSpring_title.springSpeed = speed - 2;
    [self.titleLabel pop_addAnimation:anSpring_title forKey:@"position"];
    
    POPSpringAnimation *anSpring_find = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring_find.toValue = @(centerY + 100);
    anSpring_find.beginTime = CACurrentMediaTime() + 0.1f;
    anSpring_find.springBounciness = Bounciness + 1;
    anSpring_find.springSpeed = speed - 4;
    [self.findBtn pop_addAnimation:anSpring_find forKey:@"position"];
    
    POPSpringAnimation *anSpring_give = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring_give.toValue = @(centerY + 100 + 80);
    anSpring_give.beginTime = CACurrentMediaTime() + 0.15f;
    anSpring_give.springBounciness = Bounciness + 1;
    anSpring_give.springSpeed = speed - 6;
    [self.giveBtn pop_addAnimation:anSpring_give forKey:@"position"];
}

- (void)btnAction:(UIButton *)btn{
    NSInteger tag = btn.tag - btnTagBase;
    
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(8, 8)];
    sprintAnimation.springBounciness = 20.f;
    [btn pop_addAnimation:sprintAnimation forKey:@"sendAnimation"];
    if (!tag) {
        //  find
        [self performSelector:@selector(pushToFillVC) withObject:nil afterDelay:0.4];
        self.findBtn.userInteractionEnabled = NO;
    }else{
        //  give
        [self performSelector:@selector(pushToMapVC) withObject:nil afterDelay:0.4];
        self.giveBtn.userInteractionEnabled = NO;
    }
}


- (void)pushToMapVC{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate showMapVC];
}

- (void)pushToFillVC{
    FillZeroViewController *firstVC = [[FillZeroViewController alloc] init];
    [self.navigationController pushViewController:firstVC animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.findBtn.userInteractionEnabled = YES;
}


#pragma mark - TEST
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self beginAnmation];
//}



@end
