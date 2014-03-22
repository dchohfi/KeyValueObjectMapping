Introduction
=========================

**KeyValueObjectMapping** is a Cocoa framework that provides an easy way to deal with any key/value type, as [`JSON`][JSON], [`XML`][XML], [`plist`][plist] and even a common [`NSDictionary`][NSDictionary]. With no additional framework.

It's made to be used together with a parser, such: [`NSJSONSerialization`][NSJSONSerialization], [`JSONKit`][JSONKit], [`NSXMLParser`][NSXMLParser] and other resources, and the main goal is to avoid the tedious work when you need to deal with key/value types.

Features
-------------------------

* Transform any kind of Key/Value type to a desired object. Can be a [`JSON`][JSON], [`XML`][XML], [`plist`][plist] or a simple [`NSDictionary`][NSDictionary].
* Don't generate accessors to all the attribute, keep your properties *readonly* and framework will do it's magic to put the value on the object.
* Based on Convention over Configuration
    1. If your attribute follow the same name of the key on the [`NSDictionary`][NSDictionary] everything will be done automatically.
    1. If the keys on source are separated by some character, you can configure which character is and the framework will split and camelcase it to find the properly attribute.
* Awesome customizations via **blocks**, change the default behavior when creating an instance or parsing a value. Using [`DCCustomInitialize`][DCCustomInitialize] and [`DCCustomParser`][DCCustomParser].
* Map any key to a specific attribute that doesn't follow the convention using [`DCObjectMapping`][DCObjectMapping].
* To map an *one-to-many* relation use [`DCArrayMapping`][DCArrayMapping] to tell what is the specific type of elements that will be inserted.
* Aggregate values to an specific attribute using [`DCPropertyAggregator`][DCPropertyAggregator].
* Parse [`NSDate`][NSDate] using a specific date pattern(passed through the configuration) or if it's send on [`JSON`][JSON] in milliseconds since Jan 1, 1970 (*UNIX* timestamp) will be parsed with no additional configuration.
* Having a property pointing to a [`NSURL`][NSURL], framework will try to use `[NSURL URLWithString:]` method passing the value as a [`NSString`][NSString].

Installation
-------------------------

* Using [`CocoaPods`][CocoaPods], the easier way to manage dependencies on Objective-C world.

* Using [`iOS-Universal-Framework`][iOS-Universal-Framework]
	Since **KeyValueObjectMapping** uses [`iOS-Universal-Framework`][iOS-Universal-Framework] to build and compile the project, you can easily compile and drag the *.framework* that **iOS-Universal-Framework** generates into your application, import the header *DCKeyValueObjectMapping.h* and start using the framework.
		
	* Required import:
	
	```objc
		#import <KeyValueObjectMapping/DCKeyValueObjectMapping.h>
	```

Usage
-------------------------

**KeyValueObjectMapping** is a simple object, all you need to do is create a new object and start to transform a dictionary to any classes.

Let's assume that you have some [`JSON`][JSON] like that:
```js
{
	"id_str": "27924446",
	"name": "Diego Chohfi",
	"screen_name": "dchohfi",
	"location": "São Paulo",
	"description": "Instrutor na @Caelum, desenvolvedor de coração, apaixonado por música e cerveja, sempre cerveja.",
	"url": "http://about.me/dchohfi",
	"protected": false,
	"created_at": "Tue Mar 31 18:01:12 +0000 2009"
}
```

And your `User` model looks like:
```objective-c
@interface User : NSObject
@property(nonatomic, strong) NSString *idStr;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *screenName;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) BOOL protected;
@property(nonatomic, strong) NSNumber *followersCount;
@property(nonatomic, strong) NSDate *createdAt;
@end
```

Using any [`JSON`][JSON] parser you need to transform this [`NSString`][NSString] to a [`NSDictionary`][NSDictionary] representation:
```objective-c
NSError *error;
NSDictionary *jsonParsed = [NSJSONSerialization JSONObjectWithData:jsonData
	                              options:NSJSONReadingMutableContainers error:&error];
```

If you don't use **KeyValueObjectMapping** you need to create an instance of `User` type, and set all the properties with the same key name on the dictionary. And transform it when needed.

```objective-c
User *user = [[User alloc] init];
[user setIdStr: [jsonParsed objectForKey: @"id_str"]];
[user setName: [jsonParsed objectForKey: @"name"]];
[user setScreenName: [jsonParsed objectForKey: @"screen_name"]];

NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
formatter.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
NSDate *date = [formatter dateFromString:@"Sat Apr 14 00:20:07 +0000 2012"];

[user setCreatedAt: date];
```

