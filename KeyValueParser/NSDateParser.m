//
//  NSDateParser.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "NSDateParser.h"
@interface NSDateParser()
@property(nonatomic, strong) ParserConfiguration *configuration;
- (BOOL) validDouble: (NSString *) doubleValue;
@end

@implementation NSDateParser
@synthesize configuration;
- (id) initWithConfiguration: (ParserConfiguration *) _configuration {
    self = [super init];
    if (self) {
        configuration = _configuration;
    }
    return self;
}
- (id) transformValue: (id) value {
    BOOL validDouble = [self validDouble:[NSString stringWithFormat:@"%@", value]];
    if(validDouble){
        return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = configuration.datePattern;
        return [formatter dateFromString:value];
    }
}
- (BOOL) canTransformValueForClass: (Class) class {
    return [class isSubclassOfClass:[NSDate class]];
}
- (BOOL) validDouble: (NSString *) doubleValue {
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:doubleValue];
    
    return [alphaNums isSupersetOfSet:inStringSet];
}
@end
