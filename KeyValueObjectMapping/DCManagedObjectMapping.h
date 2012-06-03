//
// Created by Sergey Klimov on 5/29/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DCKeyValueObjectMapping.h"
#import <CoreData/CoreData.h>



@interface DCManagedObjectMapping : DCKeyValueObjectMapping

+ (DCManagedObjectMapping *) mapperForClass: (Class) classToGenerate andConfiguration: (DCParserConfiguration *)
        configuration andManagedObjectContext: (NSManagedObjectContext *)context;

- (id) initWithClass: (Class) _classToGenerate forConfiguration: (DCParserConfiguration *) _configuration andManagedObjectContext: (NSManagedObjectContext *)context;

@end