//
//  WorkoutTypeSettingsViewController.h
//  SweatIt
//
//  Created by Anand Kumar on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutTypes.h"
#import "EditWorkoutDetailsViewController.h"
#import "EnterWorkoutDetailsViewController.h"
#import "WorkoutTemplateDefaultValuesViewController.h"

@interface WorkoutTypeSettingsViewController : UITableViewController <UITextFieldDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) WorkoutTypes *workoutType;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end
