//
//  WorkoutTemplateDeafultValuesViewController.h
//  SweatTrack
//
//  Created by Anand Kumar on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutTemplates.h"
#import "WorkoutTypes.h"

@interface WorkoutTemplateDefaultValuesViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) WorkoutTemplates *workoutTemplate;
@property (nonatomic, strong) WorkoutTypes *workoutType;

@end
