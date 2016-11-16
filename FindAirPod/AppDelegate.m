//
//  AppDelegate.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/9.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"
#import "HomeViewController.h"
#import "MapMainViewController.h"
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "NewHomeViewController.h"


@interface AppDelegate ()

@property(nonatomic,strong) MMDrawerController * drawerController;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //UMeng
    UMConfigInstance.appKey = UMengKey;
    UMConfigInstance.channelId = @"App Store";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！

    //设置根视图
    [self setRootViewController];
    return YES;
}

- (void)setRootViewController{
    
    //  判断是否有发布信息
    UIViewController *VC = [[UIViewController alloc] init];
    
    if ([VC checkHasLogin]) {
        //  有发布信息
        [self showMapVC];
    }else{
        //  没有发布信息
        [self showHomeVC];
    }
}

#pragma mark - public
- (void)showMapVC{
    //  主地图界面
    MapMainViewController *mapVC = [[MapMainViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mapVC];
    navVC.navigationBar.translucent = NO;
    
    //  左侧栏
    LeftViewController *leftVC = [[LeftViewController alloc] init];
    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:navVC leftDrawerViewController:leftVC];
    
    //  设置打开/关闭抽屉的手势
    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    
    //  左侧最大距离
    self.drawerController.maximumLeftDrawerWidth = maxLeftWidth;
    
    self.window.rootViewController = self.drawerController;
}

- (void)showHomeVC{
    NewHomeViewController *homeVC = [[NewHomeViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    navVC.navigationBar.translucent = NO;
    self.window.rootViewController = navVC;
}



@end
