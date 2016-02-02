//
//  XmlToDictionary.m
//  FoundIt
//
//  Created by Kusuma Kumari on 19/08/11.
//  Copyright 2011 PurpleTalk. All rights reserved.
//

#import "XmlToDictionary.h"

@implementation XMLToDictionary

- (id)init
{
    self = [super init];
	if (self) {
		array = [[NSMutableArray alloc] initWithCapacity:0];
		dict = [[NSMutableDictionary alloc] initWithCapacity:0];
		[array addObject:dict];
        
		enableDebug = NO;
		failed = NO;
		return self;
	}

    return nil;
}


- (void)setNeedAttributesKey:(BOOL)attribsKey needEmptyTags:(BOOL)emptyTags
{
	needAttributesKey = attribsKey;
	needEmptyTags = emptyTags;
}


- (void)setNeedCharactersOnlyDictionaries:(BOOL)needCharacters
                    needEmptyDictionaries:(BOOL)emptyDictionaries
{
	needCharactersOnlyDictionaries = needCharacters;
	needEmptyDictionaries = emptyDictionaries;
}


- (NSDictionary *)parseData:(NSData *)data enableDebug:(BOOL)enable
{
	enableDebug = enable;
    
	if (data == nil || [data length] <= 0) {
		[dict release];
		[array release];
		return nil;
	}
    
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldResolveExternalEntities:NO];
	[parser parse];
    
	dict = [array objectAtIndex:0];
	[array removeAllObjects];
	[array release];
	[parser release];
    
	if (failed == YES) {
		//[dict release];
		return dict;
	} else {
		return dict;
	}
}

- (void)parser:(NSXMLParser *)parser
foundUnparsedEntityDeclarationWithName:(NSString *)name
      publicID:(NSString *)publicID
      systemID:(NSString *)systemID
  notationName:(NSString *)notationName
{
}


- (void)dealloc
{
	[super dealloc];
}


- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	if (enableDebug)
		NSLog(@"XML parsing began");
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	if (enableDebug)
		NSLog(@"XML parsing completed");
}


- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
	NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithCapacity:0];
	if ([attributeDict count] > 0) {
		if (needAttributesKey) {
			[d setObject:attributeDict forKey:@"attributes"];
		} else {
			[d setDictionary:attributeDict];
		}
	}
	
	id obj = [dict objectForKey:elementName];
	if (obj == nil) {
        [dict setObject:d forKey:elementName];
    } else {
		if ([obj isKindOfClass:[NSMutableArray class]]) {
            [obj addObject:d];
        } else {
			NSMutableArray *a = [[NSMutableArray alloc] initWithCapacity:0];
			[a addObject:obj];
			[a addObject:d];
			[dict setObject:a forKey:elementName];
			[a autorelease];
		}
	}
	
	dict = d;
	[array addObject:dict];
	[dict  autorelease];
}


- (void)removeEmptyDictionary:(NSMutableDictionary *)childDict
                     fromDict:(NSMutableDictionary *)parentDict
                   forElement:(NSString*)elementName
{
	NSArray* ar = [parentDict allKeysForObject:childDict];
    
	if ([ar count] == 1) {
		[parentDict removeObjectForKey:[ar objectAtIndex:0]];
	} else if ([ar count] == 0) {
		NSMutableArray* ar = [parentDict objectForKey:elementName];
		if ([ar containsObject:childDict] == YES) {
			[ar removeObject:childDict];
		}
	}	
}


- (void)removeCharacterOnlyDictionary:(NSMutableDictionary *)childDict
                             fromDict:(NSMutableDictionary *)parentDict
                           forElement:(NSString *)elementName
{
	NSArray* ar = [parentDict allKeysForObject:childDict];
	NSString* str = [childDict objectForKey:@"characters"];
	
	if ([ar count] == 1) {
		[parentDict setObject:str forKey:[ar objectAtIndex:0]];
	} else if ([ar count] == 0) {
		NSMutableArray* ar = [parentDict objectForKey:elementName];
		if ([ar containsObject:childDict] == YES) {
			[ar addObject:str];
			[ar removeObject:childDict];
		}
	}	
}


- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
	NSMutableString* str = [dict objectForKey:@"characters"];
	if (str != nil) {
		[str setString:[str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t\n "]]];
		
		if ([str length] == 0) {
			if (needEmptyTags == NO)
				[dict removeObjectForKey:@"characters"];
		}
	}
    
	NSMutableDictionary* childDict = dict;
    
	[array removeLastObject];
	dict = [array lastObject];
	
	if ([childDict count] == 0 && needEmptyDictionaries == NO) {
		[self removeEmptyDictionary:childDict fromDict:dict forElement:elementName];
	}
    
	if (needCharactersOnlyDictionaries == NO && [childDict count] == 1 &&
        [childDict objectForKey:@"characters"] != nil) {
		[self removeCharacterOnlyDictionary:childDict fromDict:dict forElement:elementName];
	}
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	failed = YES;
	NSLog(@"Failed to parse XML... \n Reason: %@", [parseError localizedDescription]);
	NSLog(@"line - %d column - %d", [parser lineNumber], [parser columnNumber]);
}


- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError
{
	failed = YES;
	NSLog(@"Failed to validate XML... \n Reason: %@", [validError localizedDescription]);
	NSLog(@"line - %d column - %d", [parser lineNumber], [parser columnNumber]);
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	NSMutableString *chars = [dict objectForKey:@"characters"];
    
	if (chars == nil) {
		chars = [[NSMutableString alloc] initWithCapacity:0];
		[dict setObject:chars forKey:@"characters"];
		[chars release];
	}
    
	[chars appendString:string];
}


- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
	[dict setObject:CDATABlock forKey:@"cdata"];
}


@end
