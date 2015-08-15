//
//  EnterWorkoutDetailsViewController.h
//  SweatTrack
//
//  Created by Anand Kumar on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutTypes.h"

@interface EnterWorkoutDetailsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSNumber *templateWorkoutScreenShown;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchScreenBarButtonItem;

- (void)updateStateDataWhenMetricIsDeleted:(NSNumber *)metricDeleted inWorkoutType:(WorkoutTypes *)workoutType;

- (IBAction)switchScreen:(id)sender;

@end
