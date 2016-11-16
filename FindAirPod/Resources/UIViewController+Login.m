//
//  UIViewController+Login.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/23.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "UIViewController+Login.h"

#define userInfoKey @"userInfoKey"


@implementation UIViewController (Login)

//  检测是否登录
- (BOOL)checkHasLogin{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [documentsDirectory stringByAppendingPathComponent:userInfoKey];
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary *infoDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (infoDic) {
        kDebugLog(@"本地有infoDic");
        return YES;
    }else{
        kDebugLog(@"本地没有infoDic");
        return NO;
        
    }
}

//  存入用户信息
- (BOOL)saveUserLoginInfoWithDic:(NSDictionary *)infoDic{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:infoDic];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [documentsDirectory stringByAppendingPathComponent:userInfoKey];
    BOOL didWriteSuccessfull = [data writeToFile:path atomically:YES];
    if (didWriteSuccessfull) {
        kDebugLog(@"成功存入用户信息：%@",infoDic);
    }else{
        kDebugLog(@"存入失败：%@",infoDic);
    }
    
    return didWriteSuccessfull;
}

//  获取用户信息
- (NSDictionary *)getUserLoginInfoDic{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [documentsDirectory stringByAppendingPathComponent:userInfoKey];
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary *infoDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return infoDic;
}

//  删除用户信息
- (BOOL)deleteUeserInfoDic{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [documentsDirectory stringByAppendingPathComponent:userInfoKey];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    __autoreleasing NSError *error = nil;
    [manager removeItemAtPath:path error:&error];
    if (error) {
        kDebugLog(@"删除 userInfoDic 失败");
        return NO;
        
    }else{
        
        kDebugLog(@"删除 userInfoDic 成功");
        return YES;
    }
}

@end
