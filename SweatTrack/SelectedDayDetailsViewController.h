//
//  SelectedDayDetailsViewController.h
//  Kasrat
//
//  Created by Anand Kumar on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutsDone.h"
#import "CoreDataTableViewController.h"
#import "EditWorkoutDetailsViewController.h"

@interface SelectedDayDetailsViewController : CoreDataTableViewController

@property (nonatomic, weak) NSDate *date;
@property (nonatomic, weak) NSManagedObjectContext *context;

@end
