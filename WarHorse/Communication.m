//
//  Communication.m
//  PoliticalApp
//
//  Created by Anand Kumar Golla on 2/14/12.
//  Copyright 2012 YQ Labs. All rights reserved.
//

#import "Communication.h"
#import "SBJSON.h"
//#import "LeveyHUD.h"
#define TIMEOUT_INTERVAL 30

@implementation Communication
@synthesize delegate,serviceFor;

- (void)makeAsynchronousRequestWithUrl:(NSURL *)url withBodyString:(NSString *)body andWithMethod:(NSString *)method{
    
	//NSLog(@"Url = %@",url);
    //NSLog(@"Body = %@",body);
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];//application/x-www-form-urlencoded
	[theRequest setHTTPMethod:method];
	[theRequest setTimeoutInterval:TIMEOUT_INTERVAL];
    if (body != nil) {
        [theRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	//NSLog(@"theConnection %@",theConnection);
	if(theConnection){
		responseData = [[NSMutableData data] retain];
        //NSLog(@"responseData %@",responseData);
		[theConnection release];
        theConnection = nil;
        
	}
	else {
	}
    
}

- (void)makeSynchronousRequestWithUrl:(NSURL *)url withBodyString:(NSString *)body andWithMethod:(NSString *)method{
//	NSLog(@"url = %@",url);
//    NSLog(@"body = %@",body);
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	
	[theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
	[theRequest setTimeoutInterval:TIMEOUT_INTERVAL];
    
    if (body != nil) {
        [theRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
	
    NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *responseData1 = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
	
	NSString *str =  [[NSString alloc] initWithData:responseData1 encoding:NSUTF8StringEncoding];
	
    
	SBJSON *parser = [[SBJSON alloc] init];
	id data = [parser objectWithString:str error:nil];
    
    NSHTTPURLResponse * httpResponse;
	httpResponse = (NSHTTPURLResponse *) response;
    //NSLog(@"HTTP error %d",httpResponse.statusCode);
    
//	NSLog(@"data = %@",data);
    
	[parser release]; parser = nil;
	[str release]; str	= nil;
    
	if (error && [responseData1 length] == 0) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(failedToGetDataWithError:andWithServiceName:)]) {
			if (error) {
				[self.delegate failedToGetDataWithError:[NSString stringWithFormat:@"Could not register you,%@",[error localizedDescription]] andWithServiceName:serviceFor];
			}
			else {
				[self.delegate failedToGetDataWithError:@"No Data Found" andWithServiceName:serviceFor];
			}
		}
		return;
	}
	else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseData:andWithServiceName:)]) {
            [self.delegate responseData:data andWithServiceName:serviceFor];
        }
	}
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response{
	[responseData setLength:0];
	NSHTTPURLResponse * httpResponse;
	
	httpResponse = (NSHTTPURLResponse *) response;
	
	NSLog(@"HTTP error %zd", (ssize_t) httpResponse.statusCode);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error{
	[responseData release];
    
	if (self.delegate) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(failedToGetDataWithError:andWithServiceName:)]) {
			[self.delegate failedToGetDataWithError:[error localizedDescription] andWithServiceName:serviceFor];
		}
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	NSString *str =  [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"++++++++Str+++++++++++++%@",str);
	SBJSON *parser = [[SBJSON alloc] init];
    
	id data = [parser objectWithString:str error:nil];
    //id data = [parser fragmentWithString:str error:nil];
//    NSLog(@"data is......%@",data);
    
	[parser release]; parser = nil;
	[str release]; str	= nil;
    if ([responseData length] == 0) {
        if (self.delegate && self.delegate && [self.delegate respondsToSelector:@selector(failedToGetDataWithError:andWithServiceName:)]){
            [self.delegate failedToGetDataWithError:@"No Data Found" andWithServiceName:serviceFor];
        }
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseData:andWithServiceName:)]) {
            [self.delegate responseData:data andWithServiceName:serviceFor];
        }
    }
    [responseData release];responseData = nil;
}



- (void) dealloc{
	self.delegate = nil;
	[serviceFor release];serviceFor = nil;
	[super dealloc];
}
@end
