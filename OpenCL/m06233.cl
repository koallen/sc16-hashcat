/**
 * Authors.....: Jens Steube <jens.steube@gmail.com>
 *               Gabriele Gristina <matrix@hashcat.net>
 *
 * License.....: MIT
 */

#define _WHIRLPOOL_

#include "inc_vendor.cl"
#include "inc_hash_constants.h"
#include "inc_hash_functions.cl"
#include "inc_types.cl"
#include "inc_common.cl"

#include "inc_cipher_aes256.cl"
#include "inc_cipher_twofish256.cl"
#include "inc_cipher_serpent256.cl"

#define R 10

__constant u32 Ch[8][256] =
{
  {
    0x18186018, 0x23238c23, 0xc6c63fc6, 0xe8e887e8,
    0x87872687, 0xb8b8dab8, 0x01010401, 0x4f4f214f,
    0x3636d836, 0xa6a6a2a6, 0xd2d26fd2, 0xf5f5f3f5,
    0x7979f979, 0x6f6fa16f, 0x91917e91, 0x52525552,
    0x60609d60, 0xbcbccabc, 0x9b9b569b, 0x8e8e028e,
    0xa3a3b6a3, 0x0c0c300c, 0x7b7bf17b, 0x3535d435,
    0x1d1d741d, 0xe0e0a7e0, 0xd7d77bd7, 0xc2c22fc2,
    0x2e2eb82e, 0x4b4b314b, 0xfefedffe, 0x57574157,
    0x15155415, 0x7777c177, 0x3737dc37, 0xe5e5b3e5,
    0x9f9f469f, 0xf0f0e7f0, 0x4a4a354a, 0xdada4fda,
    0x58587d58, 0xc9c903c9, 0x2929a429, 0x0a0a280a,
    0xb1b1feb1, 0xa0a0baa0, 0x6b6bb16b, 0x85852e85,
    0xbdbdcebd, 0x5d5d695d, 0x10104010, 0xf4f4f7f4,
    0xcbcb0bcb, 0x3e3ef83e, 0x05051405, 0x67678167,
    0xe4e4b7e4, 0x27279c27, 0x41411941, 0x8b8b168b,
    0xa7a7a6a7, 0x7d7de97d, 0x95956e95, 0xd8d847d8,
    0xfbfbcbfb, 0xeeee9fee, 0x7c7ced7c, 0x66668566,
    0xdddd53dd, 0x17175c17, 0x47470147, 0x9e9e429e,
    0xcaca0fca, 0x2d2db42d, 0xbfbfc6bf, 0x07071c07,
    0xadad8ead, 0x5a5a755a, 0x83833683, 0x3333cc33,
    0x63639163, 0x02020802, 0xaaaa92aa, 0x7171d971,
    0xc8c807c8, 0x19196419, 0x49493949, 0xd9d943d9,
    0xf2f2eff2, 0xe3e3abe3, 0x5b5b715b, 0x88881a88,
    0x9a9a529a, 0x26269826, 0x3232c832, 0xb0b0fab0,
    0xe9e983e9, 0x0f0f3c0f, 0xd5d573d5, 0x80803a80,
    0xbebec2be, 0xcdcd13cd, 0x3434d034, 0x48483d48,
    0xffffdbff, 0x7a7af57a, 0x90907a90, 0x5f5f615f,
    0x20208020, 0x6868bd68, 0x1a1a681a, 0xaeae82ae,
    0xb4b4eab4, 0x54544d54, 0x93937693, 0x22228822,
    0x64648d64, 0xf1f1e3f1, 0x7373d173, 0x12124812,
    0x40401d40, 0x08082008, 0xc3c32bc3, 0xecec97ec,
    0xdbdb4bdb, 0xa1a1bea1, 0x8d8d0e8d, 0x3d3df43d,
    0x97976697, 0x00000000, 0xcfcf1bcf, 0x2b2bac2b,
    0x7676c576, 0x82823282, 0xd6d67fd6, 0x1b1b6c1b,
    0xb5b5eeb5, 0xafaf86af, 0x6a6ab56a, 0x50505d50,
    0x45450945, 0xf3f3ebf3, 0x3030c030, 0xefef9bef,
    0x3f3ffc3f, 0x55554955, 0xa2a2b2a2, 0xeaea8fea,
    0x65658965, 0xbabad2ba, 0x2f2fbc2f, 0xc0c027c0,
    0xdede5fde, 0x1c1c701c, 0xfdfdd3fd, 0x4d4d294d,
    0x92927292, 0x7575c975, 0x06061806, 0x8a8a128a,
    0xb2b2f2b2, 0xe6e6bfe6, 0x0e0e380e, 0x1f1f7c1f,
    0x62629562, 0xd4d477d4, 0xa8a89aa8, 0x96966296,
    0xf9f9c3f9, 0xc5c533c5, 0x25259425, 0x59597959,
    0x84842a84, 0x7272d572, 0x3939e439, 0x4c4c2d4c,
    0x5e5e655e, 0x7878fd78, 0x3838e038, 0x8c8c0a8c,
    0xd1d163d1, 0xa5a5aea5, 0xe2e2afe2, 0x61619961,
    0xb3b3f6b3, 0x21218421, 0x9c9c4a9c, 0x1e1e781e,
    0x43431143, 0xc7c73bc7, 0xfcfcd7fc, 0x04041004,
    0x51515951, 0x99995e99, 0x6d6da96d, 0x0d0d340d,
    0xfafacffa, 0xdfdf5bdf, 0x7e7ee57e, 0x24249024,
    0x3b3bec3b, 0xabab96ab, 0xcece1fce, 0x11114411,
    0x8f8f068f, 0x4e4e254e, 0xb7b7e6b7, 0xebeb8beb,
    0x3c3cf03c, 0x81813e81, 0x94946a94, 0xf7f7fbf7,
    0xb9b9deb9, 0x13134c13, 0x2c2cb02c, 0xd3d36bd3,
    0xe7e7bbe7, 0x6e6ea56e, 0xc4c437c4, 0x03030c03,
    0x56564556, 0x44440d44, 0x7f7fe17f, 0xa9a99ea9,
    0x2a2aa82a, 0xbbbbd6bb, 0xc1c123c1, 0x53535153,
    0xdcdc57dc, 0x0b0b2c0b, 0x9d9d4e9d, 0x6c6cad6c,
    0x3131c431, 0x7474cd74, 0xf6f6fff6, 0x46460546,
    0xacac8aac, 0x89891e89, 0x14145014, 0xe1e1a3e1,
    0x16165816, 0x3a3ae83a, 0x6969b969, 0x09092409,
    0x7070dd70, 0xb6b6e2b6, 0xd0d067d0, 0xeded93ed,
    0xcccc17cc, 0x42421542, 0x98985a98, 0xa4a4aaa4,
    0x2828a028, 0x5c5c6d5c, 0xf8f8c7f8, 0x86862286,
  },
  {
    0xd8181860, 0x2623238c, 0xb8c6c63f, 0xfbe8e887,
    0xcb878726, 0x11b8b8da, 0x09010104, 0x0d4f4f21,
    0x9b3636d8, 0xffa6a6a2, 0x0cd2d26f, 0x0ef5f5f3,
    0x967979f9, 0x306f6fa1, 0x6d91917e, 0xf8525255,
    0x4760609d, 0x35bcbcca, 0x379b9b56, 0x8a8e8e02,
    0xd2a3a3b6, 0x6c0c0c30, 0x847b7bf1, 0x803535d4,
    0xf51d1d74, 0xb3e0e0a7, 0x21d7d77b, 0x9cc2c22f,
    0x432e2eb8, 0x294b4b31, 0x5dfefedf, 0xd5575741,
    0xbd151554, 0xe87777c1, 0x923737dc, 0x9ee5e5b3,
    0x139f9f46, 0x23f0f0e7, 0x204a4a35, 0x44dada4f,
    0xa258587d, 0xcfc9c903, 0x7c2929a4, 0x5a0a0a28,
    0x50b1b1fe, 0xc9a0a0ba, 0x146b6bb1, 0xd985852e,
    0x3cbdbdce, 0x8f5d5d69, 0x90101040, 0x07f4f4f7,
    0xddcbcb0b, 0xd33e3ef8, 0x2d050514, 0x78676781,
    0x97e4e4b7, 0x0227279c, 0x73414119, 0xa78b8b16,
    0xf6a7a7a6, 0xb27d7de9, 0x4995956e, 0x56d8d847,
    0x70fbfbcb, 0xcdeeee9f, 0xbb7c7ced, 0x71666685,
    0x7bdddd53, 0xaf17175c, 0x45474701, 0x1a9e9e42,
    0xd4caca0f, 0x582d2db4, 0x2ebfbfc6, 0x3f07071c,
    0xacadad8e, 0xb05a5a75, 0xef838336, 0xb63333cc,
    0x5c636391, 0x12020208, 0x93aaaa92, 0xde7171d9,
    0xc6c8c807, 0xd1191964, 0x3b494939, 0x5fd9d943,
    0x31f2f2ef, 0xa8e3e3ab, 0xb95b5b71, 0xbc88881a,
    0x3e9a9a52, 0x0b262698, 0xbf3232c8, 0x59b0b0fa,
    0xf2e9e983, 0x770f0f3c, 0x33d5d573, 0xf480803a,
    0x27bebec2, 0xebcdcd13, 0x893434d0, 0x3248483d,
    0x54ffffdb, 0x8d7a7af5, 0x6490907a, 0x9d5f5f61,
    0x3d202080, 0x0f6868bd, 0xca1a1a68, 0xb7aeae82,
    0x7db4b4ea, 0xce54544d, 0x7f939376, 0x2f222288,
    0x6364648d, 0x2af1f1e3, 0xcc7373d1, 0x82121248,
    0x7a40401d, 0x48080820, 0x95c3c32b, 0xdfecec97,
    0x4ddbdb4b, 0xc0a1a1be, 0x918d8d0e, 0xc83d3df4,
    0x5b979766, 0x00000000, 0xf9cfcf1b, 0x6e2b2bac,
    0xe17676c5, 0xe6828232, 0x28d6d67f, 0xc31b1b6c,
    0x74b5b5ee, 0xbeafaf86, 0x1d6a6ab5, 0xea50505d,
    0x57454509, 0x38f3f3eb, 0xad3030c0, 0xc4efef9b,
    0xda3f3ffc, 0xc7555549, 0xdba2a2b2, 0xe9eaea8f,
    0x6a656589, 0x03babad2, 0x4a2f2fbc, 0x8ec0c027,
    0x60dede5f, 0xfc1c1c70, 0x46fdfdd3, 0x1f4d4d29,
    0x76929272, 0xfa7575c9, 0x36060618, 0xae8a8a12,
    0x4bb2b2f2, 0x85e6e6bf, 0x7e0e0e38, 0xe71f1f7c,
    0x55626295, 0x3ad4d477, 0x81a8a89a, 0x52969662,
    0x62f9f9c3, 0xa3c5c533, 0x10252594, 0xab595979,
    0xd084842a, 0xc57272d5, 0xec3939e4, 0x164c4c2d,
    0x945e5e65, 0x9f7878fd, 0xe53838e0, 0x988c8c0a,
    0x17d1d163, 0xe4a5a5ae, 0xa1e2e2af, 0x4e616199,
    0x42b3b3f6, 0x34212184, 0x089c9c4a, 0xee1e1e78,
    0x61434311, 0xb1c7c73b, 0x4ffcfcd7, 0x24040410,
    0xe3515159, 0x2599995e, 0x226d6da9, 0x650d0d34,
    0x79fafacf, 0x69dfdf5b, 0xa97e7ee5, 0x19242490,
    0xfe3b3bec, 0x9aabab96, 0xf0cece1f, 0x99111144,
    0x838f8f06, 0x044e4e25, 0x66b7b7e6, 0xe0ebeb8b,
    0xc13c3cf0, 0xfd81813e, 0x4094946a, 0x1cf7f7fb,
    0x18b9b9de, 0x8b13134c, 0x512c2cb0, 0x05d3d36b,
    0x8ce7e7bb, 0x396e6ea5, 0xaac4c437, 0x1b03030c,
    0xdc565645, 0x5e44440d, 0xa07f7fe1, 0x88a9a99e,
    0x672a2aa8, 0x0abbbbd6, 0x87c1c123, 0xf1535351,
    0x72dcdc57, 0x530b0b2c, 0x019d9d4e, 0x2b6c6cad,
    0xa43131c4, 0xf37474cd, 0x15f6f6ff, 0x4c464605,
    0xa5acac8a, 0xb589891e, 0xb4141450, 0xbae1e1a3,
    0xa6161658, 0xf73a3ae8, 0x066969b9, 0x41090924,
    0xd77070dd, 0x6fb6b6e2, 0x1ed0d067, 0xd6eded93,
    0xe2cccc17, 0x68424215, 0x2c98985a, 0xeda4a4aa,
    0x752828a0, 0x865c5c6d, 0x6bf8f8c7, 0xc2868622,
  },
  {
    0x30d81818, 0x46262323, 0x91b8c6c6, 0xcdfbe8e8,
    0x13cb8787, 0x6d11b8b8, 0x02090101, 0x9e0d4f4f,
    0x6c9b3636, 0x51ffa6a6, 0xb90cd2d2, 0xf70ef5f5,
    0xf2967979, 0xde306f6f, 0x3f6d9191, 0xa4f85252,
    0xc0476060, 0x6535bcbc, 0x2b379b9b, 0x018a8e8e,
    0x5bd2a3a3, 0x186c0c0c, 0xf6847b7b, 0x6a803535,
    0x3af51d1d, 0xddb3e0e0, 0xb321d7d7, 0x999cc2c2,
    0x5c432e2e, 0x96294b4b, 0xe15dfefe, 0xaed55757,
    0x2abd1515, 0xeee87777, 0x6e923737, 0xd79ee5e5,
    0x23139f9f, 0xfd23f0f0, 0x94204a4a, 0xa944dada,
    0xb0a25858, 0x8fcfc9c9, 0x527c2929, 0x145a0a0a,
    0x7f50b1b1, 0x5dc9a0a0, 0xd6146b6b, 0x17d98585,
    0x673cbdbd, 0xba8f5d5d, 0x20901010, 0xf507f4f4,
    0x8bddcbcb, 0x7cd33e3e, 0x0a2d0505, 0xce786767,
    0xd597e4e4, 0x4e022727, 0x82734141, 0x0ba78b8b,
    0x53f6a7a7, 0xfab27d7d, 0x37499595, 0xad56d8d8,
    0xeb70fbfb, 0xc1cdeeee, 0xf8bb7c7c, 0xcc716666,
    0xa77bdddd, 0x2eaf1717, 0x8e454747, 0x211a9e9e,
    0x89d4caca, 0x5a582d2d, 0x632ebfbf, 0x0e3f0707,
    0x47acadad, 0xb4b05a5a, 0x1bef8383, 0x66b63333,
    0xc65c6363, 0x04120202, 0x4993aaaa, 0xe2de7171,
    0x8dc6c8c8, 0x32d11919, 0x923b4949, 0xaf5fd9d9,
    0xf931f2f2, 0xdba8e3e3, 0xb6b95b5b, 0x0dbc8888,
    0x293e9a9a, 0x4c0b2626, 0x64bf3232, 0x7d59b0b0,
    0xcff2e9e9, 0x1e770f0f, 0xb733d5d5, 0x1df48080,
    0x6127bebe, 0x87ebcdcd, 0x68893434, 0x90324848,
    0xe354ffff, 0xf48d7a7a, 0x3d649090, 0xbe9d5f5f,
    0x403d2020, 0xd00f6868, 0x34ca1a1a, 0x41b7aeae,
    0x757db4b4, 0xa8ce5454, 0x3b7f9393, 0x442f2222,
    0xc8636464, 0xff2af1f1, 0xe6cc7373, 0x24821212,
    0x807a4040, 0x10480808, 0x9b95c3c3, 0xc5dfecec,
    0xab4ddbdb, 0x5fc0a1a1, 0x07918d8d, 0x7ac83d3d,
    0x335b9797, 0x00000000, 0x83f9cfcf, 0x566e2b2b,
    0xece17676, 0x19e68282, 0xb128d6d6, 0x36c31b1b,
    0x7774b5b5, 0x43beafaf, 0xd41d6a6a, 0xa0ea5050,
    0x8a574545, 0xfb38f3f3, 0x60ad3030, 0xc3c4efef,
    0x7eda3f3f, 0xaac75555, 0x59dba2a2, 0xc9e9eaea,
    0xca6a6565, 0x6903baba, 0x5e4a2f2f, 0x9d8ec0c0,
    0xa160dede, 0x38fc1c1c, 0xe746fdfd, 0x9a1f4d4d,
    0x39769292, 0xeafa7575, 0x0c360606, 0x09ae8a8a,
    0x794bb2b2, 0xd185e6e6, 0x1c7e0e0e, 0x3ee71f1f,
    0xc4556262, 0xb53ad4d4, 0x4d81a8a8, 0x31529696,
    0xef62f9f9, 0x97a3c5c5, 0x4a102525, 0xb2ab5959,
    0x15d08484, 0xe4c57272, 0x72ec3939, 0x98164c4c,
    0xbc945e5e, 0xf09f7878, 0x70e53838, 0x05988c8c,
    0xbf17d1d1, 0x57e4a5a5, 0xd9a1e2e2, 0xc24e6161,
    0x7b42b3b3, 0x42342121, 0x25089c9c, 0x3cee1e1e,
    0x86614343, 0x93b1c7c7, 0xe54ffcfc, 0x08240404,
    0xa2e35151, 0x2f259999, 0xda226d6d, 0x1a650d0d,
    0xe979fafa, 0xa369dfdf, 0xfca97e7e, 0x48192424,
    0x76fe3b3b, 0x4b9aabab, 0x81f0cece, 0x22991111,
    0x03838f8f, 0x9c044e4e, 0x7366b7b7, 0xcbe0ebeb,
    0x78c13c3c, 0x1ffd8181, 0x35409494, 0xf31cf7f7,
    0x6f18b9b9, 0x268b1313, 0x58512c2c, 0xbb05d3d3,
    0xd38ce7e7, 0xdc396e6e, 0x95aac4c4, 0x061b0303,
    0xacdc5656, 0x885e4444, 0xfea07f7f, 0x4f88a9a9,
    0x54672a2a, 0x6b0abbbb, 0x9f87c1c1, 0xa6f15353,
    0xa572dcdc, 0x16530b0b, 0x27019d9d, 0xd82b6c6c,
    0x62a43131, 0xe8f37474, 0xf115f6f6, 0x8c4c4646,
    0x45a5acac, 0x0fb58989, 0x28b41414, 0xdfbae1e1,
    0x2ca61616, 0x74f73a3a, 0xd2066969, 0x12410909,
    0xe0d77070, 0x716fb6b6, 0xbd1ed0d0, 0xc7d6eded,
    0x85e2cccc, 0x84684242, 0x2d2c9898, 0x55eda4a4,
    0x50752828, 0xb8865c5c, 0xed6bf8f8, 0x11c28686,
  },
  {
    0x7830d818, 0xaf462623, 0xf991b8c6, 0x6fcdfbe8,
    0xa113cb87, 0x626d11b8, 0x05020901, 0x6e9e0d4f,
    0xee6c9b36, 0x0451ffa6, 0xbdb90cd2, 0x06f70ef5,
    0x80f29679, 0xcede306f, 0xef3f6d91, 0x07a4f852,
    0xfdc04760, 0x766535bc, 0xcd2b379b, 0x8c018a8e,
    0x155bd2a3, 0x3c186c0c, 0x8af6847b, 0xe16a8035,
    0x693af51d, 0x47ddb3e0, 0xacb321d7, 0xed999cc2,
    0x965c432e, 0x7a96294b, 0x21e15dfe, 0x16aed557,
    0x412abd15, 0xb6eee877, 0xeb6e9237, 0x56d79ee5,
    0xd923139f, 0x17fd23f0, 0x7f94204a, 0x95a944da,
    0x25b0a258, 0xca8fcfc9, 0x8d527c29, 0x22145a0a,
    0x4f7f50b1, 0x1a5dc9a0, 0xdad6146b, 0xab17d985,
    0x73673cbd, 0x34ba8f5d, 0x50209010, 0x03f507f4,
    0xc08bddcb, 0xc67cd33e, 0x110a2d05, 0xe6ce7867,
    0x53d597e4, 0xbb4e0227, 0x58827341, 0x9d0ba78b,
    0x0153f6a7, 0x94fab27d, 0xfb374995, 0x9fad56d8,
    0x30eb70fb, 0x71c1cdee, 0x91f8bb7c, 0xe3cc7166,
    0x8ea77bdd, 0x4b2eaf17, 0x468e4547, 0xdc211a9e,
    0xc589d4ca, 0x995a582d, 0x79632ebf, 0x1b0e3f07,
    0x2347acad, 0x2fb4b05a, 0xb51bef83, 0xff66b633,
    0xf2c65c63, 0x0a041202, 0x384993aa, 0xa8e2de71,
    0xcf8dc6c8, 0x7d32d119, 0x70923b49, 0x9aaf5fd9,
    0x1df931f2, 0x48dba8e3, 0x2ab6b95b, 0x920dbc88,
    0xc8293e9a, 0xbe4c0b26, 0xfa64bf32, 0x4a7d59b0,
    0x6acff2e9, 0x331e770f, 0xa6b733d5, 0xba1df480,
    0x7c6127be, 0xde87ebcd, 0xe4688934, 0x75903248,
    0x24e354ff, 0x8ff48d7a, 0xea3d6490, 0x3ebe9d5f,
    0xa0403d20, 0xd5d00f68, 0x7234ca1a, 0x2c41b7ae,
    0x5e757db4, 0x19a8ce54, 0xe53b7f93, 0xaa442f22,
    0xe9c86364, 0x12ff2af1, 0xa2e6cc73, 0x5a248212,
    0x5d807a40, 0x28104808, 0xe89b95c3, 0x7bc5dfec,
    0x90ab4ddb, 0x1f5fc0a1, 0x8307918d, 0xc97ac83d,
    0xf1335b97, 0x00000000, 0xd483f9cf, 0x87566e2b,
    0xb3ece176, 0xb019e682, 0xa9b128d6, 0x7736c31b,
    0x5b7774b5, 0x2943beaf, 0xdfd41d6a, 0x0da0ea50,
    0x4c8a5745, 0x18fb38f3, 0xf060ad30, 0x74c3c4ef,
    0xc37eda3f, 0x1caac755, 0x1059dba2, 0x65c9e9ea,
    0xecca6a65, 0x686903ba, 0x935e4a2f, 0xe79d8ec0,
    0x81a160de, 0x6c38fc1c, 0x2ee746fd, 0x649a1f4d,
    0xe0397692, 0xbceafa75, 0x1e0c3606, 0x9809ae8a,
    0x40794bb2, 0x59d185e6, 0x361c7e0e, 0x633ee71f,
    0xf7c45562, 0xa3b53ad4, 0x324d81a8, 0xf4315296,
    0x3aef62f9, 0xf697a3c5, 0xb14a1025, 0x20b2ab59,
    0xae15d084, 0xa7e4c572, 0xdd72ec39, 0x6198164c,
    0x3bbc945e, 0x85f09f78, 0xd870e538, 0x8605988c,
    0xb2bf17d1, 0x0b57e4a5, 0x4dd9a1e2, 0xf8c24e61,
    0x457b42b3, 0xa5423421, 0xd625089c, 0x663cee1e,
    0x52866143, 0xfc93b1c7, 0x2be54ffc, 0x14082404,
    0x08a2e351, 0xc72f2599, 0xc4da226d, 0x391a650d,
    0x35e979fa, 0x84a369df, 0x9bfca97e, 0xb4481924,
    0xd776fe3b, 0x3d4b9aab, 0xd181f0ce, 0x55229911,
    0x8903838f, 0x6b9c044e, 0x517366b7, 0x60cbe0eb,
    0xcc78c13c, 0xbf1ffd81, 0xfe354094, 0x0cf31cf7,
    0x676f18b9, 0x5f268b13, 0x9c58512c, 0xb8bb05d3,
    0x5cd38ce7, 0xcbdc396e, 0xf395aac4, 0x0f061b03,
    0x13acdc56, 0x49885e44, 0x9efea07f, 0x374f88a9,
    0x8254672a, 0x6d6b0abb, 0xe29f87c1, 0x02a6f153,
    0x8ba572dc, 0x2716530b, 0xd327019d, 0xc1d82b6c,
    0xf562a431, 0xb9e8f374, 0x09f115f6, 0x438c4c46,
    0x2645a5ac, 0x970fb589, 0x4428b414, 0x42dfbae1,
    0x4e2ca616, 0xd274f73a, 0xd0d20669, 0x2d124109,
    0xade0d770, 0x54716fb6, 0xb7bd1ed0, 0x7ec7d6ed,
    0xdb85e2cc, 0x57846842, 0xc22d2c98, 0x0e55eda4,
    0x88507528, 0x31b8865c, 0x3fed6bf8, 0xa411c286,
  },
  {
    0xc07830d8, 0x05af4626, 0x7ef991b8, 0x136fcdfb,
    0x4ca113cb, 0xa9626d11, 0x08050209, 0x426e9e0d,
    0xadee6c9b, 0x590451ff, 0xdebdb90c, 0xfb06f70e,
    0xef80f296, 0x5fcede30, 0xfcef3f6d, 0xaa07a4f8,
    0x27fdc047, 0x89766535, 0xaccd2b37, 0x048c018a,
    0x71155bd2, 0x603c186c, 0xff8af684, 0xb5e16a80,
    0xe8693af5, 0x5347ddb3, 0xf6acb321, 0x5eed999c,
    0x6d965c43, 0x627a9629, 0xa321e15d, 0x8216aed5,
    0xa8412abd, 0x9fb6eee8, 0xa5eb6e92, 0x7b56d79e,
    0x8cd92313, 0xd317fd23, 0x6a7f9420, 0x9e95a944,
    0xfa25b0a2, 0x06ca8fcf, 0x558d527c, 0x5022145a,
    0xe14f7f50, 0x691a5dc9, 0x7fdad614, 0x5cab17d9,
    0x8173673c, 0xd234ba8f, 0x80502090, 0xf303f507,
    0x16c08bdd, 0xedc67cd3, 0x28110a2d, 0x1fe6ce78,
    0x7353d597, 0x25bb4e02, 0x32588273, 0x2c9d0ba7,
    0x510153f6, 0xcf94fab2, 0xdcfb3749, 0x8e9fad56,
    0x8b30eb70, 0x2371c1cd, 0xc791f8bb, 0x17e3cc71,
    0xa68ea77b, 0xb84b2eaf, 0x02468e45, 0x84dc211a,
    0x1ec589d4, 0x75995a58, 0x9179632e, 0x381b0e3f,
    0x012347ac, 0xea2fb4b0, 0x6cb51bef, 0x85ff66b6,
    0x3ff2c65c, 0x100a0412, 0x39384993, 0xafa8e2de,
    0x0ecf8dc6, 0xc87d32d1, 0x7270923b, 0x869aaf5f,
    0xc31df931, 0x4b48dba8, 0xe22ab6b9, 0x34920dbc,
    0xa4c8293e, 0x2dbe4c0b, 0x8dfa64bf, 0xe94a7d59,
    0x1b6acff2, 0x78331e77, 0xe6a6b733, 0x74ba1df4,
    0x997c6127, 0x26de87eb, 0xbde46889, 0x7a759032,
    0xab24e354, 0xf78ff48d, 0xf4ea3d64, 0xc23ebe9d,
    0x1da0403d, 0x67d5d00f, 0xd07234ca, 0x192c41b7,
    0xc95e757d, 0x9a19a8ce, 0xece53b7f, 0x0daa442f,
    0x07e9c863, 0xdb12ff2a, 0xbfa2e6cc, 0x905a2482,
    0x3a5d807a, 0x40281048, 0x56e89b95, 0x337bc5df,
    0x9690ab4d, 0x611f5fc0, 0x1c830791, 0xf5c97ac8,
    0xccf1335b, 0x00000000, 0x36d483f9, 0x4587566e,
    0x97b3ece1, 0x64b019e6, 0xfea9b128, 0xd87736c3,
    0xc15b7774, 0x112943be, 0x77dfd41d, 0xba0da0ea,
    0x124c8a57, 0xcb18fb38, 0x9df060ad, 0x2b74c3c4,
    0xe5c37eda, 0x921caac7, 0x791059db, 0x0365c9e9,
    0x0fecca6a, 0xb9686903, 0x65935e4a, 0x4ee79d8e,
    0xbe81a160, 0xe06c38fc, 0xbb2ee746, 0x52649a1f,
    0xe4e03976, 0x8fbceafa, 0x301e0c36, 0x249809ae,
    0xf940794b, 0x6359d185, 0x70361c7e, 0xf8633ee7,
    0x37f7c455, 0xeea3b53a, 0x29324d81, 0xc4f43152,
    0x9b3aef62, 0x66f697a3, 0x35b14a10, 0xf220b2ab,
    0x54ae15d0, 0xb7a7e4c5, 0xd5dd72ec, 0x5a619816,
    0xca3bbc94, 0xe785f09f, 0xddd870e5, 0x14860598,
    0xc6b2bf17, 0x410b57e4, 0x434dd9a1, 0x2ff8c24e,
    0xf1457b42, 0x15a54234, 0x94d62508, 0xf0663cee,
    0x22528661, 0x76fc93b1, 0xb32be54f, 0x20140824,
    0xb208a2e3, 0xbcc72f25, 0x4fc4da22, 0x68391a65,
    0x8335e979, 0xb684a369, 0xd79bfca9, 0x3db44819,
    0xc5d776fe, 0x313d4b9a, 0x3ed181f0, 0x88552299,
    0x0c890383, 0x4a6b9c04, 0xd1517366, 0x0b60cbe0,
    0xfdcc78c1, 0x7cbf1ffd, 0xd4fe3540, 0xeb0cf31c,
    0xa1676f18, 0x985f268b, 0x7d9c5851, 0xd6b8bb05,
    0x6b5cd38c, 0x57cbdc39, 0x6ef395aa, 0x180f061b,
    0x8a13acdc, 0x1a49885e, 0xdf9efea0, 0x21374f88,
    0x4d825467, 0xb16d6b0a, 0x46e29f87, 0xa202a6f1,
    0xae8ba572, 0x58271653, 0x9cd32701, 0x47c1d82b,
    0x95f562a4, 0x87b9e8f3, 0xe309f115, 0x0a438c4c,
    0x092645a5, 0x3c970fb5, 0xa04428b4, 0x5b42dfba,
    0xb04e2ca6, 0xcdd274f7, 0x6fd0d206, 0x482d1241,
    0xa7ade0d7, 0xd954716f, 0xceb7bd1e, 0x3b7ec7d6,
    0x2edb85e2, 0x2a578468, 0xb4c22d2c, 0x490e55ed,
    0x5d885075, 0xda31b886, 0x933fed6b, 0x44a411c2,
  },
  {
    0x18c07830, 0x2305af46, 0xc67ef991, 0xe8136fcd,
    0x874ca113, 0xb8a9626d, 0x01080502, 0x4f426e9e,
    0x36adee6c, 0xa6590451, 0xd2debdb9, 0xf5fb06f7,
    0x79ef80f2, 0x6f5fcede, 0x91fcef3f, 0x52aa07a4,
    0x6027fdc0, 0xbc897665, 0x9baccd2b, 0x8e048c01,
    0xa371155b, 0x0c603c18, 0x7bff8af6, 0x35b5e16a,
    0x1de8693a, 0xe05347dd, 0xd7f6acb3, 0xc25eed99,
    0x2e6d965c, 0x4b627a96, 0xfea321e1, 0x578216ae,
    0x15a8412a, 0x779fb6ee, 0x37a5eb6e, 0xe57b56d7,
    0x9f8cd923, 0xf0d317fd, 0x4a6a7f94, 0xda9e95a9,
    0x58fa25b0, 0xc906ca8f, 0x29558d52, 0x0a502214,
    0xb1e14f7f, 0xa0691a5d, 0x6b7fdad6, 0x855cab17,
    0xbd817367, 0x5dd234ba, 0x10805020, 0xf4f303f5,
    0xcb16c08b, 0x3eedc67c, 0x0528110a, 0x671fe6ce,
    0xe47353d5, 0x2725bb4e, 0x41325882, 0x8b2c9d0b,
    0xa7510153, 0x7dcf94fa, 0x95dcfb37, 0xd88e9fad,
    0xfb8b30eb, 0xee2371c1, 0x7cc791f8, 0x6617e3cc,
    0xdda68ea7, 0x17b84b2e, 0x4702468e, 0x9e84dc21,
    0xca1ec589, 0x2d75995a, 0xbf917963, 0x07381b0e,
    0xad012347, 0x5aea2fb4, 0x836cb51b, 0x3385ff66,
    0x633ff2c6, 0x02100a04, 0xaa393849, 0x71afa8e2,
    0xc80ecf8d, 0x19c87d32, 0x49727092, 0xd9869aaf,
    0xf2c31df9, 0xe34b48db, 0x5be22ab6, 0x8834920d,
    0x9aa4c829, 0x262dbe4c, 0x328dfa64, 0xb0e94a7d,
    0xe91b6acf, 0x0f78331e, 0xd5e6a6b7, 0x8074ba1d,
    0xbe997c61, 0xcd26de87, 0x34bde468, 0x487a7590,
    0xffab24e3, 0x7af78ff4, 0x90f4ea3d, 0x5fc23ebe,
    0x201da040, 0x6867d5d0, 0x1ad07234, 0xae192c41,
    0xb4c95e75, 0x549a19a8, 0x93ece53b, 0x220daa44,
    0x6407e9c8, 0xf1db12ff, 0x73bfa2e6, 0x12905a24,
    0x403a5d80, 0x08402810, 0xc356e89b, 0xec337bc5,
    0xdb9690ab, 0xa1611f5f, 0x8d1c8307, 0x3df5c97a,
    0x97ccf133, 0x00000000, 0xcf36d483, 0x2b458756,
    0x7697b3ec, 0x8264b019, 0xd6fea9b1, 0x1bd87736,
    0xb5c15b77, 0xaf112943, 0x6a77dfd4, 0x50ba0da0,
    0x45124c8a, 0xf3cb18fb, 0x309df060, 0xef2b74c3,
    0x3fe5c37e, 0x55921caa, 0xa2791059, 0xea0365c9,
    0x650fecca, 0xbab96869, 0x2f65935e, 0xc04ee79d,
    0xdebe81a1, 0x1ce06c38, 0xfdbb2ee7, 0x4d52649a,
    0x92e4e039, 0x758fbcea, 0x06301e0c, 0x8a249809,
    0xb2f94079, 0xe66359d1, 0x0e70361c, 0x1ff8633e,
    0x6237f7c4, 0xd4eea3b5, 0xa829324d, 0x96c4f431,
    0xf99b3aef, 0xc566f697, 0x2535b14a, 0x59f220b2,
    0x8454ae15, 0x72b7a7e4, 0x39d5dd72, 0x4c5a6198,
    0x5eca3bbc, 0x78e785f0, 0x38ddd870, 0x8c148605,
    0xd1c6b2bf, 0xa5410b57, 0xe2434dd9, 0x612ff8c2,
    0xb3f1457b, 0x2115a542, 0x9c94d625, 0x1ef0663c,
    0x43225286, 0xc776fc93, 0xfcb32be5, 0x04201408,
    0x51b208a2, 0x99bcc72f, 0x6d4fc4da, 0x0d68391a,
    0xfa8335e9, 0xdfb684a3, 0x7ed79bfc, 0x243db448,
    0x3bc5d776, 0xab313d4b, 0xce3ed181, 0x11885522,
    0x8f0c8903, 0x4e4a6b9c, 0xb7d15173, 0xeb0b60cb,
    0x3cfdcc78, 0x817cbf1f, 0x94d4fe35, 0xf7eb0cf3,
    0xb9a1676f, 0x13985f26, 0x2c7d9c58, 0xd3d6b8bb,
    0xe76b5cd3, 0x6e57cbdc, 0xc46ef395, 0x03180f06,
    0x568a13ac, 0x441a4988, 0x7fdf9efe, 0xa921374f,
    0x2a4d8254, 0xbbb16d6b, 0xc146e29f, 0x53a202a6,
    0xdcae8ba5, 0x0b582716, 0x9d9cd327, 0x6c47c1d8,
    0x3195f562, 0x7487b9e8, 0xf6e309f1, 0x460a438c,
    0xac092645, 0x893c970f, 0x14a04428, 0xe15b42df,
    0x16b04e2c, 0x3acdd274, 0x696fd0d2, 0x09482d12,
    0x70a7ade0, 0xb6d95471, 0xd0ceb7bd, 0xed3b7ec7,
    0xcc2edb85, 0x422a5784, 0x98b4c22d, 0xa4490e55,
    0x285d8850, 0x5cda31b8, 0xf8933fed, 0x8644a411,
  },
  {
    0x6018c078, 0x8c2305af, 0x3fc67ef9, 0x87e8136f,
    0x26874ca1, 0xdab8a962, 0x04010805, 0x214f426e,
    0xd836adee, 0xa2a65904, 0x6fd2debd, 0xf3f5fb06,
    0xf979ef80, 0xa16f5fce, 0x7e91fcef, 0x5552aa07,
    0x9d6027fd, 0xcabc8976, 0x569baccd, 0x028e048c,
    0xb6a37115, 0x300c603c, 0xf17bff8a, 0xd435b5e1,
    0x741de869, 0xa7e05347, 0x7bd7f6ac, 0x2fc25eed,
    0xb82e6d96, 0x314b627a, 0xdffea321, 0x41578216,
    0x5415a841, 0xc1779fb6, 0xdc37a5eb, 0xb3e57b56,
    0x469f8cd9, 0xe7f0d317, 0x354a6a7f, 0x4fda9e95,
    0x7d58fa25, 0x03c906ca, 0xa429558d, 0x280a5022,
    0xfeb1e14f, 0xbaa0691a, 0xb16b7fda, 0x2e855cab,
    0xcebd8173, 0x695dd234, 0x40108050, 0xf7f4f303,
    0x0bcb16c0, 0xf83eedc6, 0x14052811, 0x81671fe6,
    0xb7e47353, 0x9c2725bb, 0x19413258, 0x168b2c9d,
    0xa6a75101, 0xe97dcf94, 0x6e95dcfb, 0x47d88e9f,
    0xcbfb8b30, 0x9fee2371, 0xed7cc791, 0x856617e3,
    0x53dda68e, 0x5c17b84b, 0x01470246, 0x429e84dc,
    0x0fca1ec5, 0xb42d7599, 0xc6bf9179, 0x1c07381b,
    0x8ead0123, 0x755aea2f, 0x36836cb5, 0xcc3385ff,
    0x91633ff2, 0x0802100a, 0x92aa3938, 0xd971afa8,
    0x07c80ecf, 0x6419c87d, 0x39497270, 0x43d9869a,
    0xeff2c31d, 0xabe34b48, 0x715be22a, 0x1a883492,
    0x529aa4c8, 0x98262dbe, 0xc8328dfa, 0xfab0e94a,
    0x83e91b6a, 0x3c0f7833, 0x73d5e6a6, 0x3a8074ba,
    0xc2be997c, 0x13cd26de, 0xd034bde4, 0x3d487a75,
    0xdbffab24, 0xf57af78f, 0x7a90f4ea, 0x615fc23e,
    0x80201da0, 0xbd6867d5, 0x681ad072, 0x82ae192c,
    0xeab4c95e, 0x4d549a19, 0x7693ece5, 0x88220daa,
    0x8d6407e9, 0xe3f1db12, 0xd173bfa2, 0x4812905a,
    0x1d403a5d, 0x20084028, 0x2bc356e8, 0x97ec337b,
    0x4bdb9690, 0xbea1611f, 0x0e8d1c83, 0xf43df5c9,
    0x6697ccf1, 0x00000000, 0x1bcf36d4, 0xac2b4587,
    0xc57697b3, 0x328264b0, 0x7fd6fea9, 0x6c1bd877,
    0xeeb5c15b, 0x86af1129, 0xb56a77df, 0x5d50ba0d,
    0x0945124c, 0xebf3cb18, 0xc0309df0, 0x9bef2b74,
    0xfc3fe5c3, 0x4955921c, 0xb2a27910, 0x8fea0365,
    0x89650fec, 0xd2bab968, 0xbc2f6593, 0x27c04ee7,
    0x5fdebe81, 0x701ce06c, 0xd3fdbb2e, 0x294d5264,
    0x7292e4e0, 0xc9758fbc, 0x1806301e, 0x128a2498,
    0xf2b2f940, 0xbfe66359, 0x380e7036, 0x7c1ff863,
    0x956237f7, 0x77d4eea3, 0x9aa82932, 0x6296c4f4,
    0xc3f99b3a, 0x33c566f6, 0x942535b1, 0x7959f220,
    0x2a8454ae, 0xd572b7a7, 0xe439d5dd, 0x2d4c5a61,
    0x655eca3b, 0xfd78e785, 0xe038ddd8, 0x0a8c1486,
    0x63d1c6b2, 0xaea5410b, 0xafe2434d, 0x99612ff8,
    0xf6b3f145, 0x842115a5, 0x4a9c94d6, 0x781ef066,
    0x11432252, 0x3bc776fc, 0xd7fcb32b, 0x10042014,
    0x5951b208, 0x5e99bcc7, 0xa96d4fc4, 0x340d6839,
    0xcffa8335, 0x5bdfb684, 0xe57ed79b, 0x90243db4,
    0xec3bc5d7, 0x96ab313d, 0x1fce3ed1, 0x44118855,
    0x068f0c89, 0x254e4a6b, 0xe6b7d151, 0x8beb0b60,
    0xf03cfdcc, 0x3e817cbf, 0x6a94d4fe, 0xfbf7eb0c,
    0xdeb9a167, 0x4c13985f, 0xb02c7d9c, 0x6bd3d6b8,
    0xbbe76b5c, 0xa56e57cb, 0x37c46ef3, 0x0c03180f,
    0x45568a13, 0x0d441a49, 0xe17fdf9e, 0x9ea92137,
    0xa82a4d82, 0xd6bbb16d, 0x23c146e2, 0x5153a202,
    0x57dcae8b, 0x2c0b5827, 0x4e9d9cd3, 0xad6c47c1,
    0xc43195f5, 0xcd7487b9, 0xfff6e309, 0x05460a43,
    0x8aac0926, 0x1e893c97, 0x5014a044, 0xa3e15b42,
    0x5816b04e, 0xe83acdd2, 0xb9696fd0, 0x2409482d,
    0xdd70a7ad, 0xe2b6d954, 0x67d0ceb7, 0x93ed3b7e,
    0x17cc2edb, 0x15422a57, 0x5a98b4c2, 0xaaa4490e,
    0xa0285d88, 0x6d5cda31, 0xc7f8933f, 0x228644a4,
  },
  {
    0x186018c0, 0x238c2305, 0xc63fc67e, 0xe887e813,
    0x8726874c, 0xb8dab8a9, 0x01040108, 0x4f214f42,
    0x36d836ad, 0xa6a2a659, 0xd26fd2de, 0xf5f3f5fb,
    0x79f979ef, 0x6fa16f5f, 0x917e91fc, 0x525552aa,
    0x609d6027, 0xbccabc89, 0x9b569bac, 0x8e028e04,
    0xa3b6a371, 0x0c300c60, 0x7bf17bff, 0x35d435b5,
    0x1d741de8, 0xe0a7e053, 0xd77bd7f6, 0xc22fc25e,
    0x2eb82e6d, 0x4b314b62, 0xfedffea3, 0x57415782,
    0x155415a8, 0x77c1779f, 0x37dc37a5, 0xe5b3e57b,
    0x9f469f8c, 0xf0e7f0d3, 0x4a354a6a, 0xda4fda9e,
    0x587d58fa, 0xc903c906, 0x29a42955, 0x0a280a50,
    0xb1feb1e1, 0xa0baa069, 0x6bb16b7f, 0x852e855c,
    0xbdcebd81, 0x5d695dd2, 0x10401080, 0xf4f7f4f3,
    0xcb0bcb16, 0x3ef83eed, 0x05140528, 0x6781671f,
    0xe4b7e473, 0x279c2725, 0x41194132, 0x8b168b2c,
    0xa7a6a751, 0x7de97dcf, 0x956e95dc, 0xd847d88e,
    0xfbcbfb8b, 0xee9fee23, 0x7ced7cc7, 0x66856617,
    0xdd53dda6, 0x175c17b8, 0x47014702, 0x9e429e84,
    0xca0fca1e, 0x2db42d75, 0xbfc6bf91, 0x071c0738,
    0xad8ead01, 0x5a755aea, 0x8336836c, 0x33cc3385,
    0x6391633f, 0x02080210, 0xaa92aa39, 0x71d971af,
    0xc807c80e, 0x196419c8, 0x49394972, 0xd943d986,
    0xf2eff2c3, 0xe3abe34b, 0x5b715be2, 0x881a8834,
    0x9a529aa4, 0x2698262d, 0x32c8328d, 0xb0fab0e9,
    0xe983e91b, 0x0f3c0f78, 0xd573d5e6, 0x803a8074,
    0xbec2be99, 0xcd13cd26, 0x34d034bd, 0x483d487a,
    0xffdbffab, 0x7af57af7, 0x907a90f4, 0x5f615fc2,
    0x2080201d, 0x68bd6867, 0x1a681ad0, 0xae82ae19,
    0xb4eab4c9, 0x544d549a, 0x937693ec, 0x2288220d,
    0x648d6407, 0xf1e3f1db, 0x73d173bf, 0x12481290,
    0x401d403a, 0x08200840, 0xc32bc356, 0xec97ec33,
    0xdb4bdb96, 0xa1bea161, 0x8d0e8d1c, 0x3df43df5,
    0x976697cc, 0x00000000, 0xcf1bcf36, 0x2bac2b45,
    0x76c57697, 0x82328264, 0xd67fd6fe, 0x1b6c1bd8,
    0xb5eeb5c1, 0xaf86af11, 0x6ab56a77, 0x505d50ba,
    0x45094512, 0xf3ebf3cb, 0x30c0309d, 0xef9bef2b,
    0x3ffc3fe5, 0x55495592, 0xa2b2a279, 0xea8fea03,
    0x6589650f, 0xbad2bab9, 0x2fbc2f65, 0xc027c04e,
    0xde5fdebe, 0x1c701ce0, 0xfdd3fdbb, 0x4d294d52,
    0x927292e4, 0x75c9758f, 0x06180630, 0x8a128a24,
    0xb2f2b2f9, 0xe6bfe663, 0x0e380e70, 0x1f7c1ff8,
    0x62956237, 0xd477d4ee, 0xa89aa829, 0x966296c4,
    0xf9c3f99b, 0xc533c566, 0x25942535, 0x597959f2,
    0x842a8454, 0x72d572b7, 0x39e439d5, 0x4c2d4c5a,
    0x5e655eca, 0x78fd78e7, 0x38e038dd, 0x8c0a8c14,
    0xd163d1c6, 0xa5aea541, 0xe2afe243, 0x6199612f,
    0xb3f6b3f1, 0x21842115, 0x9c4a9c94, 0x1e781ef0,
    0x43114322, 0xc73bc776, 0xfcd7fcb3, 0x04100420,
    0x515951b2, 0x995e99bc, 0x6da96d4f, 0x0d340d68,
    0xfacffa83, 0xdf5bdfb6, 0x7ee57ed7, 0x2490243d,
    0x3bec3bc5, 0xab96ab31, 0xce1fce3e, 0x11441188,
    0x8f068f0c, 0x4e254e4a, 0xb7e6b7d1, 0xeb8beb0b,
    0x3cf03cfd, 0x813e817c, 0x946a94d4, 0xf7fbf7eb,
    0xb9deb9a1, 0x134c1398, 0x2cb02c7d, 0xd36bd3d6,
    0xe7bbe76b, 0x6ea56e57, 0xc437c46e, 0x030c0318,
    0x5645568a, 0x440d441a, 0x7fe17fdf, 0xa99ea921,
    0x2aa82a4d, 0xbbd6bbb1, 0xc123c146, 0x535153a2,
    0xdc57dcae, 0x0b2c0b58, 0x9d4e9d9c, 0x6cad6c47,
    0x31c43195, 0x74cd7487, 0xf6fff6e3, 0x4605460a,
    0xac8aac09, 0x891e893c, 0x145014a0, 0xe1a3e15b,
    0x165816b0, 0x3ae83acd, 0x69b9696f, 0x09240948,
    0x70dd70a7, 0xb6e2b6d9, 0xd067d0ce, 0xed93ed3b,
    0xcc17cc2e, 0x4215422a, 0x985a98b4, 0xa4aaa449,
    0x28a0285d, 0x5c6d5cda, 0xf8c7f893, 0x86228644,
  }
};

