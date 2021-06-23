///sqlite bool 和 int 之间转换.
bool boolFromInt(int done) => done == 1;

int boolToInt(bool done) => done ? 1 : 0;

bool? boolFromIntWithNull(int? done) => null == done ? null : (done == 1);

int? boolToIntWithNull(bool? done) => null == done ? null : (done ? 1 : 0);
