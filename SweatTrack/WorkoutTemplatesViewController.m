//
//  WorkoutTemplatesViewController.m
//  SweatTrack
//
//  Created by Anand Kumar on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutTemplatesViewController.h"
#import "WorkoutTemplates.h"

@interface WorkoutTemplatesViewController ()

@end

@implementation WorkoutTemplatesViewController

@synthesize managedObjectContext = _managedObjectContext;

- (void)setupFetchedResultsController
{
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutTemplates" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *workoutTemplateNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutTemplateName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutTemplateNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create and initialize the fetch results controller.
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                        managedObjectContext:self.managedObjectContext 
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma mark - View life cycle methods

- (void)viewWillAppear:(BOOL)animated
{  
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

#pragma mark - TableView Datasource and Delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    static NSString *CellIdentifier = @"Workout Template Name Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    WorkoutTemplates *workoutTemplate = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = workoutTemplate.workoutTemplateName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%u workouts", workoutTemplate.workoutTypesIncluded.count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkoutTemplates *workoutTemplate = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.managedObjectContext deleteObject:workoutTemplate];
    [self saveContext];
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{           
    if ([segue.identifier isEqualToString:@"Show Workout Template Details"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setWorkoutTemplate:)]) {
            [segue.destinationViewController performSelector:@selector(setSourceSegueIdentifier:) withObject:@"Show Workout Template Details"];
            WorkoutTemplates *workoutTemplate = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
            [segue.destinationViewController performSelector:@selector(setWorkoutTemplate:) withObject:workoutTemplate];
            [segue.destinationViewController performSelector:@selector(setManagedObjectContext:) withObject:self.managedObjectContext];
        }
    }
    
    if ([segue.identifier isEqualToString:@"Add Workout Template"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
            [segue.destinationViewController performSelector:@selector(setSourceSegueIdentifier:) withObject:@"Add Workout Template"];
            [segue.destinationViewController performSelector:@selector(setManagedObjectContext:) withObject:self.managedObjectContext];
        }
    }
}


- (IBAction)addWorkoutTemplateButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"Add Workout Template" sender:self];
}

- (void)saveContext
{   
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

@end