__constant u32 Cl[8][256] =
{
  {
    0xc07830d8, 0x05af4626, 0x7ef991b8, 0x136fcdfb,
    0x4ca113cb, 0xa9626d11, 0x08050209, 0x426e9e0d,
    0xadee6c9b, 0x590451ff, 0xdebdb90c, 0xfb06f70e,
    0xef80f296, 0x5fcede30, 0xfcef3f6d, 0xaa07a4f8,
    0x27fdc047, 0x89766535, 0xaccd2b37, 0x048c018a,
    0x71155bd2, 0x603c186c, 0xff8af684, 0xb5e16a80,
    0xe8693af5, 0x5347ddb3, 0xf6acb321, 0x5eed999c,
    0x6d965c43, 0x627a9629, 0xa321e15d, 0x8216aed5,
    0xa8412abd, 0x9fb6eee8, 0xa5eb6e92, 0x7b56d79e,
    0x8cd92313, 0xd317fd23, 0x6a7f9420, 0x9e95a944,
    0xfa25b0a2, 0x06ca8fcf, 0x558d527c, 0x5022145a,
    0xe14f7f50, 0x691a5dc9, 0x7fdad614, 0x5cab17d9,
    0x8173673c, 0xd234ba8f, 0x80502090, 0xf303f507,
    0x16c08bdd, 0xedc67cd3, 0x28110a2d, 0x1fe6ce78,
    0x7353d597, 0x25bb4e02, 0x32588273, 0x2c9d0ba7,
    0x510153f6, 0xcf94fab2, 0xdcfb3749, 0x8e9fad56,
    0x8b30eb70, 0x2371c1cd, 0xc791f8bb, 0x17e3cc71,
    0xa68ea77b, 0xb84b2eaf, 0x02468e45, 0x84dc211a,
    0x1ec589d4, 0x75995a58, 0x9179632e, 0x381b0e3f,
    0x012347ac, 0xea2fb4b0, 0x6cb51bef, 0x85ff66b6,
    0x3ff2c65c, 0x100a0412, 0x39384993, 0xafa8e2de,
    0x0ecf8dc6, 0xc87d32d1, 0x7270923b, 0x869aaf5f,
    0xc31df931, 0x4b48dba8, 0xe22ab6b9, 0x34920dbc,
    0xa4c8293e, 0x2dbe4c0b, 0x8dfa64bf, 0xe94a7d59,
    0x1b6acff2, 0x78331e77, 0xe6a6b733, 0x74ba1df4,
    0x997c6127, 0x26de87eb, 0xbde46889, 0x7a759032,
    0xab24e354, 0xf78ff48d, 0xf4ea3d64, 0xc23ebe9d,
    0x1da0403d, 0x67d5d00f, 0xd07234ca, 0x192c41b7,
    0xc95e757d, 0x9a19a8ce, 0xece53b7f, 0x0daa442f,
    0x07e9c863, 0xdb12ff2a, 0xbfa2e6cc, 0x905a2482,
    0x3a5d807a, 0x40281048, 0x56e89b95, 0x337bc5df,
    0x9690ab4d, 0x611f5fc0, 0x1c830791, 0xf5c97ac8,
    0xccf1335b, 0x00000000, 0x36d483f9, 0x4587566e,
    0x97b3ece1, 0x64b019e6, 0xfea9b128, 0xd87736c3,
    0xc15b7774, 0x112943be, 0x77dfd41d, 0xba0da0ea,
    0x124c8a57, 0xcb18fb38, 0x9df060ad, 0x2b74c3c4,
    0xe5c37eda, 0x921caac7, 0x791059db, 0x0365c9e9,
    0x0fecca6a, 0xb9686903, 0x65935e4a, 0x4ee79d8e,
    0xbe81a160, 0xe06c38fc, 0xbb2ee746, 0x52649a1f,
    0xe4e03976, 0x8fbceafa, 0x301e0c36, 0x249809ae,
    0xf940794b, 0x6359d185, 0x70361c7e, 0xf8633ee7,
    0x37f7c455, 0xeea3b53a, 0x29324d81, 0xc4f43152,
    0x9b3aef62, 0x66f697a3, 0x35b14a10, 0xf220b2ab,
    0x54ae15d0, 0xb7a7e4c5, 0xd5dd72ec, 0x5a619816,
    0xca3bbc94, 0xe785f09f, 0xddd870e5, 0x14860598,
    0xc6b2bf17, 0x410b57e4, 0x434dd9a1, 0x2ff8c24e,
    0xf1457b42, 0x15a54234, 0x94d62508, 0xf0663cee,
    0x22528661, 0x76fc93b1, 0xb32be54f, 0x20140824,
    0xb208a2e3, 0xbcc72f25, 0x4fc4da22, 0x68391a65,
    0x8335e979, 0xb684a369, 0xd79bfca9, 0x3db44819,
    0xc5d776fe, 0x313d4b9a, 0x3ed181f0, 0x88552299,
    0x0c890383, 0x4a6b9c04, 0xd1517366, 0x0b60cbe0,
    0xfdcc78c1, 0x7cbf1ffd, 0xd4fe3540, 0xeb0cf31c,
    0xa1676f18, 0x985f268b, 0x7d9c5851, 0xd6b8bb05,
    0x6b5cd38c, 0x57cbdc39, 0x6ef395aa, 0x180f061b,
    0x8a13acdc, 0x1a49885e, 0xdf9efea0, 0x21374f88,
    0x4d825467, 0xb16d6b0a, 0x46e29f87, 0xa202a6f1,
    0xae8ba572, 0x58271653, 0x9cd32701, 0x47c1d82b,
    0x95f562a4, 0x87b9e8f3, 0xe309f115, 0x0a438c4c,
    0x092645a5, 0x3c970fb5, 0xa04428b4, 0x5b42dfba,
    0xb04e2ca6, 0xcdd274f7, 0x6fd0d206, 0x482d1241,
    0xa7ade0d7, 0xd954716f, 0xceb7bd1e, 0x3b7ec7d6,
    0x2edb85e2, 0x2a578468, 0xb4c22d2c, 0x490e55ed,
    0x5d885075, 0xda31b886, 0x933fed6b, 0x44a411c2,
  },
  {
    0x18c07830, 0x2305af46, 0xc67ef991, 0xe8136fcd,
    0x874ca113, 0xb8a9626d, 0x01080502, 0x4f426e9e,
    0x36adee6c, 0xa6590451, 0xd2debdb9, 0xf5fb06f7,
    0x79ef80f2, 0x6f5fcede, 0x91fcef3f, 0x52aa07a4,
    0x6027fdc0, 0xbc897665, 0x9baccd2b, 0x8e048c01,
    0xa371155b, 0x0c603c18, 0x7bff8af6, 0x35b5e16a,
    0x1de8693a, 0xe05347dd, 0xd7f6acb3, 0xc25eed99,
    0x2e6d965c, 0x4b627a96, 0xfea321e1, 0x578216ae,
    0x15a8412a, 0x779fb6ee, 0x37a5eb6e, 0xe57b56d7,
    0x9f8cd923, 0xf0d317fd, 0x4a6a7f94, 0xda9e95a9,
    0x58fa25b0, 0xc906ca8f, 0x29558d52, 0x0a502214,
    0xb1e14f7f, 0xa0691a5d, 0x6b7fdad6, 0x855cab17,
    0xbd817367, 0x5dd234ba, 0x10805020, 0xf4f303f5,
    0xcb16c08b, 0x3eedc67c, 0x0528110a, 0x671fe6ce,
    0xe47353d5, 0x2725bb4e, 0x41325882, 0x8b2c9d0b,
    0xa7510153, 0x7dcf94fa, 0x95dcfb37, 0xd88e9fad,
    0xfb8b30eb, 0xee2371c1, 0x7cc791f8, 0x6617e3cc,
    0xdda68ea7, 0x17b84b2e, 0x4702468e, 0x9e84dc21,
    0xca1ec589, 0x2d75995a, 0xbf917963, 0x07381b0e,
    0xad012347, 0x5aea2fb4, 0x836cb51b, 0x3385ff66,
    0x633ff2c6, 0x02100a04, 0xaa393849, 0x71afa8e2,
    0xc80ecf8d, 0x19c87d32, 0x49727092, 0xd9869aaf,
    0xf2c31df9, 0xe34b48db, 0x5be22ab6, 0x8834920d,
    0x9aa4c829, 0x262dbe4c, 0x328dfa64, 0xb0e94a7d,
    0xe91b6acf, 0x0f78331e, 0xd5e6a6b7, 0x8074ba1d,
    0xbe997c61, 0xcd26de87, 0x34bde468, 0x487a7590,
    0xffab24e3, 0x7af78ff4, 0x90f4ea3d, 0x5fc23ebe,
    0x201da040, 0x6867d5d0, 0x1ad07234, 0xae192c41,
    0xb4c95e75, 0x549a19a8, 0x93ece53b, 0x220daa44,
    0x6407e9c8, 0xf1db12ff, 0x73bfa2e6, 0x12905a24,
    0x403a5d80, 0x08402810, 0xc356e89b, 0xec337bc5,
    0xdb9690ab, 0xa1611f5f, 0x8d1c8307, 0x3df5c97a,
    0x97ccf133, 0x00000000, 0xcf36d483, 0x2b458756,
    0x7697b3ec, 0x8264b019, 0xd6fea9b1, 0x1bd87736,
    0xb5c15b77, 0xaf112943, 0x6a77dfd4, 0x50ba0da0,
    0x45124c8a, 0xf3cb18fb, 0x309df060, 0xef2b74c3,
    0x3fe5c37e, 0x55921caa, 0xa2791059, 0xea0365c9,
    0x650fecca, 0xbab96869, 0x2f65935e, 0xc04ee79d,
    0xdebe81a1, 0x1ce06c38, 0xfdbb2ee7, 0x4d52649a,
    0x92e4e039, 0x758fbcea, 0x06301e0c, 0x8a249809,
    0xb2f94079, 0xe66359d1, 0x0e70361c, 0x1ff8633e,
    0x6237f7c4, 0xd4eea3b5, 0xa829324d, 0x96c4f431,
    0xf99b3aef, 0xc566f697, 0x2535b14a, 0x59f220b2,
    0x8454ae15, 0x72b7a7e4, 0x39d5dd72, 0x4c5a6198,
    0x5eca3bbc, 0x78e785f0, 0x38ddd870, 0x8c148605,
    0xd1c6b2bf, 0xa5410b57, 0xe2434dd9, 0x612ff8c2,
    0xb3f1457b, 0x2115a542, 0x9c94d625, 0x1ef0663c,
    0x43225286, 0xc776fc93, 0xfcb32be5, 0x04201408,
    0x51b208a2, 0x99bcc72f, 0x6d4fc4da, 0x0d68391a,
    0xfa8335e9, 0xdfb684a3, 0x7ed79bfc, 0x243db448,
    0x3bc5d776, 0xab313d4b, 0xce3ed181, 0x11885522,
    0x8f0c8903, 0x4e4a6b9c, 0xb7d15173, 0xeb0b60cb,
    0x3cfdcc78, 0x817cbf1f, 0x94d4fe35, 0xf7eb0cf3,
    0xb9a1676f, 0x13985f26, 0x2c7d9c58, 0xd3d6b8bb,
    0xe76b5cd3, 0x6e57cbdc, 0xc46ef395, 0x03180f06,
    0x568a13ac, 0x441a4988, 0x7fdf9efe, 0xa921374f,
    0x2a4d8254, 0xbbb16d6b, 0xc146e29f, 0x53a202a6,
    0xdcae8ba5, 0x0b582716, 0x9d9cd327, 0x6c47c1d8,
    0x3195f562, 0x7487b9e8, 0xf6e309f1, 0x460a438c,
    0xac092645, 0x893c970f, 0x14a04428, 0xe15b42df,
    0x16b04e2c, 0x3acdd274, 0x696fd0d2, 0x09482d12,
    0x70a7ade0, 0xb6d95471, 0xd0ceb7bd, 0xed3b7ec7,
    0xcc2edb85, 0x422a5784, 0x98b4c22d, 0xa4490e55,
    0x285d8850, 0x5cda31b8, 0xf8933fed, 0x8644a411,
  },
  {
    0x6018c078, 0x8c2305af, 0x3fc67ef9, 0x87e8136f,
    0x26874ca1, 0xdab8a962, 0x04010805, 0x214f426e,
    0xd836adee, 0xa2a65904, 0x6fd2debd, 0xf3f5fb06,
    0xf979ef80, 0xa16f5fce, 0x7e91fcef, 0x5552aa07,
    0x9d6027fd, 0xcabc8976, 0x569baccd, 0x028e048c,
    0xb6a37115, 0x300c603c, 0xf17bff8a, 0xd435b5e1,
    0x741de869, 0xa7e05347, 0x7bd7f6ac, 0x2fc25eed,
    0xb82e6d96, 0x314b627a, 0xdffea321, 0x41578216,
    0x5415a841, 0xc1779fb6, 0xdc37a5eb, 0xb3e57b56,
    0x469f8cd9, 0xe7f0d317, 0x354a6a7f, 0x4fda9e95,
    0x7d58fa25, 0x03c906ca, 0xa429558d, 0x280a5022,
    0xfeb1e14f, 0xbaa0691a, 0xb16b7fda, 0x2e855cab,
    0xcebd8173, 0x695dd234, 0x40108050, 0xf7f4f303,
    0x0bcb16c0, 0xf83eedc6, 0x14052811, 0x81671fe6,
    0xb7e47353, 0x9c2725bb, 0x19413258, 0x168b2c9d,
    0xa6a75101, 0xe97dcf94, 0x6e95dcfb, 0x47d88e9f,
    0xcbfb8b30, 0x9fee2371, 0xed7cc791, 0x856617e3,
    0x53dda68e, 0x5c17b84b, 0x01470246, 0x429e84dc,
    0x0fca1ec5, 0xb42d7599, 0xc6bf9179, 0x1c07381b,
    0x8ead0123, 0x755aea2f, 0x36836cb5, 0xcc3385ff,
    0x91633ff2, 0x0802100a, 0x92aa3938, 0xd971afa8,
    0x07c80ecf, 0x6419c87d, 0x39497270, 0x43d9869a,
    0xeff2c31d, 0xabe34b48, 0x715be22a, 0x1a883492,
    0x529aa4c8, 0x98262dbe, 0xc8328dfa, 0xfab0e94a,
    0x83e91b6a, 0x3c0f7833, 0x73d5e6a6, 0x3a8074ba,
    0xc2be997c, 0x13cd26de, 0xd034bde4, 0x3d487a75,
    0xdbffab24, 0xf57af78f, 0x7a90f4ea, 0x615fc23e,
    0x80201da0, 0xbd6867d5, 0x681ad072, 0x82ae192c,
    0xeab4c95e, 0x4d549a19, 0x7693ece5, 0x88220daa,
    0x8d6407e9, 0xe3f1db12, 0xd173bfa2, 0x4812905a,
    0x1d403a5d, 0x20084028, 0x2bc356e8, 0x97ec337b,
    0x4bdb9690, 0xbea1611f, 0x0e8d1c83, 0xf43df5c9,
    0x6697ccf1, 0x00000000, 0x1bcf36d4, 0xac2b4587,
    0xc57697b3, 0x328264b0, 0x7fd6fea9, 0x6c1bd877,
    0xeeb5c15b, 0x86af1129, 0xb56a77df, 0x5d50ba0d,
    0x0945124c, 0xebf3cb18, 0xc0309df0, 0x9bef2b74,
    0xfc3fe5c3, 0x4955921c, 0xb2a27910, 0x8fea0365,
    0x89650fec, 0xd2bab968, 0xbc2f6593, 0x27c04ee7,
    0x5fdebe81, 0x701ce06c, 0xd3fdbb2e, 0x294d5264,
    0x7292e4e0, 0xc9758fbc, 0x1806301e, 0x128a2498,
    0xf2b2f940, 0xbfe66359, 0x380e7036, 0x7c1ff863,
    0x956237f7, 0x77d4eea3, 0x9aa82932, 0x6296c4f4,
    0xc3f99b3a, 0x33c566f6, 0x942535b1, 0x7959f220,
    0x2a8454ae, 0xd572b7a7, 0xe439d5dd, 0x2d4c5a61,
    0x655eca3b, 0xfd78e785, 0xe038ddd8, 0x0a8c1486,
    0x63d1c6b2, 0xaea5410b, 0xafe2434d, 0x99612ff8,
    0xf6b3f145, 0x842115a5, 0x4a9c94d6, 0x781ef066,
    0x11432252, 0x3bc776fc, 0xd7fcb32b, 0x10042014,
    0x5951b208, 0x5e99bcc7, 0xa96d4fc4, 0x340d6839,
    0xcffa8335, 0x5bdfb684, 0xe57ed79b, 0x90243db4,
    0xec3bc5d7, 0x96ab313d, 0x1fce3ed1, 0x44118855,
    0x068f0c89, 0x254e4a6b, 0xe6b7d151, 0x8beb0b60,
    0xf03cfdcc, 0x3e817cbf, 0x6a94d4fe, 0xfbf7eb0c,
    0xdeb9a167, 0x4c13985f, 0xb02c7d9c, 0x6bd3d6b8,
    0xbbe76b5c, 0xa56e57cb, 0x37c46ef3, 0x0c03180f,
    0x45568a13, 0x0d441a49, 0xe17fdf9e, 0x9ea92137,
    0xa82a4d82, 0xd6bbb16d, 0x23c146e2, 0x5153a202,
    0x57dcae8b, 0x2c0b5827, 0x4e9d9cd3, 0xad6c47c1,
    0xc43195f5, 0xcd7487b9, 0xfff6e309, 0x05460a43,
    0x8aac0926, 0x1e893c97, 0x5014a044, 0xa3e15b42,
    0x5816b04e, 0xe83acdd2, 0xb9696fd0, 0x2409482d,
    0xdd70a7ad, 0xe2b6d954, 0x67d0ceb7, 0x93ed3b7e,
    0x17cc2edb, 0x15422a57, 0x5a98b4c2, 0xaaa4490e,
    0xa0285d88, 0x6d5cda31, 0xc7f8933f, 0x228644a4,
  },
  {
    0x186018c0, 0x238c2305, 0xc63fc67e, 0xe887e813,
    0x8726874c, 0xb8dab8a9, 0x01040108, 0x4f214f42,
    0x36d836ad, 0xa6a2a659, 0xd26fd2de, 0xf5f3f5fb,
    0x79f979ef, 0x6fa16f5f, 0x917e91fc, 0x525552aa,
    0x609d6027, 0xbccabc89, 0x9b569bac, 0x8e028e04,
    0xa3b6a371, 0x0c300c60, 0x7bf17bff, 0x35d435b5,
    0x1d741de8, 0xe0a7e053, 0xd77bd7f6, 0xc22fc25e,
    0x2eb82e6d, 0x4b314b62, 0xfedffea3, 0x57415782,
    0x155415a8, 0x77c1779f, 0x37dc37a5, 0xe5b3e57b,
    0x9f469f8c, 0xf0e7f0d3, 0x4a354a6a, 0xda4fda9e,
    0x587d58fa, 0xc903c906, 0x29a42955, 0x0a280a50,
    0xb1feb1e1, 0xa0baa069, 0x6bb16b7f, 0x852e855c,
    0xbdcebd81, 0x5d695dd2, 0x10401080, 0xf4f7f4f3,
    0xcb0bcb16, 0x3ef83eed, 0x05140528, 0x6781671f,
    0xe4b7e473, 0x279c2725, 0x41194132, 0x8b168b2c,
    0xa7a6a751, 0x7de97dcf, 0x956e95dc, 0xd847d88e,
    0xfbcbfb8b, 0xee9fee23, 0x7ced7cc7, 0x66856617,
    0xdd53dda6, 0x175c17b8, 0x47014702, 0x9e429e84,
    0xca0fca1e, 0x2db42d75, 0xbfc6bf91, 0x071c0738,
    0xad8ead01, 0x5a755aea, 0x8336836c, 0x33cc3385,
    0x6391633f, 0x02080210, 0xaa92aa39, 0x71d971af,
    0xc807c80e, 0x196419c8, 0x49394972, 0xd943d986,
    0xf2eff2c3, 0xe3abe34b, 0x5b715be2, 0x881a8834,
    0x9a529aa4, 0x2698262d, 0x32c8328d, 0xb0fab0e9,
    0xe983e91b, 0x0f3c0f78, 0xd573d5e6, 0x803a8074,
    0xbec2be99, 0xcd13cd26, 0x34d034bd, 0x483d487a,
    0xffdbffab, 0x7af57af7, 0x907a90f4, 0x5f615fc2,
    0x2080201d, 0x68bd6867, 0x1a681ad0, 0xae82ae19,
    0xb4eab4c9, 0x544d549a, 0x937693ec, 0x2288220d,
    0x648d6407, 0xf1e3f1db, 0x73d173bf, 0x12481290,
    0x401d403a, 0x08200840, 0xc32bc356, 0xec97ec33,
    0xdb4bdb96, 0xa1bea161, 0x8d0e8d1c, 0x3df43df5,
    0x976697cc, 0x00000000, 0xcf1bcf36, 0x2bac2b45,
    0x76c57697, 0x82328264, 0xd67fd6fe, 0x1b6c1bd8,
    0xb5eeb5c1, 0xaf86af11, 0x6ab56a77, 0x505d50ba,
    0x45094512, 0xf3ebf3cb, 0x30c0309d, 0xef9bef2b,
    0x3ffc3fe5, 0x55495592, 0xa2b2a279, 0xea8fea03,
    0x6589650f, 0xbad2bab9, 0x2fbc2f65, 0xc027c04e,
    0xde5fdebe, 0x1c701ce0, 0xfdd3fdbb, 0x4d294d52,
    0x927292e4, 0x75c9758f, 0x06180630, 0x8a128a24,
    0xb2f2b2f9, 0xe6bfe663, 0x0e380e70, 0x1f7c1ff8,
    0x62956237, 0xd477d4ee, 0xa89aa829, 0x966296c4,
    0xf9c3f99b, 0xc533c566, 0x25942535, 0x597959f2,
    0x842a8454, 0x72d572b7, 0x39e439d5, 0x4c2d4c5a,
    0x5e655eca, 0x78fd78e7, 0x38e038dd, 0x8c0a8c14,
    0xd163d1c6, 0xa5aea541, 0xe2afe243, 0x6199612f,
    0xb3f6b3f1, 0x21842115, 0x9c4a9c94, 0x1e781ef0,
    0x43114322, 0xc73bc776, 0xfcd7fcb3, 0x04100420,
    0x515951b2, 0x995e99bc, 0x6da96d4f, 0x0d340d68,
    0xfacffa83, 0xdf5bdfb6, 0x7ee57ed7, 0x2490243d,
    0x3bec3bc5, 0xab96ab31, 0xce1fce3e, 0x11441188,
    0x8f068f0c, 0x4e254e4a, 0xb7e6b7d1, 0xeb8beb0b,
    0x3cf03cfd, 0x813e817c, 0x946a94d4, 0xf7fbf7eb,
    0xb9deb9a1, 0x134c1398, 0x2cb02c7d, 0xd36bd3d6,
    0xe7bbe76b, 0x6ea56e57, 0xc437c46e, 0x030c0318,
    0x5645568a, 0x440d441a, 0x7fe17fdf, 0xa99ea921,
    0x2aa82a4d, 0xbbd6bbb1, 0xc123c146, 0x535153a2,
    0xdc57dcae, 0x0b2c0b58, 0x9d4e9d9c, 0x6cad6c47,
    0x31c43195, 0x74cd7487, 0xf6fff6e3, 0x4605460a,
    0xac8aac09, 0x891e893c, 0x145014a0, 0xe1a3e15b,
    0x165816b0, 0x3ae83acd, 0x69b9696f, 0x09240948,
    0x70dd70a7, 0xb6e2b6d9, 0xd067d0ce, 0xed93ed3b,
    0xcc17cc2e, 0x4215422a, 0x985a98b4, 0xa4aaa449,
    0x28a0285d, 0x5c6d5cda, 0xf8c7f893, 0x86228644,
  },
  {
    0x18186018, 0x23238c23, 0xc6c63fc6, 0xe8e887e8,
    0x87872687, 0xb8b8dab8, 0x01010401, 0x4f4f214f,
    0x3636d836, 0xa6a6a2a6, 0xd2d26fd2, 0xf5f5f3f5,
    0x7979f979, 0x6f6fa16f, 0x91917e91, 0x52525552,
    0x60609d60, 0xbcbccabc, 0x9b9b569b, 0x8e8e028e,
    0xa3a3b6a3, 0x0c0c300c, 0x7b7bf17b, 0x3535d435,
    0x1d1d741d, 0xe0e0a7e0, 0xd7d77bd7, 0xc2c22fc2,
    0x2e2eb82e, 0x4b4b314b, 0xfefedffe, 0x57574157,
    0x15155415, 0x7777c177, 0x3737dc37, 0xe5e5b3e5,
    0x9f9f469f, 0xf0f0e7f0, 0x4a4a354a, 0xdada4fda,
    0x58587d58, 0xc9c903c9, 0x2929a429, 0x0a0a280a,
    0xb1b1feb1, 0xa0a0baa0, 0x6b6bb16b, 0x85852e85,
    0xbdbdcebd, 0x5d5d695d, 0x10104010, 0xf4f4f7f4,
    0xcbcb0bcb, 0x3e3ef83e, 0x05051405, 0x67678167,
    0xe4e4b7e4, 0x27279c27, 0x41411941, 0x8b8b168b,
    0xa7a7a6a7, 0x7d7de97d, 0x95956e95, 0xd8d847d8,
    0xfbfbcbfb, 0xeeee9fee, 0x7c7ced7c, 0x66668566,
    0xdddd53dd, 0x17175c17, 0x47470147, 0x9e9e429e,
    0xcaca0fca, 0x2d2db42d, 0xbfbfc6bf, 0x07071c07,
    0xadad8ead, 0x5a5a755a, 0x83833683, 0x3333cc33,
    0x63639163, 0x02020802, 0xaaaa92aa, 0x7171d971,
    0xc8c807c8, 0x19196419, 0x49493949, 0xd9d943d9,
    0xf2f2eff2, 0xe3e3abe3, 0x5b5b715b, 0x88881a88,
    0x9a9a529a, 0x26269826, 0x3232c832, 0xb0b0fab0,
    0xe9e983e9, 0x0f0f3c0f, 0xd5d573d5, 0x80803a80,
    0xbebec2be, 0xcdcd13cd, 0x3434d034, 0x48483d48,
    0xffffdbff, 0x7a7af57a, 0x90907a90, 0x5f5f615f,
    0x20208020, 0x6868bd68, 0x1a1a681a, 0xaeae82ae,
    0xb4b4eab4, 0x54544d54, 0x93937693, 0x22228822,
    0x64648d64, 0xf1f1e3f1, 0x7373d173, 0x12124812,
    0x40401d40, 0x08082008, 0xc3c32bc3, 0xecec97ec,
    0xdbdb4bdb, 0xa1a1bea1, 0x8d8d0e8d, 0x3d3df43d,
    0x97976697, 0x00000000, 0xcfcf1bcf, 0x2b2bac2b,
    0x7676c576, 0x82823282, 0xd6d67fd6, 0x1b1b6c1b,
    0xb5b5eeb5, 0xafaf86af, 0x6a6ab56a, 0x50505d50,
    0x45450945, 0xf3f3ebf3, 0x3030c030, 0xefef9bef,
    0x3f3ffc3f, 0x55554955, 0xa2a2b2a2, 0xeaea8fea,
    0x65658965, 0xbabad2ba, 0x2f2fbc2f, 0xc0c027c0,
    0xdede5fde, 0x1c1c701c, 0xfdfdd3fd, 0x4d4d294d,
    0x92927292, 0x7575c975, 0x06061806, 0x8a8a128a,
    0xb2b2f2b2, 0xe6e6bfe6, 0x0e0e380e, 0x1f1f7c1f,
    0x62629562, 0xd4d477d4, 0xa8a89aa8, 0x96966296,
    0xf9f9c3f9, 0xc5c533c5, 0x25259425, 0x59597959,
    0x84842a84, 0x7272d572, 0x3939e439, 0x4c4c2d4c,
    0x5e5e655e, 0x7878fd78, 0x3838e038, 0x8c8c0a8c,
    0xd1d163d1, 0xa5a5aea5, 0xe2e2afe2, 0x61619961,
    0xb3b3f6b3, 0x21218421, 0x9c9c4a9c, 0x1e1e781e,
    0x43431143, 0xc7c73bc7, 0xfcfcd7fc, 0x04041004,
    0x51515951, 0x99995e99, 0x6d6da96d, 0x0d0d340d,
    0xfafacffa, 0xdfdf5bdf, 0x7e7ee57e, 0x24249024,
    0x3b3bec3b, 0xabab96ab, 0xcece1fce, 0x11114411,
    0x8f8f068f, 0x4e4e254e, 0xb7b7e6b7, 0xebeb8beb,
    0x3c3cf03c, 0x81813e81, 0x94946a94, 0xf7f7fbf7,
    0xb9b9deb9, 0x13134c13, 0x2c2cb02c, 0xd3d36bd3,
    0xe7e7bbe7, 0x6e6ea56e, 0xc4c437c4, 0x03030c03,
    0x56564556, 0x44440d44, 0x7f7fe17f, 0xa9a99ea9,
    0x2a2aa82a, 0xbbbbd6bb, 0xc1c123c1, 0x53535153,
    0xdcdc57dc, 0x0b0b2c0b, 0x9d9d4e9d, 0x6c6cad6c,
    0x3131c431, 0x7474cd74, 0xf6f6fff6, 0x46460546,
    0xacac8aac, 0x89891e89, 0x14145014, 0xe1e1a3e1,
    0x16165816, 0x3a3ae83a, 0x6969b969, 0x09092409,
    0x7070dd70, 0xb6b6e2b6, 0xd0d067d0, 0xeded93ed,
    0xcccc17cc, 0x42421542, 0x98985a98, 0xa4a4aaa4,
    0x2828a028, 0x5c5c6d5c, 0xf8f8c7f8, 0x86862286,
  },
  {
    0xd8181860, 0x2623238c, 0xb8c6c63f, 0xfbe8e887,
    0xcb878726, 0x11b8b8da, 0x09010104, 0x0d4f4f21,
    0x9b3636d8, 0xffa6a6a2, 0x0cd2d26f, 0x0ef5f5f3,
    0x967979f9, 0x306f6fa1, 0x6d91917e, 0xf8525255,
    0x4760609d, 0x35bcbcca, 0x379b9b56, 0x8a8e8e02,
    0xd2a3a3b6, 0x6c0c0c30, 0x847b7bf1, 0x803535d4,
    0xf51d1d74, 0xb3e0e0a7, 0x21d7d77b, 0x9cc2c22f,
    0x432e2eb8, 0x294b4b31, 0x5dfefedf, 0xd5575741,
    0xbd151554, 0xe87777c1, 0x923737dc, 0x9ee5e5b3,
    0x139f9f46, 0x23f0f0e7, 0x204a4a35, 0x44dada4f,
    0xa258587d, 0xcfc9c903, 0x7c2929a4, 0x5a0a0a28,
    0x50b1b1fe, 0xc9a0a0ba, 0x146b6bb1, 0xd985852e,
    0x3cbdbdce, 0x8f5d5d69, 0x90101040, 0x07f4f4f7,
    0xddcbcb0b, 0xd33e3ef8, 0x2d050514, 0x78676781,
    0x97e4e4b7, 0x0227279c, 0x73414119, 0xa78b8b16,
    0xf6a7a7a6, 0xb27d7de9, 0x4995956e, 0x56d8d847,
    0x70fbfbcb, 0xcdeeee9f, 0xbb7c7ced, 0x71666685,
    0x7bdddd53, 0xaf17175c, 0x45474701, 0x1a9e9e42,
    0xd4caca0f, 0x582d2db4, 0x2ebfbfc6, 0x3f07071c,
    0xacadad8e, 0xb05a5a75, 0xef838336, 0xb63333cc,
    0x5c636391, 0x12020208, 0x93aaaa92, 0xde7171d9,
    0xc6c8c807, 0xd1191964, 0x3b494939, 0x5fd9d943,
    0x31f2f2ef, 0xa8e3e3ab, 0xb95b5b71, 0xbc88881a,
    0x3e9a9a52, 0x0b262698, 0xbf3232c8, 0x59b0b0fa,
    0xf2e9e983, 0x770f0f3c, 0x33d5d573, 0xf480803a,
    0x27bebec2, 0xebcdcd13, 0x893434d0, 0x3248483d,
    0x54ffffdb, 0x8d7a7af5, 0x6490907a, 0x9d5f5f61,
    0x3d202080, 0x0f6868bd, 0xca1a1a68, 0xb7aeae82,
    0x7db4b4ea, 0xce54544d, 0x7f939376, 0x2f222288,
    0x6364648d, 0x2af1f1e3, 0xcc7373d1, 0x82121248,
    0x7a40401d, 0x48080820, 0x95c3c32b, 0xdfecec97,
    0x4ddbdb4b, 0xc0a1a1be, 0x918d8d0e, 0xc83d3df4,
    0x5b979766, 0x00000000, 0xf9cfcf1b, 0x6e2b2bac,
    0xe17676c5, 0xe6828232, 0x28d6d67f, 0xc31b1b6c,
    0x74b5b5ee, 0xbeafaf86, 0x1d6a6ab5, 0xea50505d,
    0x57454509, 0x38f3f3eb, 0xad3030c0, 0xc4efef9b,
    0xda3f3ffc, 0xc7555549, 0xdba2a2b2, 0xe9eaea8f,
    0x6a656589, 0x03babad2, 0x4a2f2fbc, 0x8ec0c027,
    0x60dede5f, 0xfc1c1c70, 0x46fdfdd3, 0x1f4d4d29,
    0x76929272, 0xfa7575c9, 0x36060618, 0xae8a8a12,
    0x4bb2b2f2, 0x85e6e6bf, 0x7e0e0e38, 0xe71f1f7c,
    0x55626295, 0x3ad4d477, 0x81a8a89a, 0x52969662,
    0x62f9f9c3, 0xa3c5c533, 0x10252594, 0xab595979,
    0xd084842a, 0xc57272d5, 0xec3939e4, 0x164c4c2d,
    0x945e5e65, 0x9f7878fd, 0xe53838e0, 0x988c8c0a,
    0x17d1d163, 0xe4a5a5ae, 0xa1e2e2af, 0x4e616199,
    0x42b3b3f6, 0x34212184, 0x089c9c4a, 0xee1e1e78,
    0x61434311, 0xb1c7c73b, 0x4ffcfcd7, 0x24040410,
    0xe3515159, 0x2599995e, 0x226d6da9, 0x650d0d34,
    0x79fafacf, 0x69dfdf5b, 0xa97e7ee5, 0x19242490,
    0xfe3b3bec, 0x9aabab96, 0xf0cece1f, 0x99111144,
    0x838f8f06, 0x044e4e25, 0x66b7b7e6, 0xe0ebeb8b,
    0xc13c3cf0, 0xfd81813e, 0x4094946a, 0x1cf7f7fb,
    0x18b9b9de, 0x8b13134c, 0x512c2cb0, 0x05d3d36b,
    0x8ce7e7bb, 0x396e6ea5, 0xaac4c437, 0x1b03030c,
    0xdc565645, 0x5e44440d, 0xa07f7fe1, 0x88a9a99e,
    0x672a2aa8, 0x0abbbbd6, 0x87c1c123, 0xf1535351,
    0x72dcdc57, 0x530b0b2c, 0x019d9d4e, 0x2b6c6cad,
    0xa43131c4, 0xf37474cd, 0x15f6f6ff, 0x4c464605,
    0xa5acac8a, 0xb589891e, 0xb4141450, 0xbae1e1a3,
    0xa6161658, 0xf73a3ae8, 0x066969b9, 0x41090924,
    0xd77070dd, 0x6fb6b6e2, 0x1ed0d067, 0xd6eded93,
    0xe2cccc17, 0x68424215, 0x2c98985a, 0xeda4a4aa,
    0x752828a0, 0x865c5c6d, 0x6bf8f8c7, 0xc2868622,
  },
  {
    0x30d81818, 0x46262323, 0x91b8c6c6, 0xcdfbe8e8,
    0x13cb8787, 0x6d11b8b8, 0x02090101, 0x9e0d4f4f,
    0x6c9b3636, 0x51ffa6a6, 0xb90cd2d2, 0xf70ef5f5,
    0xf2967979, 0xde306f6f, 0x3f6d9191, 0xa4f85252,
    0xc0476060, 0x6535bcbc, 0x2b379b9b, 0x018a8e8e,
    0x5bd2a3a3, 0x186c0c0c, 0xf6847b7b, 0x6a803535,
    0x3af51d1d, 0xddb3e0e0, 0xb321d7d7, 0x999cc2c2,
    0x5c432e2e, 0x96294b4b, 0xe15dfefe, 0xaed55757,
    0x2abd1515, 0xeee87777, 0x6e923737, 0xd79ee5e5,
    0x23139f9f, 0xfd23f0f0, 0x94204a4a, 0xa944dada,
    0xb0a25858, 0x8fcfc9c9, 0x527c2929, 0x145a0a0a,
    0x7f50b1b1, 0x5dc9a0a0, 0xd6146b6b, 0x17d98585,
    0x673cbdbd, 0xba8f5d5d, 0x20901010, 0xf507f4f4,
    0x8bddcbcb, 0x7cd33e3e, 0x0a2d0505, 0xce786767,
    0xd597e4e4, 0x4e022727, 0x82734141, 0x0ba78b8b,
    0x53f6a7a7, 0xfab27d7d, 0x37499595, 0xad56d8d8,
    0xeb70fbfb, 0xc1cdeeee, 0xf8bb7c7c, 0xcc716666,
    0xa77bdddd, 0x2eaf1717, 0x8e454747, 0x211a9e9e,
    0x89d4caca, 0x5a582d2d, 0x632ebfbf, 0x0e3f0707,
    0x47acadad, 0xb4b05a5a, 0x1bef8383, 0x66b63333,
    0xc65c6363, 0x04120202, 0x4993aaaa, 0xe2de7171,
    0x8dc6c8c8, 0x32d11919, 0x923b4949, 0xaf5fd9d9,
    0xf931f2f2, 0xdba8e3e3, 0xb6b95b5b, 0x0dbc8888,
    0x293e9a9a, 0x4c0b2626, 0x64bf3232, 0x7d59b0b0,
    0xcff2e9e9, 0x1e770f0f, 0xb733d5d5, 0x1df48080,
    0x6127bebe, 0x87ebcdcd, 0x68893434, 0x90324848,
    0xe354ffff, 0xf48d7a7a, 0x3d649090, 0xbe9d5f5f,
    0x403d2020, 0xd00f6868, 0x34ca1a1a, 0x41b7aeae,
    0x757db4b4, 0xa8ce5454, 0x3b7f9393, 0x442f2222,
    0xc8636464, 0xff2af1f1, 0xe6cc7373, 0x24821212,
    0x807a4040, 0x10480808, 0x9b95c3c3, 0xc5dfecec,
    0xab4ddbdb, 0x5fc0a1a1, 0x07918d8d, 0x7ac83d3d,
    0x335b9797, 0x00000000, 0x83f9cfcf, 0x566e2b2b,
    0xece17676, 0x19e68282, 0xb128d6d6, 0x36c31b1b,
    0x7774b5b5, 0x43beafaf, 0xd41d6a6a, 0xa0ea5050,
    0x8a574545, 0xfb38f3f3, 0x60ad3030, 0xc3c4efef,
    0x7eda3f3f, 0xaac75555, 0x59dba2a2, 0xc9e9eaea,
    0xca6a6565, 0x6903baba, 0x5e4a2f2f, 0x9d8ec0c0,
    0xa160dede, 0x38fc1c1c, 0xe746fdfd, 0x9a1f4d4d,
    0x39769292, 0xeafa7575, 0x0c360606, 0x09ae8a8a,
    0x794bb2b2, 0xd185e6e6, 0x1c7e0e0e, 0x3ee71f1f,
    0xc4556262, 0xb53ad4d4, 0x4d81a8a8, 0x31529696,
    0xef62f9f9, 0x97a3c5c5, 0x4a102525, 0xb2ab5959,
    0x15d08484, 0xe4c57272, 0x72ec3939, 0x98164c4c,
    0xbc945e5e, 0xf09f7878, 0x70e53838, 0x05988c8c,
    0xbf17d1d1, 0x57e4a5a5, 0xd9a1e2e2, 0xc24e6161,
    0x7b42b3b3, 0x42342121, 0x25089c9c, 0x3cee1e1e,
    0x86614343, 0x93b1c7c7, 0xe54ffcfc, 0x08240404,
    0xa2e35151, 0x2f259999, 0xda226d6d, 0x1a650d0d,
    0xe979fafa, 0xa369dfdf, 0xfca97e7e, 0x48192424,
    0x76fe3b3b, 0x4b9aabab, 0x81f0cece, 0x22991111,
    0x03838f8f, 0x9c044e4e, 0x7366b7b7, 0xcbe0ebeb,
    0x78c13c3c, 0x1ffd8181, 0x35409494, 0xf31cf7f7,
    0x6f18b9b9, 0x268b1313, 0x58512c2c, 0xbb05d3d3,
    0xd38ce7e7, 0xdc396e6e, 0x95aac4c4, 0x061b0303,
    0xacdc5656, 0x885e4444, 0xfea07f7f, 0x4f88a9a9,
    0x54672a2a, 0x6b0abbbb, 0x9f87c1c1, 0xa6f15353,
    0xa572dcdc, 0x16530b0b, 0x27019d9d, 0xd82b6c6c,
    0x62a43131, 0xe8f37474, 0xf115f6f6, 0x8c4c4646,
    0x45a5acac, 0x0fb58989, 0x28b41414, 0xdfbae1e1,
    0x2ca61616, 0x74f73a3a, 0xd2066969, 0x12410909,
    0xe0d77070, 0x716fb6b6, 0xbd1ed0d0, 0xc7d6eded,
    0x85e2cccc, 0x84684242, 0x2d2c9898, 0x55eda4a4,
    0x50752828, 0xb8865c5c, 0xed6bf8f8, 0x11c28686,
  },
  {
    0x7830d818, 0xaf462623, 0xf991b8c6, 0x6fcdfbe8,
    0xa113cb87, 0x626d11b8, 0x05020901, 0x6e9e0d4f,
    0xee6c9b36, 0x0451ffa6, 0xbdb90cd2, 0x06f70ef5,
    0x80f29679, 0xcede306f, 0xef3f6d91, 0x07a4f852,
    0xfdc04760, 0x766535bc, 0xcd2b379b, 0x8c018a8e,
    0x155bd2a3, 0x3c186c0c, 0x8af6847b, 0xe16a8035,
    0x693af51d, 0x47ddb3e0, 0xacb321d7, 0xed999cc2,
    0x965c432e, 0x7a96294b, 0x21e15dfe, 0x16aed557,
    0x412abd15, 0xb6eee877, 0xeb6e9237, 0x56d79ee5,
    0xd923139f, 0x17fd23f0, 0x7f94204a, 0x95a944da,
    0x25b0a258, 0xca8fcfc9, 0x8d527c29, 0x22145a0a,
    0x4f7f50b1, 0x1a5dc9a0, 0xdad6146b, 0xab17d985,
    0x73673cbd, 0x34ba8f5d, 0x50209010, 0x03f507f4,
    0xc08bddcb, 0xc67cd33e, 0x110a2d05, 0xe6ce7867,
    0x53d597e4, 0xbb4e0227, 0x58827341, 0x9d0ba78b,
    0x0153f6a7, 0x94fab27d, 0xfb374995, 0x9fad56d8,
    0x30eb70fb, 0x71c1cdee, 0x91f8bb7c, 0xe3cc7166,
    0x8ea77bdd, 0x4b2eaf17, 0x468e4547, 0xdc211a9e,
    0xc589d4ca, 0x995a582d, 0x79632ebf, 0x1b0e3f07,
    0x2347acad, 0x2fb4b05a, 0xb51bef83, 0xff66b633,
    0xf2c65c63, 0x0a041202, 0x384993aa, 0xa8e2de71,
    0xcf8dc6c8, 0x7d32d119, 0x70923b49, 0x9aaf5fd9,
    0x1df931f2, 0x48dba8e3, 0x2ab6b95b, 0x920dbc88,
    0xc8293e9a, 0xbe4c0b26, 0xfa64bf32, 0x4a7d59b0,
    0x6acff2e9, 0x331e770f, 0xa6b733d5, 0xba1df480,
    0x7c6127be, 0xde87ebcd, 0xe4688934, 0x75903248,
    0x24e354ff, 0x8ff48d7a, 0xea3d6490, 0x3ebe9d5f,
    0xa0403d20, 0xd5d00f68, 0x7234ca1a, 0x2c41b7ae,
    0x5e757db4, 0x19a8ce54, 0xe53b7f93, 0xaa442f22,
    0xe9c86364, 0x12ff2af1, 0xa2e6cc73, 0x5a248212,
    0x5d807a40, 0x28104808, 0xe89b95c3, 0x7bc5dfec,
    0x90ab4ddb, 0x1f5fc0a1, 0x8307918d, 0xc97ac83d,
    0xf1335b97, 0x00000000, 0xd483f9cf, 0x87566e2b,
    0xb3ece176, 0xb019e682, 0xa9b128d6, 0x7736c31b,
    0x5b7774b5, 0x2943beaf, 0xdfd41d6a, 0x0da0ea50,
    0x4c8a5745, 0x18fb38f3, 0xf060ad30, 0x74c3c4ef,
    0xc37eda3f, 0x1caac755, 0x1059dba2, 0x65c9e9ea,
    0xecca6a65, 0x686903ba, 0x935e4a2f, 0xe79d8ec0,
    0x81a160de, 0x6c38fc1c, 0x2ee746fd, 0x649a1f4d,
    0xe0397692, 0xbceafa75, 0x1e0c3606, 0x9809ae8a,
    0x40794bb2, 0x59d185e6, 0x361c7e0e, 0x633ee71f,
    0xf7c45562, 0xa3b53ad4, 0x324d81a8, 0xf4315296,
    0x3aef62f9, 0xf697a3c5, 0xb14a1025, 0x20b2ab59,
    0xae15d084, 0xa7e4c572, 0xdd72ec39, 0x6198164c,
    0x3bbc945e, 0x85f09f78, 0xd870e538, 0x8605988c,
    0xb2bf17d1, 0x0b57e4a5, 0x4dd9a1e2, 0xf8c24e61,
    0x457b42b3, 0xa5423421, 0xd625089c, 0x663cee1e,
    0x52866143, 0xfc93b1c7, 0x2be54ffc, 0x14082404,
    0x08a2e351, 0xc72f2599, 0xc4da226d, 0x391a650d,
    0x35e979fa, 0x84a369df, 0x9bfca97e, 0xb4481924,
    0xd776fe3b, 0x3d4b9aab, 0xd181f0ce, 0x55229911,
    0x8903838f, 0x6b9c044e, 0x517366b7, 0x60cbe0eb,
    0xcc78c13c, 0xbf1ffd81, 0xfe354094, 0x0cf31cf7,
    0x676f18b9, 0x5f268b13, 0x9c58512c, 0xb8bb05d3,
    0x5cd38ce7, 0xcbdc396e, 0xf395aac4, 0x0f061b03,
    0x13acdc56, 0x49885e44, 0x9efea07f, 0x374f88a9,
    0x8254672a, 0x6d6b0abb, 0xe29f87c1, 0x02a6f153,
    0x8ba572dc, 0x2716530b, 0xd327019d, 0xc1d82b6c,
    0xf562a431, 0xb9e8f374, 0x09f115f6, 0x438c4c46,
    0x2645a5ac, 0x970fb589, 0x4428b414, 0x42dfbae1,
    0x4e2ca616, 0xd274f73a, 0xd0d20669, 0x2d124109,
    0xade0d770, 0x54716fb6, 0xb7bd1ed0, 0x7ec7d6ed,
    0xdb85e2cc, 0x57846842, 0xc22d2c98, 0x0e55eda4,
    0x88507528, 0x31b8865c, 0x3fed6bf8, 0xa411c286,
  },
};

