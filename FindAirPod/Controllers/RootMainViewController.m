//
//  RootMainViewController.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/9.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "RootMainViewController.h"

@interface RootMainViewController ()

@property (nonatomic, strong) UIImageView *navBarHairlineImageView;

@property (nonatomic, strong) UIButton *keyboardContinueBtn;

@end

@implementation RootMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];

}

//TEST
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navBarHairlineImageView.hidden = NO;
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - public
- (void)addLeftBackButton{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [backBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)addContinueButton{
    //3.继续按钮
    self.continueBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    [self.continueBtn setTitle:@"继续" forState:UIControlStateNormal];
    self.continueBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self changeContinueBtnCanUse:NO];
    [self.continueBtn addTarget:self action:@selector(rightContinueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.continueBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)rightContinueBtnAction:(UIButton *)btn{
    
}


- (void)changeContinueBtnCanUse:(BOOL)canUse{
    if (canUse) {
        //  可用
        [self.continueBtn setTitleColor:color_SuccessGreen forState:UIControlStateNormal];
        self.continueBtn.userInteractionEnabled = YES;
        
        [self.keyboardContinueBtn setImage:[UIImage imageNamed:@"icon_next_normal"] forState:UIControlStateNormal];
        self.keyboardContinueBtn.userInteractionEnabled = YES;
        
    }else{
        //  不可用
        [self.continueBtn setTitleColor:color_QuoteBgGray forState:UIControlStateNormal];
        self.continueBtn.userInteractionEnabled = NO;
        
        [self.keyboardContinueBtn setImage:[UIImage imageNamed:@"icon_next_disabled"] forState:UIControlStateNormal];
        self.keyboardContinueBtn.userInteractionEnabled = NO;
 
    }
}


- (void)leftBackButtonAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

//监听键盘
- (void)addNSNotificationToKeyboard{
    CGFloat btnSide = 38;
    if (kIsScreen5_5) {
        btnSide = 46;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide) name:UIKeyboardWillHideNotification object:nil];

    self.keyboardContinueBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - btnSide - 20, kScreenH - 64 - 10 - btnSide, btnSide, btnSide)];
    [self changeContinueBtnCanUse:NO];
    [self.keyboardContinueBtn addTarget:self action:@selector(rightContinueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.keyboardContinueBtn.layer.cornerRadius = btnSide/2.f;
    [self.view addSubview:self.keyboardContinueBtn];

}

//键盘出现
-(void)keyBoard:(NSNotification*)noti{
    
    //    通过字典 获取到 键盘的结束高度
    NSValue *frameValue = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect rect = [frameValue CGRectValue];
    
    CGFloat height = rect.size.height;
    

    //    通过字典 获取到 键盘的显示时上弹动画的时间
    
    
    
    NSNumber *number = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:[number doubleValue] animations:^{
        //        _scrollView.contentOffset = CGPointMake(0, _scrollView.contentSize.height-_scrollView.height+height);
        CGFloat btnSide = self.keyboardContinueBtn.frame.size.height;
        self.keyboardContinueBtn.frame = CGRectMake(self.keyboardContinueBtn.frame.origin.x, kScreenH - btnSide - 10 -height -64, btnSide, btnSide);
    }];
    
}

//键盘消失
-(void)keyBoardHide{

    [UIView animateWithDuration:0.2 animations:^{
        //        _scrollView.contentOffset = CGPointMake(0, _scrollView.contentSize.height-_scrollView.height+height);
        CGFloat btnSide = self.keyboardContinueBtn.frame.size.height;
        self.keyboardContinueBtn.frame = CGRectMake(kScreenW - btnSide - 20, kScreenH - 64 - 10 - btnSide, btnSide, btnSide);
    }];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}




@end