Boring job, don't you think? So, if you use **KeyValueObjectMapping** you just need to give the dictionary and the class that you want to create, and everthing else will be made automatically. 

```objective-c
DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass: [Tweet class]];

Tweet *tweet = [parser parseDictionary:jsonParsed];
NSLog(@"%@ - %@", tweet.idStr, tweet.name);
```

#### DCParserConfiguration

If your [`NSDate`][NSDate] pattern are different then the default, which is `@"eee MMM dd HH:mm:ss ZZZZ yyyy"`, you can configure to use a different one. So, there is an object to add custom configuration to the framework.

Using [`DCParserConfiguration`][DCParserConfiguration] you can change the default behavior of some components, like the default pattern to parse a date.

```objective-c
DCParserConfiguration *config = [DCParserConfiguration configuration];
config.datePattern = @"dd/MM/yyyy";

DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass: [Tweet class] andConfiguration: config];
```

Overriding Key Name for Attribute
-------------------------

If your [`JSON`][JSON] have some specific key that doesn't match the attribute name you can use [`DCObjectMapping`][DCObjectMapping] to map this key to the attribute, the attribute type can be a specific Object either.

Your `Tweet` model:
```objective-c
@interface Tweet : NSObject
@property(nonatomic, readonly) NSString *idStr;
@property(nonatomic, readonly) NSString *tweetText;

@property(nonatomic, readonly) User *userOwner;

@end
```

And the [`JSON`][JSON] received follow the struct:
```js
{
    "id_str": 190957570511478800,
    "text": "Tweet text",
    "user": {
        "name": "Diego Chohfi",
        "screen_name": "dchohfi",
        "location": "São Paulo"
    }
}
```

Using [`DCObjectMapping`][DCObjectMapping] you can parse this [`JSON`][JSON] and override the key names like that:

```objective-c
DCParserConfiguration *config = [DCParserConfiguration configuration];

DCObjectMapping *textToTweetText = [DCObjectMapping mapKeyPath:@"text" toAttribute:@"tweetText" onClass:[Tweet class]];
DCObjectMapping *userToUserOwner = [DCObjectMapping mapKeyPath:@"user" toAttribute:@"userOwner" onClass:[Tweet class]];

[config addObjectMapping:textToTweetText];
[config addObjectMapping:userToUserOwner];

DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass: [Tweet class]  andConfiguration:config];
Tweet *tweetParsed = [parser parseDictionary:json];
```

Parsing [`NSArray`][NSArray] properties
-------------------------

Since Objective-C don't support typed collections like Java and other static language we can't figure out what it the type of elements inside a collection. 
But **KeyValueObjectMapping** can be configured to learn what is the type of elements that will be added to the collection on the specific attribute for the class.

So, if the model `User` have many Tweets:
```objective-c
@interface User : NSObject
@property(nonatomic, strong) NSString *idStr;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *screenName;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) BOOL protected;
@property(nonatomic, strong) NSNumber *followersCount;
@property(nonatomic, strong) NSDate *createdAt;

@property(nonatomic, strong) NSArray *tweets;

@end
```

The `Tweet` looks like:
```objective-c
@interface Tweet : NSObject
@property(nonatomic, strong) NSString *idStr;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSDate *createdAt;

@end
```

And the [`JSON`][JSON] looks like:
```js
{
    "id_str": "27924446",
    "name": "Diego Chohfi",
    "screen_name": "dchohfi",
    "location": "São Paulo",
    "description": "Instrutor na @Caelum, desenvolvedor de coração, apaixonado por música e cerveja, sempre cerveja.",
    "url": "http://about.me/dchohfi",
    "protected": false,
    "created_at": "Tue Mar 31 18:01:12 +0000 2009",
		"tweets" : [
			{
				"created_at" : "Sat Apr 14 00:20:07 +0000 2012",
				"id_str" : 190957570511478784,
				"text" : "Tweet text"
			},
			{
				"created_at" : "Sat Apr 14 00:20:07 +0000 2012",
				"id_str" : 190957570511478784,
				"text" : "Tweet text"
			}
		]
}
```

Using [`DCArrayMapping`][DCArrayMapping] and adding it to the configuration, you tell to the **KeyValueObjectMapping** how to parse this specific attribute.

