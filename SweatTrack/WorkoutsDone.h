//
//  WorkoutsDone.h
//  SweatTrack
//
//  Created by Anand Kumar on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorkoutTypes;

@interface WorkoutsDone : NSManagedObject

@property (nonatomic, retain) NSDate * workoutDate;
@property (nonatomic, retain) NSString * workoutTimeZoneName;
@property (nonatomic, retain) NSString * workoutMetric1Name;
@property (nonatomic, retain) NSString * workoutMetric1Unit;
@property (nonatomic, retain) NSString * workoutMetric1Value;
@property (nonatomic, retain) NSString * workoutMetric2Name;
@property (nonatomic, retain) NSString * workoutMetric2Unit;
@property (nonatomic, retain) NSString * workoutMetric2Value;
@property (nonatomic, retain) NSString * workoutMetric3Name;
@property (nonatomic, retain) NSString * workoutMetric3Unit;
@property (nonatomic, retain) NSString * workoutMetric3Value;
@property (nonatomic, retain) WorkoutTypes *workoutType;

@end
