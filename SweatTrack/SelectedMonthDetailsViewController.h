//
//  SelectedMonthDetailsViewController.h
//  Kasrat
//
//  Created by Anand Kumar on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "WorkoutsDone.h"

@interface SelectedMonthDetailsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> 

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
