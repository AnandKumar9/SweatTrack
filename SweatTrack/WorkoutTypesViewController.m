//
//  WorkoutTypesViewController.m
//  SweatIt
//
//  Created by Anand Kumar on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutTypesViewController.h"
#import "WorkoutTypes.h"
#import "WorkoutTypes+Create.h"

@interface WorkoutTypesViewController ()

@property (nonatomic, strong) NSNumber *hideHiddenWorkouts;

@property (weak, nonatomic) NSIndexPath *indexPathForRowOfAccessoryButtonTapped;
@property (weak, nonatomic) NSIndexPath *indexPathForRowTapped;

@end

@implementation WorkoutTypesViewController
@synthesize buttonForHiddenAttribute = _buttonForHiddenAttribute;
@synthesize workoutDoneWhenSeguedFromAnotherTab = _workoutDoneWhenSeguedFromAnotherTab;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize hideHiddenWorkouts = _hideHiddenWorkouts;
@synthesize indexPathForRowOfAccessoryButtonTapped = _indexPathForRowOfAccessoryButtonTapped;
@synthesize indexPathForRowTapped = _indexPathForRowTapped;

- (void)setupFetchedResultsController
{
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutTypes" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    if (self.hideHiddenWorkouts.boolValue == YES) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"workoutHiddenByDefault == NO"];
    }
    
    // Create the sort descriptors array.
    NSSortDescriptor *workoutNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutNameDescriptor, nil];
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
    
    if (!self.hideHiddenWorkouts) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults objectForKey:@"hideHiddenWorkoutsInWorkoutTypesView"]) {
            [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"hideHiddenWorkoutsInWorkoutTypesView"];
            [defaults synchronize];
        }
        self.hideHiddenWorkouts = [defaults objectForKey:@"hideHiddenWorkoutsInWorkoutTypesView"];
    }
    
    if (self.hideHiddenWorkouts.boolValue == NO) {
        self.buttonForHiddenAttribute.title = @"Hide Some";
    }
    else {
        self.buttonForHiddenAttribute.title = @"Show All";
    }
    
    [self setupFetchedResultsController];
}

- (IBAction)addWorkoutTypeButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"Show Add Workout Type" sender:self];
}

- (IBAction)buttonForHiddenAttributePressed:(id)sender {
    
    self.hideHiddenWorkouts = [NSNumber numberWithBool:!self.hideHiddenWorkouts.boolValue];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.hideHiddenWorkouts forKey:@"hideHiddenWorkoutsInWorkoutTypesView"];
    [defaults synchronize];
    
    [self setupFetchedResultsController];

    if (self.hideHiddenWorkouts.boolValue == NO) {
        self.buttonForHiddenAttribute.title = @"Hide Some";
    }
    else {
        self.buttonForHiddenAttribute.title = @"Show All";
    }
    
    [self.tableView reloadData];
}

#pragma mark - TableView Datasource and Delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    static NSString *CellIdentifier = @"Workout Type Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    WorkoutTypes *workoutType = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = workoutType.workoutName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    self.indexPathForRowOfAccessoryButtonTapped = indexPath;
    [self performSegueWithIdentifier:@"Show Workout Settings" sender:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPathForRowTapped = indexPath;
    [self performSegueWithIdentifier:@"Show Workouts Done for a Type" sender:self];
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{           
    if ([segue.identifier isEqualToString:@"Show Workout Settings"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setWorkoutType:)]) {
            WorkoutTypes *workoutType = [self.fetchedResultsController objectAtIndexPath:self.indexPathForRowOfAccessoryButtonTapped];
            [segue.destinationViewController performSelector:@selector(setWorkoutType:) withObject:workoutType];
            [segue.destinationViewController performSelector:@selector(setContext:) withObject:workoutType.managedObjectContext];
        }
    }
    
    if ([segue.identifier isEqualToString:@"Show Add Workout Type"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setContext:)]) {
            [segue.destinationViewController performSelector:@selector(setContext:) withObject:self.managedObjectContext];
        }
    }
    
    if ([segue.identifier isEqualToString:@"Show Workouts Done for a Type"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setWorkoutType:)]) {

            WorkoutTypes *workoutType;
            if ([NSStringFromClass([sender class]) isEqualToString:@"WorkoutTypesViewController"]) {
                workoutType = [self.fetchedResultsController objectAtIndexPath:self.indexPathForRowTapped];            }
            
            else if ([NSStringFromClass([sender class]) isEqualToString:@"EditWorkoutDetailsViewController"]) {
                workoutType = self.workoutDoneWhenSeguedFromAnotherTab.workoutType;
                [segue.destinationViewController performSelector:@selector(setManagedObjectIDIfSeguedFromAnotherTab:) 
                                                      withObject:self.workoutDoneWhenSeguedFromAnotherTab.objectID];

            }
            
            [segue.destinationViewController performSelector:@selector(setWorkoutType:) withObject:workoutType];
//            [segue.destinationViewController performSelector:@selector(setContext:) withObject:workoutType.managedObjectContext];
        }
    }
    
}

- (void)viewDidUnload {
    [self setButtonForHiddenAttribute:nil];
    [super viewDidUnload];
}
@end
