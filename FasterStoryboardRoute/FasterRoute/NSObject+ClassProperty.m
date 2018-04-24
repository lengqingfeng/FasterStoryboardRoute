//
//  NSObject+ClassProperty.m
//  FasterStoryboardRoute
//
//  Created by lengshengren on 2018/3/4.
//  Copyright © 2018年 Lengshengren. All rights reserved.
//

#import "NSObject+ClassProperty.h"
#import <objc/runtime.h>
@implementation NSObject (ClassProperty)
- (void)setControllerPropertyParams:(NSDictionary *)params {
    if (!params || ![params isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    unsigned int outCount, i;
    Class class = [self class];
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *char_f  = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id value = params[propertyName];
        if (value) {
             [self setValue:value forKey:propertyName];
        }
    }
    free(properties);
}
@end