#define BOX(S,n,i) (S)[(n)][(i)]

void whirlpool_transform (const u32 w[16], u32 dgst[16], __local u32 (*s_Ch)[256], __local u32 (*s_Cl)[256])
{
  const u32 rch[R + 1] =
  {
    0x00000000,
    0x1823c6e8,
    0x36a6d2f5,
    0x60bc9b8e,
    0x1de0d7c2,
    0x157737e5,
    0x58c9290a,
    0xbd5d10f4,
    0xe427418b,
    0xfbee7c66,
    0xca2dbf07,
  };

  const u32 rcl[R + 1] =
  {
    0x00000000,
    0x87b8014f,
    0x796f9152,
    0xa30c7b35,
    0x2e4bfe57,
    0x9ff04ada,
    0xb1a06b85,
    0xcb3e0567,
    0xa77d95d8,
    0xdd17479e,
    0xad5a8333,
  };

  u32 Kh[8];
  u32 Kl[8];

  Kh[0] = dgst[ 0];
  Kl[0] = dgst[ 1];
  Kh[1] = dgst[ 2];
  Kl[1] = dgst[ 3];
  Kh[2] = dgst[ 4];
  Kl[2] = dgst[ 5];
  Kh[3] = dgst[ 6];
  Kl[3] = dgst[ 7];
  Kh[4] = dgst[ 8];
  Kl[4] = dgst[ 9];
  Kh[5] = dgst[10];
  Kl[5] = dgst[11];
  Kh[6] = dgst[12];
  Kl[6] = dgst[13];
  Kh[7] = dgst[14];
  Kl[7] = dgst[15];

  u32 stateh[8];
  u32 statel[8];

  stateh[0] = w[ 0] ^ Kh[0];
  statel[0] = w[ 1] ^ Kl[0];
  stateh[1] = w[ 2] ^ Kh[1];
  statel[1] = w[ 3] ^ Kl[1];
  stateh[2] = w[ 4] ^ Kh[2];
  statel[2] = w[ 5] ^ Kl[2];
  stateh[3] = w[ 6] ^ Kh[3];
  statel[3] = w[ 7] ^ Kl[3];
  stateh[4] = w[ 8] ^ Kh[4];
  statel[4] = w[ 9] ^ Kl[4];
  stateh[5] = w[10] ^ Kh[5];
  statel[5] = w[11] ^ Kl[5];
  stateh[6] = w[12] ^ Kh[6];
  statel[6] = w[13] ^ Kl[6];
  stateh[7] = w[14] ^ Kh[7];
  statel[7] = w[15] ^ Kl[7];

  u32 r;

  for (r = 1; r <= R; r++)
  {
    u32 Lh[8];
    u32 Ll[8];

    u32 i;

    #ifdef _unroll
    #pragma unroll
    #endif
    for (i = 0; i < 8; i++)
    {
      const u8 Lp0 = Kh[(i + 8) & 7] >> 24;
      const u8 Lp1 = Kh[(i + 7) & 7] >> 16;
      const u8 Lp2 = Kh[(i + 6) & 7] >>  8;
      const u8 Lp3 = Kh[(i + 5) & 7] >>  0;
      const u8 Lp4 = Kl[(i + 4) & 7] >> 24;
      const u8 Lp5 = Kl[(i + 3) & 7] >> 16;
      const u8 Lp6 = Kl[(i + 2) & 7] >>  8;
      const u8 Lp7 = Kl[(i + 1) & 7] >>  0;

      Lh[i] = BOX (s_Ch, 0, Lp0 & 0xff)
            ^ BOX (s_Ch, 1, Lp1 & 0xff)
            ^ BOX (s_Ch, 2, Lp2 & 0xff)
            ^ BOX (s_Ch, 3, Lp3 & 0xff)
            ^ BOX (s_Ch, 4, Lp4 & 0xff)
            ^ BOX (s_Ch, 5, Lp5 & 0xff)
            ^ BOX (s_Ch, 6, Lp6 & 0xff)
            ^ BOX (s_Ch, 7, Lp7 & 0xff);

      Ll[i] = BOX (s_Cl, 0, Lp0 & 0xff)
            ^ BOX (s_Cl, 1, Lp1 & 0xff)
            ^ BOX (s_Cl, 2, Lp2 & 0xff)
            ^ BOX (s_Cl, 3, Lp3 & 0xff)
            ^ BOX (s_Cl, 4, Lp4 & 0xff)
            ^ BOX (s_Cl, 5, Lp5 & 0xff)
            ^ BOX (s_Cl, 6, Lp6 & 0xff)
            ^ BOX (s_Cl, 7, Lp7 & 0xff);
    }

    Kh[0] = Lh[0] ^ rch[r];
    Kl[0] = Ll[0] ^ rcl[r];
    Kh[1] = Lh[1];
    Kl[1] = Ll[1];
    Kh[2] = Lh[2];
    Kl[2] = Ll[2];
    Kh[3] = Lh[3];
    Kl[3] = Ll[3];
    Kh[4] = Lh[4];
    Kl[4] = Ll[4];
    Kh[5] = Lh[5];
    Kl[5] = Ll[5];
    Kh[6] = Lh[6];
    Kl[6] = Ll[6];
    Kh[7] = Lh[7];
    Kl[7] = Ll[7];

    #ifdef _unroll
    #pragma unroll
    #endif
    for (i = 0; i < 8; i++)
    {
      const u8 Lp0 = stateh[(i + 8) & 7] >> 24;
      const u8 Lp1 = stateh[(i + 7) & 7] >> 16;
      const u8 Lp2 = stateh[(i + 6) & 7] >>  8;
      const u8 Lp3 = stateh[(i + 5) & 7] >>  0;
      const u8 Lp4 = statel[(i + 4) & 7] >> 24;
      const u8 Lp5 = statel[(i + 3) & 7] >> 16;
      const u8 Lp6 = statel[(i + 2) & 7] >>  8;
      const u8 Lp7 = statel[(i + 1) & 7] >>  0;

      Lh[i] = BOX (s_Ch, 0, Lp0 & 0xff)
            ^ BOX (s_Ch, 1, Lp1 & 0xff)
            ^ BOX (s_Ch, 2, Lp2 & 0xff)
            ^ BOX (s_Ch, 3, Lp3 & 0xff)
            ^ BOX (s_Ch, 4, Lp4 & 0xff)
            ^ BOX (s_Ch, 5, Lp5 & 0xff)
            ^ BOX (s_Ch, 6, Lp6 & 0xff)
            ^ BOX (s_Ch, 7, Lp7 & 0xff);

      Ll[i] = BOX (s_Cl, 0, Lp0 & 0xff)
            ^ BOX (s_Cl, 1, Lp1 & 0xff)
            ^ BOX (s_Cl, 2, Lp2 & 0xff)
            ^ BOX (s_Cl, 3, Lp3 & 0xff)
            ^ BOX (s_Cl, 4, Lp4 & 0xff)
            ^ BOX (s_Cl, 5, Lp5 & 0xff)
            ^ BOX (s_Cl, 6, Lp6 & 0xff)
            ^ BOX (s_Cl, 7, Lp7 & 0xff);
    }

    stateh[0] = Lh[0] ^ Kh[0];
    statel[0] = Ll[0] ^ Kl[0];
    stateh[1] = Lh[1] ^ Kh[1];
    statel[1] = Ll[1] ^ Kl[1];
    stateh[2] = Lh[2] ^ Kh[2];
    statel[2] = Ll[2] ^ Kl[2];
    stateh[3] = Lh[3] ^ Kh[3];
    statel[3] = Ll[3] ^ Kl[3];
    stateh[4] = Lh[4] ^ Kh[4];
    statel[4] = Ll[4] ^ Kl[4];
    stateh[5] = Lh[5] ^ Kh[5];
    statel[5] = Ll[5] ^ Kl[5];
    stateh[6] = Lh[6] ^ Kh[6];
    statel[6] = Ll[6] ^ Kl[6];
    stateh[7] = Lh[7] ^ Kh[7];
    statel[7] = Ll[7] ^ Kl[7];
  }

  dgst[ 0] ^= stateh[0] ^ w[ 0];
  dgst[ 1] ^= statel[0] ^ w[ 1];
  dgst[ 2] ^= stateh[1] ^ w[ 2];
  dgst[ 3] ^= statel[1] ^ w[ 3];
  dgst[ 4] ^= stateh[2] ^ w[ 4];
  dgst[ 5] ^= statel[2] ^ w[ 5];
  dgst[ 6] ^= stateh[3] ^ w[ 6];
  dgst[ 7] ^= statel[3] ^ w[ 7];
  dgst[ 8] ^= stateh[4] ^ w[ 8];
  dgst[ 9] ^= statel[4] ^ w[ 9];
  dgst[10] ^= stateh[5] ^ w[10];
  dgst[11] ^= statel[5] ^ w[11];
  dgst[12] ^= stateh[6] ^ w[12];
  dgst[13] ^= statel[6] ^ w[13];
  dgst[14] ^= stateh[7] ^ w[14];
  dgst[15] ^= statel[7] ^ w[15];
}

