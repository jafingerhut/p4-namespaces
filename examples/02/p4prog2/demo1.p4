/*
Copyright 2022 Intel Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import <core.p4>;
import <v1model.p4> as v1;

header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}

header ipv4_t {
    bit<4>  version;
    bit<4>  ihl;
    bit<8>  diffserv;
    bit<16> totalLen;
    bit<16> identification;
    bit<3>  flags;
    bit<13> fragOffset;
    bit<8>  ttl;
    bit<8>  protocol;
    bit<16> hdrChecksum;
    bit<32> srcAddr;
    bit<32> dstAddr;
}

struct fwd_metadata_t {
    bit<32> l2ptr;
    bit<24> out_bd;
}

struct metadata_t {
    fwd_metadata_t fwd_metadata;
}

struct headers_t {
    ethernet_t ethernet;
    ipv4_t     ipv4;
}

parser parserImpl(
    core.packet_in packet,
    out headers_t hdr,
    inout metadata_t meta,
    inout v1.standard_metadata_t stdmeta)
{
    const bit<16> ETHERTYPE_IPV4 = 16w0x0800;

    state start {
        transition parse_ethernet;
    }
    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            ETHERTYPE_IPV4: parse_ipv4;
            default: accept;
        }
    }
    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition accept;
    }
}

control ingressImpl(
    inout headers_t hdr,
    inout metadata_t meta,
    inout v1.standard_metadata_t stdmeta)
{
    action my_drop() {
        v1.mark_to_drop(stdmeta);
    }

    action set_l2ptr(bit<32> l2ptr) {
        meta.fwd_metadata.l2ptr = l2ptr;
    }
    table ipv4_da_lpm {
        core.key = {
            hdr.ipv4.dstAddr: core.lpm @core.name("ipv4_dest");
        }
        core.actions = {
            @core.tableonly set_l2ptr;
            my_drop;
        }
        core.default_action = my_drop;
        core.size = 32768;
    }

    action set_bd_dmac_intf(bit<24> bd, bit<48> dmac, bit<9> intf) {
        meta.fwd_metadata.out_bd = bd;
        hdr.ethernet.dstAddr = dmac;
        stdmeta.egress_spec = intf;
        hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    }
    table mac_da {
        core.key = {
            meta.fwd_metadata.l2ptr: core.exact;
        }
        core.actions = {
            set_bd_dmac_intf;
            my_drop;
        }
        core.default_action = my_drop;
        core.size = 8192;
    }

    apply {
        ipv4_da_lpm.apply();
        mac_da.apply();
    }
}

control egressImpl(
    inout headers_t hdr,
    inout metadata_t meta,
    inout v1.standard_metadata_t stdmeta)
{
    action my_drop() {
        v1.mark_to_drop(stdmeta);
    }
    action rewrite_mac(bit<48> smac) {
        hdr.ethernet.srcAddr = smac;
    }
    table send_frame {
        core.key = {
            meta.fwd_metadata.out_bd: core.exact;
        }
        core.actions = {
            rewrite_mac;
            my_drop;
        }
        core.default_action = my_drop;
        core.size = 128;
    }

    apply {
        send_frame.apply();
    }
}

control deparserImpl(
    core.packet_out packet,
    in headers_t hdr)
{
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.ipv4);
    }
}

control verifyChecksum(
    inout headers_t hdr,
    inout metadata_t meta)
{
    apply {
        v1.verify_checksum(hdr.ipv4.isValid() && hdr.ipv4.ihl == 5,
            { hdr.ipv4.version,
                hdr.ipv4.ihl,
                hdr.ipv4.diffserv,
                hdr.ipv4.totalLen,
                hdr.ipv4.identification,
                hdr.ipv4.flags,
                hdr.ipv4.fragOffset,
                hdr.ipv4.ttl,
                hdr.ipv4.protocol,
                hdr.ipv4.srcAddr,
                hdr.ipv4.dstAddr },
            hdr.ipv4.hdrChecksum, v1.HashAlgorithm.csum16);
    }
}

control updateChecksum(
    inout headers_t hdr,
    inout metadata_t meta)
{
    apply {
        v1.update_checksum(hdr.ipv4.isValid() && hdr.ipv4.ihl == 5,
            { hdr.ipv4.version,
                hdr.ipv4.ihl,
                hdr.ipv4.diffserv,
                hdr.ipv4.totalLen,
                hdr.ipv4.identification,
                hdr.ipv4.flags,
                hdr.ipv4.fragOffset,
                hdr.ipv4.ttl,
                hdr.ipv4.protocol,
                hdr.ipv4.srcAddr,
                hdr.ipv4.dstAddr },
            hdr.ipv4.hdrChecksum, v1.HashAlgorithm.csum16);
    }
}

v1.V1Switch(
    parserImpl(),
    verifyChecksum(),
    ingressImpl(),
    egressImpl(),
    updateChecksum(),
    deparserImpl()) main;
