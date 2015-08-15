//
//  WorkoutTemplatesViewController.h
//  SweatTrack
//
//  Created by Anand Kumar on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface WorkoutTemplatesViewController : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)addWorkoutTemplateButtonPressed:(id)sender;

@end