```objective-c
DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements: :[Tweet class] forAttribute:@"tweets"] onClass:[User class]];
											
DCParserConfiguration *config = [DCParserConfiguration configuration];
[config addArrayMapper:mapper];

DCKeyValueObjectMapping *parser = [[DCKeyValueObjectMapping mapperForClass:[User class]  andConfiguration:configuration];
User *user = [parser parseDictionary:jsonParsed];
```

Aggregating values to specific type
-------------------------

Sometimes you faces an [`JSON`][JSON] to parse that you don't have access to modify the struct, and you don't want to make your classes follow that specific struct.
Using [`DCPropertyAggregator`][DCPropertyAggregator] you can aggregate more than one key/value to a specific attribute on your domain.

So, if your [`JSON`][JSON] looks like that:
```js
{
	"tweet" : "Some text",
	"latitude" : -23.588453,
	"longitude" : -46.632103,
	"distance" : 100
}
```

If you follow this [`JSON`][JSON] struct your objects won't be so organized, right?
So, you can make your objects follow something different:
```objective-c
@interface Tweet : NSObject
@property(nonatomic, readonly) NSString *text;
@property(nonatomic, readonly) Location *location;
@end

@interface Location : NSObject
@property(nonatomic, readonly) NSNumber *distance;
@property(nonatomic, readonly) Point *point;
@end

@interface Point : NSObject
@property(nonatomic, readonly) NSNumber *latitude;
@property(nonatomic, readonly) NSNumber *longitude;
@end
```

And using [`DCPropertyAggregator`][DCPropertyAggregator] to map this specific behavior:
```objective-c
DCPropertyAggregator *aggregteLatLong = [DCPropertyAggregator aggregateKeys:[NSSet setWithObjects:@"latitude", @"longitude", nil] intoAttribute:@"point"];
DCPropertyAggregator *aggregatePointDist = [DCPropertyAggregator aggregateKeys:[NSSet setWithObjects:@"point", @"distance", nil] intoAttribute:@"location"];

DCParserConfiguration *configuration = [DCParserConfiguration configuration];
[configuration addAggregator:aggregteLatLong];
[configuration addAggregator:aggregatePointDist];

DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Tweet class] andConfiguration:configuration];
Tweet *tweet = [parser parseDictionary: json];
```

[NSJSONSerialization]: http://developer.apple.com/library/ios/#documentation/Foundation/Reference/NSJSONSerialization_Class/Reference/Reference.html
[JSONKit]: https://github.com/johnezang/JSONKit
[NSXMLParser]: https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSXMLParser_Class/Reference/Reference.html
[NSDictionary]: http://developer.apple.com/mac/library/documentation/Cocoa/Reference/Foundation/Classes/NSDictionary_Class/index.html
[NSArray]: http://developer.apple.com/mac/library/documentation/Cocoa/Reference/Foundation/Classes/NSArray_Class/index.html
[NSString]: http://developer.apple.com/mac/library/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/index.html
[NSURL]: https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSURL_Class/Reference/Reference.html
[JSON]: http://www.json.org/
[plist]: http://wikipedia.org/wiki/Property_list
[XML]: http://wikipedia.org/wiki/XML
[NSDate]: https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSDate_Class/Reference/Reference.html
[DCArrayMapping]: https://github.com/dchohfi/KeyValueObjectMapping/blob/master/KeyValueObjectMapping/DCArrayMapping.h
[DCPropertyAggregator]: https://github.com/dchohfi/KeyValueObjectMapping/blob/master/KeyValueObjectMapping/DCPropertyAggregator.h
[DCParserConfiguration]: https://github.com/dchohfi/KeyValueObjectMapping/blob/master/KeyValueObjectMapping/DCParserConfiguration.h
[DCObjectMapping]: https://github.com/dchohfi/KeyValueObjectMapping/blob/master/KeyValueObjectMapping/DCObjectMapping.h
[DCCustomInitialize]: https://github.com/dchohfi/KeyValueObjectMapping/blob/master/KeyValueObjectMapping/DCCustomInitialize.h
[DCCustomParser]: https://github.com/dchohfi/KeyValueObjectMapping/blob/master/KeyValueObjectMapping/DCCustomParser.h
[iOS-Universal-Framework]: https://github.com/kstenerud/iOS-Universal-Framework
[CocoaPods]: http://cocoapods.org

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/dchohfi/keyvalueobjectmapping/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

