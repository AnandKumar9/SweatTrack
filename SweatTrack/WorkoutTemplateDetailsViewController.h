//
//  WorkoutTemplateDetailsViewController.h
//  SweatTrack
//
//  Created by Anand Kumar on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "WorkoutTemplates.h"

@interface WorkoutTemplateDetailsViewController : UITableViewController <UITextFieldDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) WorkoutTemplates *workoutTemplate;

- (void)updateTemplateOrder;

@end
