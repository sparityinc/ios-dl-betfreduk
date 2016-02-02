


#import <Foundation/Foundation.h>

@protocol CommunicatonDelegate
@required
-(void)responseData:(id)data andWithServiceName:(NSString *)serviceName;
-(void)failedToGetDataWithError:(NSString *)error andWithServiceName:(NSString *)serviceName;
@end


@interface Communication : NSObject {
	id delegate;
	NSMutableData *responseData;
	NSString *serviceFor;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString *serviceFor;

-(void)makeAsynchronousRequestWithUrl:(NSURL *)url withBodyString:(NSString *)body andWithMethod:(NSString *)method;
-(void)makeSynchronousRequestWithUrl:(NSURL *)url withBodyString:(NSString *)body andWithMethod:(NSString *)method;

@end