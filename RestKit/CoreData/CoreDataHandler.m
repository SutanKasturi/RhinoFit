//
//  CoreDataHandler.m
//  TapTag
//
//  Created by Steve Gregory on 8/03/2014.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "CoreDataHandler.h"
#import <objc/runtime.h>
#import <RestKit/RestKit.h>
#import <RestKit/ObjectMapping.h>

@implementation CoreDataHandler

- (void)updateRecord:(NSString*)entityName idField:(NSString*)idField idValue:(NSNumber*)idValue fields:(NSDictionary*)fields{
    NSError *error;
    NSManagedObjectContext *mOC =[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSLog(@"UPDATING: %@", fields);
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:idField ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"%K == %@", idField, idValue];
    
    [fetchRequest setPredicate:predicate];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:mOC
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    
    [fetchedResultsController performFetch:&error];
    for(id key in fields){
        NSLog(@"key: %@",key);
        NSLog(@"value: %@",[fields objectForKey:key]);
        [[fetchedResultsController fetchedObjects] setValue:[fields objectForKey:key] forKey:key];
    }

    if (![mOC save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
    
    if (![mOC saveToPersistentStore:&error]){
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
}

- (void)insertNewRecord:(NSString*)entityName fields:(NSDictionary*)fields{
    NSManagedObjectContext *mOC =[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSLog(@"SAVING: %@", fields);
    
    
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                            inManagedObjectContext:mOC];
    
    for (NSString *key in fields) {
        id sentObject = [fields valueForKey: key];
        [object setValue:sentObject forKey:key];
    }
    
    NSError *error;
    if (![mOC save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
    
    if (![mOC saveToPersistentStore:&error]){
         NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
}

- (void)deleteDataByValue:(NSString*)entityName fieldName:(NSString*)fieldName fieldValue:(NSNumber*)fieldValue{
    NSError *error;
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext save:&error];
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext saveToPersistentStore:&error];
    NSManagedObjectContext *mOC =[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:fieldName ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"%K == %@", fieldName, fieldValue];
    
    [fetchRequest setPredicate:predicate];
    
    // Setup fetched results
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:mOC
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    
    [fetchedResultsController performFetch:&error];
    
    for (id object in [ fetchedResultsController fetchedObjects]) {
        NSLog(@"DELETING ******* %@", object);
        [mOC deleteObject:object];
    }
    
    if (![mOC saveToPersistentStore:&error]) {
        NSLog(@"CORE DATA FAILED TO SAVE");
    }
    
    [mOC processPendingChanges];
    
}



- (void)deleteAllDataForEntity:(NSString*)entityName{
    NSManagedObjectContext *mOC =[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mOC];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [mOC executeFetchRequest:fetchRequest error:&error];
    for ( NSManagedObject *managedObject in items ) {
        [mOC deleteObject:managedObject];
        NSLog(@"%@ object deleted", entityName);
    }
    
    if ( ![mOC save:&error] ) {
        NSLog(@"Error deleting %@ - error: %@", entityName, error);
    }
}

-(NSArray*) getEntityDataByID:(NSString*)entityName idField:(NSString*)idField idValue:(NSNumber*)idValue{
    NSManagedObjectContext *mOC =[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mOC];
    [request setEntity:entity];
//    [request setResultType:NSDictionaryResultType];
    

   NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"%K == %d", idField, [idValue intValue]];
    
    [request setPredicate:predicate];

    // Execute the fetch.
    NSError *error = nil;
    NSArray *objects = [mOC executeFetchRequest:request error:&error];
    if (objects == nil) {
        return nil;
    }
    else {
        return objects;
    }
}

//- (NSArray*)getEntityDataByDate:(NSString*)entityName dateValue:(NSDate*)dateValue
//{
//    NSManagedObjectContext *mOC =[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mOC];
//    [request setEntity:entity];
//    //    [request setResultType:NSDictionaryResultType];
//    
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:<#(NSDate *)#>]
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                              @"(startDate >= %@) AND (endDate <=%@) AND day=%d", dateValue, dateValue, [dayValue intValue]];
//    
//    [request setPredicate:predicate];
//    
//    // Execute the fetch.
//    NSError *error = nil;
//    NSArray *objects = [mOC executeFetchRequest:request error:&error];
//    if (objects == nil) {
//        return nil;
//    }
//    else {
//        return objects;
//    }
//}

- (NSArray*)getAllDataForEntity:(NSString*)entityName{
    NSManagedObjectContext *mOC =[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mOC];
    [request setEntity:entity];
//    [request setResultType:NSDictionaryResultType];
    
    // Execute the fetch.
    NSError *error = nil;
    NSArray *objects = [mOC executeFetchRequest:request error:&error];
    if (objects == nil) {
        return nil;
    }
    else {
        return objects;
    }
}

- (NSArray*)getAllDataForEntity:(NSString*)entityName sortField:(NSString*)_sortField ascending:(bool)_ascending{
    NSManagedObjectContext *mOC =[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mOC];
    [request setEntity:entity];
//    [request setResultType:NSDictionaryResultType];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:_sortField ascending:_ascending];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    // Execute the fetch.
    NSError *error = nil;
    NSArray *objects = [mOC executeFetchRequest:request error:&error];
    if (objects == nil) {
        return nil;
    }
    else {
        return objects;
    }
    
}

- (NSArray*)getTopDataForEntity:(NSString*)entityName sortField:(NSString*)_sortField{
    NSManagedObjectContext *mOC =[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setFetchLimit:1];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mOC];
    [request setEntity:entity];
//    [request setResultType:NSDictionaryResultType];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:_sortField ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    // Execute the fetch.
    NSError *error = nil;
    NSArray *objects = [mOC executeFetchRequest:request error:&error];
    if (objects == nil) {
        return nil;
    }
    else {
        
        NSLog(@"%@", objects);
        return objects;
    }
    
}


- (void)storeImageForEntity:(NSString*)filePath EntityName:(NSString*)entityName PropertyName:(NSString*)propertyName IDField:(NSString*)idField IDValue:(NSNumber*)idValue{
    NSManagedObjectContext *mOC =[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSError *error = nil;
    Class entityClass = NSClassFromString(entityName);
    //id entityObject = [[entityClass alloc] init];
    id entityObject;
    
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:mOC]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"%K == %d", idField, [idValue intValue]];
    [request setPredicate:predicate];
    
    entityObject = [[mOC executeFetchRequest:request error:&error] lastObject];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(entityClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *classProperty = [NSString stringWithFormat:@"%s",property_getName(property)];
        //NSLog(@"propertyName: %@", classProperty);
        if ([classProperty isEqualToString:propertyName]) {
            [entityObject setValue:filePath forKey:propertyName];
        }
    }
    error = nil;
    //IMPORTANT NOTE!! THE RESTKIT SAVE DOESN"T ALWAYS PERSIST THE CHANGE!!!
    if (![mOC saveToPersistentStore:&error]) {
        //if (![mOC save:&error]) {
        //Handle any error with the saving of the context
        NSLog(@"CORE DATA FAILED TO SAVE");
    } else {
        NSLog(@"Stored local file name of: %@", filePath);
    }
}


- (void)storeImageForEntity:(NSString*)filePath EntityName:(NSString*)entityName PropertyName:(NSString*)propertyName {
    NSManagedObjectContext *mOC =[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSError *error = nil;
    Class entityClass = NSClassFromString(entityName);
    //id entityObject = [[entityClass alloc] init];
    id entityObject;
    

    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:mOC]];
    entityObject = [[mOC executeFetchRequest:request error:&error] lastObject];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(entityClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *classProperty = [NSString stringWithFormat:@"%s",property_getName(property)];
        //NSLog(@"propertyName: %@", classProperty);
        if ([classProperty isEqualToString:propertyName]) {
            [entityObject setValue:filePath forKey:propertyName];
        }
    }
    error = nil;
    //IMPORTANT NOTE!! THE RESTKIT SAVE DOESN"T ALWAYS PERSIST THE CHANGE!!!
    if (![mOC saveToPersistentStore:&error]) {
    //if (![mOC save:&error]) {
        //Handle any error with the saving of the context
        NSLog(@"CORE DATA FAILED TO SAVE");
    } else {
        NSLog(@"Stored local file name of: %@", filePath);
    }
}


@end
