//
// Created by Sergey Klimov on 5/29/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import "DCManagedObjectsMappingsTests.h"
#import "DCParserConfiguration.h"

#import "Artist.h"
#import "DCManagedObjectMapping.h"


@interface NSManagedObject(TestCase)
+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;
+ (NSArray *)findAllObjectsInContext:(NSManagedObjectContext *)context;
@end

@implementation NSManagedObject(TestCase)
+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context
{
    return [self respondsToSelector:@selector(entityInManagedObjectContext:)] ?
            [self performSelector:@selector(entityInManagedObjectContext:) withObject:context] :
            [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
}
+ (NSArray *)findAllObjectsInContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [self entityDescriptionInContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    return [context executeFetchRequest:request error:nil];
}
@end

@implementation DCManagedObjectsMappingsTests {
    NSArray *artistsFixture;
    NSArray *albumsFixture;
    
    
    NSPersistentStoreCoordinator *coord;
    NSManagedObjectContext *ctx;
    NSManagedObjectModel *model;
    NSPersistentStore *store;


}





- (DCManagedObjectMapping *)createArtistMapping
{
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    DCObjectMapping *nameMapping = [DCObjectMapping mapKeyPath:@"name" toAttribute:@"name" onClass:[Artist class]];
    DCObjectMapping *idMapping = [DCObjectMapping mapKeyPath:@"objectId" toAttribute:@"id" onClass:[Artist class]];
    [config addObjectMapping:nameMapping];
    [config addObjectMapping:idMapping];


    DCManagedObjectMapping *parser = [DCManagedObjectMapping mapperForClass:[Artist class]
         andConfiguration:config andManagedObjectContext:ctx];
    return parser;
}

- (void)setUp
{

    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass: [self class]] pathForResource:@"artists" ofType:@"json"]];
    NSError *error;
    artistsFixture = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableContainers error:&error];

    data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass: [self class]] pathForResource:@"albums"
                                                                                            ofType:@"json"]];
    albumsFixture = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingMutableContainers error:&error];



    model = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject: [NSBundle bundleForClass: [self class]]]] ;
    NSLog(@"model: %@", model);
    coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
    store = [coord addPersistentStoreWithType: NSInMemoryStoreType
                                configuration: nil
                                          URL: nil
                                      options: nil 
                                        error: NULL];
    ctx = [[NSManagedObjectContext alloc] init];
    [ctx setPersistentStoreCoordinator: coord];
}

- (void)tearDown
{
    ctx = nil;
    NSError *error = nil;
    STAssertTrue([coord removePersistentStore: store error: &error], 
                 @"couldn't remove persistent store: %@", error);
    store = nil;
    coord = nil;
    model = nil;
}



- (void) testBasicMapping {
    DCManagedObjectMapping *parser = [self createArtistMapping];


    NSArray *artists = [parser parseArray:artistsFixture];
    STAssertTrue([artists count]==2, nil);
    Artist *artist = [parser parseDictionary:[artistsFixture lastObject]];
    STAssertNotNil(artist, nil);
    STAssertTrue([artist.id isEqualToString:[[artistsFixture lastObject] objectForKey:@"objectId"]], nil);
    STAssertTrue([artist.name isEqualToString:[[artistsFixture lastObject] objectForKey:@"name"]], nil);
}

- (void) testUniqueness
{
    DCManagedObjectMapping *parser = [self createArtistMapping];

    [parser parseArray:artistsFixture];
    NSArray *artistsFirstTime = [Artist findAllObjectsInContext:ctx];
    STAssertTrue(artistsFirstTime.count == 2, nil);

    [parser parseArray:artistsFixture];
    NSArray *artistsSecondTime = [Artist findAllObjectsInContext:ctx];
    STAssertTrue(artistsSecondTime.count == 2, nil);

    STAssertTrue([artistsSecondTime containsObject:[artistsFirstTime objectAtIndex:0]], nil);
    STAssertTrue([artistsSecondTime containsObject:[artistsFirstTime lastObject]], nil);
}



@end