//
//  EditWorkoutDetailsViewController.h
//  SweatTrack
//
//  Created by Anand Kumar on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutsDone.h"

@interface EditWorkoutDetailsViewController : UITableViewController <UITextFieldDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) WorkoutsDone *workoutDone;
@property (nonatomic, weak) NSManagedObjectContext *context;

@end
