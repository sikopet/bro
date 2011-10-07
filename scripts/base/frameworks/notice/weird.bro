@load base/utils/conn-ids
@load base/utils/site
@load ./main

module Weird;

export {
	redef enum Log::ID += { LOG };
	
	redef enum Notice::Type += {
		## Generic unusual but alarm-worthy activity.
		Weird_Activity,
	};
	
	type Info: record {
		ts:     time    &log;
		uid:    string  &log &optional;
		id:     conn_id &log &optional;
		msg:    string  &log;
		addl:   string  &log &optional;
		notice: bool    &log &default=F;
	};

	type WeirdAction: enum {
		WEIRD_UNSPECIFIED, WEIRD_IGNORE, WEIRD_FILE,
		WEIRD_NOTICE_ALWAYS, WEIRD_NOTICE_PER_CONN,
		WEIRD_NOTICE_PER_ORIG, WEIRD_NOTICE_ONCE,
	};

	# Which of the above actions lead to logging.  For internal use.
	const notice_actions = {
		WEIRD_NOTICE_ALWAYS, WEIRD_NOTICE_PER_CONN,
		WEIRD_NOTICE_PER_ORIG, WEIRD_NOTICE_ONCE,
	};

	const weird_action: table[string] of WeirdAction = {
		# tcp_weird
		["above_hole_data_without_any_acks"]	=	WEIRD_FILE,
		["active_connection_reuse"]	=	WEIRD_FILE,
		["bad_HTTP_reply"]	=	WEIRD_FILE,
		["bad_HTTP_version"]	=	WEIRD_FILE,
		["bad_ICMP_checksum"]	=	WEIRD_FILE,
		["bad_ident_port"]	=	WEIRD_FILE,
		["bad_ident_reply"]	=	WEIRD_FILE,
		["bad_ident_request"]	=	WEIRD_FILE,
		["bad_rlogin_prolog"]	=	WEIRD_FILE,
		["bad_rsh_prolog"] = 	WEIRD_FILE,
		["rsh_text_after_rejected"] = 	WEIRD_FILE,
		["bad_RPC"]	=	WEIRD_NOTICE_PER_ORIG,
		["bad_RPC_program"]	=	WEIRD_FILE,
		["bad_SYN_ack"]	=	WEIRD_FILE,
		["bad_TCP_checksum"]	=	WEIRD_FILE,
		["bad_UDP_checksum"]	=	WEIRD_FILE,
		["baroque_SYN"]	=	WEIRD_FILE,
		["base64_illegal_encoding"]	=	WEIRD_FILE,
		["connection_originator_SYN_ack"]	=	WEIRD_FILE,
		["corrupt_tcp_options"]	=	WEIRD_NOTICE_PER_ORIG,
		["crud_trailing_HTTP_request"]	=	WEIRD_FILE,
		["data_after_reset"]	=	WEIRD_FILE,
		["data_before_established"]	=	WEIRD_FILE,
		["data_without_SYN_ACK"]	=	WEIRD_FILE,
		["DHCP_no_type_option"] = 	WEIRD_FILE,
		["DHCP_wrong_msg_type"] = 	WEIRD_FILE,
		["DHCP_wrong_op_type"] = 	WEIRD_FILE,
		["DNS_AAAA_neg_length"] = 	WEIRD_FILE,
		["DNS_Conn_count_too_large"] = 	WEIRD_FILE,
		["DNS_NAME_too_long"] = 	WEIRD_FILE,
		["DNS_RR_bad_length"] = 	WEIRD_FILE,
		["DNS_RR_length_mismatch"] = 	WEIRD_FILE,
		["DNS_RR_unknown_type"] = 	WEIRD_FILE,
		["DNS_label_forward_compress_offset"] = 	WEIRD_NOTICE_PER_ORIG,
		["DNS_label_len_gt_name_len"] = 	WEIRD_NOTICE_PER_ORIG,
		["DNS_label_len_gt_pkt"] = 	WEIRD_NOTICE_PER_ORIG,
		["DNS_label_too_long"] = 	WEIRD_NOTICE_PER_ORIG,
		["DNS_truncated_RR_rdlength_lt_len"] = 	WEIRD_FILE,
		["DNS_truncated_ans_too_short"] = 	WEIRD_FILE,
		["DNS_truncated_len_lt_hdr_len"] = 	WEIRD_FILE,
		["DNS_truncated_quest_too_short"] = 	WEIRD_FILE,
		["dns_changed_number_of_responses"]	=	WEIRD_NOTICE_PER_ORIG,
		["dns_reply_seen_after_done"]	=	WEIRD_NOTICE_PER_ORIG,
		["excessive_data_without_further_acks"] = 	WEIRD_FILE,
		["excess_RPC"]	=	WEIRD_NOTICE_PER_ORIG,
		["excessive_RPC_len"]	=	WEIRD_NOTICE_PER_ORIG,
		["FIN_advanced_last_seq"]	=	WEIRD_FILE,
		["FIN_after_reset"]	=	WEIRD_IGNORE,
		["FIN_storm"]	=	WEIRD_NOTICE_ALWAYS,
		["HTTP_bad_chunk_size"]	=	WEIRD_FILE,
		["HTTP_chunked_transfer_for_multipart_message"]	=	WEIRD_FILE,
		["HTTP_overlapping_messages"]	=	WEIRD_FILE,
		["HTTP_unknown_method"]	=	WEIRD_FILE,
		["HTTP_version_mismatch"]	=	WEIRD_FILE,
		["ident_request_addendum"]	=	WEIRD_FILE,
		["inappropriate_FIN"]	=	WEIRD_FILE,
		["inflate_data_failed"]	=	WEIRD_FILE,
		["inflate_failed"]	=	WEIRD_FILE,
		["invalid_irc_global_users_reply"] = 	WEIRD_FILE,
		["irc_invalid_command"] = 	WEIRD_FILE,
		["irc_invalid_dcc_message_format"] = 	WEIRD_FILE,
		["irc_invalid_invite_message_format"] = 	WEIRD_FILE,
		["irc_invalid_join_line"] = 	WEIRD_FILE,
		["irc_invalid_kick_message_format"] = 	WEIRD_FILE,
		["irc_invalid_line"] = 	WEIRD_FILE,
		["irc_invalid_mode_message_format"] = 	WEIRD_FILE,
		["irc_invalid_names_line"] = 	WEIRD_FILE,
		["irc_invalid_njoin_line"] = 	WEIRD_FILE,
		["irc_invalid_notice_message_format"] = 	WEIRD_FILE,
		["irc_invalid_oper_message_format"] = 	WEIRD_FILE,
		["irc_invalid_privmsg_message_format"] = 	WEIRD_FILE,
		["irc_invalid_reply_number"] = 	WEIRD_FILE,
		["irc_invalid_squery_message_format"] = 	WEIRD_FILE,
		["irc_invalid_topic_reply"] = 	WEIRD_FILE,
		["irc_invalid_who_line"] = 	WEIRD_FILE,
		["irc_invalid_who_message_format"] = 	WEIRD_FILE,
		["irc_invalid_whois_channel_line"] = 	WEIRD_FILE,
		["irc_invalid_whois_message_format"] = 	WEIRD_FILE,
		["irc_invalid_whois_operator_line"] = 	WEIRD_FILE,
		["irc_invalid_whois_user_line"] = 	WEIRD_FILE,
		["irc_line_size_exceeded"] = 	WEIRD_FILE,
		["irc_line_too_short"] = 	WEIRD_FILE,
		["irc_too_many_invalid"] = 	WEIRD_FILE,
		["line_terminated_with_single_CR"]	=	WEIRD_FILE,
		["line_terminated_with_single_LF"]	=	WEIRD_FILE,
		["malformed_ssh_identification"]	= WEIRD_FILE,
		["malformed_ssh_version"] = 	WEIRD_FILE,
		["matching_undelivered_data"]	= WEIRD_FILE,
		["multiple_HTTP_request_elements"]	=	WEIRD_FILE,
		["multiple_RPCs"]	=	WEIRD_NOTICE_PER_ORIG,
		["non_IPv4_packet"]	=	WEIRD_NOTICE_ONCE,
		["NUL_in_line"]	=	WEIRD_FILE,
		["originator_RPC_reply"]	=	WEIRD_NOTICE_PER_ORIG,
		["partial_finger_request"]	=	WEIRD_FILE,
		["partial_ftp_request"]	=	WEIRD_FILE,
		["partial_ident_request"]	=	WEIRD_FILE,
		["partial_RPC"]	=	WEIRD_NOTICE_PER_ORIG,
		["partial_RPC_request"]	=	WEIRD_FILE,
		["pending_data_when_closed"]	=	WEIRD_FILE,
		["pop3_bad_base64_encoding"]	=	WEIRD_FILE,
		["pop3_client_command_unknown"]	=	WEIRD_FILE,
		["pop3_client_sending_server_commands"]	=	WEIRD_FILE,
		["pop3_malformed_auth_plain"]	=	WEIRD_FILE,
		["pop3_server_command_unknown"]	=	WEIRD_FILE,
		["pop3_server_sending_client_commands"]	=	WEIRD_FILE,
		["possible_split_routing"]	=	WEIRD_FILE,
		["premature_connection_reuse"]	=	WEIRD_FILE,
		["repeated_SYN_reply_wo_ack"]	=	WEIRD_FILE,
		["repeated_SYN_with_ack"]	=	WEIRD_FILE,
		["responder_RPC_call"]	=	WEIRD_NOTICE_PER_ORIG,
		["rlogin_text_after_rejected"]	=	WEIRD_FILE,
		["RPC_rexmit_inconsistency"]	=	WEIRD_FILE,
		["RPC_underflow"] = 	WEIRD_FILE,
		["RST_storm"]	=	WEIRD_NOTICE_ALWAYS,
		["RST_with_data"]	=	WEIRD_FILE,	# PC's do this
		["simultaneous_open"]	=	WEIRD_NOTICE_PER_CONN,
		["spontaneous_FIN"]	=	WEIRD_IGNORE,
		["spontaneous_RST"]	=	WEIRD_IGNORE,
		["SMB_parsing_error"] = 	WEIRD_FILE,
		["no_smb_session_using_parsesambamsg"] = 	WEIRD_FILE,
		["smb_andx_command_failed_to_parse"] = 	WEIRD_FILE,
		["transaction_subcmd_missing"] = 	WEIRD_FILE,
		["SSLv3_data_without_full_handshake"] = 	WEIRD_FILE,
		["unexpected_SSLv3_record"] = 	WEIRD_FILE,
		["successful_RPC_reply_to_invalid_request"] = 	WEIRD_NOTICE_PER_ORIG,
		["SYN_after_close"]	=	WEIRD_FILE,
		["SYN_after_partial"]	=	WEIRD_NOTICE_PER_ORIG,
		["SYN_after_reset"]	=	WEIRD_FILE,
		["SYN_inside_connection"]	=	WEIRD_FILE,
		["SYN_seq_jump"]	=	WEIRD_FILE,
		["SYN_with_data"]	=	WEIRD_FILE,
		["TCP_christmas"]	=	WEIRD_FILE,
		["truncated_ARP"]	=	WEIRD_FILE,
		["truncated_NTP"]	=	WEIRD_FILE,
		["UDP_datagram_length_mismatch"]	=	WEIRD_NOTICE_PER_ORIG,
		["unexpected_client_HTTP_data"] = 	WEIRD_FILE,
		["unexpected_multiple_HTTP_requests"]	=	WEIRD_FILE,
		["unexpected_server_HTTP_data"] = 	WEIRD_FILE,
		["unmatched_HTTP_reply"]	=	WEIRD_FILE,
		["unpaired_RPC_response"]	=	WEIRD_FILE,
		["unsolicited_SYN_response"]	=	WEIRD_IGNORE,
		["window_recision"]	= WEIRD_FILE,
		["double_%_in_URI"]	= WEIRD_FILE,
		["illegal_%_at_end_of_URI"]	= WEIRD_FILE,
		["unescaped_%_in_URI"]	= WEIRD_FILE,
		["unescaped_special_URI_char"]	= WEIRD_FILE,

		["UDP_zone_transfer"]	= WEIRD_NOTICE_ONCE,

		["deficit_netbios_hdr_len"]	= WEIRD_FILE,
		["excess_netbios_hdr_len"]	= WEIRD_FILE,
		["netbios_client_session_reply"]	= WEIRD_FILE,
		["netbios_raw_session_msg"]	= WEIRD_FILE,
		["netbios_server_session_request"]	= WEIRD_FILE,
		["unknown_netbios_type"]	= WEIRD_FILE,

		# flow_weird
		["excessively_large_fragment"]	=	WEIRD_NOTICE_ALWAYS,

		# Code Red generates slews ...
		["excessively_small_fragment"]	=	WEIRD_NOTICE_PER_ORIG,

		["fragment_inconsistency"]	=	WEIRD_NOTICE_PER_ORIG,
		["fragment_overlap"]	=	WEIRD_NOTICE_PER_ORIG,
		["fragment_protocol_inconsistency"]	=	WEIRD_NOTICE_ALWAYS,
		["fragment_size_inconsistency"]	=	WEIRD_NOTICE_PER_ORIG,
		["fragment_with_DF"]	=	WEIRD_FILE,	# these do indeed happen!
		["incompletely_captured_fragment"]	=	WEIRD_NOTICE_ALWAYS,

		# net_weird
		["bad_IP_checksum"]	=	WEIRD_FILE,
		["bad_TCP_header_len"]	=	WEIRD_FILE,
		["internally_truncated_header"]	=	WEIRD_NOTICE_ALWAYS,
		["truncated_IP"]	=	WEIRD_FILE,
		["truncated_header"]	=	WEIRD_FILE,

		# generated by policy script
		["Land_attack"]	=		WEIRD_NOTICE_PER_ORIG,
		["bad_pm_port"]	=		WEIRD_NOTICE_PER_ORIG,
		
		["ICMP-unreachable for wrong state"] = WEIRD_NOTICE_PER_ORIG,
		
	} &redef;

	# table that maps weird types into a function that should be called
	# to determine the action.
	const weird_action_filters:
		table[string] of function(c: connection): WeirdAction &redef;

	const weird_ignore_host: set[addr, string] &redef;

	# But don't ignore these (for the weird file), it's handy keeping
	# track of clustered checksum errors.
	const weird_do_not_ignore_repeats = {
		"bad_IP_checksum", "bad_TCP_checksum", "bad_UDP_checksum",
		"bad_ICMP_checksum",
	} &redef;
	
	global log_weird: event(rec: Info);
}

