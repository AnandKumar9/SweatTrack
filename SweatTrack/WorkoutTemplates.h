//
//  WorkoutTemplates.h
//  SweatTrack
//
//  Created by Anand Kumar on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorkoutTypes;

@interface WorkoutTemplates : NSManagedObject

@property (nonatomic, retain) NSString * workoutTemplateName;
@property (nonatomic, retain) NSString * workoutTypesOrder;
@property (nonatomic, retain) NSString * workoutTypesDefaultValues;
@property (nonatomic, retain) NSSet *workoutTypesIncluded;
@end

@interface WorkoutTemplates (CoreDataGeneratedAccessors)

- (void)addWorkoutTypesIncludedObject:(WorkoutTypes *)value;
- (void)removeWorkoutTypesIncludedObject:(WorkoutTypes *)value;
- (void)addWorkoutTypesIncluded:(NSSet *)values;
- (void)removeWorkoutTypesIncluded:(NSSet *)values;

@end
