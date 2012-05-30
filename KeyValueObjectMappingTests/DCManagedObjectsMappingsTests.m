//
// Created by Sergey Klimov on 5/29/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import "DCManagedObjectsMappingsTests.h"
#import "DCParserConfiguration.h"

#import "Artist.h"
#import "DCManagedObjectMapping.h"
#import "Album.h"
#import "Song.h"



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
    config.primaryKeyName = @"objectId";

    DCObjectMapping *nameMapping = [DCObjectMapping mapKeyPath:@"name" toAttribute:@"name" onClass:[Artist class]];
    DCObjectMapping *idMapping = [DCObjectMapping mapKeyPath:@"objectId" toAttribute:@"id" onClass:[Artist class]];
    [config addObjectMapping:nameMapping];
    [config addObjectMapping:idMapping];


    DCManagedObjectMapping *parser = [DCManagedObjectMapping mapperForClass:[Artist class]
         andConfiguration:config andManagedObjectContext:ctx];
    return parser;
}

- (DCManagedObjectMapping *)createAlbumMappingWithFullSongSerialization:(BOOL) fullSongSerialization
{
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.primaryKeyName = @"album_id";

    DCManagedObjectMapping *songParser = [self createSongMapping];
    songParser.fullSerialization = fullSongSerialization;
    DCObjectMapping *nameMapping = [DCObjectMapping mapKeyPath:@"name" toAttribute:@"name" onClass:[Album class]];
    DCObjectMapping *idMapping = [DCObjectMapping mapKeyPath:@"album_id" toAttribute:@"id" onClass:[Album class]];
    DCObjectMapping *songsMapping = [DCObjectMapping mapKeyPath:@"songs" toAttribute:@"songs" onClass:[Album class]
                                                         parser:songParser];



    DCManagedObjectMapping *artistParser = [self createArtistMapping];
    artistParser.fullSerialization = NO;
    DCObjectMapping *artistMapping = [DCObjectMapping mapKeyPath:@"artist" toAttribute:@"artist" onClass:[Album class]
            parser:artistParser];


    DCArrayMapping *songsArrayMapping = [DCArrayMapping mapperForClass:[Song class]
                                                             onMapping:songsMapping];

    [config addObjectMapping:nameMapping];
    [config addObjectMapping:idMapping];
    [config addObjectMapping:artistMapping];
    [config addObjectMapping:songsMapping];
    [config addArrayMapper:songsArrayMapping];

    DCManagedObjectMapping *parser = [DCManagedObjectMapping mapperForClass:[Album class]
            andConfiguration:config andManagedObjectContext:ctx];
    return parser;
}

- (DCManagedObjectMapping *)createSongMapping
{
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.primaryKeyName = @"id";

    DCManagedObjectMapping *artistParser = [self createArtistMapping];
    artistParser.fullSerialization = NO;
    DCObjectMapping *nameMapping = [DCObjectMapping mapKeyPath:@"title" toAttribute:@"title" onClass:[Song class]];
    DCObjectMapping *idMapping = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"id" onClass:[Song class]];
    DCObjectMapping *artistMapping = [DCObjectMapping mapKeyPath:@"artist" toAttribute:@"artist" onClass:[Song class]
            parser:artistParser];

    [config addObjectMapping:artistMapping];

    [config addObjectMapping:nameMapping];
    [config addObjectMapping:idMapping];

    DCManagedObjectMapping *parser = [DCManagedObjectMapping mapperForClass:[Song class]
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
    albumsFixture = nil;
    artistsFixture = nil;

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

-(void) testObjectsWithSamePrimaryKeyUpdate {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass: [self class]]
                                                          pathForResource:@"artists2" ofType:@"json"]];
    NSError *error;
    NSArray *artists2Fixture = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers error:&error];



    DCManagedObjectMapping *parser = [self createArtistMapping];

    [parser parseArray:artistsFixture];
    NSArray *artistsFirstTime = [Artist findAllObjectsInContext:ctx];
    NSString *firstName = [[artistsFirstTime lastObject] name];

    [parser parseArray:artists2Fixture];
    NSArray *artistsSecondTime = [Artist findAllObjectsInContext:ctx];
    NSString *secondName = [[artistsSecondTime lastObject] name];

    STAssertFalse([firstName isEqualToString:secondName], nil);
    STAssertTrue([secondName isEqualToString:[[artists2Fixture lastObject] objectForKey:@"name"]]||
            [secondName isEqualToString:[[artists2Fixture objectAtIndex:0] objectForKey:@"name"]], nil);

}

- (void)testNestedObjectUniqueness
{
    DCManagedObjectMapping *parser = [self createAlbumMappingWithFullSongSerialization:NO];

    [parser parseArray:albumsFixture];
    NSArray *songs = [Song findAllObjectsInContext:ctx];
    STAssertTrue(songs.count == 4, nil);
    [parser parseArray:albumsFixture];
    NSArray *songsSecondTime = [Song findAllObjectsInContext:ctx];
    STAssertTrue(songsSecondTime.count == 4, nil);
}

