//
//  WorkoutTypes.h
//  SweatTrack
//
//  Created by Anand Kumar on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorkoutTemplates, WorkoutsDone;

@interface WorkoutTypes : NSManagedObject

@property (nonatomic, retain) NSNumber * workoutHiddenByDefault;
@property (nonatomic, retain) NSString * workoutMetric1DefaultUnit;
@property (nonatomic, retain) NSString * workoutMetric1Name;
@property (nonatomic, retain) NSString * workoutMetric2DefaultUnit;
@property (nonatomic, retain) NSString * workoutMetric2Name;
@property (nonatomic, retain) NSString * workoutMetric3DefaultUnit;
@property (nonatomic, retain) NSString * workoutMetric3Name;
@property (nonatomic, retain) NSString * workoutName;
@property (nonatomic, retain) NSSet *workoutsDone;
@property (nonatomic, retain) NSSet *workoutTemplatesReferredToIn;
@end

@interface WorkoutTypes (CoreDataGeneratedAccessors)

- (void)addWorkoutsDoneObject:(WorkoutsDone *)value;
- (void)removeWorkoutsDoneObject:(WorkoutsDone *)value;
- (void)addWorkoutsDone:(NSSet *)values;
- (void)removeWorkoutsDone:(NSSet *)values;

- (void)addWorkoutTemplatesReferredToInObject:(WorkoutTemplates *)value;
- (void)removeWorkoutTemplatesReferredToInObject:(WorkoutTemplates *)value;
- (void)addWorkoutTemplatesReferredToIn:(NSSet *)values;
- (void)removeWorkoutTemplatesReferredToIn:(NSSet *)values;

@end
