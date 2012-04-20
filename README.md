Introduction
=========================

**KeyValueObjectMapping** is a Cocoa framework that provides an easy way to deal with any key/value type, as JSON, plist and even a common *NSDictionary*. With no additional framework.

It's made to be used with *NSJSONSerialization* and other resources, and the main goal is to avoid the tedious work when you need to deal with key/value types.

Features
-------------------------

* Transform any kind of Key/Value type to a desired object. Can be a JSON, PLIST or a simple NSDictionary.
* Don't generate accessors to all the attribute, keep your properties *readonly* and framework will do it's magic to put the value on the object.
* Based on Convention over Configuration
    1. If your attribute follow the same name of the key on the NSDictionary everything will be done automatically.
    1. If the keys on source are separated by some character, you can configure which character is and the framework will split and camelcase it to find the properly attribute.
* Map any key to a specific attribute that doesn't follow the convention using **DCObjectMapping**.
* To map an *one-to-many* relation use **DCArrayMapping** to tell what is the specific type of elements that will be inserted.
* Parse *NSDate* using a specific date pattern(passed through the configuration) or if it's send on JSON in milliseconds since Jan 1, 1970 (*UNIX* timestamp) will be parsed with no additional configuration.
* Having a property pointing to a **NSURL**, framework will try to *[NSURL URLWithString:]* with the value.

Usage
-------------------------

**KeyValueObjectMapping** is a simple object, all you need to do is create a new object and start to transform a dictionary to any classes.

Let's assume that you have some JSON like that:
<pre>
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
</pre>

And your User model looks like:
<pre>
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
</pre>

Using any JSON parser you need to transform this *NSString* to a *NSDictionary* representation:
<pre>
NSError *error;
NSDictionary *jsonParsed = [NSJSONSerialization JSONObjectWithData:jsonData
	                              options:NSJSONReadingMutableContainers 
																error:&error];
</pre>

If you don't use **KeyValueObjectMapping** you need to create an instance of *User* type, and set all the properties with the same key name on the dictionary. And transform it when needed.

<pre>
User *user = [[User alloc] init];
[user setIdStr: [jsonParsed objectForKey: @"id_str"]];
[user setName: [jsonParsed objectForKey: @"name"]];
[user setScreenName: [jsonParsed objectForKey: @"screen_name"]];

NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
formatter.dateFormat = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
NSDate *date = [formatter dateFromString:@"Sat Apr 14 00:20:07 +0000 2012"];

[user setCreatedAt: date];
</pre>

Boring job, don't you think? So, if you use **KeyValueObjectMapping** you just need to give the dictionary and the class that you want to create, and everthing else will be made automatically. 

<pre>
DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass: [Tweet class]];

Tweet *tweet = [parser parseDictionary:jsonParsed];
NSLog(@"%@ - %@", tweet.idStr, tweet.name);
</pre>

#### DCParserConfiguration

If your *NSDate* pattern are different then the default, which is `@"eee MMM dd HH:mm:ss ZZZZ yyyy"`, you can configure to use a different one. So, there is an object to add custom configuration to the framework.

Using **DCParserConfiguration** you can change the default behavior of some components, like the default pattern to parse a date.

<pre>
DCParserConfiguration *config = [DCParserConfiguration configuration];
config.dateFormat = @"dd/MM/yyyy";

DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass: [Tweet class] andConfiguration: config];
</pre>

Overriding Key Name for Attribute
-------------------------

If your JSON have some specific key that doesn't match the attribute name you can use **DCObjectMapping** to map this key to the attribute, the attribute type can be a specific Object either.

Your tweet model:
<pre>
@interface Tweet : NSObject
@property(nonatomic, readonly) NSString *idStr;
@property(nonatomic, readonly) NSString *tweetText;

@property(nonatomic, readonly) User *userOwner;

@end
</pre>

And the JSON received follow the struct:
<pre>
{
    "id_str": 190957570511478800,
    "text": "Tweet text",
    "user": {
        "name": "Diego Chohfi",
        "screen_name": "dchohfi",
        "location": "São Paulo"
    }
}
</pre>

Using **DCObjectMapping** you can parse this JSON and override the key names like that:

<pre>
DCParserConfiguration *config = [DCParserConfiguration configuration];

DCObjectMapping *textToTweetText = [DCObjectMapping mapKeyPath:@"text" toAttribute:@"tweetText" onClass:[Tweet class]];
DCObjectMapping *userToUserOwner = [DCObjectMapping mapKeyPath:@"user" toAttribute:@"userOwner" onClass:[Tweet class]];

[config addObjectMapping:textToTweetText];
[config addObjectMapping:userToUserOwner];

DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass: [Tweet class]  andConfiguration:config];
Tweet *tweetParsed = [parser parseDictionary:json];
</pre>

Parsing NSArray properties
-------------------------

Since Objective-C don't support typed collections like Java and other static language we can't figure out what it the type of elements inside a collection. 
But **KeyValueObjectMapping** can be configured to learn what is the type of elements that will be added to the collection on the specific attribute for the class.

So, if the model User have many Tweets:
<pre>
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
</pre>

The Tweet looks like:
<pre>
@interface Tweet : NSObject
@property(nonatomic, strong) NSString *idStr;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSDate *createdAt;

@end
</pre>

And the JSON looks like:
<pre>
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
</pre>

Using **DCArrayMapping** and adding it to the configuration, you tell to the **KeyValueObjectMapping** how to parse this specific attribute.

<pre>
DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements: :[Tweet class] forAttribute:@"tweets"] onClass:[User class]];
											
DCParserConfiguration *config = [DCParserConfiguration configuration];
[config addArrayMapper:mapper];

DCKeyValueObjectMapping *parser = [[DCKeyValueObjectMapping mapperForClass:[User class]  andConfiguration:configuration];
User *user = [parser parseDictionary:jsonParsed];
</pre>

Aggregating values to specific type
-------------------------

Sometimes you faces an JSON to parse that you don't have access to modify the struct, and you don't want to make your classes follow that specific struct.
Using **DCPropertyAggregator** you can aggregate more than one key/value to a specific attribute on your domain.

So, if your JSON looks like that:
<pre>
{
	"tweet" : "Some text",
	"latitude" : -23.588453,
	"longitude" : -46.632103,
	"distance" : 100
}
</pre>

If you follow this JSON struct your objects won't be so organized, right?
So, you can make your objects follow something different:
<pre>
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
</pre>

And using **DCPropertyAggregator** to map this specific behavior:
<pre>
DCPropertyAggregator *aggregteLatLong = [DCPropertyAggregator aggregateKeys:[NSSet setWithObjects:@"latitude", @"longitude", nil] intoAttribute:@"point"];
DCPropertyAggregator *aggregatePointDist = [DCPropertyAggregator aggregateKeys:[NSSet setWithObjects:@"point", @"distance", nil] intoAttribute:@"location"];

DCParserConfiguration *configuration = [DCParserConfiguration configuration];
[configuration addAggregator:aggregteLatLong];
[configuration addAggregator:aggregatePointDist];

DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Tweet class] andConfiguration:configuration];
Tweet *tweet = [parser parseDictionary: json];
</pre>