
#import "NSDictionary+RouteCategory.h"

@implementation NSDictionary (Category)

- (NSString *)stringValueForKey:(NSString *)key {
    id value = [self valueForKey:key];

    if (!value || [NSNull null] == value) {
        return nil;
    }
    if([value isKindOfClass:[NSString class]]) {
        return value;
    } else if([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue];
    }

    return nil;
}

- (NSNumber *)numberValueForKey:(NSString *)key {
    id value = [self valueForKey:key];
    
    if (!value || [NSNull null] == value) {
        return nil;
    }
    if([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    if([value respondsToSelector:@selector(floatValue)]) {
        return @([value floatValue]);
    }
    return nil;
}

- (NSDate *)dateValueForKey:(NSString *)key {
    id value = [self valueForKey:key];
    if (!value || [NSNull null] == value || ![value isKindOfClass:[NSDate class]]) {
        return nil;
    }
    
    return value;
}

- (NSDictionary *)dictionaryValueForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if (!value || [NSNull null] == value || ![value isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return value;
}

- (NSArray *)arrayValueForKey:(NSString *)key {
    id value = [self valueForKey:key];
    if (!value || [NSNull null] == value || ![value isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    return value;
}

- (NSInteger)integerValueForKey:(NSString *)key {
    id value = [self valueForKey:key];
    if (!value || [NSNull null] == value) {
        return 0;
    }
    if([value respondsToSelector:@selector(integerValue)]) {
        return [value integerValue];
    }
    return 0;
}

- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    // 检查键是否有效
    if (!key) {
        return defaultValue;
    }

    // 尝试获取与键关联的对象
    id value = [self objectForKey:key];

    // 检查对象是否为 nil 或者 NSNull
    if (!value || [value isKindOfClass:[NSNull class]]) {
        return defaultValue;
    }

    // 确认对象是 NSNumber 类型并且尝试转换为布尔值
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }

    // 如果对象不是 NSNumber 类型，则返回默认值
    return defaultValue;
}

@end
