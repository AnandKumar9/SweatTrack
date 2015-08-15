//
//  WorkoutTypesViewController.h
//  SweatIt
//
//  Created by Anand Kumar on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "WorkoutsDone+Create.h"

@interface WorkoutTypesViewController : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)addWorkoutTypeButtonPressed:(id)sender;
- (IBAction)buttonForHiddenAttributePressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonForHiddenAttribute;
@property (strong, nonatomic) WorkoutsDone *workoutDoneWhenSeguedFromAnotherTab;

@end
