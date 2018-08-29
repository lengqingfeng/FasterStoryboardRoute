//
//  FasterStoryboardRouteManager.h
//  FasterStoryboardRoute
//
//  Created by lengshengren on 2018/3/4.
//  Copyright © 2018年 Lengshengren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FastRoute : NSObject

@property (nonatomic, weak) UINavigationController *currentNavigationController;

+ (FastRoute *)sharedInstance;

/**
 路由配置文件名称
 */
@property (strong, nonatomic) NSString *routerPlistName;

/**
 faster://home/detail schemeName is faster 默认faster
 */
@property (strong, nonatomic) NSString *schemeName;

/**
 通过URL方式跳转 故事版 代码 都支持

 @param urlString 跳转url
 */
+ (BOOL)openURLString:(NSString *)urlString;

/**
 通过URL方式跳转 故事版 代码 都支持 可以把参数放在params 不用放在URL

 @param urlString 跳转URL
 @param params 传递参数
 @return 是否跳转成功
 */
+ (BOOL)openURLString:(NSString *)urlString params:(NSDictionary *)params;

/**
 带有回调方法的路由，执行某个动作后需要回调传递值

 @param urlString 注册的URL 参数可拼接在URL 里
 @param completion 回调方法
 @return 是否跳转成功
 */
+ (BOOL)openURLString:(NSString *)urlString completion:(void (^)(id result))completion;


/**
  带有回调方法的路由，执行某个动作后需要回调传递值

 @param urlString 注册的URL
 @param params 传递参数 也可也在URL 里
 @param completion 回调方法
 @return 是否跳转成功
 */
+ (BOOL)openURLString:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(id result))completion;

/**
 配合 👆 completion 回调 方法使用

 @param urlString 注册root url 不带参数部分 跟👆url 保持一致
 @param params 想要传的参数
 @return 是否传递成功
 */
+ (BOOL)callBackWithURLString:(NSString *)urlString params:(id)params;

/**
 故事版路由跳转
 
 @param identifier identifier 统一跟类名保持一致
 @param params 传递参数
 */
+ (void)openContorllerWithIdentifier:(NSString *)identifier
                              params:(NSDictionary *)params;

/**
 代码路由跳转
 
 @param className 类名
 @param params 传递参数
 */
+ (void)openViewControllerWithClassName:(NSString *)className
                                 params:(NSDictionary *)params;


/**
 指定返回控制器

 @param className 返回控制器类名
 */
+ (void)popToRouteViewControlerWithClassName:(NSString *)className;

@end
