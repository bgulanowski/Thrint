#import "Product.h"

#import <ThrintKit/NSManagedObject+ViewAdditions.h>
#import <BAFoundation/NSManagedObject+BAAdditions.h>
#import <BAFoundation/NSManagedObjectContext+BAAdditions.h>

#import "Component.h"

#import "Milestone.h"
#import "Team.h"


@implementation Product

- (NSDictionary *)genericDetailSections {
    return [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"name", nil] forKey:@"General"];
}

- (NSArray *)orderedSectionTitles {
    return [NSArray arrayWithObject:@"General"];
}

- (NSString *)listString {
    return [NSString stringWithFormat:@"%@ by %@ - due %@", self.name, self.team.name, [df stringFromDate:self.dueDate]];
}

- (NSArray *)displayPropertyNames {
    
    static __strong NSArray * names;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        names = [[NSArray alloc] initWithObjects:
                 @"name",
                 @"code",
                 @"startDate",
                 @"dueDate",
                 @"otherTitle",
                 @"other",
                 nil];
    });
    return names;
}

- (void)awakeFromInsert {
    self.name = @"New Product";
    self.code = @"PRODUCT-CODE";
    self.startDate = [NSDate date];
    self.dueDate = [NSDate dateWithTimeIntervalSinceNow:24 * 7 * 24 * 3600];
}

@end
