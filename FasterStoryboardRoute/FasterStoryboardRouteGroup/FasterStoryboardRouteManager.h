//
//  FasterStoryboardRouteManager.h
//  FasterStoryboardRoute
//
//  Created by lengshengren on 2018/3/4.
//  Copyright © 2018年 Lengshengren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FasterStoryboardRouteManager : NSObject

+ (FasterStoryboardRouteManager  *)sharedInstance;

- (UIViewController *)openViewControllerWithIdentifier:(NSString *)identifier;

/**
 故事版路由跳转

 @param identifier identifier 统一跟类名保持一致
 @param source 当前对象
 @param params 传递参数
 */
void OpenViewControllerWithStoryboard(NSString *identifier, id source, NSDictionary *params);

/**
 代码路由跳转

 @param className 类名
 @param source 当前对象
 @param params 传递参数
 */
void OpenViewControllerWithClass(NSString *className, id source, NSDictionary *params);
@end
