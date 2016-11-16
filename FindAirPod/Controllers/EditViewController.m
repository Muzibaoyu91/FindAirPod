//
//  EditViewController.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/30.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "EditViewController.h"
#import "MainModel.h"
#import "AppDelegate.h"
#import "EditInfoViewController.h"
#import "BaoyNSURLRequest.h"
#import "UIViewController+HUDManager.h"
#import "EditInfoViewController.h"

#define maginX 20
#define cellHeight  80

@interface EditViewController ()

@property (nonatomic, strong) MainModel *mainModel;

@property (nonatomic, strong) BaoyNSURLRequest *urlRequest;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation EditViewController

- (BaoyNSURLRequest *)urlRequest{
    if (!_urlRequest) {
        _urlRequest = [[BaoyNSURLRequest alloc] init];
    }
    return _urlRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    
    [self loadContentView];
}


#pragma mark - UI
- (void)loadContentView{
    //0.
    [self addLeftBackButton];
    [self addRightBtn];
    
    self.title = @"我的信息";
    self.view.backgroundColor = RGB(245, 245, 245);

    
    //1.
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(maginX, 20, kScreenW - maginX*2, cellHeight)];
    nameLabel.font = [UIFont boldSystemFontOfSize:bigTitleFont];
    nameLabel.text = self.mainModel.title;
    [self.view addSubview:nameLabel];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(maginX, CGRectGetMaxY(nameLabel.frame) +10, 50, 1)];
    lineLabel.backgroundColor = color_QuoteBgGray;
    [self.view addSubview:lineLabel];
    
    //2.
    NSString *which;
    if ([self.mainModel.which isEqualToString:@"left"]) {
        which = @"左";
    }else if([self.mainModel.which isEqualToString:@"right"]){
        which = @"右";
    }else if ([self.mainModel.which isEqualToString:@"both"]){
        which = @"一对";
    }
    UIImage *img_0 = [UIImage imageNamed:@"icon_headset"];
    [self creatLabelWithTitle:which withColor:color_TestGray withImg:img_0 withRow:0];
    
    
    NSString *gender;
    UIColor *color_1;
    if ([self.mainModel.gender isEqualToString:@"male"]) {
        gender = @"男";
        color_1 = color_maleBlue;
    }else if ([self.mainModel.gender isEqualToString:@"female"]){
        gender = @"女";
        color_1 = color_femalePink;
    }else if ([self.mainModel.gender isEqualToString:@"unknown"]){
        gender = @"保密";
        color_1 = color_TestGray;
    }
    UIImage *img_1 = [UIImage imageNamed:@"icon_gender"];
    [self creatLabelWithTitle:gender withColor:color_1 withImg:img_1 withRow:1];
    
    
    NSString *wechat = self.mainModel.wechat;
    UIImage *img_2 = [UIImage imageNamed:@"icon_wechat"];
    [self creatLabelWithTitle:wechat withColor:color_TestGray withImg:img_2 withRow:2];
    
    NSString *desc = self.mainModel.desc;
    [self creatLabelWithTitle:desc withColor:color_TestGray withImg:nil withRow:3];
    
    
    
}

- (UILabel *)creatLabelWithTitle:(NSString *)title withColor:(UIColor *)color withImg:(UIImage *)img withRow:(NSInteger)row{
    
    if (row == 3) {
        UILabel *label_0 = [[UILabel alloc] initWithFrame:CGRectMake(maginX, 40 + cellHeight + row * cellHeight, 100, 50)];
        label_0.text = @"简介";
        label_0.font = [UIFont systemFontOfSize:15];
        label_0.textColor = RGB(170, 170, 170);
        [self.view addSubview:label_0];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(maginX, 40 + cellHeight + row * cellHeight, kScreenW - 2*maginX, cellHeight)];
    
    if (row == 3) {
        
        label.frame = CGRectMake(maginX, 40 + cellHeight + row * cellHeight + 30, kScreenW - 2*maginX, cellHeight + 20);
        
    }
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(maginX, CGRectGetMaxY(label.frame), kScreenW - 2*maginX, 1)];
    
    label.textColor = color;
    
    label.numberOfLines = 4;
    
    label.text = title;
    
    label.font = [UIFont systemFontOfSize:20];
    
    if (row == 3) {
        
        label.font = [UIFont systemFontOfSize:16];
        
    }
    
    CGFloat iconSide = 32;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(label.frame) - iconSide, (cellHeight - iconSide)/2.f, iconSide, iconSide)];
    
    imgView.image = img;
    
    [label addSubview:imgView];
    
    lineLabel.backgroundColor = color_QuoteBgGray;
    
    [self.view addSubview:label];
    
    [self.view addSubview:lineLabel];
    
    return label;
    
}

- (void)addRightBtn{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [btn setImage:[UIImage imageNamed:@"commmon_nav_btn_back_n"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBtnAction:(UIButton *)btn{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        EditInfoViewController *infoVC = [[EditInfoViewController alloc] init];
        infoVC.mainModel = self.mainModel;
        [self.navigationController pushViewController:infoVC animated:YES];
        
        
    }];
    UIAlertAction *deleAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定删除您发布的信息？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *url = [NSString stringWithFormat:@"%@%@loc/%@",kAppSeverHome_API,kVersion_API,self.mainModel.ID];
            
            self.hud = [self creatLoadingHUD];
            
            NSDictionary *parameters = @{
                                         @"id":self.mainModel.ID
                                         };
            
            [self.urlRequest Delet:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
                kDebugLog(@"服务器删除成功");
                
                if ([self deleteUeserInfoDic]) {
                    
                    //  删除成功
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.hud hide:YES];
                        
                        [self showSuccessHUDWithTitle:@"删除成功！"];
                        
                        
                        
                        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
                        
                        [delegate performSelector:@selector(showHomeVC) withObject:nil afterDelay:1.5f];
                        
                    });
                    
                }else{
                    
                    //  删除失败
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.hud hide:YES];
                        
                        [self showErrorHUDWithTitle:@"删除失败"];
                        
                    });
                    
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                kDebugLog(@"删除信息失败:%@",error);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.hud hide:YES];
                    
                    [self showErrorHUDWithTitle:@"删除失败"];
                    
                });
            }];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:sureAction];
        [alertC addAction:cancelAction];
        [self presentViewController:alertC animated:YES completion:nil];
        

        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:editAction];
    [alertC addAction:deleAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
    
    
}

#pragma mark - function
- (void)requestData{
    NSDictionary *dic = [self getUserLoginInfoDic];
    self.mainModel = [[MainModel alloc] initWithDictionary:dic error:nil];
}


@end
