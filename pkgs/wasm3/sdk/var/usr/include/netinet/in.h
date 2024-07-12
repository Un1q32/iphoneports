#pragma once

#include_next <netinet/in.h>

#define IP_ADD_SOURCE_MEMBERSHIP 70
#define IP_DROP_SOURCE_MEMBERSHIP 71
#define MCAST_JOIN_SOURCE_GROUP 82
#define MCAST_LEAVE_SOURCE_GROUP 83

struct ip_mreq_source {
  struct in_addr imr_multiaddr;
  struct in_addr imr_sourceaddr;
  struct in_addr imr_interface;
};

struct group_source_req {
  uint32_t gsr_interface;
  struct sockaddr_storage gsr_group;
  struct sockaddr_storage gsr_source;
};
