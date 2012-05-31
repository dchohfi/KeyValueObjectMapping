//
// Created by Sergey Klimov on 5/31/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import <Foundation/Foundation.h>

@class DCManagedObjectMapping;
@class NSManagedObjectContext;


@interface DCMapperManager : NSObject
- (id)initWithConfiguration:(NSDictionary *)configurationDictionary;

- (id)initWithConfiguration:(NSDictionary *)configurationDictionary andManagedObjectContext:(NSManagedObjectContext
*)_context;
- (id)mapperForClass:(Class)class;

- (DCManagedObjectMapping *)managedMapperForClass:(Class)class;
@end