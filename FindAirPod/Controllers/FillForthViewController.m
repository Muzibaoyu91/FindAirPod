//
//  FillForthViewController.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/27.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "FillForthViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MainModel.h"
#import "AppDelegate.h"


@interface FillForthViewController ()<UITextFieldDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIImageView *stateImgView;

@property (nonatomic, strong) UILabel *showLabel;

@property (nonatomic, strong) MainModel *mainModel;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) BaoyNSURLRequest *request;

@end

@implementation FillForthViewController

- (BaoyNSURLRequest *)request{
    if (!_request) {
        _request = [[BaoyNSURLRequest alloc] init];
    }
    return _request;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContentView];
    
    [self requestData];
}

#pragma mark - UI
- (void)loadContentView{
    CGFloat labelHeight = 120;
    CGFloat maginX = 20;
    CGFloat imgSide = 20;
    
    //0.
    self.title = @"5/5";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLeftBackButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maginX, 0, kScreenW - maginX*2, labelHeight)];
    titleLabel.text = @"最后，留下一个您的联系方式（微信）并打开定位服务";
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont boldSystemFontOfSize:bigTitleFont];
    titleLabel.textColor = color_mainColor;
    [self.view addSubview:titleLabel];
    
    //2.textField
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(maginX, CGRectGetMaxY(titleLabel.frame), kScreenW - maginX - imgSide*2, labelHeight/2.f)];
    [self.textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    self.textField.delegate = self;
    self.textField.font = [UIFont systemFontOfSize:18];
    self.textField.placeholder = @"微信";
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
    self.showLabel.text = @"    请输入正确的微信号";
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
    [self.demandDic setObject:self.textField.text forKey:@"wechat"];
    
    [self requestData];
    
    //  检测没有获取定位
    if (![self.demandDic objectForKey:@"lng"]) {
        [self pushToiPhoneSetting];
        return;
    }
    
    __autoreleasing NSError *error = nil;
    self.mainModel = [[MainModel alloc] initWithDictionary:self.demandDic error:&error];
    if (error) {
        kDebugLog(@"解析字典错误：%@",error);
        return;
    }
    
    NSString *which;
    if ([self.mainModel.which isEqualToString:@"left"]) {
        //  左耳
        which = @"左";
    }else if ([self.mainModel.which isEqualToString:@"right"]){
        //  右耳
        which = @"右";
    }else if ([self.mainModel.which isEqualToString:@"both"]){
        //  一对
        which = @"一对";
    }
    
    
    NSString *gender;
    if ([self.mainModel.gender isEqualToString:@"male"]) {
        gender = @"男";
    }else if ([self.mainModel.gender isEqualToString:@"female"]){
        gender = @"女";
    }else if ([self.mainModel.gender isEqualToString:@"unknow"]){
        gender = @"保密";
    }
    
    [self.view endEditing:NO];
    
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"发布信息" message:[NSString stringWithFormat:@"姓名：\t%@\n需求：\t%@\n性别：\t%@\n介绍：\t%@\n微信：\t%@",self.mainModel.title,which,gender,self.mainModel.desc,self.mainModel.wechat] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //  先loading
        self.hud = [self creatLoadingHUD];
        
        NSString *url = [NSString stringWithFormat:@"%@%@loc",kAppSeverHome_API,kVersion_API];
        
        [self.request POST:url parameters:self.demandDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            kDebugLog(@"上传成功");
            kDebugLog(@"%@",responseObject);
            
            //  存入本地
            [self saveUserLoginInfoWithDic:responseObject];
            
            //  跳转到map
            [self pushToMapVC];
            
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            kDebugLog(@"上传失败%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hide:YES];
                [self showErrorHUDWithTitle:@"上传失败"];
            });
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:sureAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
    
    

    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)textFieldDidChange{
    [self judgeTheTextFiledText];
}

- (void)judgeTheTextFiledText{
    if (!NULLString(self.textField.text) && self.textField.text.length <=35) {
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


#pragma mark - function
- (void)requestData{
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        [self pushToiPhoneSetting];
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}

- (void)pushToMapVC{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate showMapVC];
}

- (void)pushToiPhoneSetting{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"打开定位开关" message:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关，并允许我们使用定位服务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:sureAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
    
    
    
}


#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    
    [self.demandDic setObject:@(coordinate.longitude) forKey:@"lng"];
    [self.demandDic setObject:@(coordinate.latitude) forKey:@"lat"];
}




@end