- (void)testNestedObjectRelationships
{
    DCManagedObjectMapping *parser = [self createAlbumMappingWithFullSongSerialization:NO];

    NSArray *albums = [parser parseArray:albumsFixture];
    NSArray *songs = [Song findAllObjectsInContext:ctx];

    for (Album *album in albums) {
        STAssertTrue(album.songs.count > 1, nil);
    }

    for (Song *song in songs) {
        STAssertTrue(song.albums.count >= 1, nil);
        Album * album = [song.albums anyObject];
        STAssertTrue([album.songs containsObject:song], nil);
    }
}

- (void)testForeignKeyRelationships
{
    DCManagedObjectMapping *parser = [self createArtistMapping];

    [parser parseArray:artistsFixture];
    NSArray *artists =  [Artist findAllObjectsInContext:ctx];

    parser = [self createAlbumMappingWithFullSongSerialization:NO];
    [parser parseArray:albumsFixture];
    NSArray *albums = [Album findAllObjectsInContext:ctx];

    for (Album *album in albums) {
        STAssertNotNil(album.artist, nil);
        STAssertTrue([album.artist.albums containsObject:album], nil);
    }

    for (Artist *artist in artists) {
        STAssertTrue(artist.albums.count >= 1, nil);
        STAssertTrue(((Album *)[artist.albums anyObject]).artist == artist, nil);
    }
}


- (void)testForeignKeyRelationshipsLazy
{

    NSMutableArray *notifications = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:notifications selector:@selector(addObject:) name:kDCKeyValueObjectMappingObjectLazyCreateNotification
                                               object:nil];

    DCManagedObjectMapping *parser;
    parser = [self createAlbumMappingWithFullSongSerialization:NO];
    [parser parseArray:albumsFixture];
    NSArray *albums = [Album findAllObjectsInContext:ctx];
    NSArray *artists = [Artist findAllObjectsInContext:ctx];

    for (Album *album in albums) {
        STAssertNotNil(album.artist, nil);
        STAssertTrue([album.artist.albums containsObject:album], nil);
    }

    for (Artist *artist in artists) {
        STAssertTrue(artist.albums.count >= 1, nil);
        STAssertTrue(((Album *)[artist.albums anyObject]).artist == artist, nil);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:notifications name:kDCKeyValueObjectMappingObjectLazyCreateNotification object:nil];

    STAssertTrue(notifications.count==artists.count, nil);

}


- (void)testManagedObjectSimpleSerialization
{
    DCManagedObjectMapping *parser = [self createArtistMapping];

    NSDictionary *artistFixture = [artistsFixture lastObject];

    [parser parseDictionary:artistFixture];
    Artist * artist = [[Artist findAllObjectsInContext:ctx] lastObject];
    NSDictionary *serializedArtist = [parser serializeObject:artist];

    STAssertEqualObjects(artistFixture, serializedArtist, nil);
}


- (void)testManagedObjectSerialization
{
    DCManagedObjectMapping *parser = [self createArtistMapping];

    [parser parseArray:artistsFixture];
    NSArray *artists =  [Artist findAllObjectsInContext:ctx];

    parser = [self createAlbumMappingWithFullSongSerialization:NO];
    [parser parseDictionary:[albumsFixture lastObject]];
    Album *album = [[Album findAllObjectsInContext:ctx] lastObject];

    NSDictionary *serializedAlbum = [parser serializeObject:album];

    STAssertEqualObjects([serializedAlbum valueForKey:@"artist"], [[albumsFixture lastObject] valueForKey:@"artist"],
    nil);

    for (Song *song in album.songs) {
        STAssertTrue([[serializedAlbum objectForKey:@"songs"] containsObject:song.id], nil);
    }
}

- (void)testNestedManagedObjectSerializationSanity
{
    DCManagedObjectMapping *parser = [self createArtistMapping];

    [parser parseArray:artistsFixture];
    NSArray *artists =  [Artist findAllObjectsInContext:ctx];


    parser = [self createAlbumMappingWithFullSongSerialization:YES];

    [parser parseArray:albumsFixture];
    NSArray *albums =  [Album findAllObjectsInContext:ctx];

    albums = [albums sortedArrayUsingComparator: ^(Album* obj1, Album* obj2) {
        return [obj1.id compare:obj2.id];
    }];

    NSArray*serializedAlbums = [parser serializeObjectArray:albums];

    STAssertTrue(albumsFixture.count == serializedAlbums.count, nil);

    [albumsFixture enumerateObjectsUsingBlock:^(NSDictionary * albumDictionary, NSUInteger i, BOOL* stop){
        NSMutableDictionary *mAlbumDictionary = [NSMutableDictionary dictionaryWithDictionary:albumDictionary];
        NSMutableDictionary *mSerializedAlbumDictionary = [NSMutableDictionary
                dictionaryWithDictionary:[serializedAlbums objectAtIndex:i]];
        [mAlbumDictionary setObject:[NSSet setWithArray:[mAlbumDictionary objectForKey:@"songs"]] forKey:@"songs"];
        [mSerializedAlbumDictionary setObject:[NSSet setWithArray:[mSerializedAlbumDictionary objectForKey:@"songs"]] forKey:@"songs"];

        STAssertEqualObjects(mAlbumDictionary, mAlbumDictionary, nil);



    }];

    // compare two sets of songs
}
@end