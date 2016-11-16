//
//  BaoyNSURLRequest.m
//  Baoy
//
//  Created by Baoyu on 16/9/20.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "BaoyNSURLRequest.h"
#import "AFNetworking.h"

#define Ktimeout  10

@interface BaoyNSURLRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation BaoyNSURLRequest


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [[AFHTTPSessionManager alloc] init];
    }
    return self;
}


//  GET
- (void)Get:(NSString *)URLString progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    self.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    self.manager.requestSerializer.timeoutInterval = Ktimeout;
    [self.manager GET:URLString parameters:nil progress:progress success:success failure:failure];
    
}

- (void)Get:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    self.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    self.manager.requestSerializer.timeoutInterval = Ktimeout;
    [self.manager GET:URLString parameters:parameters progress:progress success:success failure:failure];
}


//  POST
- (void)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    self.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    self.manager.requestSerializer.timeoutInterval = Ktimeout;
    [self.manager POST:URLString parameters:parameters progress:progress success:success failure:failure];
}


//  put
- (void)Put:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    self.manager.requestSerializer.timeoutInterval = Ktimeout;
    [self.manager PUT:URLString parameters:parameters success:success failure:failure];
}


//  delet
- (void)Delet:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    self.manager.requestSerializer.timeoutInterval = Ktimeout;
    [self.manager DELETE:URLString parameters:parameters success:success failure:failure];
}




@end
