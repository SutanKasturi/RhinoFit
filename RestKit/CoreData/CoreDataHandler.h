//
//  CoreDataHandler.h
//  TapTag
//
//  Created by Steve Gregory on 8/03/2014.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface CoreDataHandler  : NSObject <NSFetchedResultsControllerDelegate>{
    
}

- (void)deleteAllDataForEntity:(NSString*)entityName sortField:(NSString*)sortField;
- (void)deleteDataByValue:(NSString*)entityName fieldName:(NSString*)fieldName fieldValue:(NSNumber*)fieldValue;

- (void)insertNewRecord:(NSString*)entityName fields:(NSDictionary*)fields;
- (void)updateRecord:(NSString*)entityName idField:(NSString*)idField idValue:(NSNumber*)idValue fields:(NSDictionary*)fields;


- (NSArray*)getAllDataForEntity:(NSString*)entityName;
- (NSArray*)getAllDataForEntity:(NSString*)entityName sortField:(NSString*)_sortField ascending:(bool)_ascending;
- (NSArray*)getTopDataForEntity:(NSString*)entityName sortField:(NSString*)_sortField;
- (NSArray*)getEntityDataByID:(NSString*)entityName idField:(NSString*)idField idValue:(NSNumber*)idValue;
- (NSArray*)getEntityData:(NSString*)entityName field:(NSString*)field value:(NSString*)value;

- (void)storeImageForEntity:(NSString*)filePath EntityName:(NSString*)entityName PropertyName:(NSString*)propertyName;
- (void)storeImageForEntity:(NSString*)filePath EntityName:(NSString*)entityName PropertyName:(NSString*)propertyName IDField:(NSString*)idField IDValue:(NSNumber*)idValue;
@end
