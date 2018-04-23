//
//  FasterStoryboardRouteManager.h
//  FasterStoryboardRoute
//
//  Created by lengshengren on 2018/3/4.
//  Copyright © 2018年 Lengshengren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FasterRoute : NSObject
@property(nonatomic,weak) UINavigationController *currentNavigationController;

+ (FasterRoute *)sharedInstance;


- (UIViewController *)openViewControllerWithIdentifier:(NSString *)identifier;

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
 通过URL方式跳转

 @param urlString 跳转url
 */
+ (BOOL)openUrlString:(NSString *)urlString;
@end
