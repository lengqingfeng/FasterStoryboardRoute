//
//  FasterStoryboardRouteManager.m
//  FasterStoryboardRoute
//
//  Created by lengshengren on 2018/3/4.
//  Copyright © 2018年 Lengshengren. All rights reserved.
//

#import "FasterStoryboardRouteManager.h"
#import "NSDictionary+RouteCategory.h"
#import "NSObject+ClassProperty.h"
static NSString * const kRestorationID = @"RestorationID";
static NSString * const kStroyboardName = @"StroyboardName";
@interface FasterStoryboardRouteManager ()
@end

@implementation FasterStoryboardRouteManager
+ (FasterStoryboardRouteManager  *)sharedInstance {
    static FasterStoryboardRouteManager *routeSharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        routeSharedInstance = [[FasterStoryboardRouteManager alloc] init];
    });
    return routeSharedInstance;
}

- (id)viewControllerWithIdentifier:(NSString *)identifier
                    storyboardName:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    if(storyboard) {
        return [storyboard instantiateViewControllerWithIdentifier:identifier];
    }
    return nil;
}

- (UIViewController *)openViewControllerWithIdentifier:(NSString *)identifier {
    if(!identifier) {
       @throw [NSException exceptionWithName:@"FasterStoryboardRouteManager"
                                      reason:@"identifier 不存在"
                                    userInfo:nil];
        return nil;
    }
    return [self getControllerWithIdentifier:identifier];
}

void OpenViewControllerWithClass(NSString *className, id source, NSDictionary *params) {
     id  controller = [[NSClassFromString(className) alloc] init];
    if (controller == nil) {
        NSLog(@"出问题了!!!");
        return;
    }
     [[FasterStoryboardRouteManager  sharedInstance] pushControllerWithObj:controller
                                                                  source:source
                                                                  params:params];
}

void OpenViewControllerWithStoryboard(NSString *identifier, id source, NSDictionary *params) {
    UIViewController *controller = [[FasterStoryboardRouteManager sharedInstance] getControllerWithIdentifier:identifier];
    if (controller == nil) {
        NSLog(@"stroyboard 控制器不存在，出问题了!!!");
        return;
    }
    [[FasterStoryboardRouteManager  sharedInstance] pushControllerWithObj:controller
                                                                  source:source
                                                                  params:params];
}

- (void)pushControllerWithObj:(id)obj
                       source:(id)source
                       params:(NSDictionary *)params {
    UIViewController *currentController = nil;
    if ([source isKindOfClass:[UIViewController class]]) {
        currentController = source;
    }else if ([source isKindOfClass:[UIView class]]) {
        UIView *currentView = source;
        currentController = [[FasterStoryboardRouteManager sharedInstance] topViewControllerWithView:currentView];
    }
    
    if (currentController) {
        if (params != nil) {
            [obj setControllerPropertyParams:params];
        }
        
        [currentController.navigationController pushViewController:obj animated:YES];
    }
}

- (UIViewController *)getControllerWithIdentifier:(NSString *)identifier {
    NSDictionary *valueDictionary = [self stroyboardNameArrayWithIdentifier:identifier];
    NSString *restorationID  = [valueDictionary stringValueForKey:kRestorationID];
    NSString *stroyboardName = [valueDictionary stringValueForKey:kStroyboardName];
    return [self viewControllerWithIdentifier:restorationID storyboardName:stroyboardName];
}

- (NSDictionary *)stroyboardNameArrayWithIdentifier:(NSString *)identifier {
    __block  BOOL isStop = NO;
    __block NSString *restorationID = @"";
    __block NSString *stroyboardName = @"";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FasterStroyboardURL" ofType:@"plist"];
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSArray *stroyboardNameArray = [dataDictionary allKeys];
    if (stroyboardNameArray.count == 0) {
        return @{};
    }
    
    for (NSString * stroyboardNameKey in stroyboardNameArray) {
         NSArray *stroyboardNameArray = [dataDictionary arrayValueForKey:stroyboardNameKey];
         [stroyboardNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dataDictionary = obj;
                restorationID = [dataDictionary stringValueForKey:kRestorationID];
                stroyboardName = [dataDictionary stringValueForKey:kStroyboardName];
             if ([restorationID isEqualToString:identifier]) {
                 isStop = YES;
                 *stop = YES;
             }
          
         }];
        
        if (isStop) {
            return @{kRestorationID:restorationID ? : @"",kStroyboardName:stroyboardName ? : @""};
            break;
        }
    }
    
    return nil;
}

- (UIViewController *)topViewControllerWithView:(UIView *)view {
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
