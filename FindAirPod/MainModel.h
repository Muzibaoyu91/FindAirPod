//
//  MainModel.h
//  FindAirPod
//
//  Created by Baoyu on 16/9/9.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MainModel : JSONModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic ,copy) NSString *title;

@property (nonatomic, copy) NSString *desc;

//  纬度
@property (nonatomic, assign) float lat;

//  经度
@property (nonatomic, assign) float lng;

//  left right both
@property (nonatomic, copy) NSString *which;

//  male female unknown
@property (nonatomic, copy) NSString *gender;

//  微信
@property (nonatomic, copy) NSString *wechat;

@end
