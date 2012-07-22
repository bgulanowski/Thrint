#import "Team.h"
#import "Product.h"

#import "NSManagedObject+BAAdditions.h"
#import "NSManagedObject+ViewAdditions.h"


@implementation Team

+ (NSManagedObject *)insertObject {
    
    Team *team = (Team *)[super insertObject];
    
    team.name = @"New Team";
    
    return team;
}

+ (Team *)insertTeam {
    return (Team *)[self insertObject];
}

- (NSString *)displayTitle {
    
    NSArray *names = [self.developers valueForKey:@"name"];
    
    names = ([names count] > 3 ? [names subarrayWithRange:NSMakeRange(0, 3)] : names);
    
    NSString *namesString = [names count] ? [names componentsJoinedByString:@", "] : @"no members";
    
    return [NSString stringWithFormat:@"%@ (%@)", self.name, namesString]; 
}

@end
