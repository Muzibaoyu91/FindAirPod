//
//  MapMainViewController.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/9.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "MapMainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BaoyAnnotation.h"
#import "MainModel.h"
#import "mainMsgView.h"
#import "FilterView.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "pop.h"




@interface MapMainViewController ()<MKMapViewDelegate,mainMsgViewDelegate,FilterViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) mainMsgView *msgView;

@property (nonatomic, strong) FilterView *filterView;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) BaoyNSURLRequest *request;

@property (nonatomic, strong) NSMutableDictionary *currentDic;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL hasShow;


@end

@implementation MapMainViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableDictionary *)currentDic{
    if (!_currentDic) {
        _currentDic = [NSMutableDictionary dictionary];
    }
    return _currentDic;
}


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
    
    [self addLeftMenuBtn];
    
    [self initGUI];
    
    [self addMainMsgView];
    
    [self addRightFiltrateBtn];

    
}

- (void)addLeftMenuBtn{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [leftBtn setImage:[UIImage imageNamed:@"commmon_nav_btn_menu_n"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //设置打开抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)leftBtnAction:(UIButton *)btn{
    //这里的话是通过遍历循环拿到之前在AppDelegate中声明的那个MMDrawerController属性，然后判断是否为打开状态，如果是就关闭，否就是打开(初略解释，里面还有一些条件)
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)addMainMsgView{
    self.msgView = [[mainMsgView alloc] init];
    self.msgView.delegate = self;
    [self.view addSubview:self.msgView];
}

- (void)addRightFiltrateBtn{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [rightBtn setImage:[UIImage imageNamed:@"commmon_nav_btn_screen_n"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(showFiltarView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark 添加地图控件
-(void)initGUI{
    CGRect rect=[UIScreen mainScreen].bounds;
    _mapView=[[MKMapView alloc]initWithFrame:rect];
    [self.view addSubview:_mapView];
    //设置代理
    _mapView.delegate=self;
    
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        //  用户已经明确禁止应用使用定位服务或者当前系统定位服务处于关闭状态
        
        [self pushToiPhoneSetting];
    }else if([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //设置代理
    _locationManager.delegate=self;
    //设置定位精度
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance=10.0;//十米定位一次
    _locationManager.distanceFilter=distance;
    //启动跟踪定位
    [_locationManager startUpdatingLocation];
    
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
}

#pragma mark - function
- (void)requestData{
    //  获取数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *url = [NSString stringWithFormat:@"%@%@loc",kAppSeverHome_API,kVersion_API];
        
        if (![self.currentDic objectForKey:@"lat"]) {
            [self.currentDic setObject:@(116.321960) forKey:@"lng"];
            [self.currentDic setObject:@(37.452197) forKey:@"lat"];
        }
        
        NSDictionary *paramerts = @{
                                  @"lat":[self.currentDic objectForKey:@"lat"],
                                  @"lng":[self.currentDic objectForKey:@"lng"],
                                  @"dist":@(100000000)
                                  };
        
        [self.request Get:url parameters:paramerts progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            kDebugLog(@"Get成功:%@",responseObject);
            NSArray *responseArray = responseObject;
            for (NSDictionary *dic in responseArray) {
                MainModel *oneModel = [[MainModel alloc] initWithDictionary:dic error:nil];
                
                [self addAnnotationWithMainModel:oneModel];
            }
            
            
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            kDebugLog(@"Get失败:%@",error);
        }];
        
        
        
    });
    
    
   
    //TEST
//    MainModel *testModel = [[MainModel alloc] init];
//    testModel.ID = 0;
//    testModel.title = @"PinkShark";
//    testModel.desc = @"我觉得我的这个右耳和你的左耳很配哦,我们做个朋友吧，啊哈哈哈哈，你说呢，这有多少字了我也不知道。。。";
//    testModel.lat = 39.90498900;
//    testModel.lng = 116.40528500;
//    [self addAnnotationWithMainModel:testModel];
    
}

- (void)addAnnotationWithMainModel:(MainModel *)mainModel{
    CLLocationCoordinate2D loaction2D = CLLocationCoordinate2DMake(mainModel.lat, mainModel.lng);
    BaoyAnnotation *annotation=[[BaoyAnnotation alloc]init];
    annotation.title = mainModel.title;
    annotation.mainModel = mainModel;
    annotation.coordinate = loaction2D;
    [_mapView addAnnotation:annotation];
    [self.dataSource addObject:annotation];
    
}

- (void)showFiltarView{
    if (!self.filterView) {
        self.filterView = [[FilterView alloc] init];
        self.filterView.delegate = self;
        [self.view addSubview:self.filterView];
    }
    
    
    CGFloat height = self.filterView.frame.size.height;
    
    if (_hasShow) {
        [UIView animateWithDuration:0.2 animations:^{
            self.filterView.frame = CGRectMake(0, -height, kScreenW, height);
        }];
        
        
    }else{
        
        CGFloat Bounciness = 11;    //振动幅度
        CGFloat speed = 9;     //动画速度
        if (kIsScreen5_5) {
            speed = 16;
        }
        
        POPSpringAnimation *anSpring_logo = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        anSpring_logo.toValue = @(height/2.f);
        anSpring_logo.beginTime = CACurrentMediaTime();
        anSpring_logo.springBounciness = Bounciness;
        anSpring_logo.springSpeed = speed;
        [self.filterView pop_addAnimation:anSpring_logo forKey:@"position"];
        
        
    }
    
    _hasShow = !_hasShow;
    
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


#pragma mark - MKMapViewDelegate
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[BaoyAnnotation class]]) {
        
        
        BaoyAnnotation *baoyAnnotation = (BaoyAnnotation *)annotation;
        
        if ([baoyAnnotation.mainModel.gender isEqualToString:@"male"]) {
            //  男的
            
            if ([baoyAnnotation.mainModel.which isEqualToString:@"left"]) {
                //  左耳
                static NSString *key1 =@"AnnotationKey_maleLeft";
                return [self creatAnnotationViewWithKey:key1 Annotation:baoyAnnotation withImg:[UIImage imageNamed:@"left_man_n"]];
            }else{
                //  右耳
                static NSString *key2 =@"AnnotationKey_maleright";
                return [self creatAnnotationViewWithKey:key2 Annotation:baoyAnnotation withImg:[UIImage imageNamed:@"rignt_man_n"]];
            }
            
        }else{
            //  女的
            
            if ([baoyAnnotation.mainModel.which isEqualToString:@"left"]) {
                //  左耳
                static NSString *key3 =@"AnnotationKey_femaleLeft";
                return [self creatAnnotationViewWithKey:key3 Annotation:baoyAnnotation withImg:[UIImage imageNamed:@"left_woman_n"]];
            }else{
                //  右耳
                static NSString *key3 =@"AnnotationKey_femaleright";
                return [self creatAnnotationViewWithKey:key3 Annotation:baoyAnnotation withImg:[UIImage imageNamed:@"right_woman_n"]];
            }
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
//        static NSString *key1=@"AnnotationKey_maleLeft";
//        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
//        //如果缓存池中不存在则新建
//        if (!annotationView) {
//            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
//            annotationView.canShowCallout=true;//允许交互点击
//            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
//            
//            
//    
//            
//            
//            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test_blue.png"]];//定义详情左侧视图
//        }
//        
//        //修改大头针视图
//        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
//        annotationView.annotation=annotation;
//        annotationView.image= [UIImage imageNamed:@"test_blue.png"] ;//设置大头针视图的图片
//        
//        return annotationView;
    }else {
        return nil;
    }
}


- (MKAnnotationView *)creatAnnotationViewWithKey:(NSString *)key Annotation:(id<MKAnnotation>)annotation withImg:(UIImage *)img{
    MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key];
    //如果缓存池中不存在则新建
    if (!annotationView) {
        annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key];
        annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
        annotationView.canShowCallout=true;//允许交互点击

    }
    
    //修改大头针视图
    //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
    annotationView.annotation=annotation;
    annotationView.image= img ;//设置大头针视图的图片
    
    return annotationView;
}


//  点击选中某个大头针时触发
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    BaoyAnnotation *baoyAnnotation;
    if ([view.annotation isKindOfClass:[BaoyAnnotation class]]) {
         baoyAnnotation = (BaoyAnnotation *)view.annotation;
    }else{
        return;
    }
    
    

    
    
    if ([baoyAnnotation.mainModel.gender isEqualToString:@"male"]) {
        //  男的
        
        if ([baoyAnnotation.mainModel.which isEqualToString:@"left"]) {
            //  左耳
            view.image = [UIImage imageNamed:@"left_man_s"];
        }else{
            //  右耳
            view.image = [UIImage imageNamed:@"rignt_man_s"];
        }
        
    }else{
        //  女的
        
        if ([baoyAnnotation.mainModel.which isEqualToString:@"left"]) {
            //  左耳
            view.image = [UIImage imageNamed:@"left_woman_s"];
        }else{
            //  右耳
            view.image = [UIImage imageNamed:@"right_woman_s"];
        }
        
    }
    //  调整地图的中心点
    CLLocationCoordinate2D loaction2D = CLLocationCoordinate2DMake(baoyAnnotation.mainModel.lat, baoyAnnotation.mainModel.lng);
    [mapView setCenterCoordinate:loaction2D animated:YES];
    
    //弹出msg并赋值model
    self.msgView.mainModel = baoyAnnotation.mainModel;
    [self.msgView showWithViewController:self];
}

