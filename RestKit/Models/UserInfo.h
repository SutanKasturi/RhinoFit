//
//  UserInfo.h
//  
//
//  Created by Admin on 10/17/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * userAddress1;
@property (nonatomic, retain) NSString * userAddress2;
@property (nonatomic, retain) NSString * userCity;
@property (nonatomic, retain) NSString * userCountry;
@property (nonatomic, retain) NSString * userFirstName;
@property (nonatomic, retain) NSString * userLastName;
@property (nonatomic, retain) NSString * userPhone1;
@property (nonatomic, retain) NSString * userPhone2;
@property (nonatomic, retain) NSString * userState;
@property (nonatomic, retain) NSString * userZip;
@property (nonatomic, retain) NSString * userEmail;
@property (nonatomic, retain) NSString * userPicture;

@end
