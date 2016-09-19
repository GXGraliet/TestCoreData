//
//  ViewController.m
//  coreData
//
//  Created by Onery on 16/9/18.
//  Copyright © 2016年 Graliet. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Person.h"

@interface ViewController ()
@property (nonatomic, strong) AppDelegate * appdelegate;
@property (nonatomic, strong) Person * currentPerson;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",NSHomeDirectory());
//    [self insert];
    [self migrateDate];
}

- (void)insert {
    
    NSEntityDescription * enty = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.appdelegate.managedObjectContext];
    
    Person * p = [[Person alloc] initWithEntity:enty insertIntoManagedObjectContext:self.appdelegate.managedObjectContext];
    
    p.name = @"zhangsan";
    p.birth = @1;
    self.currentPerson = p;
    [self.appdelegate saveContext];
    
}

- (void)delete {
    [self.appdelegate.managedObjectContext deleteObject:self.currentPerson];
    
    [self.appdelegate saveContext];
}

- (void)update {
    self.currentPerson.name = @"xxx";
    
    [self.appdelegate saveContext];
}

- (void)migrateDate {
    
     NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"coreData" withExtension:@"momd"];
    
    
    NSManagedObjectModel * sourceModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[modelURL URLByAppendingPathComponent:@"coreData 3.mom"]];
    NSManagedObjectModel * destModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[modelURL URLByAppendingPathComponent:@"coreData 4.mom"]];
    
    NSMigrationManager * mgr = [[NSMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:destModel];
    
    NSURL *sourceURL = [[self.appdelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"coreData.sqlite"];
    
    NSURL *destURL = [[self.appdelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"mod11111el.sqlite"];

    
    NSMappingModel * mdel = [NSMappingModel mappingModelFromBundles:@[[NSBundle mainBundle]] forSourceModel:sourceModel destinationModel:destModel];
    NSError * error = nil;
    
   BOOL success = [mgr migrateStoreFromURL:sourceURL type:NSSQLiteStoreType options:nil withMappingModel:mdel toDestinationURL:destURL destinationType:NSSQLiteStoreType destinationOptions:nil error:&error];
    
    if (success) {
        NSLog(@"yes");
    }else {
        NSLog(@"no");
//        NSLog(@")
    }
}

#pragma mark- lazy loading
- (AppDelegate *)appdelegate {
    if (!_appdelegate) {
        _appdelegate = [[UIApplication sharedApplication] delegate];
    }
    return _appdelegate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
