//
//  WorkoutTypes+Create.m
//  SweatIt
//
//  Created by Anand Kumar on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutTypes+Create.h"

@implementation WorkoutTypes (Create)

+ (WorkoutTypes *)workoutTypeWithName:(NSString *)name 
                          metric1Name:(NSString *)metric1Name 
                   metric1DefaultUnit:(NSString *)metric1DefaultUnit 
                          metric2Name:(NSString *)metric2Name 
                   metric2DefaultUnit:(NSString *)metric2DefaultUnit 
                          metric3Name:(NSString *)metric3Name 
                   metric3DefaultUnit:(NSString *)metric3DefaultUnit
                     hidddenByDefault:(NSNumber *)hiddenByDefault
               inManagedObjectContext:(NSManagedObjectContext *)context
{
    WorkoutTypes *workoutType = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"WorkoutTypes"];
    request.predicate = [NSPredicate predicateWithFormat:@"workoutName = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"workoutName" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matchingWorkoutTypesFetched = [context executeFetchRequest:request error:&error];
    
    if (!matchingWorkoutTypesFetched || ([matchingWorkoutTypesFetched count] > 1)) {
        // handle error. The returning array cannot have more than 1 objects (if any)
    } 
    
    else if (![matchingWorkoutTypesFetched count]) {
        
        workoutType = [NSEntityDescription insertNewObjectForEntityForName:@"WorkoutTypes"
                                                    inManagedObjectContext:context];
        workoutType.workoutName = name;
        workoutType.workoutMetric1Name = metric1Name;
        workoutType.workoutMetric1DefaultUnit = metric1DefaultUnit;
        workoutType.workoutMetric2Name = metric2Name;
        workoutType.workoutMetric2DefaultUnit = metric2DefaultUnit;
        workoutType.workoutMetric3Name = metric3Name;
        workoutType.workoutMetric3DefaultUnit = metric3DefaultUnit;
        workoutType.workoutHiddenByDefault = hiddenByDefault;
    } else {
        workoutType = [matchingWorkoutTypesFetched lastObject];
//        NSLog(@"Already exists");
    }
    
    return workoutType;    

}

@end