//  取消选中大头针时触发
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    BaoyAnnotation *baoyAnnotation;
    if ([view.annotation isKindOfClass:[BaoyAnnotation class]]) {
        baoyAnnotation = (BaoyAnnotation *)view.annotation;
    }else{
        return;
    }
    
    if ([baoyAnnotation.mainModel.gender isEqualToString:@"male"]) {
        //  男的
        
        if ([baoyAnnotation.mainModel.which isEqualToString:@"left"]) {
            //  左耳
            view.image = [UIImage imageNamed:@"left_man_n"];
        }else{
            //  右耳
            view.image = [UIImage imageNamed:@"rignt_man_n"];
        }
        
    }else{
        //  女的
        
        if ([baoyAnnotation.mainModel.which isEqualToString:@"left"]) {
            //  左耳
            view.image = [UIImage imageNamed:@"left_woman_n"];
        }else{
            //  右耳
            view.image = [UIImage imageNamed:@"right_woman_n"];
        }
        
    }
    
    [self.msgView dismisWithViewController:self];
}

#pragma mark - FilterViewDelegate
- (void)filtrateWithWhich:(NSString *)which withGender:(NSString *)gender{
    CGFloat height = self.filterView.frame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        self.filterView.frame = CGRectMake(0, -height, kScreenW, height);
    }];
    self.hasShow = NO;
    
    
    [self removeAllAnmation];
    
    [self addAllAnmation];
    
    if ([which isEqualToString:@"both"]) {
        
    }else if ([which isEqualToString:@"left"]){
        [self removeWithWhich:@"right"];
    }else if ([which isEqualToString:@"right"]){
        [self removeWithWhich:@"left"];
    }
    
    
    if ([gender isEqualToString:@"unknow"]) {
        
    }else if ([gender isEqualToString:@"male"]){
        [self removeWithGender:@"female"];
    }else if ([gender isEqualToString:@"female"]){
        [self removeWithGender:@"male"];
    }
    
}


- (void)removeAllAnmation{
    for (BaoyAnnotation *anmation in self.dataSource) {
        [_mapView removeAnnotation:anmation];
    }
}

- (void)addAllAnmation{
    for (BaoyAnnotation *annotation in self.dataSource) {
        [_mapView addAnnotation:annotation];
    }
}


- (void)removeWithWhich:(NSString *)which{
    for (BaoyAnnotation *anmation in self.dataSource) {
        if ([anmation.mainModel.which isEqualToString:which]) {
            [_mapView removeAnnotation:anmation];
        }
    }
}

- (void)removeWithGender:(NSString *)gender{
    for (BaoyAnnotation *anmation in self.dataSource) {
        if ([anmation.mainModel.gender isEqualToString:gender]) {
            [_mapView removeAnnotation:anmation];
        }
    }
}





#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    
    [self.currentDic setObject:@(coordinate.longitude) forKey:@"lng"];
    [self.currentDic setObject:@(coordinate.latitude) forKey:@"lat"];
}

@end
