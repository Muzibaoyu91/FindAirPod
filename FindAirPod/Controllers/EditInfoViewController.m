//
//  EditInfoViewController.m
//  FindAirPod
//
//  Created by Baoyu on 16/10/1.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "EditInfoViewController.h"
#import "MainModel.h"
#import "BaoyNSURLRequest.h"
#import "UIViewController+MMDrawerController.h"
#import "LeftViewController.h"



#define optionFont  19

#define textFieldTag    1000

@interface EditInfoViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) BaoyNSURLRequest *request;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *whichBtnes;

@property (nonatomic, strong) NSMutableArray *genderBtnes;

@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UITextField *wechatTextField;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation EditInfoViewController

- (BaoyNSURLRequest *)request{
    if (!_request) {
        _request = [[BaoyNSURLRequest alloc] init];
    }
    return _request;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64)];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (NSMutableArray *)whichBtnes{
    if (!_whichBtnes) {
        _whichBtnes = [NSMutableArray array];
    }
    return _whichBtnes;
}

- (NSMutableArray *)genderBtnes{
    if (!_genderBtnes) {
        _genderBtnes = [NSMutableArray array];
    }
    return _genderBtnes;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadContentView];
    
}


#pragma mark - UI
- (void)loadContentView{
    
    //  0.
    self.title = @"编辑详细信息";
    [self addLeftBackButton];
    [self addRightSaveButton];
    self.view.backgroundColor = RGB(245, 245, 245);

    //  1.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 40)];
    titleLabel.text = @"需求";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = color_TestGray;
    [self.scrollView addSubview:titleLabel];
    
    //  2.
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 10, (kScreenW -20)/2.f, 30)];
    [leftBtn setTitle:@"左耳" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(whichBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:optionFont];
    [self.scrollView addSubview:leftBtn];
    [self.whichBtnes addObject:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/2.f, CGRectGetMinY(leftBtn.frame), (kScreenW -20)/2.f, 30)];
    [rightBtn setTitle:@"右耳" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(whichBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:optionFont];
    [self.scrollView addSubview:rightBtn];
    [self.whichBtnes addObject:rightBtn];
    
    [self addLineLabelWithY:CGRectGetMaxY(rightBtn.frame) + 10];
    
    if ([self.mainModel.which isEqualToString:@"left"]) {
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:color_TestGray forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:optionFont];
    }else if ([self.mainModel.which isEqualToString:@"right"]){
        [leftBtn setTitleColor:color_TestGray forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:optionFont];
    }
    
    
    
    //3.
    UILabel *personLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(leftBtn.frame) + 25, kScreenW, 40)];
    personLabel.textAlignment = NSTextAlignmentCenter;
    personLabel.text = @"个人信息";
    personLabel.font = [UIFont systemFontOfSize:18];
    personLabel.textColor = color_TestGray;
    [self.scrollView addSubview:personLabel];
    
    UIButton *maleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(personLabel.frame) + 10, (kScreenW -20)/2.f, 30)];
    [maleBtn setTitle:@"男生" forState:UIControlStateNormal];
    [maleBtn addTarget:self action:@selector(genderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    maleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:optionFont];
    [self.scrollView addSubview:maleBtn];
    [self.genderBtnes addObject:maleBtn];
    
    
    UIButton *femaleBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/2.f, CGRectGetMinY(maleBtn.frame), (kScreenW -20)/2.f, 30)];
    [femaleBtn setTitle:@"女生" forState:UIControlStateNormal];
    [femaleBtn addTarget:self action:@selector(genderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:femaleBtn];
    femaleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:optionFont];
    [self.genderBtnes addObject:femaleBtn];
    
    [self addLineLabelWithY:CGRectGetMaxY(femaleBtn.frame)+10];
    
    if ([self.mainModel.gender isEqualToString:@"male"]) {
        self.mainModel.gender = @"male";
        [maleBtn setTitleColor:color_maleBlue forState:UIControlStateNormal];
        [femaleBtn setTitleColor:color_TestGray forState:UIControlStateNormal];
    }else if ([self.mainModel.gender isEqualToString:@"female"]){
        self.mainModel.gender = @"female";
        [femaleBtn setTitleColor:color_femalePink forState:UIControlStateNormal];
        [maleBtn setTitleColor:color_TestGray forState:UIControlStateNormal];
    }
    
    
    // 4.
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(femaleBtn.frame) + 35, 100, 30)];
    nameLabel.font = [UIFont systemFontOfSize:optionFont];
    nameLabel.text = @"姓名";
    nameLabel.textColor = color_TestGray;
    [self.scrollView addSubview:nameLabel];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(130, CGRectGetMinY(nameLabel.frame), kScreenW - 30 - 130, 30)];
    self.nameTextField.text = self.mainModel.title;
    self.nameTextField.textAlignment = NSTextAlignmentRight;
    self.nameTextField.font = [UIFont systemFontOfSize:optionFont -1];
    self.nameTextField.returnKeyType = UIReturnKeyDone;
    self.nameTextField.tag = textFieldTag;
    [self.scrollView addSubview:self.nameTextField];
    self.nameTextField.delegate = self;
    
    [self addLineLabelWithY:CGRectGetMaxY(self.nameTextField.frame)+10];
    
    //  5.
    UILabel *wechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(nameLabel.frame) + 30, 100, 30)];
    wechatLabel.font = [UIFont systemFontOfSize:optionFont];
    wechatLabel.text = @"微信";
    wechatLabel.textColor = color_TestGray;
    [self.scrollView addSubview:wechatLabel];
    
    self.wechatTextField = [[UITextField alloc] initWithFrame:CGRectMake(130, CGRectGetMinY(wechatLabel.frame), kScreenW - 30 -130, 30)];
    self.wechatTextField.text = self.mainModel.wechat;
    self.wechatTextField.textAlignment = NSTextAlignmentRight;
    self.wechatTextField.returnKeyType = UIReturnKeyDone;
    self.wechatTextField.font = [UIFont systemFontOfSize:optionFont -2];
    self.wechatTextField.tag = textFieldTag + 1;
    [self.scrollView addSubview:self.wechatTextField];
    self.wechatTextField.delegate = self;
    [self addLineLabelWithY:CGRectGetMaxY(self.wechatTextField.frame) +10];
    
    
    //6.
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.wechatTextField.frame) + 30, kScreenW, 30)];
    descLabel.text = @"简介";
    descLabel.font = [UIFont systemFontOfSize:18];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = color_TestGray;
    [self.scrollView addSubview:descLabel];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(descLabel.frame) + 10, kScreenW - 2*30, 80)];
    self.textView.text = self.mainModel.desc;
    [self.scrollView addSubview:self.textView];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:optionFont - 2];
    self.textView.backgroundColor = RGB(245, 245, 245);
    self.textView.returnKeyType = UIReturnKeyDone;
    [self addLineLabelWithY:CGRectGetMaxY(self.textView.frame) + 10];
    
    
}


