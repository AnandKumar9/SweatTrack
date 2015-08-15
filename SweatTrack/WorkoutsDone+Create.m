//
//  WorkoutsDone+Create.m
//  SweatIt
//
//  Created by Anand Kumar on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutsDone+Create.h"

@implementation WorkoutsDone (Create)

+ (WorkoutsDone *)workoutDoneIs:(NSString *)name 
                WithMetric1Name:(NSString *)metric1Name 
                    metric1Unit:(NSString *)metric1Unit
                   metric1Value:(NSString *)metric1Value
                    metric2Name:(NSString *)metric2Name  
                    metric2Unit:(NSString *)metric2Unit
                   metric2Value:(NSString *)metric2Value  
                    metric3Name:(NSString *)metric3Name  
                    metric3Unit:(NSString *)metric3Unit  
                   metric3Value:(NSString *)metric3Value
                         onDate:(NSDate *)date 
         inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    WorkoutsDone *workoutDone = nil;
    
    workoutDone = [NSEntityDescription insertNewObjectForEntityForName:@"WorkoutsDone" inManagedObjectContext:context];


    workoutDone.workoutType = [WorkoutTypes workoutTypeWithName:name 
                                                    metric1Name:nil 
                                             metric1DefaultUnit:nil
                                                    metric2Name:nil
                                             metric2DefaultUnit:nil
                                                    metric3Name:nil
                                             metric3DefaultUnit:nil
                                               hidddenByDefault:nil
                                         inManagedObjectContext:context];

    workoutDone.workoutMetric1Name = metric1Name;
    workoutDone.workoutMetric1Unit = metric1Unit;
    workoutDone.workoutMetric1Value = metric1Value;
    workoutDone.workoutMetric2Name = metric2Name;
    workoutDone.workoutMetric2Unit = metric2Unit;
    workoutDone.workoutMetric2Value = metric2Value;
    workoutDone.workoutMetric3Name = metric3Name;
    workoutDone.workoutMetric3Unit = metric3Unit;
    workoutDone.workoutMetric3Value = metric3Value;
    workoutDone.workoutTimeZoneName = [[NSTimeZone systemTimeZone] name];
    workoutDone.workoutDate = date;

//    //date will come in raw GMT timezone. Get the time interval (in seconds) between system time zone and GMT.
//    NSDate *dateInGMT = date;
//    NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
//    NSInteger systemGMTOffset = [systemTimeZone secondsFromGMTForDate:dateInGMT];
//    NSTimeInterval interval = systemGMTOffset;
//    
//    //Create a new NSDate object by pushing dateInGMT by interval
//    NSDate *dateInSystemTimeZoneWithOffsetStillShownAs0000 = [[NSDate alloc] initWithTimeInterval:interval sinceDate:dateInGMT];
//
//    workoutDone.workoutDate = dateInSystemTimeZoneWithOffsetStillShownAs0000;

    return workoutDone;
    
}

@end
