//
//  DCTestParseOnlyValuesToObject.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 7/23/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCTestParseOnlyValuesToObject.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"
#import "Person.h"
@interface DCTestParseOnlyValuesToObject()

@property(nonatomic,strong) NSDictionary *plist;
@property(nonatomic,strong) NSDictionary *json;

@end
@implementation DCTestParseOnlyValuesToObject
@synthesize plist, json;
- (void)setUp
{
    [super setUp];
    
    NSString *pathToFile = [[NSBundle bundleForClass: [self class]] pathForResource:@"plist" ofType:@"plist"];
    plist = [NSDictionary dictionaryWithContentsOfFile:pathToFile];
    
    
    NSString *caminhoJson = [[NSBundle bundleForClass: [self class]] pathForResource:@"tweet" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:caminhoJson];
    
    json = [NSJSONSerialization JSONObjectWithData:data
                                           options:NSJSONReadingMutableContainers error:nil];
    
}

- (void) testValidPlistToPerson
{         
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    configuration.datePattern = @"yyyy-MM-dd'T'hh:mm:ssZ";
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Person class] andConfiguration:configuration];
    Person *person = [[Person alloc] init];
    [parser setValuesOnObject:person withDictionary:plist];
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

@end