- (void)addLineLabelWithY:(CGFloat)labelY{
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, labelY, kScreenW - 60, 1)];
    lineLabel.backgroundColor = color_QuoteBgGray;
    [self.scrollView addSubview:lineLabel];
}

#pragma mark - function
- (void)addRightSaveButton{
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)rightBtnAction:(UIButton *)btn{
    if (self.nameTextField.text.length>=11) {
        [self showErrorHUDWithTitle:@"姓名长度不超过10个字符"];
        return;
    }
    
    if (self.wechatTextField.text.length >= 20) {
        [self showErrorHUDWithTitle:@"请输入正确的微信格式"];
        return;
    }
    
    
    self.hud = [self creatLoadingHUD];
    
    NSString *url = [NSString stringWithFormat:@"%@%@loc/%@",kAppSeverHome_API,kVersion_API,self.mainModel.ID];
    NSDictionary *paramerts = @{
                                @"ID":self.mainModel.ID,
                                @"title":self.nameTextField.text,
                                @"desc":self.textView.text,
                                @"wechat":self.wechatTextField.text,
                                @"lat":@(self.mainModel.lat),
                                @"lng":@(self.mainModel.lng),
                                @"gender":self.mainModel.gender,
                                @"which":self.mainModel.which
                                };
    
    
    
    [self.request Put:url parameters:paramerts progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        kDebugLog(@"编辑成功");
        
        [self deleteUeserInfoDic];
        [self saveUserLoginInfoWithDic:responseObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud hide:YES];
            [self showSuccessHUDWithTitle:@"编辑成功"];
            
            
            LeftViewController *leftVC = (LeftViewController *)self.mm_drawerController.leftDrawerViewController;
            [leftVC reloadData];
            
            
            
            
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 两秒钟之后, 停止活动
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            });
        });
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        kDebugLog(@"编辑失败%@",error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud hide:YES];
            [self showErrorHUDWithTitle:@"上传失败"];
        });
        
        
    }];
    
    
}

- (void)whichBtnAction:(UIButton *)btn{
    for (UIButton *btn in self.whichBtnes) {
        [btn setTitleColor:color_TestGray forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:optionFont];
    }
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:optionFont];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([btn.titleLabel.text isEqualToString:@"左耳"]) {
        self.mainModel.which = @"left";
    }else{
        self.mainModel.which = @"right";
    }
}

- (void)genderBtnAction:(UIButton *)btn{
    for (UIButton *btn in self.genderBtnes) {
        [btn setTitleColor:color_TestGray forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:optionFont];
    }
    
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:optionFont];
    
    NSString *btnTitle = btn.titleLabel.text;
    if ([btnTitle isEqualToString:@"男生"]) {
        [btn setTitleColor:color_maleBlue forState:UIControlStateNormal];
        self.mainModel.gender = @"male";
    }else if ([btnTitle isEqualToString:@"女生"]){
        [btn setTitleColor:color_femalePink forState:UIControlStateNormal];
        self.mainModel.gender = @"female";
    }
}



#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    CGFloat nowY = CGRectGetMaxY(textField.frame);
    
    if (nowY > kScreenH - 64 - 252) {
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, (nowY -(kScreenH -64 -252))+15);
        }];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSInteger tag = textField.tag - textFieldTag;
    
    if (tag == 0) {
        if (self.nameTextField.text.length>=11) {
            [self showErrorHUDWithTitle:@"姓名长度不超过10个字符"];
            return YES;
        }
        [self.nameTextField resignFirstResponder];
    }else if (tag == 1){
        if (self.wechatTextField.text.length >= 20) {
            [self showErrorHUDWithTitle:@"请输入正确的微信格式"];
            return YES;
        }
        [self.wechatTextField resignFirstResponder];
    }

    return YES;
}


#pragma mark - textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    CGFloat nowY = CGRectGetMaxY(textView.frame);
    if (nowY > kScreenH - 64 - 252) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, (nowY -(kScreenH -64 -252)+30));
        }];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length > 50) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 50)];
        [self showErrorHUDWithTitle:@"简介不能超过50个字符"];
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
        return YES;
    }
    return YES;
}




@end
