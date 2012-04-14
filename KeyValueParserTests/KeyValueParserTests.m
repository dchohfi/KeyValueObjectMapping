//
//  KeyValueParserTests.m
//  KeyValueParserTests
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KeyValueParserTests.h"
#import "ParserConfiguration.h"
#import "KeyValueParser.h"
#import "Person.h"
#import "PropertyNameParser.h"

@interface KeyValueParserTests()

@property(nonatomic,strong) NSDictionary *jsonToParse;

@end
@implementation KeyValueParserTests
@synthesize jsonToParse;
- (void)setUp
{
    [super setUp];
    
    NSString *pathToFile = [[NSBundle bundleForClass: [self class]] pathForResource:@"valid_json" ofType:@"plist"];
    jsonToParse = [NSDictionary dictionaryWithContentsOfFile:pathToFile];
}

- (void)testValidPerson
{         
    ParserConfiguration *configuration = [[ParserConfiguration alloc] init];
    configuration.datePattern = @"yyyy-MM-dd'T'hh:mm:ssZ";
    KeyValueParser *parser = [[KeyValueParser alloc] initWithConfiguration:configuration];
    Person *person = [parser parseJson:jsonToParse forClass:[Person class]];
    STAssertEqualObjects(person.name, @"Diego Chohfi Turini", @"Should be equals name");
    STAssertEqualObjects(person.adress, @"Rua dos bobos, n 0", @"Should be equals adress");
    STAssertEqualObjects(person.phone, @"+551199999999", @"Should be equals phone");
    STAssertEquals(person.age, 24, nil, @"Should be equals age");
    STAssertEqualObjects(person.birthDay, [NSDate dateWithTimeIntervalSince1970:565927200], nil, @"Should be equals NSDate");
    STAssertNil(person.parents, @"Should ignore NSArray");
    STAssertTrue(person.valid, @"Person should be valid");
    STAssertEqualObjects(person.url, [NSURL URLWithString:@"http://dchohfi.com/"], @"Should create equals urls");
    STAssertEqualObjects(person.nota, [NSNumber numberWithInt:10], @"Should be equals");
    STAssertEqualObjects(person.dateWithString, [NSDate dateWithTimeIntervalSince1970:0], @"Should create equals NSDate");
    STAssertEquals((int)[person.arrayPrimitive count], 4, @"Should have same size");
    STAssertEqualObjects([person.arrayPrimitive objectAtIndex:0], @"hello", @"Should have hello on first position of array");
    STAssertEqualObjects([person.arrayPrimitive objectAtIndex:1], @"mutchaco", @"Should have muthaco on first position of array");    
    STAssertEqualObjects([person.arrayPrimitive objectAtIndex:2], [NSNumber numberWithInt:1], @"Should have muthaco on first position of array");
    STAssertEqualObjects([person.arrayPrimitive objectAtIndex:3], [NSNumber numberWithDouble:3.1416], @"Should have muthaco on first position of array");
    configuration = nil;
}

- (void)testSplitPropetyName
{
}

@end
