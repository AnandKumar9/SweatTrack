//
//  WorkoutsDone+Create.h
//  SweatIt
//
//  Created by Anand Kumar on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutsDone.h"
#import "WorkoutTypes+Create.h"

@interface WorkoutsDone (Create)

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
         inManagedObjectContext:(NSManagedObjectContext *)context;

@end
