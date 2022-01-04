// The following is all of the top level names in the v1model
// architecture as of 2021-Dec-14, as defined in this file:

// https://github.com/p4lang/p4c/blob/main/p4include/v1model.p4

// match_kind list was originally range, selector on 2016-Apr-04.
// optional was added to v1model on 2020-Feb-04.

// A struct type named standard_metadata_t has always been part of
// v1model.p4 since the beginning.  What fields it contains has
// changed over the years.  Those changes are not described here.

// The counts immediately below do not count match kinds, table
// properties, or annotations:

//           28 top level names at end of 2016
//     +5 -> 33 top level names at end of 2017
//     No change to this count in 2018
//     +3 -> 36 top level names at end of 2019
//     +2 -> 38 top level names at end of 2020
//     +3 -> 41 top level names at end of 2021

//     There are a total of 41 top level names as of 2021-Dec-14.

// The counts below _do_ count match kinds, table properties, and
// annotations:

//     There are a total of 48 top level names as of 2021-Dec-14, if
//       we include the match_kind "optional".

from v1model import
    ////////////////////////////////////////////////////////////
    // Until the next comment, the first group of names were added 2016-Apr-04
    ////////////////////////////////////////////////////////////
    standard_metadata_t,
    CounterType,
    HashAlgorithm,
    CloneType,
    random,
    digest,
    mark_to_drop,  // 2 signatures, 0-arg signature deprecated 2019-Apr-18
    hash,
    Checksum16,
    clone,
    Parser,
    VerifyChecksum,
    Ingress,
    Egress,
    ComputeChecksum,
    Deparser,
    V1Switch,
    resubmit,    // deprecated 2021-Dec-06: see resubmit_preserving_field_list
    recirculate, // deprecated 2021-Dec-06: see recirculate_preserving_field_list
    clone3,      // deprecated 2021-Dec-06: see clone_preserving_field_list

    ////////////////////////////////////////////////////////////
    // The next group were originally named CapitalizedStyle, renamed
    // 2016-May-31
    ////////////////////////////////////////////////////////////
    counter,         // originally Counter
    direct_counter,  // originally DirectCounter
    meter,           // originally Meter
    direct_meter,    // originally DirectMeter
    register,        // originally Register
    action_profile,  // originally ActionProfile
    action_selector, // originally ActionSelector

    truncate,        // added 2016-Dec-02

    MeterType,       // added 2017-Mar-29
    verify_checksum,               // added 2017-Aug-23
    update_checksum,               // added 2017-Aug-23
    verify_checksum_with_payload,  // added 2017-Dec-12
    update_checksum_with_payload,  // added 2017-Dec-12

    assert,    // added 2019-Jun-18
    assume,    // added 2019-Jun-18
    log_msg,   // 2 signatures, added 2019-Oct-01

    __v1model_version,   // added 2020-Apr-13
    PortId_t,            // added 2020-Apr-13

    // the next group were added on 2021-Dec-06
    resubmit_preserving_field_list,
    recirculate_preserving_field_list,
    clone_preserving_field_list,

    // match kinds
    range,
    // Leaving "optional" out for now, until we decide how to handle
    // issue that optional is also the name of an annotation in core
    // namespace.  If we do not import it by default, the match_kind
    // could be named v1model.match_kind in P4 user programs that use
    // it.
    selector,

    // annotations
    // I believe that v1model does not add any annotations over what
    // exists in the P4_16 language.

    // table properties
    // I believe that this is a complete list of all table properties
    // defined by the bmv2 implementation of the v1model architecture:
    // https://github.com/p4lang/p4c/blob/main/frontends/p4/fromv1.0/v1model.h#L224-L235
    // Note that "size" appears in the code linked above as of
    // 2021-Jan-03, I think because it was originally implemented in
    // p4c as a v1model-specific table property, and then years later
    // added to the P4_16 language specification.
    counters,
    meters,
    implementation,
    support_timeout;