void hmac_run2 (const u32 w1[16], const u32 w2[16], const u32 ipad[16], const u32 opad[16], u32 dgst[16], __local u32 (*s_Ch)[256], __local u32 (*s_Cl)[256])
{
  dgst[ 0] = ipad[ 0];
  dgst[ 1] = ipad[ 1];
  dgst[ 2] = ipad[ 2];
  dgst[ 3] = ipad[ 3];
  dgst[ 4] = ipad[ 4];
  dgst[ 5] = ipad[ 5];
  dgst[ 6] = ipad[ 6];
  dgst[ 7] = ipad[ 7];
  dgst[ 8] = ipad[ 8];
  dgst[ 9] = ipad[ 9];
  dgst[10] = ipad[10];
  dgst[11] = ipad[11];
  dgst[12] = ipad[12];
  dgst[13] = ipad[13];
  dgst[14] = ipad[14];
  dgst[15] = ipad[15];

  whirlpool_transform (w1, dgst, s_Ch, s_Cl);
  whirlpool_transform (w2, dgst, s_Ch, s_Cl);

  u32 w[16];

  w[ 0] = dgst[ 0];
  w[ 1] = dgst[ 1];
  w[ 2] = dgst[ 2];
  w[ 3] = dgst[ 3];
  w[ 4] = dgst[ 4];
  w[ 5] = dgst[ 5];
  w[ 6] = dgst[ 6];
  w[ 7] = dgst[ 7];
  w[ 8] = dgst[ 8];
  w[ 9] = dgst[ 9];
  w[10] = dgst[10];
  w[11] = dgst[11];
  w[12] = dgst[12];
  w[13] = dgst[13];
  w[14] = dgst[14];
  w[15] = dgst[15];

  dgst[ 0] = opad[ 0];
  dgst[ 1] = opad[ 1];
  dgst[ 2] = opad[ 2];
  dgst[ 3] = opad[ 3];
  dgst[ 4] = opad[ 4];
  dgst[ 5] = opad[ 5];
  dgst[ 6] = opad[ 6];
  dgst[ 7] = opad[ 7];
  dgst[ 8] = opad[ 8];
  dgst[ 9] = opad[ 9];
  dgst[10] = opad[10];
  dgst[11] = opad[11];
  dgst[12] = opad[12];
  dgst[13] = opad[13];
  dgst[14] = opad[14];
  dgst[15] = opad[15];

  whirlpool_transform (w, dgst, s_Ch, s_Cl);

  w[ 0] = 0x80000000;
  w[ 1] = 0;
  w[ 2] = 0;
  w[ 3] = 0;
  w[ 4] = 0;
  w[ 5] = 0;
  w[ 6] = 0;
  w[ 7] = 0;
  w[ 8] = 0;
  w[ 9] = 0;
  w[10] = 0;
  w[11] = 0;
  w[12] = 0;
  w[13] = 0;
  w[14] = 0;
  w[15] = (64 + 64) * 8;

  whirlpool_transform (w, dgst, s_Ch, s_Cl);
}

