#import "Library.h"

#import "NSManagedObject+ViewAdditions.h"
#import <BAFoundation/NSManagedObject+BAAdditions.h>


@implementation Library

- (void)awakeFromInsert {
    [super awakeFromInsert];
    self.name = @"New Library";
}

- (NSString *)listString {
    return [NSString stringWithFormat:@"%@ (%zu deps)", self.name, [self.dependents count]];
}

@end
