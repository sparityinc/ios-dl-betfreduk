//
//  XmlToDictionary.h
//  FoundIt
//
//  Created by Kusuma Kumari on 19/08/11.
//  Copyright 2011 PurpleTalk. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __IPHONE_4_0
@interface XMLToDictionary : NSObject <NSXMLParserDelegate>
#else
@interface XMLToDictionary : NSObject
#endif
{
    
@private
    
	// the stack of dictionaries
	NSMutableArray		*array;
    
	// the current dictionary that is going to be filled
	NSMutableDictionary	*dict;
    
	// when set to YES, prints debug level logs on the console
	BOOL				enableDebug;
    
	// set this to YES, if you need a key named "attributes" to be added to the dictionary found while parsing an XML tag
	// ex: <books count=10><book></book></books>
	// the key-value pair "count=10" will be added to "attributes" key within the dictionary created for <books> tag
	BOOL				needAttributesKey;
    
	// when set to YES, this will preserve tags which do not have any content.
	// when set to NO, all tags with no data except whitespace characters will be removed
	BOOL				needEmptyTags;
    
	// when set to YES, any dictionaries (XML tags) with no sub-dictionaries or data within it will be removed
	BOOL				needEmptyDictionaries;
    
	// when set to YES, any dictionaries (XML tags) which only contain characters and no sub-dictionaries (XML sub-tags)
	// will have a key named "characters" with the value of the XML tag
	// ex: <book>iPhone SDK Programming</book>
	// for the above input...
    // when set to YES the output will be 
    // <key>book</key>
    // <dict>
    // 		<key>characters</key>
    //		<string>iPhone SDK Programming</string>
    // </dict>
    // when set to NO the output will be
    // <key>book</key>
    // <string>iPhone SDK Programming</string>
	BOOL				needCharactersOnlyDictionaries;
    
	// indicates whether XML Parsing failed
	BOOL				failed;
}


// the functions below set the parameters based on which the XML parser works
- (void)setNeedAttributesKey:(BOOL)attribsKey needEmptyTags:(BOOL)emptyTags;
- (void)setNeedCharactersOnlyDictionaries:(BOOL)needCharacters needEmptyDictionaries:(BOOL)emptyDictionaries;

// call this function to start parsing the XML input, this function should be processed only when the parameteres are set satisfactorily
- (NSDictionary*)parseData:(NSData*)data enableDebug:(BOOL)enable;

@end

