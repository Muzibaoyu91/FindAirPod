//
//  FillSecondViewController.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/13.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "FillSecondViewController.h"
#import "FillThirdViewController.h"

@interface FillSecondViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIImageView *stateImgView;

@property (nonatomic, strong) UILabel *showLabel;


@end

@implementation FillSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContentView];
}

#pragma mark - UI
- (void)loadContentView{
    CGFloat labelHeight = 80;
    CGFloat maginX = 20;
    CGFloat imgSide = 20;
    
    //0.
    self.title = @"3/5";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLeftBackButton];
    
    //1.label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maginX, 0, kScreenW - maginX, labelHeight)];
    titleLabel.text = @"介绍一下你自己";
    titleLabel.font = [UIFont boldSystemFontOfSize:bigTitleFont];
    titleLabel.textColor = color_mainColor;
    [self.view addSubview:titleLabel];
    
    //1.1subLable
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(maginX, CGRectGetMaxY(titleLabel.frame) - 20, kScreenW - maginX*2, labelHeight)];
    subLabel.textColor = color_TestGray;
    subLabel.text = @"例如：我有一个左耳无线耳机，怎样找到有右耳的你呢？";
    subLabel.font = [UIFont systemFontOfSize:18];
    subLabel.numberOfLines = 2;
    [self.view addSubview:subLabel];
    
    //2.textField
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(maginX, CGRectGetMaxY(subLabel.frame), kScreenW - maginX - imgSide*2, labelHeight/2.f)];
    [self.textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    self.textField.delegate = self;
    self.textField.font = [UIFont systemFontOfSize:18];
    self.textField.placeholder = @"自我介绍";
    [self.view addSubview:self.textField];
    
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(maginX, CGRectGetMaxY(self.textField.frame) + 2, kScreenW - maginX*2, 1)];
    [self.textField becomeFirstResponder];
    lineLabel.backgroundColor = color_QuoteBgGray;
    [self.view addSubview:lineLabel];
    
    self.showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineLabel.frame), kScreenW, 35)];
    self.showLabel.backgroundColor = color_DangerRed;
    self.showLabel.textColor = [UIColor whiteColor];
    self.showLabel.font = [UIFont systemFontOfSize:14];
    self.showLabel.hidden = YES;
    self.showLabel.text = @"   你的介绍不能多于50个字符";
    [self.view addSubview:self.showLabel];
    
    
    //3.stateImgView
    self.stateImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - imgSide - maginX, self.textField.center.y - imgSide/2.f, imgSide, imgSide)];
    [self.view addSubview:self.stateImgView];
    
    //4.继续按钮
    //    [self addContinueButton];
    
    
    //5.键盘上的继续按钮
    [self addNSNotificationToKeyboard];
}
- (void)rightContinueBtnAction:(UIButton *)btn{
    [self.demandDic setObject:self.textField.text forKey:@"desc"];
    FillThirdViewController *thirdVC = [[FillThirdViewController alloc] init];
    thirdVC.demandDic = self.demandDic;
    [self.navigationController pushViewController:thirdVC animated:YES];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)textFieldDidChange{
    [self judgeTheTextFiledText];
}

- (void)judgeTheTextFiledText{
    if (!NULLString(self.textField.text) && self.textField.text.length <=50) {
        [self changeContinueBtnCanUse:YES];
        [self changeImgWith:YES];
        self.textField.textColor = [UIColor blackColor];
        self.showLabel.hidden = YES;
    }else{
        [self changeContinueBtnCanUse:NO];
        [self changeImgWith:NO];
        self.showLabel.hidden = NO;
        self.textField.textColor = color_DangerRed;
    }
    
    if (NULLString(self.textField.text)) {
        self.stateImgView.image = nil;
        self.showLabel.hidden = YES;
    }
    
}

- (void)changeImgWith:(BOOL)success{
    if (success) {
        self.stateImgView.image = [UIImage imageNamed:@"success"];
    }else{
        self.stateImgView.image = [UIImage imageNamed:@"warning"];
    }
}





@end
