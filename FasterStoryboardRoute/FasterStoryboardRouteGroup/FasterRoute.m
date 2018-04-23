//
//  FasterStoryboardRouteManager.m
//  FasterStoryboardRoute
//
//  Created by lengshengren on 2018/3/4.
//  Copyright © 2018年 Lengshengren. All rights reserved.
//

#import "FasterRoute.h"
#import "NSDictionary+RouteCategory.h"
#import "NSObject+ClassProperty.h"
#import <objc/runtime.h>
static NSString * const kClassName = @"className";
static NSString * const kStroyboardName = @"stroyboardName";
static NSString * const kScheme = @"faster";
static NSString * const kisStoryboard = @"isStoryboard";
@interface FasterRoute ()
@end

@implementation FasterRoute
+ (FasterRoute  *)sharedInstance {
    static FasterRoute *routeSharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        routeSharedInstance = [[FasterRoute alloc] init];
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

#pragma mark 类名跳转
+ (void)openViewControllerWithClassName:(NSString *)className
                                 params:(NSDictionary *)params {
    id  controller = [[NSClassFromString(className) alloc] init];
    if (controller == nil) {
        NSLog(@"出问题了!!!");
        return;
    }
    [self pushControllerWithObj:controller params:params];
}

#pragma mark Storyboard identifier 跳转
+ (void)openContorllerWithIdentifier:(NSString *)identifier
                              params:(NSDictionary *)params {
    UIViewController *controller = [[FasterRoute sharedInstance] getControllerWithIdentifier:identifier];
    if (controller == nil) {
        NSLog(@"stroyboard 控制器不存在，出问题了!!!");
        return;
    }
    
    [self pushControllerWithObj:controller params:params];
}

+ (BOOL)openUrlString:(NSString *)urlString {
    //去空格
    NSString *stringTrim = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (!stringTrim.length) {
         return NO;
    }
    
    NSURL *URL = [NSURL URLWithString:stringTrim];
    return [self handleRouteWithURL:URL];;
}

+ (BOOL)handleRouteWithURL:(NSURL *)URL {
    NSString *pattern = [URL absoluteString];
    NSURLComponents *components = [NSURLComponents componentsWithString:pattern];
    NSString *scheme = components.scheme;
    if (![scheme isEqualToString:kScheme]) {
        NSLog(@"scheme not find");
        return NO;
    }
    
    if (components.host.length > 0 && (![components.host isEqualToString:@"localhost"] && [components.host rangeOfString:@"."].location == NSNotFound)) {
        NSString *host = [components.percentEncodedHost copy];
        components.host = @"/";
        components.percentEncodedPath = [host stringByAppendingPathComponent:(components.percentEncodedPath ?: @"")];
    }
    
    NSString *path = [components percentEncodedPath];
    
    if (components.fragment != nil) {
        BOOL fragmentContainsQueryParams = NO;
        NSURLComponents *fragmentComponents = [NSURLComponents componentsWithString:components.percentEncodedFragment];
        
        if (fragmentComponents.query == nil && fragmentComponents.path != nil) {
            fragmentComponents.query = fragmentComponents.path;
        }
        
        if (fragmentComponents.queryItems.count > 0) {
            fragmentContainsQueryParams = fragmentComponents.queryItems.firstObject.value.length > 0;
        }
        
        if (fragmentContainsQueryParams) {
            components.queryItems = [(components.queryItems ?: @[]) arrayByAddingObjectsFromArray:fragmentComponents.queryItems];
        }
        
        if (fragmentComponents.path != nil && (!fragmentContainsQueryParams || ![fragmentComponents.path isEqualToString:fragmentComponents.query])) {
            path = [path stringByAppendingString:[NSString stringWithFormat:@"#%@", fragmentComponents.percentEncodedPath]];
        }
    }
    
    if (path.length > 0 && [path characterAtIndex:0] == '/') {
        path = [path substringFromIndex:1];
    }
    
    if (path.length > 0 && [path characterAtIndex:path.length - 1] == '/') {
        path = [path substringToIndex:path.length - 1];
    }
    
    //获取queryItem
    NSArray <NSURLQueryItem *> *queryItems = [components queryItems] ?: @[];
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *item in queryItems) {
        if (item.value == nil) {
            continue;
        }
        
        if (queryParams[item.name] == nil) {
            queryParams[item.name] = item.value;
        } else if ([queryParams[item.name] isKindOfClass:[NSArray class]]) {
            NSArray *values = (NSArray *)(queryParams[item.name]);
            queryParams[item.name] = [values arrayByAddingObject:item.value];
        } else {
            id existingValue = queryParams[item.name];
            queryParams[item.name] = @[existingValue, item.value];
        }
    }
    
    NSDictionary *params = queryParams.copy;
    
    NSArray *rootURLArray = [pattern componentsSeparatedByString:@"?"];
    if (rootURLArray.count > 0) {
        NSString *root = [rootURLArray firstObject];
        if (root.length > kScheme.length && [[root substringToIndex:kScheme.length] isEqualToString:kScheme]) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FasterStroyboardURL" ofType:@"plist"];
            NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
            NSDictionary *urlDictionary = [dataDictionary dictionaryValueForKey:@"URL"];
            NSDictionary *data = [urlDictionary dictionaryValueForKey:root];
            BOOL isStoryboard = [urlDictionary dictionaryValueForKey:kisStoryboard];
            NSString *className = [data stringValueForKey:kClassName];
            UIViewController *controller = nil;
            if (className == nil) {
                NSLog(@"出问题了!!!");
                return NO;
            }
            
            if (!isStoryboard) {
                controller = [[NSClassFromString(className) alloc] init];

            } else {
                controller = [[FasterRoute sharedInstance] getControllerWithURLData:data];
            }
            
            if (controller == nil) {
                NSLog(@"stroyboard 控制器不存在，出问题了!!!");
                return NO;
            }
            
            [self pushControllerWithObj:controller params:params];
            
        }
    } else {
        return  NO;
    }

    return YES;
}

