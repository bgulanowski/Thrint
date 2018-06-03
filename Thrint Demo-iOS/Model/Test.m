#import "Test.h"
#import "Feature.h"

#import <BAFoundation/NSManagedObject+BAAdditions.h>
#import "NSManagedObject+ViewAdditions.h"

@implementation Test

- (NSString *)listString {
    return [@"Test of %@" stringByAppendingFormat:@"%@", self.feature.name];
}

- (NSString *)displayDescription {
    return [NSString stringWithFormat:@"Test for %@", self.feature.name];
}

@end
