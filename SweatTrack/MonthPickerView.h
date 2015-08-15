//
//  MonthPickerView.h
//  Kasrat
//
//  Created by Anand Kumar on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthPickerView : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSString *selectedMonth;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (id)initWithFrame:(CGRect)frame andContext:(NSManagedObjectContext *)context;
- (void)ifAvailableShowOption:(NSString *)possibleOption;

@end
