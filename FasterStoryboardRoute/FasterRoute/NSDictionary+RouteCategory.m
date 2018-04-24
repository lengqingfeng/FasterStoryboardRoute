
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

@end
