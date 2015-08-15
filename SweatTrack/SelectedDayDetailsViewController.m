//
//  SelectedDayDetailsViewController.m
//  Kasrat
//
//  Created by Anand Kumar on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectedDayDetailsViewController.h"
#import "WorkoutTypes.h"

@interface SelectedDayDetailsViewController ()

@property (nonatomic, strong) NSDate *dateShown;

@end

@implementation SelectedDayDetailsViewController

@synthesize dateShown = _dateShown;
@synthesize date = _date;
@synthesize context = _context;

- (void)setupFetchedResultsController
{    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"WorkoutsDone"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"workoutType.workoutName"
                                                                                     ascending:YES],
                                                        [NSSortDescriptor sortDescriptorWithKey:@"workoutDate"
                                                             ascending:NO], nil];
    
    NSDate *date1 = [NSDate dateWithTimeInterval:0 sinceDate:self.dateShown];
    NSDate *date2 = [NSDate dateWithTimeInterval:86400 sinceDate:self.dateShown];
    
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&date1 interval:NULL forDate:date1];
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&date2 interval:NULL forDate:date2];
        
    request.predicate = [NSPredicate predicateWithFormat:@"(workoutDate >= %@) AND (workoutDate < %@)", date1, date2];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                    managedObjectContext:self.context
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    self.dateShown = [self.date copy];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.title = [dateFormatter stringFromDate:self.dateShown];
}

-  (void)setContext:(NSManagedObjectContext *)context
{   
    _context = context;
}

- (void)viewWillAppear:(BOOL)animated
{   
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

#pragma mark - Table view Datasource and Delegate methods


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    static NSString *CellIdentifier = @"Every Workout on a Day Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    WorkoutsDone *workoutDone = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *tempString = @"";
    
    if (![workoutDone.workoutMetric1Name isEqualToString:@""]) {
        if (![workoutDone.workoutMetric1Value isEqualToString:@""]) {
            tempString = [tempString stringByAppendingString:workoutDone.workoutMetric1Value];
            if (![[NSString stringWithFormat:@"%f", workoutDone.workoutMetric1Unit] isEqualToString:@""]) {
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
            if (![[NSString stringWithFormat:@"%f", workoutDone.workoutMetric2Unit] isEqualToString:@""]) {
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
            if (![[NSString stringWithFormat:@"%f", workoutDone.workoutMetric3Unit] isEqualToString:@""]) {
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
    cell.textLabel.text = workoutDone.workoutType.workoutName;
    
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
                                              withObject:self.context];
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

@end
