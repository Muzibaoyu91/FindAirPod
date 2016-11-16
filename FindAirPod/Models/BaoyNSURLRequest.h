//
//  BaoyNSURLRequest.h
//  Baoy
//
//  Created by Baoyu on 16/9/20.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaoyNSURLRequest : NSObject


//  GET请求
- (void)Get:(NSString *)URLString
          progress:(void (^)(NSProgress * downloadProgress))progress
           success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
           failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;



- (void)Get:(NSString *)URLString
   parameters:parameters
   progress:(void (^)(NSProgress * downloadProgress))progress
    success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;



//  POST请求
/**
 *  post请求
 *
 *  @param URLString  URLString
 *  @param parameters parameters
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (void)POST:(NSString *)URLString
         parameters:(id)parameters
           progress:(void (^)(NSProgress * downloadProgress))progress
            success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;


//  put
- (void)Put:(NSString *)URLString
        parameters:(id)parameters
          progress:(void (^)(NSProgress * downloadProgress))progress
           success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
           failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

//  delet
- (void)Delet:(NSString *)URLString
     parameters:(id)parameters
     progress:(void (^)(NSProgress * downloadProgress))progress
      success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
      failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;


@end
