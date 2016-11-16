//
//  FillZeroViewController.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/28.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "FillZeroViewController.h"
#import "FillFirstViewController.h"

#define baseBtnTag  1000


@interface FillZeroViewController ()

@property (nonatomic, strong) NSMutableArray *btnArray;
//  left right both
@property (nonatomic, copy) NSString *which;


@end

@implementation FillZeroViewController

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContentView];
    
    [self requestData];

}

#pragma mark - UI
- (void)loadContentView{
    CGFloat labelHeight = 80;
    CGFloat maginX = 20;
    
    //0.
    self.title = @"1/5";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLeftBackButton];
    
    //1.label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maginX, 0, kScreenW - maginX, labelHeight)];
    titleLabel.text = @"您在寻找无线耳机？";
    titleLabel.font = [UIFont boldSystemFontOfSize:bigTitleFont];
    titleLabel.textColor = color_mainColor;
    [self.view addSubview:titleLabel];
    
    
    //2.continueBtn
    CGFloat btnSide = 38;
    if (kIsScreen5_5) {
        btnSide = 46;
    }
    UIButton *continueBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - btnSide - 20, kScreenH - 64 - 10 - btnSide, btnSide, btnSide)];
    [continueBtn setImage:[UIImage imageNamed:@"icon_next_normal"] forState:UIControlStateNormal];
    [continueBtn addTarget:self action:@selector(rightContinueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueBtn];
    
    //3.两个btn
    NSArray *names = @[
                       @"左耳",
                       @"右耳"
                       ];
    CGFloat btnWidth = 110;
    CGFloat btnHeight = 50;
    for (int i = 0; i<names.count; i++) {
        CGFloat originY = CGRectGetMaxY(titleLabel.frame) + 20;
        [self creatGenderBtnWithTitle:names[i] withTag:i + baseBtnTag withFrame:CGRectMake(maginX, originY + i*(22 + btnHeight), btnWidth, btnHeight)];
    }
    [self selectBtnWithTag:0 + baseBtnTag];
    
    
}
- (void)rightContinueBtnAction:(UIButton *)btn{
    [self.demandDic setObject:self.which forKey:@"which"];
    FillFirstViewController *forthVC = [[FillFirstViewController alloc] init];
    forthVC.demandDic = self.demandDic;
    [self.navigationController pushViewController:forthVC animated:YES];
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
        self.which = @"left";
    }else if (tag - baseBtnTag == 1){
        self.which = @"right";
    }else if (tag - baseBtnTag == 2){
        self.which = @"both";
    }
    kDebugLog(@"现在选择的是:%@",self.which);
}

#pragma mark - function
- (void)requestData{
    self.demandDic = [NSMutableDictionary dictionary];
}



@end
