
#import <Foundation/Foundation.h>

@interface NSDictionary (Category)

/**
 * read value from dictionary directly, we need to consider whether to convert the value to NSString if its type is wrong
 *
 * @key key
 * @return NSString value for the given key or nil
 */
- (NSString *)stringValueForKey:(NSString *)key;

/**
 * read value from dictionary directly, we need to consider whether to convert the value to NSNumber if its type is wrong.
 * for example, if it's NSString '1', this method will return nil with current implementation
 * @key key
 * @return NSString value for the given key or nil
 */
- (NSNumber *)numberValueForKey:(NSString *)key;

/**
 * read value from dictionary directly, we need to consider whether to convert the value to NSDate if its type is wrong.
 * @key key
 * @return NSString value for the given key or nil
 */
- (NSDate *)dateValueForKey:(NSString *)key;


/**
 * read value from dictionary directly, if it's not type of NSDictionary, return nil
 *
 * @key key, should not be nil
 * @return NSDictionary value for the given key or nil
 */
- (NSDictionary *)dictionaryValueForKey:(NSString *)key;

/**
 * read value from dictionary directly, if it's not type of NSArray, return nil
 *
 * @key key
 * @return NSArray value for the given key or nil
 */
- (NSArray *)arrayValueForKey:(NSString *)key;

/**
 * read value from dictionary directly, if it can't convert to NSInteger, return 0
 *
 * @key key
 * @return NSInteger value for the given key or nil
 */
- (NSInteger)integerValueForKey:(NSString *)key;


- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
@end
