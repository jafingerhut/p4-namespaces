// The following is all of the top level names in this file as of
// 2021-Dec-14:

// https://github.com/p4lang/p4c/blob/main/p4include/core.p4

// To that short list of only 4 names the file below also proposes
// adding match kinds, annotations, and table properties as top level
// names that can be imported.

// From 2016 until the end of 2021, _no_ new top level names were
// added to this file.

// There were new values of the type 'error' added during those 6
// years, and one new 2-argument signature for the 'emit' method for
// extern object 'packet_out'.

// The match_kind list in core.p4 has always been exact, lpm, ternary

// There are a total of 23 top level names

from core import
    // extern object types
    packet_in,
    packet_out,

    // extern functions
    verify,

    // actions
    NoAction,

    // match kinds
    exact,
    ternary,
    lpm,

    // annotations
    atomic,
    defaultonly,
    deprecated,
    hidden,
    match,
    name,
    noSideEffects,
    noWarn,
    optional,
    pure,
    tableonly,

    // table properties
    key,
    actions,
    default_action,
    entries,
    size;
