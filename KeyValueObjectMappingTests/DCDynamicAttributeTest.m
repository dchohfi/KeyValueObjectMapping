//
//  DynamicAttributeTest.m
//  DCKeyValueObjectMappingTests
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCDynamicAttributeTest.h"
#import "DCDynamicAttribute.h"
#import "Tweet.h"
@implementation DCDynamicAttributeTest

- (void) testDynamicAttributeForPrimitiveInt {
    DCDynamicAttribute *attribute = [[DCDynamicAttribute alloc] initWithAttributeDescription:@"Ti,R,N,Vage"
                                                                                      forKey:@"age"
                                                                                     onClass:[Tweet class]];
    STAssertEquals(attribute.classe, [Tweet class], @"Should be the same class");
    STAssertTrue([attribute isPrimitive], @"Should be a primitive attribute");
    STAssertFalse([attribute isIdType], @"Should not be and id type");
    STAssertFalse([attribute isValidObject], @"Should not be a valid object");
    STAssertNil(attribute.objectMapping.classReference, @"Should be nil when attribute is primitive");
    STAssertEqualObjects(attribute.typeName, @"i", @"Should be an integer attribute");
    STAssertEqualObjects(attribute.objectMapping.attributeName, @"age", @"AttributeName should be age");
}

- (void) testDynamicAttributeForNSStringType {
    DCDynamicAttribute *attribute = [[DCDynamicAttribute alloc] initWithAttributeDescription:@"T@\"NSString\",&,N,Vadress" forKey:@"adress" onClass:[Tweet class]];
    STAssertEquals(attribute.classe, [Tweet class], @"Should be the same class");
    STAssertFalse([attribute isPrimitive], @"Should be a class");
    STAssertFalse([attribute isIdType], @"Should not be and id type");
    STAssertTrue([attribute isValidObject], @"Should not be a valid object");
    STAssertEquals(attribute.objectMapping.classReference, [NSString class], @"Should be NSString class");
    STAssertEqualObjects(attribute.typeName, @"NSString", @"Should be a NSString attribute");
    STAssertEqualObjects(attribute.objectMapping.attributeName, @"adress", @"AttributeName should be adress");
}

- (void) testDynamicAttributeForNSDateType {
    DCDynamicAttribute *attribute = [[DCDynamicAttribute alloc] initWithAttributeDescription:@"T@\"NSDate\",&,N,VdataNascimento" forKey:@"dataNascimento" onClass:[Tweet class]];
    STAssertEquals(attribute.classe, [Tweet class], @"Should be the same class");
    STAssertFalse([attribute isPrimitive], @"Should be a class");
    STAssertFalse([attribute isIdType], @"Should not be and id type");
    STAssertTrue([attribute isValidObject], @"Should not be a valid object");
    STAssertEquals(attribute.objectMapping.classReference, [NSDate class], @"Should be NSDate class");
    STAssertEqualObjects(attribute.typeName, @"NSDate", @"Should be a NSDate attribute");
    STAssertEqualObjects(attribute.objectMapping.attributeName, @"dataNascimento", @"AttributeName should be dataNascimento");
}

- (void) testDynamicAttributeForIdType {
    DCDynamicAttribute *attribute = [[DCDynamicAttribute alloc] initWithAttributeDescription:@"T@,&,N,Vid" forKey:@"id" onClass:[Tweet class]];
    STAssertEquals(attribute.classe, [Tweet class], @"Should be the same class");
    STAssertFalse([attribute isPrimitive], @"Should be a class");
    STAssertFalse([attribute isValidObject], @"Should not be a valid object");
    STAssertTrue([attribute isIdType], @"Should be and id type");
    STAssertNil(attribute.objectMapping.classReference, @"Should be nil when attribute is id");
    STAssertNil(attribute.typeName, @"Should be null when attribut is id");
    STAssertEqualObjects(attribute.objectMapping.attributeName, @"id", @"AttributeName should be id");
}

- (void) testDynamicNotSynthetizedAttribute {
    DCDynamicAttribute *attribute = [[DCDynamicAttribute alloc] initWithAttributeDescription:@"T@\"NSString\",&,D,N" forKey:@"adress" onClass:[Tweet class] attributeName:@"adress"];
    STAssertEquals(attribute.classe, [Tweet class], @"Should be the same class");
    STAssertFalse([attribute isPrimitive], @"Should be a class");
    STAssertFalse([attribute isIdType], @"Should not be and id type");
    STAssertTrue([attribute isValidObject], @"Should not be a valid object");
    STAssertEquals(attribute.objectMapping.classReference, [NSString class], @"Should be NSString class");
    STAssertEqualObjects(attribute.typeName, @"NSString", @"Should be a NSString attribute");
    STAssertEqualObjects(attribute.objectMapping.attributeName, @"adress", @"AttributeName should be adress");
}
@end