void hmac_init (u32 w[16], u32 ipad[16], u32 opad[16], __local u32 (*s_Ch)[256], __local u32 (*s_Cl)[256])
{
  w[ 0] ^= 0x36363636;
  w[ 1] ^= 0x36363636;
  w[ 2] ^= 0x36363636;
  w[ 3] ^= 0x36363636;
  w[ 4] ^= 0x36363636;
  w[ 5] ^= 0x36363636;
  w[ 6] ^= 0x36363636;
  w[ 7] ^= 0x36363636;
  w[ 8] ^= 0x36363636;
  w[ 9] ^= 0x36363636;
  w[10] ^= 0x36363636;
  w[11] ^= 0x36363636;
  w[12] ^= 0x36363636;
  w[13] ^= 0x36363636;
  w[14] ^= 0x36363636;
  w[15] ^= 0x36363636;

  ipad[ 0] = 0;
  ipad[ 1] = 0;
  ipad[ 2] = 0;
  ipad[ 3] = 0;
  ipad[ 4] = 0;
  ipad[ 5] = 0;
  ipad[ 6] = 0;
  ipad[ 7] = 0;
  ipad[ 8] = 0;
  ipad[ 9] = 0;
  ipad[10] = 0;
  ipad[11] = 0;
  ipad[12] = 0;
  ipad[13] = 0;
  ipad[14] = 0;
  ipad[15] = 0;

  whirlpool_transform (w, ipad, s_Ch, s_Cl);

  w[ 0] ^= 0x6a6a6a6a;
  w[ 1] ^= 0x6a6a6a6a;
  w[ 2] ^= 0x6a6a6a6a;
  w[ 3] ^= 0x6a6a6a6a;
  w[ 4] ^= 0x6a6a6a6a;
  w[ 5] ^= 0x6a6a6a6a;
  w[ 6] ^= 0x6a6a6a6a;
  w[ 7] ^= 0x6a6a6a6a;
  w[ 8] ^= 0x6a6a6a6a;
  w[ 9] ^= 0x6a6a6a6a;
  w[10] ^= 0x6a6a6a6a;
  w[11] ^= 0x6a6a6a6a;
  w[12] ^= 0x6a6a6a6a;
  w[13] ^= 0x6a6a6a6a;
  w[14] ^= 0x6a6a6a6a;
  w[15] ^= 0x6a6a6a6a;

  opad[ 0] = 0;
  opad[ 1] = 0;
  opad[ 2] = 0;
  opad[ 3] = 0;
  opad[ 4] = 0;
  opad[ 5] = 0;
  opad[ 6] = 0;
  opad[ 7] = 0;
  opad[ 8] = 0;
  opad[ 9] = 0;
  opad[10] = 0;
  opad[11] = 0;
  opad[12] = 0;
  opad[13] = 0;
  opad[14] = 0;
  opad[15] = 0;

  whirlpool_transform (w, opad, s_Ch, s_Cl);
}

