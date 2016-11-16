//
//  UIViewController+Login.h
//  FindAirPod
//
//  Created by Baoyu on 16/9/23.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Login)

/**
 *  检查是否登录
 *
 *  @return YES：登录了， NO：没有登录
 */
- (BOOL)checkHasLogin;

/**
 *  存入用户登录信息
 */
- (BOOL)saveUserLoginInfoWithDic:(NSDictionary *)infoDic;

/**
 *  读取用户登录信息
 */
- (NSDictionary *)getUserLoginInfoDic;

/**
 *  删除用户登录信息
 */

- (BOOL)deleteUeserInfoDic;


@end
