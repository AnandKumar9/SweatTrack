//
//  WorkoutTemplates+Create.m
//  SweatTrack
//
//  Created by Anand Kumar on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutTemplates+Create.h"

@implementation WorkoutTemplates (Create)

+ (WorkoutTemplates *)templateIs:(NSString *)name
                withWorkoutTypes:(NSSet *)workoutTypes
               workoutTypesOrder:(NSString *)workoutTypesOrder
       workoutTypesDefaultValues:(NSString *)workoutTypesDefaultValues
          inManagedObjectContext:(NSManagedObjectContext *)context
{
    WorkoutTemplates *workoutTemplate = nil;
    
    workoutTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"WorkoutTemplates" inManagedObjectContext:context];
    
    workoutTemplate.workoutTemplateName = name;
    
    NSMutableSet *tempWorkoutTypes = [[NSMutableSet alloc] init];
    for (NSString *tempWorkoutName in workoutTypes)
    {
        [tempWorkoutTypes addObject:[WorkoutTypes workoutTypeWithName:tempWorkoutName 
                                                          metric1Name:nil 
                                                   metric1DefaultUnit:nil
                                                          metric2Name:nil
                                                   metric2DefaultUnit:nil
                                                          metric3Name:nil
                                                   metric3DefaultUnit:nil
                                                     hidddenByDefault:nil
                                               inManagedObjectContext:context]];

    }
    
    workoutTemplate.workoutTypesIncluded = (NSSet *)tempWorkoutTypes;
    workoutTemplate.workoutTypesOrder = workoutTypesOrder;
    workoutTemplate.workoutTypesDefaultValues = workoutTypesDefaultValues;
    
    return workoutTemplate;
}

@end