u32 u8add (const u32 a, const u32 b)
{
  const u32 a1 = (a >>  0) & 0xff;
  const u32 a2 = (a >>  8) & 0xff;
  const u32 a3 = (a >> 16) & 0xff;
  const u32 a4 = (a >> 24) & 0xff;

  const u32 b1 = (b >>  0) & 0xff;
  const u32 b2 = (b >>  8) & 0xff;
  const u32 b3 = (b >> 16) & 0xff;
  const u32 b4 = (b >> 24) & 0xff;

  const u32 r1 = (a1 + b1) & 0xff;
  const u32 r2 = (a2 + b2) & 0xff;
  const u32 r3 = (a3 + b3) & 0xff;
  const u32 r4 = (a4 + b4) & 0xff;

  const u32 r = r1 <<  0
               | r2 <<  8
               | r3 << 16
               | r4 << 24;

  return r;
}

__kernel void m06233_init (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global tc_tmp_t *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global tc_t *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV0_buf, __global u32 *d_scryptV1_buf, __global u32 *d_scryptV2_buf, __global u32 *d_scryptV3_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 il_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * modifier
   */

  const u32 gid = get_global_id (0);
  const u32 lid = get_local_id (0);
  const u32 lsz = get_local_size (0);

  /**
   * shared
   */

  __local u32 s_Ch[8][256];
  __local u32 s_Cl[8][256];

  for (u32 i = lid; i < 256; i += lsz)
  {
    s_Ch[0][i] = Ch[0][i];
    s_Ch[1][i] = Ch[1][i];
    s_Ch[2][i] = Ch[2][i];
    s_Ch[3][i] = Ch[3][i];
    s_Ch[4][i] = Ch[4][i];
    s_Ch[5][i] = Ch[5][i];
    s_Ch[6][i] = Ch[6][i];
    s_Ch[7][i] = Ch[7][i];

    s_Cl[0][i] = Cl[0][i];
    s_Cl[1][i] = Cl[1][i];
    s_Cl[2][i] = Cl[2][i];
    s_Cl[3][i] = Cl[3][i];
    s_Cl[4][i] = Cl[4][i];
    s_Cl[5][i] = Cl[5][i];
    s_Cl[6][i] = Cl[6][i];
    s_Cl[7][i] = Cl[7][i];
  }

  barrier (CLK_LOCAL_MEM_FENCE);

  if (gid >= gid_max) return;

  /**
   * base
   */

  u32 w0[4];

  w0[0] = pws[gid].i[ 0];
  w0[1] = pws[gid].i[ 1];
  w0[2] = pws[gid].i[ 2];
  w0[3] = pws[gid].i[ 3];

  u32 w1[4];

  w1[0] = pws[gid].i[ 4];
  w1[1] = pws[gid].i[ 5];
  w1[2] = pws[gid].i[ 6];
  w1[3] = pws[gid].i[ 7];

  u32 w2[4];

  w2[0] = pws[gid].i[ 8];
  w2[1] = pws[gid].i[ 9];
  w2[2] = pws[gid].i[10];
  w2[3] = pws[gid].i[11];

  u32 w3[4];

  w3[0] = pws[gid].i[12];
  w3[1] = pws[gid].i[13];
  w3[2] = pws[gid].i[14];
  w3[3] = pws[gid].i[15];

  /**
   * keyfile
   */

  w0[0] = u8add (w0[0], esalt_bufs[salt_pos].keyfile_buf[ 0]);
  w0[1] = u8add (w0[1], esalt_bufs[salt_pos].keyfile_buf[ 1]);
  w0[2] = u8add (w0[2], esalt_bufs[salt_pos].keyfile_buf[ 2]);
  w0[3] = u8add (w0[3], esalt_bufs[salt_pos].keyfile_buf[ 3]);
  w1[0] = u8add (w1[0], esalt_bufs[salt_pos].keyfile_buf[ 4]);
  w1[1] = u8add (w1[1], esalt_bufs[salt_pos].keyfile_buf[ 5]);
  w1[2] = u8add (w1[2], esalt_bufs[salt_pos].keyfile_buf[ 6]);
  w1[3] = u8add (w1[3], esalt_bufs[salt_pos].keyfile_buf[ 7]);
  w2[0] = u8add (w2[0], esalt_bufs[salt_pos].keyfile_buf[ 8]);
  w2[1] = u8add (w2[1], esalt_bufs[salt_pos].keyfile_buf[ 9]);
  w2[2] = u8add (w2[2], esalt_bufs[salt_pos].keyfile_buf[10]);
  w2[3] = u8add (w2[3], esalt_bufs[salt_pos].keyfile_buf[11]);
  w3[0] = u8add (w3[0], esalt_bufs[salt_pos].keyfile_buf[12]);
  w3[1] = u8add (w3[1], esalt_bufs[salt_pos].keyfile_buf[13]);
  w3[2] = u8add (w3[2], esalt_bufs[salt_pos].keyfile_buf[14]);
  w3[3] = u8add (w3[3], esalt_bufs[salt_pos].keyfile_buf[15]);

  /**
   * salt
   */

  u32 salt_buf1[16];

  salt_buf1[ 0] = swap32 (esalt_bufs[salt_pos].salt_buf[ 0]);
  salt_buf1[ 1] = swap32 (esalt_bufs[salt_pos].salt_buf[ 1]);
  salt_buf1[ 2] = swap32 (esalt_bufs[salt_pos].salt_buf[ 2]);
  salt_buf1[ 3] = swap32 (esalt_bufs[salt_pos].salt_buf[ 3]);
  salt_buf1[ 4] = swap32 (esalt_bufs[salt_pos].salt_buf[ 4]);
  salt_buf1[ 5] = swap32 (esalt_bufs[salt_pos].salt_buf[ 5]);
  salt_buf1[ 6] = swap32 (esalt_bufs[salt_pos].salt_buf[ 6]);
  salt_buf1[ 7] = swap32 (esalt_bufs[salt_pos].salt_buf[ 7]);
  salt_buf1[ 8] = swap32 (esalt_bufs[salt_pos].salt_buf[ 8]);
  salt_buf1[ 9] = swap32 (esalt_bufs[salt_pos].salt_buf[ 9]);
  salt_buf1[10] = swap32 (esalt_bufs[salt_pos].salt_buf[10]);
  salt_buf1[11] = swap32 (esalt_bufs[salt_pos].salt_buf[11]);
  salt_buf1[12] = swap32 (esalt_bufs[salt_pos].salt_buf[12]);
  salt_buf1[13] = swap32 (esalt_bufs[salt_pos].salt_buf[13]);
  salt_buf1[14] = swap32 (esalt_bufs[salt_pos].salt_buf[14]);
  salt_buf1[15] = swap32 (esalt_bufs[salt_pos].salt_buf[15]);

  u32 salt_buf2[16];

  salt_buf2[ 0] = 0;
  salt_buf2[ 1] = 0x80000000;
  salt_buf2[ 2] = 0;
  salt_buf2[ 3] = 0;
  salt_buf2[ 4] = 0;
  salt_buf2[ 5] = 0;
  salt_buf2[ 6] = 0;
  salt_buf2[ 7] = 0;
  salt_buf2[ 8] = 0;
  salt_buf2[ 9] = 0;
  salt_buf2[10] = 0;
  salt_buf2[11] = 0;
  salt_buf2[12] = 0;
  salt_buf2[13] = 0;
  salt_buf2[14] = 0;
  salt_buf2[15] = (64 + 64 + 4) * 8;

  const u32 truecrypt_mdlen = salt_bufs[0].truecrypt_mdlen;

  u32 w[16];

  w[ 0] = swap32 (w0[0]);
  w[ 1] = swap32 (w0[1]);
  w[ 2] = swap32 (w0[2]);
  w[ 3] = swap32 (w0[3]);
  w[ 4] = swap32 (w1[0]);
  w[ 5] = swap32 (w1[1]);
  w[ 6] = swap32 (w1[2]);
  w[ 7] = swap32 (w1[3]);
  w[ 8] = swap32 (w2[0]);
  w[ 9] = swap32 (w2[1]);
  w[10] = swap32 (w2[2]);
  w[11] = swap32 (w2[3]);
  w[12] = swap32 (w3[0]);
  w[13] = swap32 (w3[1]);
  w[14] = swap32 (w3[2]);
  w[15] = swap32 (w3[3]);

  u32 ipad[16];
  u32 opad[16];

  hmac_init (w, ipad, opad, s_Ch, s_Cl);

  tmps[gid].ipad[ 0] = ipad[ 0];
  tmps[gid].ipad[ 1] = ipad[ 1];
  tmps[gid].ipad[ 2] = ipad[ 2];
  tmps[gid].ipad[ 3] = ipad[ 3];
  tmps[gid].ipad[ 4] = ipad[ 4];
  tmps[gid].ipad[ 5] = ipad[ 5];
  tmps[gid].ipad[ 6] = ipad[ 6];
  tmps[gid].ipad[ 7] = ipad[ 7];
  tmps[gid].ipad[ 8] = ipad[ 8];
  tmps[gid].ipad[ 9] = ipad[ 9];
  tmps[gid].ipad[10] = ipad[10];
  tmps[gid].ipad[11] = ipad[11];
  tmps[gid].ipad[12] = ipad[12];
  tmps[gid].ipad[13] = ipad[13];
  tmps[gid].ipad[14] = ipad[14];
  tmps[gid].ipad[15] = ipad[15];

  tmps[gid].opad[ 0] = opad[ 0];
  tmps[gid].opad[ 1] = opad[ 1];
  tmps[gid].opad[ 2] = opad[ 2];
  tmps[gid].opad[ 3] = opad[ 3];
  tmps[gid].opad[ 4] = opad[ 4];
  tmps[gid].opad[ 5] = opad[ 5];
  tmps[gid].opad[ 6] = opad[ 6];
  tmps[gid].opad[ 7] = opad[ 7];
  tmps[gid].opad[ 8] = opad[ 8];
  tmps[gid].opad[ 9] = opad[ 9];
  tmps[gid].opad[10] = opad[10];
  tmps[gid].opad[11] = opad[11];
  tmps[gid].opad[12] = opad[12];
  tmps[gid].opad[13] = opad[13];
  tmps[gid].opad[14] = opad[14];
  tmps[gid].opad[15] = opad[15];

  for (u32 i = 0, j = 1; i < (truecrypt_mdlen / 8 / 4); i += 16, j += 1)
  {
    salt_buf2[0] = j;

    u32 dgst[16];

    hmac_run2 (salt_buf1, salt_buf2, ipad, opad, dgst, s_Ch, s_Cl);

    tmps[gid].dgst[i +  0] = dgst[ 0];
    tmps[gid].dgst[i +  1] = dgst[ 1];
    tmps[gid].dgst[i +  2] = dgst[ 2];
    tmps[gid].dgst[i +  3] = dgst[ 3];
    tmps[gid].dgst[i +  4] = dgst[ 4];
    tmps[gid].dgst[i +  5] = dgst[ 5];
    tmps[gid].dgst[i +  6] = dgst[ 6];
    tmps[gid].dgst[i +  7] = dgst[ 7];
    tmps[gid].dgst[i +  8] = dgst[ 8];
    tmps[gid].dgst[i +  9] = dgst[ 9];
    tmps[gid].dgst[i + 10] = dgst[10];
    tmps[gid].dgst[i + 11] = dgst[11];
    tmps[gid].dgst[i + 12] = dgst[12];
    tmps[gid].dgst[i + 13] = dgst[13];
    tmps[gid].dgst[i + 14] = dgst[14];
    tmps[gid].dgst[i + 15] = dgst[15];

    tmps[gid].out[i +  0] = dgst[ 0];
    tmps[gid].out[i +  1] = dgst[ 1];
    tmps[gid].out[i +  2] = dgst[ 2];
    tmps[gid].out[i +  3] = dgst[ 3];
    tmps[gid].out[i +  4] = dgst[ 4];
    tmps[gid].out[i +  5] = dgst[ 5];
    tmps[gid].out[i +  6] = dgst[ 6];
    tmps[gid].out[i +  7] = dgst[ 7];
    tmps[gid].out[i +  8] = dgst[ 8];
    tmps[gid].out[i +  9] = dgst[ 9];
    tmps[gid].out[i + 10] = dgst[10];
    tmps[gid].out[i + 11] = dgst[11];
    tmps[gid].out[i + 12] = dgst[12];
    tmps[gid].out[i + 13] = dgst[13];
    tmps[gid].out[i + 14] = dgst[14];
    tmps[gid].out[i + 15] = dgst[15];
  }
}

