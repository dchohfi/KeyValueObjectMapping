//
//  DCNSDateConverter.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCNSDateConverter.h"
#import "DCDynamicAttribute.h"

@interface DCNSDateConverter()
@property(nonatomic, strong) NSString *pattern;
@property(nonatomic, strong) NSLocale *locale;
- (BOOL) validDouble: (NSString *) doubleValue;
@end

@implementation DCNSDateConverter
@synthesize pattern = _pattern;


+ (DCNSDateConverter *) dateConverterForPattern: (NSString *) pattern locale:(NSLocale *)locale {
    return [[self alloc] initWithDatePattern: pattern locale:locale];
}

- (id) initWithDatePattern: (NSString *) pattern locale:(NSLocale *)locale {
    self = [super init];
    if (self) {
        _pattern = pattern;
        _locale = locale;
    }
    return self;
}

- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute dictionary:(NSDictionary *)dictionary parentObject:(id)parentObject {
    BOOL validDouble = [self validDouble:[NSString stringWithFormat:@"%@", value]];
    if(validDouble){
        return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
    }else{
      if ([value isKindOfClass:[NSString class]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = self.pattern;
        if (self.locale) {
            formatter.locale = self.locale;
        }
        return [formatter dateFromString:value];
      } else {
        return nil;
      }
    }
}
- (id)serializeValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = self.pattern;
    if (self.locale) {
        formatter.locale = self.locale;
    }
    return [formatter stringFromDate:value];
}
- (BOOL)canTransformValueForClass: (Class) cls {
    return [cls isSubclassOfClass:[NSDate class]];
}
- (BOOL) validDouble: (NSString *) doubleValue {
  return [[[NSNumberFormatter alloc] init] numberFromString:doubleValue] != nil;
}
@end
