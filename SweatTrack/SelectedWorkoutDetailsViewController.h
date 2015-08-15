//
//  SelectedWorkoutDetailsViewController.h
//  Kasrat
//
//  Created by Anand Kumar on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "WorkoutTypes.h"
#import "EditWorkoutDetailsViewController.h"

@interface SelectedWorkoutDetailsViewController : CoreDataTableViewController

@property (nonatomic, strong) WorkoutTypes *workoutType;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end
