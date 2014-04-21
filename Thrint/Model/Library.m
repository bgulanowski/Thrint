#import "Library.h"

#import "NSManagedObject+ViewAdditions.h"
#import <BAFoundation/NSManagedObject+BAAdditions.h>


@implementation Library

- (void)awakeFromInsert {
    self.name = @"New Library";
}

- (NSString *)listString {
    return [NSString stringWithFormat:@"%@ (%u deps)", self.name, [self.dependents count]];
}

@end
