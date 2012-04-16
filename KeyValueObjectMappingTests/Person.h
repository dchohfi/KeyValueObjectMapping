//
//  Person.h
//  JSONParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property(nonatomic,readonly) NSString *name;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *adress;
@property(nonatomic,readonly) int age;
@property(nonatomic,strong) NSDate *birthDay;
@property(nonatomic,strong) NSArray *parents;
@property(nonatomic,assign) BOOL valid;
@property(nonatomic,readonly) NSURL *url;
@property(nonatomic,strong) NSNumber *nota;
@property(nonatomic,strong) NSDate *dateWithString;
@property(nonatomic,strong) NSArray *arrayPrimitive;
@end