__kernel void m06233_loop (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global tc_tmp_t *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global tc_t *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV0_buf, __global u32 *d_scryptV1_buf, __global u32 *d_scryptV2_buf, __global u32 *d_scryptV3_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 il_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * modifier
   */

  const u32 gid = get_global_id (0);
  const u32 lid = get_local_id (0);
  const u32 lsz = get_local_size (0);

  /**
   * shared
   */

  __local u32 s_Ch[8][256];
  __local u32 s_Cl[8][256];

  for (u32 i = lid; i < 256; i += lsz)
  {
    s_Ch[0][i] = Ch[0][i];
    s_Ch[1][i] = Ch[1][i];
    s_Ch[2][i] = Ch[2][i];
    s_Ch[3][i] = Ch[3][i];
    s_Ch[4][i] = Ch[4][i];
    s_Ch[5][i] = Ch[5][i];
    s_Ch[6][i] = Ch[6][i];
    s_Ch[7][i] = Ch[7][i];

    s_Cl[0][i] = Cl[0][i];
    s_Cl[1][i] = Cl[1][i];
    s_Cl[2][i] = Cl[2][i];
    s_Cl[3][i] = Cl[3][i];
    s_Cl[4][i] = Cl[4][i];
    s_Cl[5][i] = Cl[5][i];
    s_Cl[6][i] = Cl[6][i];
    s_Cl[7][i] = Cl[7][i];
  }

  barrier (CLK_LOCAL_MEM_FENCE);

  if (gid >= gid_max) return;

  const u32 truecrypt_mdlen = salt_bufs[0].truecrypt_mdlen;

  u32 ipad[16];

  ipad[ 0] = tmps[gid].ipad[ 0];
  ipad[ 1] = tmps[gid].ipad[ 1],
  ipad[ 2] = tmps[gid].ipad[ 2];
  ipad[ 3] = tmps[gid].ipad[ 3];
  ipad[ 4] = tmps[gid].ipad[ 4];
  ipad[ 5] = tmps[gid].ipad[ 5];
  ipad[ 6] = tmps[gid].ipad[ 6],
  ipad[ 7] = tmps[gid].ipad[ 7];
  ipad[ 8] = tmps[gid].ipad[ 8];
  ipad[ 9] = tmps[gid].ipad[ 9];
  ipad[10] = tmps[gid].ipad[10];
  ipad[11] = tmps[gid].ipad[11],
  ipad[12] = tmps[gid].ipad[12];
  ipad[13] = tmps[gid].ipad[13];
  ipad[14] = tmps[gid].ipad[14];
  ipad[15] = tmps[gid].ipad[15];

  u32 opad[16];

  opad[ 0] = tmps[gid].opad[ 0];
  opad[ 1] = tmps[gid].opad[ 1],
  opad[ 2] = tmps[gid].opad[ 2];
  opad[ 3] = tmps[gid].opad[ 3];
  opad[ 4] = tmps[gid].opad[ 4];
  opad[ 5] = tmps[gid].opad[ 5];
  opad[ 6] = tmps[gid].opad[ 6],
  opad[ 7] = tmps[gid].opad[ 7];
  opad[ 8] = tmps[gid].opad[ 8];
  opad[ 9] = tmps[gid].opad[ 9];
  opad[10] = tmps[gid].opad[10];
  opad[11] = tmps[gid].opad[11],
  opad[12] = tmps[gid].opad[12];
  opad[13] = tmps[gid].opad[13];
  opad[14] = tmps[gid].opad[14];
  opad[15] = tmps[gid].opad[15];

  for (u32 i = 0; i < (truecrypt_mdlen / 8 / 4); i += 16)
  {
    u32 dgst[16];

    dgst[ 0] = tmps[gid].dgst[i +  0];
    dgst[ 1] = tmps[gid].dgst[i +  1];
    dgst[ 2] = tmps[gid].dgst[i +  2];
    dgst[ 3] = tmps[gid].dgst[i +  3];
    dgst[ 4] = tmps[gid].dgst[i +  4];
    dgst[ 5] = tmps[gid].dgst[i +  5];
    dgst[ 6] = tmps[gid].dgst[i +  6];
    dgst[ 7] = tmps[gid].dgst[i +  7];
    dgst[ 8] = tmps[gid].dgst[i +  8];
    dgst[ 9] = tmps[gid].dgst[i +  9];
    dgst[10] = tmps[gid].dgst[i + 10];
    dgst[11] = tmps[gid].dgst[i + 11];
    dgst[12] = tmps[gid].dgst[i + 12];
    dgst[13] = tmps[gid].dgst[i + 13];
    dgst[14] = tmps[gid].dgst[i + 14];
    dgst[15] = tmps[gid].dgst[i + 15];

    u32 out[16];

    out[ 0] = tmps[gid].out[i +  0];
    out[ 1] = tmps[gid].out[i +  1];
    out[ 2] = tmps[gid].out[i +  2];
    out[ 3] = tmps[gid].out[i +  3];
    out[ 4] = tmps[gid].out[i +  4];
    out[ 5] = tmps[gid].out[i +  5];
    out[ 6] = tmps[gid].out[i +  6];
    out[ 7] = tmps[gid].out[i +  7];
    out[ 8] = tmps[gid].out[i +  8];
    out[ 9] = tmps[gid].out[i +  9];
    out[10] = tmps[gid].out[i + 10];
    out[11] = tmps[gid].out[i + 11];
    out[12] = tmps[gid].out[i + 12];
    out[13] = tmps[gid].out[i + 13];
    out[14] = tmps[gid].out[i + 14];
    out[15] = tmps[gid].out[i + 15];

    for (u32 j = 0; j < loop_cnt; j++)
    {
      u32 w1[16];

      w1[ 0] = dgst[ 0];
      w1[ 1] = dgst[ 1];
      w1[ 2] = dgst[ 2];
      w1[ 3] = dgst[ 3];
      w1[ 4] = dgst[ 4];
      w1[ 5] = dgst[ 5];
      w1[ 6] = dgst[ 6];
      w1[ 7] = dgst[ 7];
      w1[ 8] = dgst[ 8];
      w1[ 9] = dgst[ 9];
      w1[10] = dgst[10];
      w1[11] = dgst[11];
      w1[12] = dgst[12];
      w1[13] = dgst[13];
      w1[14] = dgst[14];
      w1[15] = dgst[15];

      u32 w2[16];

      w2[ 0] = 0x80000000;
      w2[ 1] = 0;
      w2[ 2] = 0;
      w2[ 3] = 0;
      w2[ 4] = 0;
      w2[ 5] = 0;
      w2[ 6] = 0;
      w2[ 7] = 0;
      w2[ 8] = 0;
      w2[ 9] = 0;
      w2[10] = 0;
      w2[11] = 0;
      w2[12] = 0;
      w2[13] = 0;
      w2[14] = 0;
      w2[15] = (64 + 64) * 8;

      hmac_run2 (w1, w2, ipad, opad, dgst, s_Ch, s_Cl);

      out[ 0] ^= dgst[ 0];
      out[ 1] ^= dgst[ 1];
      out[ 2] ^= dgst[ 2];
      out[ 3] ^= dgst[ 3];
      out[ 4] ^= dgst[ 4];
      out[ 5] ^= dgst[ 5];
      out[ 6] ^= dgst[ 6];
      out[ 7] ^= dgst[ 7];
      out[ 8] ^= dgst[ 8];
      out[ 9] ^= dgst[ 9];
      out[10] ^= dgst[10];
      out[11] ^= dgst[11];
      out[12] ^= dgst[12];
      out[13] ^= dgst[13];
      out[14] ^= dgst[14];
      out[15] ^= dgst[15];
    }

    tmps[gid].dgst[i +  0] = dgst[ 0];
    tmps[gid].dgst[i +  1] = dgst[ 1];
    tmps[gid].dgst[i +  2] = dgst[ 2];
    tmps[gid].dgst[i +  3] = dgst[ 3];
    tmps[gid].dgst[i +  4] = dgst[ 4];
    tmps[gid].dgst[i +  5] = dgst[ 5];
    tmps[gid].dgst[i +  6] = dgst[ 6];
    tmps[gid].dgst[i +  7] = dgst[ 7];
    tmps[gid].dgst[i +  8] = dgst[ 8];
    tmps[gid].dgst[i +  9] = dgst[ 9];
    tmps[gid].dgst[i + 10] = dgst[10];
    tmps[gid].dgst[i + 11] = dgst[11];
    tmps[gid].dgst[i + 12] = dgst[12];
    tmps[gid].dgst[i + 13] = dgst[13];
    tmps[gid].dgst[i + 14] = dgst[14];
    tmps[gid].dgst[i + 15] = dgst[15];

    tmps[gid].out[i +  0] = out[ 0];
    tmps[gid].out[i +  1] = out[ 1];
    tmps[gid].out[i +  2] = out[ 2];
    tmps[gid].out[i +  3] = out[ 3];
    tmps[gid].out[i +  4] = out[ 4];
    tmps[gid].out[i +  5] = out[ 5];
    tmps[gid].out[i +  6] = out[ 6];
    tmps[gid].out[i +  7] = out[ 7];
    tmps[gid].out[i +  8] = out[ 8];
    tmps[gid].out[i +  9] = out[ 9];
    tmps[gid].out[i + 10] = out[10];
    tmps[gid].out[i + 11] = out[11];
    tmps[gid].out[i + 12] = out[12];
    tmps[gid].out[i + 13] = out[13];
    tmps[gid].out[i + 14] = out[14];
    tmps[gid].out[i + 15] = out[15];
  }
}

