//
//  FillThirdViewController.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/27.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "FillThirdViewController.h"
#import "FillForthViewController.h"

#define baseBtnTag  1000

@interface FillThirdViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIImageView *stateImgView;

@property (nonatomic, strong) UILabel *showLabel;

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, copy) NSString *gender;

@end

@implementation FillThirdViewController

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContentView];
}

#pragma mark - UI
- (void)loadContentView{
    CGFloat labelHeight = 80;
    CGFloat maginX = 20;
    
    //0.
    self.title = @"4/5";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLeftBackButton];
    
    //1.label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maginX, 0, kScreenW - maginX, labelHeight)];
    titleLabel.text = @"您的性别？";
    titleLabel.font = [UIFont boldSystemFontOfSize:bigTitleFont];
    titleLabel.textColor = color_mainColor;
    [self.view addSubview:titleLabel];
    
    //1.1subLable
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(maginX, CGRectGetMaxY(titleLabel.frame) - 20, kScreenW - maginX*2, labelHeight)];
    subLabel.textColor = color_TestGray;
    subLabel.text = @"请选择您的性别。";
    subLabel.font = [UIFont systemFontOfSize:18];
    subLabel.numberOfLines = 2;
    [self.view addSubview:subLabel];
    
    //2.continueBtn
    CGFloat btnSide = 38;
    if (kIsScreen5_5) {
        btnSide = 46;
    }
    UIButton *continueBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - btnSide - 20, kScreenH - 64 - 10 - btnSide, btnSide, btnSide)];
    [continueBtn setImage:[UIImage imageNamed:@"icon_next_normal"] forState:UIControlStateNormal];
    [continueBtn addTarget:self action:@selector(rightContinueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueBtn];
    
    //3.三个btn
    NSArray *names = @[
                       @"男",
                       @"女"
                       ];
    CGFloat btnWidth = 110;
    CGFloat btnHeight = 50;
    for (int i = 0; i<names.count; i++) {
        CGFloat originY = CGRectGetMaxY(subLabel.frame) + 20;
        [self creatGenderBtnWithTitle:names[i] withTag:i + baseBtnTag withFrame:CGRectMake(maginX, originY + i*(22 + btnHeight), btnWidth, btnHeight)];
    }
    [self selectBtnWithTag:0 + baseBtnTag];
    
    
}
- (void)rightContinueBtnAction:(UIButton *)btn{
    [self.demandDic setObject:self.gender forKey:@"gender"];
    FillForthViewController *forthVC = [[FillForthViewController alloc] init];
    forthVC.demandDic = self.demandDic;
    [self.navigationController pushViewController:forthVC animated:YES];
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

- (UIButton *)creatGenderBtnWithTitle:(NSString *)title withTag:(NSInteger)tag withFrame:(CGRect)frame{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color_mainColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = frame.size.height/2.f;
    btn.layer.borderColor = color_mainColor.CGColor;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:bigTitleFont -6];
    btn.layer.borderWidth = 2;
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnArray addObject:btn];
    [self.view addSubview:btn];
    return btn;
}

- (void)btnAction:(UIButton *)btn{
    [self selectBtnWithTag:btn.tag];
}

- (void)selectBtnWithTag:(NSInteger)tag{
    
    for (UIButton *btn in self.btnArray) {
        if (btn.tag == tag) {
            btn.backgroundColor = color_mainColor;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:color_mainColor forState:UIControlStateNormal];
        }
    }
    
    if (tag - baseBtnTag == 0) {
        self.gender = @"male";
    }else if (tag - baseBtnTag == 1){
        self.gender = @"female";
    }else if (tag - baseBtnTag == 2){
        self.gender = @"unknow";
    }
    
    kDebugLog(@"现在选择的是:%@",self.gender);
    
}

- (void)changeImgWith:(BOOL)success{
    if (success) {
        self.stateImgView.image = [UIImage imageNamed:@"success"];
    }else{
        self.stateImgView.image = [UIImage imageNamed:@"warning"];
    }
}


@end
