#import "ImageUploader.h"
#import "Constants.h"

#define NOTIFY_AND_LEAVE(X) {[self cleanup:X]; return nil;}
#define DATA(X)	[X dataUsingEncoding:NSUTF8StringEncoding]

// Posting constants
#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define BOUNDARY @"------------0x0x0x0x0x0x0x0x"

@implementation ImageUploader
@synthesize theImage;


- (NSString*) syncUpload:(NSData *) uploadImage
{
    self.theImage = uploadImage;
    return [self main];
}

- (void) cleanup: (NSString *) output
{
	self.theImage = nil;
}

- (NSData*)generateFormDataFromPostDictionary:(NSDictionary*)dict
{
    id boundary = BOUNDARY;
    NSArray* keys = [dict allKeys];
    NSMutableData* result = [NSMutableData data];
	
    for (int i = 0; i < [keys count]; i++) 
    {
        id value = [dict valueForKey: [keys objectAtIndex:i]];
        [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
		if ([value isKindOfClass:[NSData class]]) 
		{
			// handle image data
			NSString *formstring = [NSString stringWithFormat:IMAGE_CONTENT, [keys objectAtIndex:i]];
			[result appendData: DATA(formstring)];
			[result appendData:value];
		}
		
		NSString *formstring = @"\r\n";
        [result appendData:DATA(formstring)];
    }
	
	NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    [result appendData:DATA(formstring)];
    return result;
}

- (NSString*) main
{
	if (!self.theImage) {
		NOTIFY_AND_LEAVE(@"Please set image before uploading.");
    }
    NSString* MultiPartContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY];
    
	NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
	[post_dict setObject:@"uploadedfile" forKey:@"filename"];
    [post_dict setObject:self.theImage forKey:@"uploadedfile"];
	
	NSData *postData = [self generateFormDataFromPostDictionary:post_dict];
	
    NSString *baseurl = [NSString stringWithFormat:@"%@testupload.php", kAppBaseUrl];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    if (!urlRequest) NOTIFY_AND_LEAVE(@"Error creating the URL Request");
	
    [urlRequest setHTTPMethod: @"POST"];
  	[urlRequest setValue:MultiPartContentType forHTTPHeaderField: @"Content-Type"];
    [urlRequest setHTTPBody:postData];
	
    NSError *error;
    NSURLResponse *response;
	NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    //NSLog(@"***** result =%@", result);
    
    if (!result)
	{
		[self cleanup:[NSString stringWithFormat:@"upload error: %@", [error localizedDescription]]];
        return nil;
	}
	
	// Return results
    NSString *outstring = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"***** outstring =%@", outstring);
	[self cleanup: outstring];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[outstring dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    if ( !error )
    {
        if ( [[json objectForKey:@"success"] isEqualToString:@"1"] )
            return [json objectForKey:@"path"];
    }
    return nil;
}

+ (void)uploadPhoto:(NSData*)imageData
              title:(NSString*)title
        description:(NSString*)description
//      imgurClientID:(NSString*)clientID
    completionBlock:(void(^)(NSString* result))completion
       failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock
{
    NSAssert(imageData, @"Image data is required");
//    NSAssert(clientID, @"Client ID is required");
    
    NSString *urlString = [NSString stringWithFormat:@"%@testupload.php", kAppBaseUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *requestBody = [[NSMutableData alloc] init];
    
    NSString *boundary = @"---------------------------0983745982375409872438752038475287";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // Add client ID as authrorization header
//    [request addValue:[NSString stringWithFormat:@"Client-ID %@", clientID] forHTTPHeaderField:@"Authorization"];
    
    // Image File Data
    [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[@"Content-Disposition: attachment; name=\"uploadedfile\"; filename=\".tiff\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [requestBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[NSData dataWithData:imageData]];
    [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Title parameter
    if (title) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[title dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // Description parameter
    if (description) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[description dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [requestBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:requestBody];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                                  options:NSJSONReadingMutableContainers
                                                                                                    error:nil];
                               if (![[responseDictionary valueForKeyPath:@"success"] isEqualToString:@"1"] ) {
                                   if (failureBlock) {
                                       if (!error) {
                                           // If no error has been provided, create one based on the response received from the server
                                           error = [NSError errorWithDomain:@"imguruploader"
                                                                       code:10000
                                                                   userInfo:@{NSLocalizedFailureReasonErrorKey :
                                                                                  [responseDictionary valueForKeyPath:@"data.error"]}];
                                       }
                                       failureBlock(response, error, [[responseDictionary valueForKey:@"status"] intValue]);
                                   }
                               } else {
                                   if (completion) {
                                       completion([responseDictionary valueForKeyPath:@"path"]);
                                   }
                                   
                               }
                               
                           }];
}

@end