__kernel void m06233_comp (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global tc_tmp_t *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global tc_t *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV0_buf, __global u32 *d_scryptV1_buf, __global u32 *d_scryptV2_buf, __global u32 *d_scryptV3_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 il_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * base
   */

  const u32 gid = get_global_id (0);
  const u32 lid = get_local_id (0);

  if (gid >= gid_max) return;

  u32 ukey1[8];

  ukey1[0] = swap32 (tmps[gid].out[ 0]);
  ukey1[1] = swap32 (tmps[gid].out[ 1]);
  ukey1[2] = swap32 (tmps[gid].out[ 2]);
  ukey1[3] = swap32 (tmps[gid].out[ 3]);
  ukey1[4] = swap32 (tmps[gid].out[ 4]);
  ukey1[5] = swap32 (tmps[gid].out[ 5]);
  ukey1[6] = swap32 (tmps[gid].out[ 6]);
  ukey1[7] = swap32 (tmps[gid].out[ 7]);

  u32 ukey2[8];

  ukey2[0] = swap32 (tmps[gid].out[ 8]);
  ukey2[1] = swap32 (tmps[gid].out[ 9]);
  ukey2[2] = swap32 (tmps[gid].out[10]);
  ukey2[3] = swap32 (tmps[gid].out[11]);
  ukey2[4] = swap32 (tmps[gid].out[12]);
  ukey2[5] = swap32 (tmps[gid].out[13]);
  ukey2[6] = swap32 (tmps[gid].out[14]);
  ukey2[7] = swap32 (tmps[gid].out[15]);

  u32 data[4];

  data[0] = esalt_bufs[0].data_buf[0];
  data[1] = esalt_bufs[0].data_buf[1];
  data[2] = esalt_bufs[0].data_buf[2];
  data[3] = esalt_bufs[0].data_buf[3];

  const u32 signature = esalt_bufs[0].signature;

  u32 tmp[4];

  {
    tmp[0] = data[0];
    tmp[1] = data[1];
    tmp[2] = data[2];
    tmp[3] = data[3];

    aes256_decrypt_xts (ukey1, ukey2, tmp, tmp);

    if (((tmp[0] == signature) && (tmp[3] == 0)) || ((tmp[0] == signature) && ((tmp[1] >> 16) <= 5)))
    {
      mark_hash (plains_buf, d_return_buf, salt_pos, 0, 0, gid, 0);
    }
  }

  {
    tmp[0] = data[0];
    tmp[1] = data[1];
    tmp[2] = data[2];
    tmp[3] = data[3];

    serpent256_decrypt_xts (ukey1, ukey2, tmp, tmp);

    if (((tmp[0] == signature) && (tmp[3] == 0)) || ((tmp[0] == signature) && ((tmp[1] >> 16) <= 5)))
    {
      mark_hash (plains_buf, d_return_buf, salt_pos, 0, 0, gid, 0);
    }
  }

  {
    tmp[0] = data[0];
    tmp[1] = data[1];
    tmp[2] = data[2];
    tmp[3] = data[3];

    twofish256_decrypt_xts (ukey1, ukey2, tmp, tmp);

    if (((tmp[0] == signature) && (tmp[3] == 0)) || ((tmp[0] == signature) && ((tmp[1] >> 16) <= 5)))
    {
      mark_hash (plains_buf, d_return_buf, salt_pos, 0, 0, gid, 0);
    }
  }

  u32 ukey3[8];

  ukey3[0] = swap32 (tmps[gid].out[16]);
  ukey3[1] = swap32 (tmps[gid].out[17]);
  ukey3[2] = swap32 (tmps[gid].out[18]);
  ukey3[3] = swap32 (tmps[gid].out[19]);
  ukey3[4] = swap32 (tmps[gid].out[20]);
  ukey3[5] = swap32 (tmps[gid].out[21]);
  ukey3[6] = swap32 (tmps[gid].out[22]);
  ukey3[7] = swap32 (tmps[gid].out[23]);

  u32 ukey4[8];

  ukey4[0] = swap32 (tmps[gid].out[24]);
  ukey4[1] = swap32 (tmps[gid].out[25]);
  ukey4[2] = swap32 (tmps[gid].out[26]);
  ukey4[3] = swap32 (tmps[gid].out[27]);
  ukey4[4] = swap32 (tmps[gid].out[28]);
  ukey4[5] = swap32 (tmps[gid].out[29]);
  ukey4[6] = swap32 (tmps[gid].out[30]);
  ukey4[7] = swap32 (tmps[gid].out[31]);

  {
    tmp[0] = data[0];
    tmp[1] = data[1];
    tmp[2] = data[2];
    tmp[3] = data[3];

    aes256_decrypt_xts     (ukey2, ukey4, tmp, tmp);
    twofish256_decrypt_xts (ukey1, ukey3, tmp, tmp);

    if (((tmp[0] == signature) && (tmp[3] == 0)) || ((tmp[0] == signature) && ((tmp[1] >> 16) <= 5)))
    {
      mark_hash (plains_buf, d_return_buf, salt_pos, 0, 0, gid, 0);
    }
  }

  {
    tmp[0] = data[0];
    tmp[1] = data[1];
    tmp[2] = data[2];
    tmp[3] = data[3];

    serpent256_decrypt_xts (ukey2, ukey4, tmp, tmp);
    aes256_decrypt_xts     (ukey1, ukey3, tmp, tmp);

    if (((tmp[0] == signature) && (tmp[3] == 0)) || ((tmp[0] == signature) && ((tmp[1] >> 16) <= 5)))
    {
      mark_hash (plains_buf, d_return_buf, salt_pos, 0, 0, gid, 0);
    }
  }

  {
    tmp[0] = data[0];
    tmp[1] = data[1];
    tmp[2] = data[2];
    tmp[3] = data[3];

    twofish256_decrypt_xts (ukey2, ukey4, tmp, tmp);
    serpent256_decrypt_xts (ukey1, ukey3, tmp, tmp);

    if (((tmp[0] == signature) && (tmp[3] == 0)) || ((tmp[0] == signature) && ((tmp[1] >> 16) <= 5)))
    {
      mark_hash (plains_buf, d_return_buf, salt_pos, 0, 0, gid, 0);
    }
  }

  u32 ukey5[8];

  ukey5[0] = swap32 (tmps[gid].out[32]);
  ukey5[1] = swap32 (tmps[gid].out[33]);
  ukey5[2] = swap32 (tmps[gid].out[34]);
  ukey5[3] = swap32 (tmps[gid].out[35]);
  ukey5[4] = swap32 (tmps[gid].out[36]);
  ukey5[5] = swap32 (tmps[gid].out[37]);
  ukey5[6] = swap32 (tmps[gid].out[38]);
  ukey5[7] = swap32 (tmps[gid].out[39]);

  u32 ukey6[8];

  ukey6[0] = swap32 (tmps[gid].out[40]);
  ukey6[1] = swap32 (tmps[gid].out[41]);
  ukey6[2] = swap32 (tmps[gid].out[42]);
  ukey6[3] = swap32 (tmps[gid].out[43]);
  ukey6[4] = swap32 (tmps[gid].out[44]);
  ukey6[5] = swap32 (tmps[gid].out[45]);
  ukey6[6] = swap32 (tmps[gid].out[46]);
  ukey6[7] = swap32 (tmps[gid].out[47]);

  {
    tmp[0] = data[0];
    tmp[1] = data[1];
    tmp[2] = data[2];
    tmp[3] = data[3];

    aes256_decrypt_xts     (ukey3, ukey6, tmp, tmp);
    twofish256_decrypt_xts (ukey2, ukey5, tmp, tmp);
    serpent256_decrypt_xts (ukey1, ukey4, tmp, tmp);

    if (((tmp[0] == signature) && (tmp[3] == 0)) || ((tmp[0] == signature) && ((tmp[1] >> 16) <= 5)))
    {
      mark_hash (plains_buf, d_return_buf, salt_pos, 0, 0, gid, 0);
    }
  }

  {
    tmp[0] = data[0];
    tmp[1] = data[1];
    tmp[2] = data[2];
    tmp[3] = data[3];

    serpent256_decrypt_xts (ukey3, ukey6, tmp, tmp);
    twofish256_decrypt_xts (ukey2, ukey5, tmp, tmp);
    aes256_decrypt_xts     (ukey1, ukey4, tmp, tmp);

    if (((tmp[0] == signature) && (tmp[3] == 0)) || ((tmp[0] == signature) && ((tmp[1] >> 16) <= 5)))
    {
      mark_hash (plains_buf, d_return_buf, salt_pos, 0, 0, gid, 0);
    }
  }
}
