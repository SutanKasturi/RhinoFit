//
//  Header.h
//  2B1S
//
//  Created by Admin on 9/28/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

@interface ImageUploader : NSObject {
    NSData *theImage;
}
@property (retain) NSData *theImage;
- (NSString*) syncUpload:(NSData *) uploadImage;

+ (void)uploadPhoto:(NSData*)imageData
              title:(NSString*)title
        description:(NSString*)description
    completionBlock:(void(^)(NSString* result))completion
       failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock;
@end