+ (void)pushControllerWithObj:(id)obj
                       params:(NSDictionary *)params {
    if (obj) {
        if (params != nil) {
            [obj setControllerPropertyParams:params];
        }
        
        [[FasterRoute sharedInstance].currentNavigationController pushViewController:obj animated:YES];
    }
}

- (UIViewController *)getControllerWithURLData:(NSDictionary *)data {
    NSString *restorationID  = [data stringValueForKey:kClassName];
    NSString *stroyboardName = [data stringValueForKey:kStroyboardName];
    return [self viewControllerWithIdentifier:restorationID storyboardName:stroyboardName];
}

- (UIViewController *)getControllerWithIdentifier:(NSString *)identifier {
    NSDictionary *valueDictionary = [self stroyboardNameArrayWithIdentifier:identifier];
    NSString *restorationID  = [valueDictionary stringValueForKey:kClassName];
    NSString *stroyboardName = [valueDictionary stringValueForKey:kStroyboardName];
    return [self viewControllerWithIdentifier:restorationID storyboardName:stroyboardName];
}

- (NSDictionary *)stroyboardNameArrayWithIdentifier:(NSString *)identifier {
    __block  BOOL isStop = NO;
    __block NSString *restorationID = @"";
    __block NSString *stroyboardName = @"";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FasterStroyboardURL" ofType:@"plist"];
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSDictionary *stroyboardDictionary = [dataDictionary dictionaryValueForKey:@"Storyboard"];
    NSArray *stroyboardNameArray = [stroyboardDictionary allKeys];
    if (stroyboardNameArray.count == 0) {
        return @{};
    }
    
    for (NSString * stroyboardNameKey in stroyboardNameArray) {
         NSArray *data = [stroyboardDictionary arrayValueForKey:stroyboardNameKey];
         [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dataDictionary = obj;
                restorationID = [dataDictionary stringValueForKey:kClassName];
                stroyboardName = [dataDictionary stringValueForKey:kStroyboardName];
             if ([restorationID isEqualToString:identifier]) {
                 isStop = YES;
                 *stop = YES;
             }
          
         }];
        
        if (isStop) {
            return @{kClassName:restorationID ? : @"",kStroyboardName:stroyboardName ? : @""};
            break;
        }
    }
    
    return nil;
}

@end

#pragma mark - UINavigationController+FasterRoute

@interface UINavigationController (FasterRoute)

@end

@implementation UINavigationController (FasterRoute)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        swizzleMethod(class, @selector(viewWillAppear:), @selector(aop_NavigationViewWillAppear:));
    });
}

- (void)aop_NavigationViewWillAppear:(BOOL)animation {
    [self aop_NavigationViewWillAppear:animation];
    [FasterRoute sharedInstance].currentNavigationController = self;
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end

