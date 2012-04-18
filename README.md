Introduction
=========================

**KeyValueObjectMapping** is a Cocoa framework that provides an easy way to deal with any key/value type, as JSON, plist and even a common *NSDictionary*.

It's made to be used with *NSJSONSerialization* and other resources, and the main goal is to avoid the tedious work when you need to deal with key/value types.

Features
-------------------------

* Transform any kind of Key/Value type to a desired object. Can be a JSON, PLIST or a simple NSDictionary.
* Don't generate accessors to all the attribute, keep your properties *readonly* and framework will do it's magic to put the value on the object.
* Based on Convention over Configuration
    1. If your attribute follow the same name of the key on the NSDictionary everything will be done automatically.
    1. If the key on NSDictionary are splited between some character, you can configure which character is and the framework will split and camelcase it to find the properly attribute.
* Map any key to a specific attribute that doesn't follow the convention sugin **DCObjectMapping**.
* To map an *one-to-many* relation use **DCArrayMapping** to tell what is the specific type of elements that will be inserted.
* Parse *NSDate* using a specific date pattern(passed through the configuration) or if it's send on JSON in milliseconds since Jan 1, 1970 will be parsed with no additional configuration.
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

Boring job, don't you think? So, if you use **KeyValueObjectMapping** you just need to give the dictionary and the class that you want to create, and everthing else will be made automatically. And you can configure the parser to behave like you want, giving some pattern for *NSDate* parser, the character that separate the keys (on example we have used an '_' character, which is the default), and so on.

<pre>
ParserConfiguration *config = [[ParserConfiguration alloc] init];
config.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";

KeyValueObjectMapping * parser = [[KeyValueObjectMapping alloc] initWithConfiguration:config];

Tweet *tweet = [parser parseDictionary:jsonParsed forClass:[Tweet class]];
NSLog(@"%@ - %@", tweet.idStr, tweet.name);
</pre>

Pretty easy, hã?

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
DCParserConfiguration *config = [[DCParserConfiguration alloc] init];

DCObjectMapping *textToTweetText = [DCObjectMapping mapKeyPath:@"text" toAttribute:@"tweetText" onClass:[Tweet class]];
DCObjectMapping *userToUserOwner = [DCObjectMapping mapKeyPath:@"user" toAttribute:@"userOwner" onClass:[Tweet class]];

[config addObjectMapping:textToTweetText];
[config addObjectMapping:userToUserOwner];

DCKeyValueObjectMapping *parser = [[DCKeyValueObjectMapping alloc] initWithConfiguration:config];
Tweet *tweetParsed [parser parseDictionary:json forClass:[Tweet class]];;
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
DCArrayMapping *mapper = [[DCArrayMapping alloc] initWithClassForElements:[Tweet class] forKeyAndAttributeName:@"tweets"] inClass:[User class]];
											
DCParserConfiguration *config = [[DCParserConfiguration alloc] init];
[config addMapper:mapper];
config.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";

DCKeyValueObjectMapping *parser = [[DCKeyValueObjectMapping alloc] initWithConfiguration:configuration];
User *user = [parser parseDictionary:jsonParsed forClass:[User class]];
</pre>