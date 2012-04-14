//
//  DynamicAttributeTest.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DynamicAttributeTest.h"
#import "DynamicAttribute.h"
@implementation DynamicAttributeTest

- (void) testDynamicAttributeForPrimitiveInt {
    DynamicAttribute *attribute = [[DynamicAttribute alloc] initWithAttributeDescription:@"Ti,R,N,Vage"];
    STAssertTrue([attribute isPrimitive], @"Should be a primitive attribute");
    STAssertFalse([attribute isIdType], @"Should not be and id type");
    STAssertFalse([attribute isValidObject], @"Should not be a valid object");
    STAssertNil([attribute attributeClass], @"Should be nil when attribute is primitive");
    STAssertEqualObjects([attribute attributeType], @"i", @"Should be an integer attribute");
    STAssertEqualObjects([attribute attributeName], @"age", @"AttributeName should be age");
}

- (void) testDynamicAttributeForNSStringType {
    DynamicAttribute *attribute = [[DynamicAttribute alloc] initWithAttributeDescription:@"T@\"NSString\",&,N,Vadress"];
    STAssertFalse([attribute isPrimitive], @"Should be a class");
    STAssertFalse([attribute isIdType], @"Should not be and id type");
    STAssertTrue([attribute isValidObject], @"Should not be a valid object");
    STAssertEquals([attribute attributeClass], [NSString class], @"Should be NSString class");
    STAssertEqualObjects([attribute attributeType], @"NSString", @"Should be a NSString attribute");
    STAssertEqualObjects([attribute attributeName], @"adress", @"AttributeName should be adress");
}

- (void) testDynamicAttributeForNSDateType {
    DynamicAttribute *attribute = [[DynamicAttribute alloc] initWithAttributeDescription:@"T@\"NSDate\",&,N,VdataNascimento"];
    STAssertFalse([attribute isPrimitive], @"Should be a class");
    STAssertFalse([attribute isIdType], @"Should not be and id type");
    STAssertTrue([attribute isValidObject], @"Should not be a valid object");
    STAssertEquals([attribute attributeClass], [NSDate class], @"Should be NSDate class");
    STAssertEqualObjects([attribute attributeType], @"NSDate", @"Should be a NSDate attribute");
    STAssertEqualObjects([attribute attributeName], @"dataNascimento", @"AttributeName should be dataNascimento");
}

- (void) testDynamicAttributeForIdType {
    DynamicAttribute *attribute = [[DynamicAttribute alloc] initWithAttributeDescription:@"T@,&,N,Vid"];
    STAssertFalse([attribute isPrimitive], @"Should be a class");
    STAssertFalse([attribute isValidObject], @"Should not be a valid object");
    STAssertTrue([attribute isIdType], @"Should be and id type");
    STAssertNil([attribute attributeClass], @"Should be nil when attribute is id");
    STAssertNil([attribute attributeType], @"Should be null when attribut is id");
    STAssertEqualObjects([attribute attributeName], @"id", @"AttributeName should be id");
}

@end