# id/msg pairs that should be ignored (because the problem has already
# been reported).
global weird_ignore: table[string] of set[string] &write_expire = 10 min;

# For WEIRD_NOTICE_PER_CONN.
global did_notice_conn: set[addr, port, addr, port, string]
							&read_expire = 1 day;

# For WEIRD_NOTICE_PER_ORIG.
global did_notice_orig: set[addr, string] &read_expire = 1 day;

# For WEIRD_NOTICE_ONCE.
global did_weird_log: set[string] &read_expire = 1 day;

global did_inconsistency_msg: set[conn_id];

# Used to pass the optional connection into report_weird().
global current_conn: connection;

event bro_init() &priority=5
	{
	Log::create_stream(Weird::LOG, [$columns=Info, $ev=log_weird]);
	}

function report_weird(t: time, name: string, id: string, have_conn: bool,
			addl: string, action: WeirdAction, no_log: bool)
	{
	local info: Info;
	info$ts = t;
	info$msg = name;
	if ( addl != "" )
		info$addl = addl;
	if ( have_conn )
		{
		info$uid = current_conn$uid;
		info$id = current_conn$id;
		}
	
	if ( action == WEIRD_IGNORE ||
	     (id in weird_ignore && name in weird_ignore[id]) )
		return;
	
	if ( action == WEIRD_UNSPECIFIED )
		{
		if ( name in weird_action && weird_action[name] == WEIRD_IGNORE )
			return;
		else
			{
			action = WEIRD_NOTICE_ALWAYS;
			info$notice = T;
			}
		}
	
	if ( action in notice_actions && ! no_log )
		{
		local n: Notice::Info;
		n$note = Weird_Activity;
		n$msg = info$msg;
		if ( have_conn )
			n$conn = current_conn;
		if ( info?$addl )
			n$sub = info$addl;
		NOTICE(n);
		}
	else if ( id != "" && name !in weird_do_not_ignore_repeats )
		{
		if ( id !in weird_ignore )
			weird_ignore[id] = set() &mergeable;
		add weird_ignore[id][name];
		}
		
	Log::write(Weird::LOG, info);
	}

