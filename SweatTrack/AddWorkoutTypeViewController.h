//
//  AddWorkoutTypeViewController.h
//  SweatTrack
//
//  Created by Anand Kumar on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutTypes+Create.h"

@interface AddWorkoutTypeViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;

@end
