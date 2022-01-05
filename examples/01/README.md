# Introduction

This directory and all files/subdirectories within it contain:

+ `p4include` - a proposed replacement for files in the
  https://github.com/p4lang/p4c repo's `p4include` directory.
+ `p4namespaces` - a proposed new top level directory to be added to
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


# What happens when you compile p4prog1/demo1.p4 ?

Just as there is a default include path that contains the `p4include`
directory with today's p4c, there would still be one with this
proposal, and it would contain the files in the `p4include` directory,
relative to this README.md file.

There would also be a default namespace path that contains the
`p4namespaces` directory, and it would contain the files in the
`p4namespaces` directory, relative to this README.md file.

Running commands like those shown below with the default include and
namespace paths:

```bash
cd p4prog1
p4c --target bmv2 --arch v1model demo1.p4
```

would go through the following steps, each of which are discussed
further below.

+ Run CPP (the C Preprocessor) on file demo1.p4 with the current
  include path, producing demo1.p4i
+ p4c begins compiling demo1.p4i and encounters the first import statement
  + p4c finds and compiles namespace core
+ p4c continues compiling demo1.p4i and encounters the second import statement
  + p4c finds and compiles namespace v1model
+ p4c continues compiling demo1.p4i and encounters no more import statements


## Run CPP on file demo1.p4 with the current include path, producing demo1.p4i

Running the C preprocessor on file demo1.p4 will result in a file I
will call demo1.p4i.  demo.p4i has the line `#include <core.p4>`
replaced with the contents of the file `p4include/core.p4`, which is:

```
from core import
    // extern object types
    packet_in,
    packet_out,

    // ... many lines here omitted for brevity ...

    // table properties
    key,
    actions,
    default_action,
    entries,
    size;
```

Similarly it has the line `#include <v1model.p4>` replaced with the
contents of the file `p4include/v1model.p4`, which contains:

```
from v1model import
    ////////////////////////////////////////////////////////////
    // Until the next comment, the first group of names were added 2016-Apr-04
    ////////////////////////////////////////////////////////////
    standard_metadata_t,
    CounterType,
    HashAlgorithm,

    // ... many lines here omitted for brevity ...

    implementation,
    support_timeout;
```

Note: The resulting demo1.p4i file contains _NO_ definitions of any of
these names.


## p4c begins compiling demo1.p4i and encounters the first import statement

When p4c reaches the line `from core import ...;` in demo1.p4i, it
will search for a namespace named `core` in the currently configured
namespace path.  It should find the file `p4namespaces/core.p4`.

p4c then runs CPP on `p4namespaces/core.p4`.  In this case, there are
no preprocessor directives in the file, so the output of CPP is the
same as the input file.  In general, CPP could process `#define`,
`#ifdef`, and `#include` directives, as normal.  I will call the the
output of CPP `core.p4i`.

p4c should then compile the file `core.p4i` in such a way that:

+ all of its non-exported top level names are visible only within the
  file core.p4i.
+ all of its exported top level names are visible later within
  core.p4i by the name used in the file, as usual in today's P4
  language.  These exported names are also visible to the namespace
  that contains the statement importing namespace `core`.
  + In this case, since the relevant `import` statement is `from core
    import packet_in, ...;`, they will be visible in the default
    namespace of demo1.p4i by the same names they are defined in
    `core.p4i`.

When p4c is finished compiling `core.p4i`, it should resume compiling
`demo1.p4i`.


## p4c continues compiling demo1.p4i and encounters the second import statement

When p4c reaches the line `from v1model import ...;` in demo1.p4i, it
will search for the namespace v1model.  This is similar to what it did
for namespace core in the previous section.

It will then run CPP on the top level file defining namespace v1model,
producing `v1model.p4i`.

It will then compile the contents of `v1model.p4i` in much the same
way as described in the previous section for `core.p4i`.


## p4c continues compiling demo1.p4i and encounters no more import statements

The rest of demo1.p4i is now compiled.  Throughout this last part of
compilation, the imported names have been made to appear that they
were locally defined inside of demo1.p4i, and do not require any
prefix to refer to them.
