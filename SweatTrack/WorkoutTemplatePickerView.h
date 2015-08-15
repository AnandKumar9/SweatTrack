//
//  WorkoutTemplatePickerView.h
//  SweatTrack
//
//  Created by Anand Kumar on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutTemplatePickerView : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSString *selectedWorkoutTemplate;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (id)initWithFrame:(CGRect)frame andContext:(NSManagedObjectContext *)context;
- (void)ifAvailableShowOption:(NSString *)possibleOption;

@end