#import "Developer.h"

#import "Role.h"
#import "Team.h"

#import <BAFoundation/NSManagedObject+BAAdditions.h>
#import "NSManagedObject+ViewAdditions.h"

@implementation Developer

- (void)awakeFromInsert {
    [super awakeFromInsert];
    self.name = @"New Developer";
    self.joinDate = [NSDate date];
}

- (NSString *)listString {
    
    Role *role = [self.roles anyObject];
    NSString *roleString;
    
    if(role)
        roleString = [NSString stringWithFormat:@"%@ on %@", role.name, role.team.name];
    else
        roleString = @"unassigned";
        
    return [NSString stringWithFormat:@"%@ (%@)", self.name, roleString];
}

- (NSString *)displayDescription {
    return [self listString];
}

@end
