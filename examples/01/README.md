# Introduction

This directory and all files/subdirectories within it contain:

+ `p4include` - a proposed replacement for files in the
  https://github.com/p4lang/p4c repo's `p4include` directory.
+ `p4namespace` - a proposed new top level directory to be added to
  the `p4c` repo, containing definitions of standard namespaces.
+ `p4prog<n>` - a few sample programs written to use the new namespace
  features.

This set of files is written assuming that the following kinds of
names can be imported from a namespace, just like other top-level
names such as type, typedef, const, and header type names:

+ match_kind
+ annotation names, declared explicitly in `annotation { ... }` statements
+ table property names, declared explicitly in `table_property { ... }` statements


# p4include

The directory `p4include` contains files that would replace those in
the `p4c` repo's `p4include` directory, which in the default
installation of `p4c` is always on the include path, and thus searched
whenever a P4 developer's program is compiled with lines like
`#include <core.p4>`.  The files in this directory are _completely
optional_ to use, but may ease the transition for P4 developers after
the namespace feature is introduced.

`p4include/core.p4` and other files in the `p4include` directory all
consist of a single `from <namespace> import <name1>, <name2>, ...;`
statement, like this:

```
from core import packet_in, packet_out, verify,
    // All other top level names defined in core namespace are
    // enumerated here ...
    ;
```

Thus if a P4 developer does `include <core.p4>` in their program, it
imports the core namespace in such a way that all of the names in it
can be used in the P4 developer's program with no `core.` prefix.


# p4namespaces

The directory `p4namespaces` is proposed to be a new directory in the
`p4c` repo, and always on the default `P4PATH` path of directories
that `p4c` searches for namespace definitions.  The files in this
directory _must_ be used by P4 developers after namespaces are
introduced, as they contain the definitions of the namespaces core,
v1model, and psa.


# p4prog1

The P4 program `demo1.p4` is a simple `v1model` architecture program.
It starts with these include statements:

```
#include <core.p4>
#include <v1model.p4>
```

and it compiles using today's `p4c` and runs on bmv2.

Today that works because when you install `p4c`, there is a
system-wide `p4include` directory,
e.g. `/usr/local/share/p4c/p4include`, that contains the files
`core.p4` and `v1model.p4`, and those files contain all of the top
level definitions for types, extern objects and methods, extern
functions, etc. that have been there for years.

This _identical source code_ is intended to compile and work the same
way after the namespace facility is added, because the `p4include`
directory will contain core.p4 and v1model.p4 files, each with one
`import` statement that imports all of the top level names from those
namespaces.


# p4prog2

The P4 program `demo1.p4` in this directory is functionally the same
as the one in the p4prog1 directory, but avoids using the new include
files, instead choosing to use these `import` statements:

```
import core;
import v1model as v1;
```

Thus everywhere a name defined in one of those namespaces is used in
this program, it must be prefixed with `core.` or `v1.`.  You can see
all of these prefixes by searching for those names or diff'ing the
p4prog1/demo1.p4 and p4prog2/demo1.p4 programs.

I do not expect that many P4 developers will _want_ to write code
using this style, but it is a choice available to them.
