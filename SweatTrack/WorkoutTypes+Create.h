//
//  WorkoutTypes+Create.h
//  SweatIt
//
//  Created by Anand Kumar on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutTypes.h"

@interface WorkoutTypes (Create)

+ (WorkoutTypes *)workoutTypeWithName:(NSString *)name 
                          metric1Name:(NSString *)metric1Name 
                   metric1DefaultUnit:(NSString *)metric1DefaultUnit 
                          metric2Name:(NSString *)metric2Name 
                   metric2DefaultUnit:(NSString *)metric2DefaultUnit 
                          metric3Name:(NSString *)metric3Name 
                   metric3DefaultUnit:(NSString *)metric3DefaultUnit
                     hidddenByDefault:(NSNumber *)hiddenByDefault
               inManagedObjectContext:(NSManagedObjectContext *)context;
               


@end
