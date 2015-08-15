//
//  SelectedWorkoutDetailsViewController.m
//  Kasrat
//
//  Created by Anand Kumar on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectedWorkoutDetailsViewController.h"
#import "WorkoutsDone.h"
#import "GAI.h"

@interface SelectedWorkoutDetailsViewController ()

@end

@implementation SelectedWorkoutDetailsViewController

@synthesize workoutType = _workoutType;
@synthesize context = _context;
@synthesize managedObjectIDIfSeguedFromAnotherTab = _managedObjectIDIfSeguedFromAnotherTab;

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"WorkoutsDone"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"workoutDate"
                                                                                     ascending:NO]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"workoutType.workoutName = %@", self.workoutType.workoutName];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.workoutType.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
}

- (void)setWorkoutType:(WorkoutTypes *)workoutType
{
    _workoutType = workoutType;
    
    self.title = workoutType.workoutName;
    self.context = workoutType.managedObjectContext;
    
    [self setupFetchedResultsController];
}

#pragma mark - View life cycle methods

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.managedObjectIDIfSeguedFromAnotherTab) {
        NSIndexPath *indexPathToBeScrolledTo = [self.fetchedResultsController indexPathForObject:[self.context objectWithID:self.managedObjectIDIfSeguedFromAnotherTab]];
        [self.tableView scrollToRowAtIndexPath:indexPathToBeScrolledTo atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    if (ANALYTICS_TRACKING == TRUE) {
        [self sendAnalyticsData];
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    self.managedObjectIDIfSeguedFromAnotherTab = nil;
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Workout Done Details Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    WorkoutsDone *workoutDone = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *tempString = @"";
    
    if (![workoutDone.workoutMetric1Name isEqualToString:@""]) {
        if (![workoutDone.workoutMetric1Value isEqualToString:@""]) {
            tempString = [tempString stringByAppendingString:workoutDone.workoutMetric1Value];
            if (![[NSString stringWithFormat:@"%@", workoutDone.workoutMetric1Unit] isEqualToString:@""]) {
                tempString = [tempString stringByAppendingString:@" "];
                if (![workoutDone.workoutMetric1Unit isEqualToString:@""]) {
                    tempString = [tempString stringByAppendingString:[workoutDone.workoutMetric1Unit lowercaseString]];
                }
                else {
                    tempString = [tempString stringByAppendingString:[workoutDone.workoutMetric1Name lowercaseString]];
                }
                tempString = [tempString stringByAppendingString:@"  "];
            }
        }
    }
    
    if (![workoutDone.workoutMetric2Name isEqualToString:@""]) {
        if (![workoutDone.workoutMetric2Value isEqualToString:@""]) {
            tempString = [tempString stringByAppendingString:workoutDone.workoutMetric2Value];
            if (![[NSString stringWithFormat:@"%@", workoutDone.workoutMetric2Unit] isEqualToString:@""]) {
                tempString = [tempString stringByAppendingString:@" "];
                if (![workoutDone.workoutMetric2Unit isEqualToString:@""]) {
                    tempString = [tempString stringByAppendingString:[workoutDone.workoutMetric2Unit lowercaseString]];
                }
                else {
                    tempString = [tempString stringByAppendingString:[workoutDone.workoutMetric2Name lowercaseString]];
                }
                tempString = [tempString stringByAppendingString:@"  "];
            }
        }
    }
    
    if (![workoutDone.workoutMetric3Name isEqualToString:@""]) {
        if (![workoutDone.workoutMetric3Value isEqualToString:@""]) {
            tempString = [tempString stringByAppendingString:workoutDone.workoutMetric3Value];
            if (![[NSString stringWithFormat:@"%@", workoutDone.workoutMetric3Unit] isEqualToString:@""]) {
                tempString = [tempString stringByAppendingString:@" "];
                if (![workoutDone.workoutMetric3Unit isEqualToString:@""]) {
                    tempString = [tempString stringByAppendingString:[workoutDone.workoutMetric3Unit lowercaseString]];
                }
                else {
                    tempString = [tempString stringByAppendingString:[workoutDone.workoutMetric3Name lowercaseString]];
                }
                tempString = [tempString stringByAppendingString:@"  "];
            }
        }
    }    
    
    cell.detailTextLabel.text = tempString;
    
    NSDate *date = workoutDone.workoutDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    cell.textLabel.text = [dateFormatter stringFromDate:date];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkoutsDone *workoutDone = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSManagedObjectID *objectIDOfCurrentManagedObject = [workoutDone objectID];
    
    for (id viewController in self.navigationController.tabBarController.viewControllers) {
        if ([viewController isMemberOfClass:[UINavigationController class]]) {
            if ([[viewController valueForKey:@"topViewController"] isMemberOfClass:[EditWorkoutDetailsViewController class]]) {
                if ([viewController valueForKey:@"topViewController"] != self) {
                    if ([[viewController valueForKey:@"topViewController"] valueForKey:@"workoutDone"]) {
                        NSManagedObjectID *objectIDOfOtherManagedObject = [[[viewController valueForKey:@"topViewController"] valueForKey:@"workoutDone"] valueForKey:@"objectID"];
                        if ([[objectIDOfCurrentManagedObject URIRepresentation] isEqual:[objectIDOfOtherManagedObject URIRepresentation]]) {
                            [viewController popViewControllerAnimated:NO];
                        }
                    }
                }
            }
        }
    }
    
    
    [self.context deleteObject:workoutDone];
    [self saveContext];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.destinationViewController respondsToSelector:@selector(setWorkoutDone:)] && [segue.identifier isEqualToString:@"Edit Workout Details"]) {
        [segue.destinationViewController performSelector:@selector(setContext:) 
                                              withObject:self.workoutType.managedObjectContext];
        [segue.destinationViewController performSelector:@selector(setWorkoutDone:) 
                                              withObject:[self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow]];
    }
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.context;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Analytics method

- (void)sendAnalyticsData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:@"analyticsViewWorkoutsOfType"]) {
        [[[GAI sharedInstance] defaultTracker] trackView:@"View Workouts of a Type"];
        [defaults setObject:[NSDate date] forKey:@"analyticsViewWorkoutsOfType"];
    }
    else {
        NSDate *analyticsLastPostDate = [defaults objectForKey:@"analyticsViewWorkoutsOfType"];
        NSDate *currentDate = [NSDate date];
        
        NSInteger analyticsLastPostDateDay = [[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:analyticsLastPostDate] day];
        NSInteger currentDateDay = [[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:currentDate] day];
        
        if (analyticsLastPostDateDay != currentDateDay) {
            [[[GAI sharedInstance] defaultTracker] trackView:@"View Workouts of a Type"];
            [defaults setObject:[NSDate date] forKey:@"analyticsViewWorkoutsOfType"];
        }
    }
    
    [defaults synchronize];
}

@end


