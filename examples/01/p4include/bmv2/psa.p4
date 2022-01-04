// The following is all of the top level names in this file as of
// 2021-Dec-14:

// https://github.com/p4lang/p4c/blob/main/p4include/bmv2/psa.p4

// additional git commit history was obtained from the former location
// of this file before it was moved on 2021-Jul-01

// https://github.com/p4lang/p4c/blob/main/p4include/psa.p4

// The earliest version of this file checked into the p4c repo was
// 2017-May-10.  I am going to treat any changes made before the PSA
// specification version 1.0 was published on 2018-Mar-01 as if they
// were added on 2018-Mar-01.

// match_kind list was originally range, selector on 2018-Mar-01
// optional was added to PSA on 2021-Apr-28.

// The counts immediately below do not count match kinds, table
// properties, or annotations:

//     63 top level names in PSA v1.0
//     -1, +29 top level names in PSA v1.1, totaling 91 top level names

//     93 total top level names as of 2021-Dec-14

// The counts below _do_ count match kinds, table properties, and
// annotations:

//     There are a total of 101 top level names as of 2021-Dec-14, if
//       we include the match_kind "optional".

from psa import
    ////////////////////////////////////////////////////////////
    // Until the "End of PSA v1.0" comment below, all of these names
    // were part of the v1.0 of the PSA specification published on
    // 2018-Mar-01.
    ////////////////////////////////////////////////////////////

    // typedef in v1.0, changed to type in v1.1
    PortId_t,
    MulticastGroup_t,
    CloneSessionId_t,
    ClassOfService_t,
    PacketLength_t,
    EgressInstance_t,
    Timestamp_t,
    ParserError_t,
    PortIdInHeader_t,
    MulticastGroupInHeader_t,
    CloneSessionIdInHeader_t,
    ClassOfServiceInHeader_t,
    PacketLengthInHeader_t,
    EgressInstanceInHeader_t,
    TimestampInHeader_t,

    // const
    PSA_PORT_RECIRCULATE,
    PSA_PORT_CPU,
    PSA_CLONE_SESSION_TO_CPU,

    // enum
    PSA_PacketPath_t,

    // struct types
    psa_ingress_parser_input_metadata_t,
    psa_egress_parser_input_metadata_t,
    psa_ingress_input_metadata_t,
    psa_ingress_output_metadata_t,
    psa_egress_input_metadata_t,
    psa_egress_deparser_input_metadata_t,
    psa_egress_output_metadata_t,

    // extern functions
    psa_clone_i2e,
    psa_resubmit,
    psa_normal,
    psa_clone_e2e,
    psa_recirculate,

    // actions
    send_to_port,
    multicast,
    ingress_drop,
    egress_drop,

    // mostly extern objects, with a few enum types
    PacketReplicationEngine,
    BufferingQueueingEngine,
    PSA_HashAlgorithm_t,
    Hash,
    Checksum,
    InternetChecksum,
    PSA_CounterType_t,
    Counter,
    DirectCounter,
    PSA_MeterType_t,
    PSA_MeterColor_t,
    Meter,
    DirectMeter,
    Register,
    Random,
    ActionProfile,
    ActionSelector,
    Digest,

    // a ValueSet extern was in PSA v1.0, but removed in PSA v1.1 when
    // the 'value_set' construct was added to v1.1.0 of the P4_16
    // language specification, released on 2018-Nov-26.

    // parsers, controls, and packages
    IngressParser,
    Ingress,
    IngressDeparser,
    EgressParser,
    Egress,
    EgressDeparser,
    IngressPipeline,
    EgressPipeline,
    PSA_Switch,

    ////////////////////////////////////////////////////////////
    // End of PSA v1.0
    ////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////
    // Until the "End of PSA v1.1" comment below, all of these names
    // were part of the v1.1 of the PSA specification published on
    // 2018-Nov-22, but not part of the v1.0 specification.
    ////////////////////////////////////////////////////////////

    // typedefs
    PortIdUint_t,
    MulticastGroupUint_t,
    CloneSessionIdUint_t,
    ClassOfServiceUint_t,
    PacketLengthUint_t,
    EgressInstanceUint_t,
    TimestampUint_t,
    PortIdInHeaderUint_t,
    MulticastGroupInHeaderUint_t,
    CloneSessionIdInHeaderUint_t,
    ClassOfServiceInHeaderUint_t,
    PacketLengthInHeaderUint_t,
    EgressInstanceInHeaderUint_t,
    TimestampInHeaderUint_t,

    // functions
    psa_PortId_header_to_int,
    psa_MulticastGroup_header_to_int,
    psa_CloneSessionId_header_to_int,
    psa_ClassOfService_header_to_int,
    psa_PacketLength_header_to_int,
    psa_EgressInstance_header_to_int,
    psa_Timestamp_header_to_int,
    psa_PortId_int_to_header,
    psa_MulticastGroup_int_to_header,
    psa_CloneSessionId_int_to_header,
    psa_ClassOfService_int_to_header,
    psa_PacketLength_int_to_header,
    psa_EgressInstance_int_to_header,
    psa_Timestamp_int_to_header,

    // enum
    PSA_IdleTimeout_t,

    ////////////////////////////////////////////////////////////
    // End of PSA v1.1
    ////////////////////////////////////////////////////////////

    // These were added 2019-Jun-18, the same time they were added to
    // the v1model architecture.
    assert,
    assume,

    // match kinds
    range,
    // Leaving "optional" out for now, until we decide how to handle
    // issue that optional is also the name of an annotation in core
    // namespace.  If we do not import it by default, the match_kind
    // could be named psa.match_kind in P4 user programs that use
    // it.
    selector,

    // annotations

    // I believe that PSA does not add any annotations over what
    // exists in the P4_16 language.  The @p4runtime_translation is
    // discussed within the PSA specification, but I consider that as
    // an annotation defined by the P4Runtime API specification, not
    // PSA, because it is in a list of annotations in the P4Runtime
    // API specification here:
    // https://p4.org/p4-spec/p4runtime/v1.3.0/P4Runtime-Spec.html#sec-p4-annotations

    // table properties
    // This is a complete list of all table properties defined by PSA
    // specification version 1.1.0:
    // https://p4.org/p4-spec/docs/PSA-v1.1.0.html#sec-psa-table-properties
    psa_direct_counter,
    psa_direct_meter,
    psa_implementation,
    psa_empty_group_action,
    psa_idle_timeout;
