#import "Team.h"
#import "Product.h"

#import <BAFoundation/NSManagedObject+BAAdditions.h>
#import "NSManagedObject+ViewAdditions.h"


@implementation Team

- (NSString *)listString {
    return [NSString stringWithFormat:@"%@ (%u products, %u devs)", self.name, [self.products count], [self.developers count]];
}

- (NSString *)displayTitle {
    
    NSArray *names = [self.developers valueForKey:@"name"];
    
    names = ([names count] > 3 ? [names subarrayWithRange:NSMakeRange(0, 3)] : names);
    
    NSString *namesString = [names count] ? [names componentsJoinedByString:@", "] : @"no members";
    
    return [NSString stringWithFormat:@"%@ (%@)", self.name, namesString]; 
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    self.name = @"New Team";
}

@end
