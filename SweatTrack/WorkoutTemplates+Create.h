//
//  WorkoutTemplates+Create.h
//  SweatTrack
//
//  Created by Anand Kumar on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutTemplates.h"
#import "WorkoutTypes+Create.h"

@interface WorkoutTemplates (Create)

+ (WorkoutTemplates *)templateIs:(NSString *)name
                withWorkoutTypes:(NSSet *)workoutTypes
               workoutTypesOrder:(NSString *)workoutTypesOrder
       workoutTypesDefaultValues:(NSString *)workoutTypesDefaultValues
          inManagedObjectContext:(NSManagedObjectContext *)context;

@end
