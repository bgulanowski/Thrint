#import "ProductNote.h"

#import <BAFoundation/NSManagedObject+BAAdditions.h>
#import "NSManagedObject+ViewAdditions.h"


@implementation ProductNote

- (void)awakeFromInsert {
    self.title = @"New Note";
}

-(NSString *)listString {
    return [NSString stringWithFormat:@"%@", self.title];
}

- (NSString *)displaySubtitle {
    NSString *content = self.details;
    
    if([content length] > 100)
        return [NSString stringWithFormat:@"%@…", [content substringToIndex:100]];
    return content;
}

@end
