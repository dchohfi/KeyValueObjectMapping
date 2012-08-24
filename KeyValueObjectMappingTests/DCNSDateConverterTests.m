//
//  DCNSDateConverterTests.m
//  KeyValueObjectMapping
//
//  Created by Cristian Bica on 8/25/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCNSDateConverterTests.h"
#import "DCNSDateConverter.h"
@interface DCNSDateConverter()
@property(nonatomic, strong) NSString *pattern;
- (BOOL) validDouble: (NSString *) doubleValue;
@end

@implementation DCNSDateConverterTests

- (void) testValidDouble {
  DCNSDateConverter *convertor = [DCNSDateConverter dateConverterForPattern:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
  STAssertTrue([convertor validDouble:@"10"], @"Should recognize '10' as a valid double");
  STAssertTrue([convertor validDouble:@"10.0"], @"Should recognize '10.0' as a valid double");
  [@[ @"Monday, April 17, 2006", @"Monday, April 17, 2006 2:22:48 PM", @"4/17/2006 2:22:48 PM", @"Mon, 17 Apr 2006 21:22:48 GMT", @"2006-04-17 21:22:48Z", @"2006-04-17T14:22:48.2698750-07:00" ]
   enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    STAssertFalse([convertor validDouble:obj], [NSString stringWithFormat:@"Should not recognize '%@' as double", obj]);
  }];
  
  
}

@end