function report_weird_conn(t: time, name: string, id: string, addl: string,
				c: connection)
	{
	if ( [c$id$orig_h, name] in weird_ignore_host ||
	     [c$id$resp_h, name] in weird_ignore_host )
		return;

	local no_log = F;
	local action = WEIRD_UNSPECIFIED;

	if ( name in weird_action )
		{
		if ( name in weird_action_filters )
			action = weird_action_filters[name](c);

		if ( action == WEIRD_UNSPECIFIED )
			action = weird_action[name];

		local cid = c$id;

		if ( action == WEIRD_NOTICE_PER_CONN )
			{
			if ( [cid$orig_h, cid$orig_p, cid$resp_h, cid$resp_p, name] in did_notice_conn )
				no_log = T;
			else
				add did_notice_conn[cid$orig_h, cid$orig_p, cid$resp_h, cid$resp_p, name];
			}

		else if ( action == WEIRD_NOTICE_PER_ORIG )
			{
			if ( [c$id$orig_h, name] in did_notice_orig )
				no_log = T;
			else
				add did_notice_orig[c$id$orig_h, name];
			}

		else if ( action == WEIRD_NOTICE_ONCE )
			{
			if ( name in did_weird_log )
				no_log = T;
			else
				add did_weird_log[name];
			}
		}

	current_conn = c;
	report_weird(t, name, id, T, addl, action, no_log);
	}

function report_weird_orig(t: time, name: string, id: string, orig: addr)
	{
	local no_log = F;
	local action = WEIRD_UNSPECIFIED;

	if ( name in weird_action )
		{
		action = weird_action[name];
		if ( action == WEIRD_NOTICE_PER_ORIG )
			{
			if ( [orig, name] in did_notice_orig )
				no_log = T;
			else
				add did_notice_orig[orig, name];
			}
		}

	report_weird(t, name, id, F, "", action, no_log);
	}
	
event conn_weird(name: string, c: connection, addl: string)
	{
	report_weird_conn(network_time(), name, id_string(c$id), addl, c);
	}

event flow_weird(name: string, src: addr, dst: addr)
	{
	report_weird_orig(network_time(), name, fmt("%s -> %s", src, dst), src);
	}

event net_weird(name: string)
	{
	report_weird(network_time(), name, "", F, "", WEIRD_UNSPECIFIED, F);
	}

event connection_state_remove(c: connection)
	{
	delete weird_ignore[id_string(c$id)];
	delete did_inconsistency_msg[c$id];
	}
