/**
 * Author......: Jens Steube <jens.steube@gmail.com>
 * License.....: MIT
 */

#define _SHA1_

#define NEW_SIMD_CODE

#include "inc_vendor.cl"
#include "inc_hash_constants.h"
#include "inc_hash_functions.cl"
#include "inc_types.cl"
#include "inc_common.cl"
#include "inc_simd.cl"

void m00300m (u32 w[16], const u32 pw_len, __global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32x * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV0_buf, __global u32 *d_scryptV1_buf, __global u32 *d_scryptV2_buf, __global u32 *d_scryptV3_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 il_cnt, const u32 digests_cnt, const u32 digests_offset)
{
  /**
   * modifier
   */

  const u32 gid = get_global_id (0);
  const u32 lid = get_local_id (0);

  /**
   * base
   */

  const u32 c_16s = rotl32_S ((w[13] ^ w[ 8] ^ w[ 2]        ), 1u);
  const u32 c_17s = rotl32_S ((w[14] ^ w[ 9] ^ w[ 3] ^ w[ 1]), 1u);
  const u32 c_18s = rotl32_S ((w[15] ^ w[10] ^ w[ 4] ^ w[ 2]), 1u);
  const u32 c_19s = rotl32_S ((c_16s ^ w[11] ^ w[ 5] ^ w[ 3]), 1u);
  const u32 c_20s = rotl32_S ((c_17s ^ w[12] ^ w[ 6] ^ w[ 4]), 1u);
  const u32 c_21s = rotl32_S ((c_18s ^ w[13] ^ w[ 7] ^ w[ 5]), 1u);
  const u32 c_22s = rotl32_S ((c_19s ^ w[14] ^ w[ 8] ^ w[ 6]), 1u);
  const u32 c_23s = rotl32_S ((c_20s ^ w[15] ^ w[ 9] ^ w[ 7]), 1u);
  const u32 c_24s = rotl32_S ((c_21s ^ c_16s ^ w[10] ^ w[ 8]), 1u);
  const u32 c_25s = rotl32_S ((c_22s ^ c_17s ^ w[11] ^ w[ 9]), 1u);
  const u32 c_26s = rotl32_S ((c_23s ^ c_18s ^ w[12] ^ w[10]), 1u);
  const u32 c_27s = rotl32_S ((c_24s ^ c_19s ^ w[13] ^ w[11]), 1u);
  const u32 c_28s = rotl32_S ((c_25s ^ c_20s ^ w[14] ^ w[12]), 1u);
  const u32 c_29s = rotl32_S ((c_26s ^ c_21s ^ w[15] ^ w[13]), 1u);
  const u32 c_30s = rotl32_S ((c_27s ^ c_22s ^ c_16s ^ w[14]), 1u);
  const u32 c_31s = rotl32_S ((c_28s ^ c_23s ^ c_17s ^ w[15]), 1u);
  const u32 c_32s = rotl32_S ((c_29s ^ c_24s ^ c_18s ^ c_16s), 1u);
  const u32 c_33s = rotl32_S ((c_30s ^ c_25s ^ c_19s ^ c_17s), 1u);
  const u32 c_34s = rotl32_S ((c_31s ^ c_26s ^ c_20s ^ c_18s), 1u);
  const u32 c_35s = rotl32_S ((c_32s ^ c_27s ^ c_21s ^ c_19s), 1u);
  const u32 c_36s = rotl32_S ((c_33s ^ c_28s ^ c_22s ^ c_20s), 1u);
  const u32 c_37s = rotl32_S ((c_34s ^ c_29s ^ c_23s ^ c_21s), 1u);
  const u32 c_38s = rotl32_S ((c_35s ^ c_30s ^ c_24s ^ c_22s), 1u);
  const u32 c_39s = rotl32_S ((c_36s ^ c_31s ^ c_25s ^ c_23s), 1u);
  const u32 c_40s = rotl32_S ((c_37s ^ c_32s ^ c_26s ^ c_24s), 1u);
  const u32 c_41s = rotl32_S ((c_38s ^ c_33s ^ c_27s ^ c_25s), 1u);
  const u32 c_42s = rotl32_S ((c_39s ^ c_34s ^ c_28s ^ c_26s), 1u);
  const u32 c_43s = rotl32_S ((c_40s ^ c_35s ^ c_29s ^ c_27s), 1u);
  const u32 c_44s = rotl32_S ((c_41s ^ c_36s ^ c_30s ^ c_28s), 1u);
  const u32 c_45s = rotl32_S ((c_42s ^ c_37s ^ c_31s ^ c_29s), 1u);
  const u32 c_46s = rotl32_S ((c_43s ^ c_38s ^ c_32s ^ c_30s), 1u);
  const u32 c_47s = rotl32_S ((c_44s ^ c_39s ^ c_33s ^ c_31s), 1u);
  const u32 c_48s = rotl32_S ((c_45s ^ c_40s ^ c_34s ^ c_32s), 1u);
  const u32 c_49s = rotl32_S ((c_46s ^ c_41s ^ c_35s ^ c_33s), 1u);
  const u32 c_50s = rotl32_S ((c_47s ^ c_42s ^ c_36s ^ c_34s), 1u);
  const u32 c_51s = rotl32_S ((c_48s ^ c_43s ^ c_37s ^ c_35s), 1u);
  const u32 c_52s = rotl32_S ((c_49s ^ c_44s ^ c_38s ^ c_36s), 1u);
  const u32 c_53s = rotl32_S ((c_50s ^ c_45s ^ c_39s ^ c_37s), 1u);
  const u32 c_54s = rotl32_S ((c_51s ^ c_46s ^ c_40s ^ c_38s), 1u);
  const u32 c_55s = rotl32_S ((c_52s ^ c_47s ^ c_41s ^ c_39s), 1u);
  const u32 c_56s = rotl32_S ((c_53s ^ c_48s ^ c_42s ^ c_40s), 1u);
  const u32 c_57s = rotl32_S ((c_54s ^ c_49s ^ c_43s ^ c_41s), 1u);
  const u32 c_58s = rotl32_S ((c_55s ^ c_50s ^ c_44s ^ c_42s), 1u);
  const u32 c_59s = rotl32_S ((c_56s ^ c_51s ^ c_45s ^ c_43s), 1u);
  const u32 c_60s = rotl32_S ((c_57s ^ c_52s ^ c_46s ^ c_44s), 1u);
  const u32 c_61s = rotl32_S ((c_58s ^ c_53s ^ c_47s ^ c_45s), 1u);
  const u32 c_62s = rotl32_S ((c_59s ^ c_54s ^ c_48s ^ c_46s), 1u);
  const u32 c_63s = rotl32_S ((c_60s ^ c_55s ^ c_49s ^ c_47s), 1u);
  const u32 c_64s = rotl32_S ((c_61s ^ c_56s ^ c_50s ^ c_48s), 1u);
  const u32 c_65s = rotl32_S ((c_62s ^ c_57s ^ c_51s ^ c_49s), 1u);
  const u32 c_66s = rotl32_S ((c_63s ^ c_58s ^ c_52s ^ c_50s), 1u);
  const u32 c_67s = rotl32_S ((c_64s ^ c_59s ^ c_53s ^ c_51s), 1u);
  const u32 c_68s = rotl32_S ((c_65s ^ c_60s ^ c_54s ^ c_52s), 1u);
  const u32 c_69s = rotl32_S ((c_66s ^ c_61s ^ c_55s ^ c_53s), 1u);
  const u32 c_70s = rotl32_S ((c_67s ^ c_62s ^ c_56s ^ c_54s), 1u);
  const u32 c_71s = rotl32_S ((c_68s ^ c_63s ^ c_57s ^ c_55s), 1u);
  const u32 c_72s = rotl32_S ((c_69s ^ c_64s ^ c_58s ^ c_56s), 1u);
  const u32 c_73s = rotl32_S ((c_70s ^ c_65s ^ c_59s ^ c_57s), 1u);
  const u32 c_74s = rotl32_S ((c_71s ^ c_66s ^ c_60s ^ c_58s), 1u);
  const u32 c_75s = rotl32_S ((c_72s ^ c_67s ^ c_61s ^ c_59s), 1u);

  const u32 c_17sK = c_17s + SHA1C00;
  const u32 c_18sK = c_18s + SHA1C00;
  const u32 c_20sK = c_20s + SHA1C01;
  const u32 c_21sK = c_21s + SHA1C01;
  const u32 c_23sK = c_23s + SHA1C01;
  const u32 c_26sK = c_26s + SHA1C01;
  const u32 c_27sK = c_27s + SHA1C01;
  const u32 c_29sK = c_29s + SHA1C01;
  const u32 c_33sK = c_33s + SHA1C01;
  const u32 c_39sK = c_39s + SHA1C01;
  const u32 c_41sK = c_41s + SHA1C02;
  const u32 c_45sK = c_45s + SHA1C02;
  const u32 c_53sK = c_53s + SHA1C02;
  const u32 c_65sK = c_65s + SHA1C03;
  const u32 c_69sK = c_69s + SHA1C03;

  /**
   * loop
   */

  u32 w0l = w[0];

  for (u32 il_pos = 0; il_pos < il_cnt; il_pos += VECT_SIZE)
  {
    const u32x w0r = words_buf_r[il_pos / VECT_SIZE];

    const u32x w0 = w0l | w0r;

    const u32x w0s01 = rotl32 (w0, 1u);
    const u32x w0s02 = rotl32 (w0, 2u);
    const u32x w0s03 = rotl32 (w0, 3u);
    const u32x w0s04 = rotl32 (w0, 4u);
    const u32x w0s05 = rotl32 (w0, 5u);
    const u32x w0s06 = rotl32 (w0, 6u);
    const u32x w0s07 = rotl32 (w0, 7u);
    const u32x w0s08 = rotl32 (w0, 8u);
    const u32x w0s09 = rotl32 (w0, 9u);
    const u32x w0s10 = rotl32 (w0, 10u);
    const u32x w0s11 = rotl32 (w0, 11u);
    const u32x w0s12 = rotl32 (w0, 12u);
    const u32x w0s13 = rotl32 (w0, 13u);
    const u32x w0s14 = rotl32 (w0, 14u);
    const u32x w0s15 = rotl32 (w0, 15u);
    const u32x w0s16 = rotl32 (w0, 16u);
    const u32x w0s17 = rotl32 (w0, 17u);
    const u32x w0s18 = rotl32 (w0, 18u);
    const u32x w0s19 = rotl32 (w0, 19u);
    const u32x w0s20 = rotl32 (w0, 20u);

    const u32x w0s04___w0s06 = w0s04 ^ w0s06;
    const u32x w0s04___w0s08 = w0s04 ^ w0s08;
    const u32x w0s08___w0s12 = w0s08 ^ w0s12;
    const u32x w0s04___w0s06___w0s07 = w0s04___w0s06 ^ w0s07;

    u32x a = SHA1M_A;
    u32x b = SHA1M_B;
    u32x c = SHA1M_C;
    u32x d = SHA1M_D;
    u32x e = SHA1M_E;

    #undef K
    #define K SHA1C00

    SHA1_STEP (SHA1_F0o, a, b, c, d, e, w0);
    SHA1_STEP (SHA1_F0o, e, a, b, c, d, w[ 1]);
    SHA1_STEP (SHA1_F0o, d, e, a, b, c, w[ 2]);
    SHA1_STEP (SHA1_F0o, c, d, e, a, b, w[ 3]);
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, w[ 4]);
    SHA1_STEP (SHA1_F0o, a, b, c, d, e, w[ 5]);
    SHA1_STEP (SHA1_F0o, e, a, b, c, d, w[ 6]);
    SHA1_STEP (SHA1_F0o, d, e, a, b, c, w[ 7]);
    SHA1_STEP (SHA1_F0o, c, d, e, a, b, w[ 8]);
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, w[ 9]);
    SHA1_STEP (SHA1_F0o, a, b, c, d, e, w[10]);
    SHA1_STEP (SHA1_F0o, e, a, b, c, d, w[11]);
    SHA1_STEP (SHA1_F0o, d, e, a, b, c, w[12]);
    SHA1_STEP (SHA1_F0o, c, d, e, a, b, w[13]);
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, w[14]);
    SHA1_STEP (SHA1_F0o, a, b, c, d, e, w[15]);

    SHA1_STEP (SHA1_F0o, e, a, b, c, d, (c_16s ^ w0s01));
    SHA1_STEPX(SHA1_F0o, d, e, a, b, c, (c_17sK));
    SHA1_STEPX(SHA1_F0o, c, d, e, a, b, (c_18sK));
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, (c_19s ^ w0s02));

    #undef K
    #define K SHA1C01

    SHA1_STEPX(SHA1_F1 , a, b, c, d, e, (c_20sK));
    SHA1_STEPX(SHA1_F1 , e, a, b, c, d, (c_21sK));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_22s ^ w0s03));
    SHA1_STEPX(SHA1_F1 , c, d, e, a, b, (c_23sK));
    SHA1_STEP (SHA1_F1 , b, c, d, e, a, (c_24s ^ w0s02));
    SHA1_STEP (SHA1_F1 , a, b, c, d, e, (c_25s ^ w0s04));
    SHA1_STEPX(SHA1_F1 , e, a, b, c, d, (c_26sK));
    SHA1_STEPX(SHA1_F1 , d, e, a, b, c, (c_27sK));
    SHA1_STEP (SHA1_F1 , c, d, e, a, b, (c_28s ^ w0s05));
    SHA1_STEPX(SHA1_F1 , b, c, d, e, a, (c_29sK));
    SHA1_STEP (SHA1_F1 , a, b, c, d, e, (c_30s ^ w0s02 ^ w0s04));
    SHA1_STEP (SHA1_F1 , e, a, b, c, d, (c_31s ^ w0s06));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_32s ^ w0s02 ^ w0s03));
    SHA1_STEPX(SHA1_F1 , c, d, e, a, b, (c_33sK));
    SHA1_STEP (SHA1_F1 , b, c, d, e, a, (c_34s ^ w0s07));
    SHA1_STEP (SHA1_F1 , a, b, c, d, e, (c_35s ^ w0s04));
    SHA1_STEP (SHA1_F1 , e, a, b, c, d, (c_36s ^ w0s04___w0s06));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_37s ^ w0s08));
    SHA1_STEP (SHA1_F1 , c, d, e, a, b, (c_38s ^ w0s04));
    SHA1_STEPX(SHA1_F1 , b, c, d, e, a, (c_39sK));

    #undef K
    #define K SHA1C02

    SHA1_STEP (SHA1_F2o, a, b, c, d, e, (c_40s ^ w0s04 ^ w0s09));
    SHA1_STEPX(SHA1_F2o, e, a, b, c, d, (c_41sK));
    SHA1_STEP (SHA1_F2o, d, e, a, b, c, (c_42s ^ w0s06 ^ w0s08));
    SHA1_STEP (SHA1_F2o, c, d, e, a, b, (c_43s ^ w0s10));
    SHA1_STEP (SHA1_F2o, b, c, d, e, a, (c_44s ^ w0s03 ^ w0s06 ^ w0s07));
    SHA1_STEPX(SHA1_F2o, a, b, c, d, e, (c_45sK));
    SHA1_STEP (SHA1_F2o, e, a, b, c, d, (c_46s ^ w0s04 ^ w0s11));
    SHA1_STEP (SHA1_F2o, d, e, a, b, c, (c_47s ^ w0s04___w0s08));
    SHA1_STEP (SHA1_F2o, c, d, e, a, b, (c_48s ^ w0s03 ^ w0s04___w0s08 ^ w0s05 ^ w0s10));
    SHA1_STEP (SHA1_F2o, b, c, d, e, a, (c_49s ^ w0s12));
    SHA1_STEP (SHA1_F2o, a, b, c, d, e, (c_50s ^ w0s08));
    SHA1_STEP (SHA1_F2o, e, a, b, c, d, (c_51s ^ w0s04___w0s06));
    SHA1_STEP (SHA1_F2o, d, e, a, b, c, (c_52s ^ w0s04___w0s08 ^ w0s13));
    SHA1_STEPX(SHA1_F2o, c, d, e, a, b, (c_53sK));
    SHA1_STEP (SHA1_F2o, b, c, d, e, a, (c_54s ^ w0s07 ^ w0s10 ^ w0s12));
    SHA1_STEP (SHA1_F2o, a, b, c, d, e, (c_55s ^ w0s14));
    SHA1_STEP (SHA1_F2o, e, a, b, c, d, (c_56s ^ w0s04___w0s06___w0s07 ^ w0s10 ^ w0s11));
    SHA1_STEP (SHA1_F2o, d, e, a, b, c, (c_57s ^ w0s08));
    SHA1_STEP (SHA1_F2o, c, d, e, a, b, (c_58s ^ w0s04___w0s08 ^ w0s15));
    SHA1_STEP (SHA1_F2o, b, c, d, e, a, (c_59s ^ w0s08___w0s12));

    #undef K
    #define K SHA1C03

    SHA1_STEP (SHA1_F1 , a, b, c, d, e, (c_60s ^ w0s04 ^ w0s08___w0s12 ^ w0s07 ^ w0s14));
    SHA1_STEP (SHA1_F1 , e, a, b, c, d, (c_61s ^ w0s16));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_62s ^ w0s04___w0s06 ^ w0s08___w0s12));
    SHA1_STEP (SHA1_F1 , c, d, e, a, b, (c_63s ^ w0s08));
    SHA1_STEP (SHA1_F1 , b, c, d, e, a, (c_64s ^ w0s04___w0s06___w0s07 ^ w0s08___w0s12 ^ w0s17));
    SHA1_STEPX(SHA1_F1 , a, b, c, d, e, (c_65sK));
    SHA1_STEP (SHA1_F1 , e, a, b, c, d, (c_66s ^ w0s14 ^ w0s16));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_67s ^ w0s08 ^ w0s18));
    SHA1_STEP (SHA1_F1 , c, d, e, a, b, (c_68s ^ w0s11 ^ w0s14 ^ w0s15));
    SHA1_STEPX(SHA1_F1 , b, c, d, e, a, (c_69sK));
    SHA1_STEP (SHA1_F1 , a, b, c, d, e, (c_70s ^ w0s12 ^ w0s19));
    SHA1_STEP (SHA1_F1 , e, a, b, c, d, (c_71s ^ w0s12 ^ w0s16));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_72s ^ w0s05 ^ w0s11 ^ w0s12 ^ w0s13 ^ w0s16 ^ w0s18));
    SHA1_STEP (SHA1_F1 , c, d, e, a, b, (c_73s ^ w0s20));
    SHA1_STEP (SHA1_F1 , b, c, d, e, a, (c_74s ^ w0s08 ^ w0s16));
    SHA1_STEP (SHA1_F1 , a, b, c, d, e, (c_75s ^ w0s06 ^ w0s12 ^ w0s14));

    const u32x c_76s = rotl32 ((c_73s ^ c_68s ^ c_62s ^ c_60s), 1u);
    const u32x c_77s = rotl32 ((c_74s ^ c_69s ^ c_63s ^ c_61s), 1u);
    const u32x c_78s = rotl32 ((c_75s ^ c_70s ^ c_64s ^ c_62s), 1u);
    const u32x c_79s = rotl32 ((c_76s ^ c_71s ^ c_65s ^ c_63s), 1u);

    const u32x w0s21 = rotl32 (w0, 21u);
    const u32x w0s22 = rotl32 (w0, 22U);

    SHA1_STEP (SHA1_F1 , e, a, b, c, d, (c_76s ^ w0s07 ^ w0s08___w0s12 ^ w0s16 ^ w0s21));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_77s));
    SHA1_STEP (SHA1_F1 , c, d, e, a, b, (c_78s ^ w0s07 ^ w0s08 ^ w0s15 ^ w0s18 ^ w0s20));
    SHA1_STEP (SHA1_F1 , b, c, d, e, a, (c_79s ^ w0s08 ^ w0s22));

    a += SHA1M_A;
    b += SHA1M_B;
    c += SHA1M_C;
    d += SHA1M_D;
    e += SHA1M_E;

    u32x w0_t = a;
    u32x w1_t = b;
    u32x w2_t = c;
    u32x w3_t = d;
    u32x w4_t = e;
    u32x w5_t = 0x80000000;
    u32x w6_t = 0;
    u32x w7_t = 0;
    u32x w8_t = 0;
    u32x w9_t = 0;
    u32x wa_t = 0;
    u32x wb_t = 0;
    u32x wc_t = 0;
    u32x wd_t = 0;
    u32x we_t = 0;
    u32x wf_t = 20 * 8;

    a = SHA1M_A;
    b = SHA1M_B;
    c = SHA1M_C;
    d = SHA1M_D;
    e = SHA1M_E;

    #undef K
    #define K SHA1C00

    SHA1_STEP (SHA1_F0o, a, b, c, d, e, w0_t);
    SHA1_STEP (SHA1_F0o, e, a, b, c, d, w1_t);
    SHA1_STEP (SHA1_F0o, d, e, a, b, c, w2_t);
    SHA1_STEP (SHA1_F0o, c, d, e, a, b, w3_t);
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, w4_t);
    SHA1_STEP (SHA1_F0o, a, b, c, d, e, w5_t);
    SHA1_STEP (SHA1_F0o, e, a, b, c, d, w6_t);
    SHA1_STEP (SHA1_F0o, d, e, a, b, c, w7_t);
    SHA1_STEP (SHA1_F0o, c, d, e, a, b, w8_t);
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, w9_t);
    SHA1_STEP (SHA1_F0o, a, b, c, d, e, wa_t);
    SHA1_STEP (SHA1_F0o, e, a, b, c, d, wb_t);
    SHA1_STEP (SHA1_F0o, d, e, a, b, c, wc_t);
    SHA1_STEP (SHA1_F0o, c, d, e, a, b, wd_t);
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, we_t);
    SHA1_STEP (SHA1_F0o, a, b, c, d, e, wf_t);
    w0_t = rotl32 ((wd_t ^ w8_t ^ w2_t ^ w0_t), 1u); SHA1_STEP (SHA1_F0o, e, a, b, c, d, w0_t);
    w1_t = rotl32 ((we_t ^ w9_t ^ w3_t ^ w1_t), 1u); SHA1_STEP (SHA1_F0o, d, e, a, b, c, w1_t);
    w2_t = rotl32 ((wf_t ^ wa_t ^ w4_t ^ w2_t), 1u); SHA1_STEP (SHA1_F0o, c, d, e, a, b, w2_t);
    w3_t = rotl32 ((w0_t ^ wb_t ^ w5_t ^ w3_t), 1u); SHA1_STEP (SHA1_F0o, b, c, d, e, a, w3_t);

    #undef K
    #define K SHA1C01

    w4_t = rotl32 ((w1_t ^ wc_t ^ w6_t ^ w4_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, w4_t);
    w5_t = rotl32 ((w2_t ^ wd_t ^ w7_t ^ w5_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, w5_t);
    w6_t = rotl32 ((w3_t ^ we_t ^ w8_t ^ w6_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, w6_t);
    w7_t = rotl32 ((w4_t ^ wf_t ^ w9_t ^ w7_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, w7_t);
    w8_t = rotl32 ((w5_t ^ w0_t ^ wa_t ^ w8_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, w8_t);
    w9_t = rotl32 ((w6_t ^ w1_t ^ wb_t ^ w9_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, w9_t);
    wa_t = rotl32 ((w7_t ^ w2_t ^ wc_t ^ wa_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, wa_t);
    wb_t = rotl32 ((w8_t ^ w3_t ^ wd_t ^ wb_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, wb_t);
    wc_t = rotl32 ((w9_t ^ w4_t ^ we_t ^ wc_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, wc_t);
    wd_t = rotl32 ((wa_t ^ w5_t ^ wf_t ^ wd_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, wd_t);
    we_t = rotl32 ((wb_t ^ w6_t ^ w0_t ^ we_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, we_t);
    wf_t = rotl32 ((wc_t ^ w7_t ^ w1_t ^ wf_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, wf_t);
    w0_t = rotl32 ((wd_t ^ w8_t ^ w2_t ^ w0_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, w0_t);
    w1_t = rotl32 ((we_t ^ w9_t ^ w3_t ^ w1_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, w1_t);
    w2_t = rotl32 ((wf_t ^ wa_t ^ w4_t ^ w2_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, w2_t);
    w3_t = rotl32 ((w0_t ^ wb_t ^ w5_t ^ w3_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, w3_t);
    w4_t = rotl32 ((w1_t ^ wc_t ^ w6_t ^ w4_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, w4_t);
    w5_t = rotl32 ((w2_t ^ wd_t ^ w7_t ^ w5_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, w5_t);
    w6_t = rotl32 ((w3_t ^ we_t ^ w8_t ^ w6_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, w6_t);
    w7_t = rotl32 ((w4_t ^ wf_t ^ w9_t ^ w7_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, w7_t);

    #undef K
    #define K SHA1C02

    w8_t = rotl32 ((w5_t ^ w0_t ^ wa_t ^ w8_t), 1u); SHA1_STEP (SHA1_F2o, a, b, c, d, e, w8_t);
    w9_t = rotl32 ((w6_t ^ w1_t ^ wb_t ^ w9_t), 1u); SHA1_STEP (SHA1_F2o, e, a, b, c, d, w9_t);
    wa_t = rotl32 ((w7_t ^ w2_t ^ wc_t ^ wa_t), 1u); SHA1_STEP (SHA1_F2o, d, e, a, b, c, wa_t);
    wb_t = rotl32 ((w8_t ^ w3_t ^ wd_t ^ wb_t), 1u); SHA1_STEP (SHA1_F2o, c, d, e, a, b, wb_t);
    wc_t = rotl32 ((w9_t ^ w4_t ^ we_t ^ wc_t), 1u); SHA1_STEP (SHA1_F2o, b, c, d, e, a, wc_t);
    wd_t = rotl32 ((wa_t ^ w5_t ^ wf_t ^ wd_t), 1u); SHA1_STEP (SHA1_F2o, a, b, c, d, e, wd_t);
    we_t = rotl32 ((wb_t ^ w6_t ^ w0_t ^ we_t), 1u); SHA1_STEP (SHA1_F2o, e, a, b, c, d, we_t);
    wf_t = rotl32 ((wc_t ^ w7_t ^ w1_t ^ wf_t), 1u); SHA1_STEP (SHA1_F2o, d, e, a, b, c, wf_t);
    w0_t = rotl32 ((wd_t ^ w8_t ^ w2_t ^ w0_t), 1u); SHA1_STEP (SHA1_F2o, c, d, e, a, b, w0_t);
    w1_t = rotl32 ((we_t ^ w9_t ^ w3_t ^ w1_t), 1u); SHA1_STEP (SHA1_F2o, b, c, d, e, a, w1_t);
    w2_t = rotl32 ((wf_t ^ wa_t ^ w4_t ^ w2_t), 1u); SHA1_STEP (SHA1_F2o, a, b, c, d, e, w2_t);
    w3_t = rotl32 ((w0_t ^ wb_t ^ w5_t ^ w3_t), 1u); SHA1_STEP (SHA1_F2o, e, a, b, c, d, w3_t);
    w4_t = rotl32 ((w1_t ^ wc_t ^ w6_t ^ w4_t), 1u); SHA1_STEP (SHA1_F2o, d, e, a, b, c, w4_t);
    w5_t = rotl32 ((w2_t ^ wd_t ^ w7_t ^ w5_t), 1u); SHA1_STEP (SHA1_F2o, c, d, e, a, b, w5_t);
    w6_t = rotl32 ((w3_t ^ we_t ^ w8_t ^ w6_t), 1u); SHA1_STEP (SHA1_F2o, b, c, d, e, a, w6_t);
    w7_t = rotl32 ((w4_t ^ wf_t ^ w9_t ^ w7_t), 1u); SHA1_STEP (SHA1_F2o, a, b, c, d, e, w7_t);
    w8_t = rotl32 ((w5_t ^ w0_t ^ wa_t ^ w8_t), 1u); SHA1_STEP (SHA1_F2o, e, a, b, c, d, w8_t);
    w9_t = rotl32 ((w6_t ^ w1_t ^ wb_t ^ w9_t), 1u); SHA1_STEP (SHA1_F2o, d, e, a, b, c, w9_t);
    wa_t = rotl32 ((w7_t ^ w2_t ^ wc_t ^ wa_t), 1u); SHA1_STEP (SHA1_F2o, c, d, e, a, b, wa_t);
    wb_t = rotl32 ((w8_t ^ w3_t ^ wd_t ^ wb_t), 1u); SHA1_STEP (SHA1_F2o, b, c, d, e, a, wb_t);

    #undef K
    #define K SHA1C03

    wc_t = rotl32 ((w9_t ^ w4_t ^ we_t ^ wc_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, wc_t);
    wd_t = rotl32 ((wa_t ^ w5_t ^ wf_t ^ wd_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, wd_t);
    we_t = rotl32 ((wb_t ^ w6_t ^ w0_t ^ we_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, we_t);
    wf_t = rotl32 ((wc_t ^ w7_t ^ w1_t ^ wf_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, wf_t);
    w0_t = rotl32 ((wd_t ^ w8_t ^ w2_t ^ w0_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, w0_t);
    w1_t = rotl32 ((we_t ^ w9_t ^ w3_t ^ w1_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, w1_t);
    w2_t = rotl32 ((wf_t ^ wa_t ^ w4_t ^ w2_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, w2_t);
    w3_t = rotl32 ((w0_t ^ wb_t ^ w5_t ^ w3_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, w3_t);
    w4_t = rotl32 ((w1_t ^ wc_t ^ w6_t ^ w4_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, w4_t);
    w5_t = rotl32 ((w2_t ^ wd_t ^ w7_t ^ w5_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, w5_t);
    w6_t = rotl32 ((w3_t ^ we_t ^ w8_t ^ w6_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, w6_t);
    w7_t = rotl32 ((w4_t ^ wf_t ^ w9_t ^ w7_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, w7_t);
    w8_t = rotl32 ((w5_t ^ w0_t ^ wa_t ^ w8_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, w8_t);
    w9_t = rotl32 ((w6_t ^ w1_t ^ wb_t ^ w9_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, w9_t);
    wa_t = rotl32 ((w7_t ^ w2_t ^ wc_t ^ wa_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, wa_t);
    wb_t = rotl32 ((w8_t ^ w3_t ^ wd_t ^ wb_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, wb_t);
    wc_t = rotl32 ((w9_t ^ w4_t ^ we_t ^ wc_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, wc_t);
    wd_t = rotl32 ((wa_t ^ w5_t ^ wf_t ^ wd_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, wd_t);
    we_t = rotl32 ((wb_t ^ w6_t ^ w0_t ^ we_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, we_t);
    wf_t = rotl32 ((wc_t ^ w7_t ^ w1_t ^ wf_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, wf_t);

    COMPARE_M_SIMD (d, e, c, b);
  }
}

void m00300s (u32 w[16], const u32 pw_len, __global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32x * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV0_buf, __global u32 *d_scryptV1_buf, __global u32 *d_scryptV2_buf, __global u32 *d_scryptV3_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 il_cnt, const u32 digests_cnt, const u32 digests_offset)
{
  /**
   * modifier
   */

  const u32 gid = get_global_id (0);
  const u32 lid = get_local_id (0);

  /**
   * base
   */

  const u32 c_16s = rotl32_S ((w[13] ^ w[ 8] ^ w[ 2]        ), 1u);
  const u32 c_17s = rotl32_S ((w[14] ^ w[ 9] ^ w[ 3] ^ w[ 1]), 1u);
  const u32 c_18s = rotl32_S ((w[15] ^ w[10] ^ w[ 4] ^ w[ 2]), 1u);
  const u32 c_19s = rotl32_S ((c_16s ^ w[11] ^ w[ 5] ^ w[ 3]), 1u);
  const u32 c_20s = rotl32_S ((c_17s ^ w[12] ^ w[ 6] ^ w[ 4]), 1u);
  const u32 c_21s = rotl32_S ((c_18s ^ w[13] ^ w[ 7] ^ w[ 5]), 1u);
  const u32 c_22s = rotl32_S ((c_19s ^ w[14] ^ w[ 8] ^ w[ 6]), 1u);
  const u32 c_23s = rotl32_S ((c_20s ^ w[15] ^ w[ 9] ^ w[ 7]), 1u);
  const u32 c_24s = rotl32_S ((c_21s ^ c_16s ^ w[10] ^ w[ 8]), 1u);
  const u32 c_25s = rotl32_S ((c_22s ^ c_17s ^ w[11] ^ w[ 9]), 1u);
  const u32 c_26s = rotl32_S ((c_23s ^ c_18s ^ w[12] ^ w[10]), 1u);
  const u32 c_27s = rotl32_S ((c_24s ^ c_19s ^ w[13] ^ w[11]), 1u);
  const u32 c_28s = rotl32_S ((c_25s ^ c_20s ^ w[14] ^ w[12]), 1u);
  const u32 c_29s = rotl32_S ((c_26s ^ c_21s ^ w[15] ^ w[13]), 1u);
  const u32 c_30s = rotl32_S ((c_27s ^ c_22s ^ c_16s ^ w[14]), 1u);
  const u32 c_31s = rotl32_S ((c_28s ^ c_23s ^ c_17s ^ w[15]), 1u);
  const u32 c_32s = rotl32_S ((c_29s ^ c_24s ^ c_18s ^ c_16s), 1u);
  const u32 c_33s = rotl32_S ((c_30s ^ c_25s ^ c_19s ^ c_17s), 1u);
  const u32 c_34s = rotl32_S ((c_31s ^ c_26s ^ c_20s ^ c_18s), 1u);
  const u32 c_35s = rotl32_S ((c_32s ^ c_27s ^ c_21s ^ c_19s), 1u);
  const u32 c_36s = rotl32_S ((c_33s ^ c_28s ^ c_22s ^ c_20s), 1u);
  const u32 c_37s = rotl32_S ((c_34s ^ c_29s ^ c_23s ^ c_21s), 1u);
  const u32 c_38s = rotl32_S ((c_35s ^ c_30s ^ c_24s ^ c_22s), 1u);
  const u32 c_39s = rotl32_S ((c_36s ^ c_31s ^ c_25s ^ c_23s), 1u);
  const u32 c_40s = rotl32_S ((c_37s ^ c_32s ^ c_26s ^ c_24s), 1u);
  const u32 c_41s = rotl32_S ((c_38s ^ c_33s ^ c_27s ^ c_25s), 1u);
  const u32 c_42s = rotl32_S ((c_39s ^ c_34s ^ c_28s ^ c_26s), 1u);
  const u32 c_43s = rotl32_S ((c_40s ^ c_35s ^ c_29s ^ c_27s), 1u);
  const u32 c_44s = rotl32_S ((c_41s ^ c_36s ^ c_30s ^ c_28s), 1u);
  const u32 c_45s = rotl32_S ((c_42s ^ c_37s ^ c_31s ^ c_29s), 1u);
  const u32 c_46s = rotl32_S ((c_43s ^ c_38s ^ c_32s ^ c_30s), 1u);
  const u32 c_47s = rotl32_S ((c_44s ^ c_39s ^ c_33s ^ c_31s), 1u);
  const u32 c_48s = rotl32_S ((c_45s ^ c_40s ^ c_34s ^ c_32s), 1u);
  const u32 c_49s = rotl32_S ((c_46s ^ c_41s ^ c_35s ^ c_33s), 1u);
  const u32 c_50s = rotl32_S ((c_47s ^ c_42s ^ c_36s ^ c_34s), 1u);
  const u32 c_51s = rotl32_S ((c_48s ^ c_43s ^ c_37s ^ c_35s), 1u);
  const u32 c_52s = rotl32_S ((c_49s ^ c_44s ^ c_38s ^ c_36s), 1u);
  const u32 c_53s = rotl32_S ((c_50s ^ c_45s ^ c_39s ^ c_37s), 1u);
  const u32 c_54s = rotl32_S ((c_51s ^ c_46s ^ c_40s ^ c_38s), 1u);
  const u32 c_55s = rotl32_S ((c_52s ^ c_47s ^ c_41s ^ c_39s), 1u);
  const u32 c_56s = rotl32_S ((c_53s ^ c_48s ^ c_42s ^ c_40s), 1u);
  const u32 c_57s = rotl32_S ((c_54s ^ c_49s ^ c_43s ^ c_41s), 1u);
  const u32 c_58s = rotl32_S ((c_55s ^ c_50s ^ c_44s ^ c_42s), 1u);
  const u32 c_59s = rotl32_S ((c_56s ^ c_51s ^ c_45s ^ c_43s), 1u);
  const u32 c_60s = rotl32_S ((c_57s ^ c_52s ^ c_46s ^ c_44s), 1u);
  const u32 c_61s = rotl32_S ((c_58s ^ c_53s ^ c_47s ^ c_45s), 1u);
  const u32 c_62s = rotl32_S ((c_59s ^ c_54s ^ c_48s ^ c_46s), 1u);
  const u32 c_63s = rotl32_S ((c_60s ^ c_55s ^ c_49s ^ c_47s), 1u);
  const u32 c_64s = rotl32_S ((c_61s ^ c_56s ^ c_50s ^ c_48s), 1u);
  const u32 c_65s = rotl32_S ((c_62s ^ c_57s ^ c_51s ^ c_49s), 1u);
  const u32 c_66s = rotl32_S ((c_63s ^ c_58s ^ c_52s ^ c_50s), 1u);
  const u32 c_67s = rotl32_S ((c_64s ^ c_59s ^ c_53s ^ c_51s), 1u);
  const u32 c_68s = rotl32_S ((c_65s ^ c_60s ^ c_54s ^ c_52s), 1u);
  const u32 c_69s = rotl32_S ((c_66s ^ c_61s ^ c_55s ^ c_53s), 1u);
  const u32 c_70s = rotl32_S ((c_67s ^ c_62s ^ c_56s ^ c_54s), 1u);
  const u32 c_71s = rotl32_S ((c_68s ^ c_63s ^ c_57s ^ c_55s), 1u);
  const u32 c_72s = rotl32_S ((c_69s ^ c_64s ^ c_58s ^ c_56s), 1u);
  const u32 c_73s = rotl32_S ((c_70s ^ c_65s ^ c_59s ^ c_57s), 1u);
  const u32 c_74s = rotl32_S ((c_71s ^ c_66s ^ c_60s ^ c_58s), 1u);
  const u32 c_75s = rotl32_S ((c_72s ^ c_67s ^ c_61s ^ c_59s), 1u);

  const u32 c_17sK = c_17s + SHA1C00;
  const u32 c_18sK = c_18s + SHA1C00;
  const u32 c_20sK = c_20s + SHA1C01;
  const u32 c_21sK = c_21s + SHA1C01;
  const u32 c_23sK = c_23s + SHA1C01;
  const u32 c_26sK = c_26s + SHA1C01;
  const u32 c_27sK = c_27s + SHA1C01;
  const u32 c_29sK = c_29s + SHA1C01;
  const u32 c_33sK = c_33s + SHA1C01;
  const u32 c_39sK = c_39s + SHA1C01;
  const u32 c_41sK = c_41s + SHA1C02;
  const u32 c_45sK = c_45s + SHA1C02;
  const u32 c_53sK = c_53s + SHA1C02;
  const u32 c_65sK = c_65s + SHA1C03;
  const u32 c_69sK = c_69s + SHA1C03;

  /**
   * digest
   */

  const u32 search[4] =
  {
    digests_buf[digests_offset].digest_buf[DGST_R0],
    digests_buf[digests_offset].digest_buf[DGST_R1],
    digests_buf[digests_offset].digest_buf[DGST_R2],
    digests_buf[digests_offset].digest_buf[DGST_R3]
  };

  /**
   * reverse
   */

  const u32 e_rev = rotl32_S (search[1], 2u);

  /**
   * loop
   */

  u32 w0l = w[0];

  for (u32 il_pos = 0; il_pos < il_cnt; il_pos += VECT_SIZE)
  {
    const u32x w0r = words_buf_r[il_pos / VECT_SIZE];

    const u32x w0 = w0l | w0r;

    const u32x w0s01 = rotl32 (w0, 1u);
    const u32x w0s02 = rotl32 (w0, 2u);
    const u32x w0s03 = rotl32 (w0, 3u);
    const u32x w0s04 = rotl32 (w0, 4u);
    const u32x w0s05 = rotl32 (w0, 5u);
    const u32x w0s06 = rotl32 (w0, 6u);
    const u32x w0s07 = rotl32 (w0, 7u);
    const u32x w0s08 = rotl32 (w0, 8u);
    const u32x w0s09 = rotl32 (w0, 9u);
    const u32x w0s10 = rotl32 (w0, 10u);
    const u32x w0s11 = rotl32 (w0, 11u);
    const u32x w0s12 = rotl32 (w0, 12u);
    const u32x w0s13 = rotl32 (w0, 13u);
    const u32x w0s14 = rotl32 (w0, 14u);
    const u32x w0s15 = rotl32 (w0, 15u);
    const u32x w0s16 = rotl32 (w0, 16u);
    const u32x w0s17 = rotl32 (w0, 17u);
    const u32x w0s18 = rotl32 (w0, 18u);
    const u32x w0s19 = rotl32 (w0, 19u);
    const u32x w0s20 = rotl32 (w0, 20u);

    const u32x w0s04___w0s06 = w0s04 ^ w0s06;
    const u32x w0s04___w0s08 = w0s04 ^ w0s08;
    const u32x w0s08___w0s12 = w0s08 ^ w0s12;
    const u32x w0s04___w0s06___w0s07 = w0s04___w0s06 ^ w0s07;

    u32x a = SHA1M_A;
    u32x b = SHA1M_B;
    u32x c = SHA1M_C;
    u32x d = SHA1M_D;
    u32x e = SHA1M_E;

    #undef K
    #define K SHA1C00

    SHA1_STEP (SHA1_F0o, a, b, c, d, e, w0);
    SHA1_STEP (SHA1_F0o, e, a, b, c, d, w[ 1]);
    SHA1_STEP (SHA1_F0o, d, e, a, b, c, w[ 2]);
    SHA1_STEP (SHA1_F0o, c, d, e, a, b, w[ 3]);
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, w[ 4]);
    SHA1_STEP (SHA1_F0o, a, b, c, d, e, w[ 5]);
    SHA1_STEP (SHA1_F0o, e, a, b, c, d, w[ 6]);
    SHA1_STEP (SHA1_F0o, d, e, a, b, c, w[ 7]);
    SHA1_STEP (SHA1_F0o, c, d, e, a, b, w[ 8]);
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, w[ 9]);
    SHA1_STEP (SHA1_F0o, a, b, c, d, e, w[10]);
    SHA1_STEP (SHA1_F0o, e, a, b, c, d, w[11]);
    SHA1_STEP (SHA1_F0o, d, e, a, b, c, w[12]);
    SHA1_STEP (SHA1_F0o, c, d, e, a, b, w[13]);
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, w[14]);
    SHA1_STEP (SHA1_F0o, a, b, c, d, e, w[15]);

    SHA1_STEP (SHA1_F0o, e, a, b, c, d, (c_16s ^ w0s01));
    SHA1_STEPX(SHA1_F0o, d, e, a, b, c, (c_17sK));
    SHA1_STEPX(SHA1_F0o, c, d, e, a, b, (c_18sK));
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, (c_19s ^ w0s02));

    #undef K
    #define K SHA1C01

    SHA1_STEPX(SHA1_F1 , a, b, c, d, e, (c_20sK));
    SHA1_STEPX(SHA1_F1 , e, a, b, c, d, (c_21sK));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_22s ^ w0s03));
    SHA1_STEPX(SHA1_F1 , c, d, e, a, b, (c_23sK));
    SHA1_STEP (SHA1_F1 , b, c, d, e, a, (c_24s ^ w0s02));
    SHA1_STEP (SHA1_F1 , a, b, c, d, e, (c_25s ^ w0s04));
    SHA1_STEPX(SHA1_F1 , e, a, b, c, d, (c_26sK));
    SHA1_STEPX(SHA1_F1 , d, e, a, b, c, (c_27sK));
    SHA1_STEP (SHA1_F1 , c, d, e, a, b, (c_28s ^ w0s05));
    SHA1_STEPX(SHA1_F1 , b, c, d, e, a, (c_29sK));
    SHA1_STEP (SHA1_F1 , a, b, c, d, e, (c_30s ^ w0s02 ^ w0s04));
    SHA1_STEP (SHA1_F1 , e, a, b, c, d, (c_31s ^ w0s06));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_32s ^ w0s02 ^ w0s03));
    SHA1_STEPX(SHA1_F1 , c, d, e, a, b, (c_33sK));
    SHA1_STEP (SHA1_F1 , b, c, d, e, a, (c_34s ^ w0s07));
    SHA1_STEP (SHA1_F1 , a, b, c, d, e, (c_35s ^ w0s04));
    SHA1_STEP (SHA1_F1 , e, a, b, c, d, (c_36s ^ w0s04___w0s06));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_37s ^ w0s08));
    SHA1_STEP (SHA1_F1 , c, d, e, a, b, (c_38s ^ w0s04));
    SHA1_STEPX(SHA1_F1 , b, c, d, e, a, (c_39sK));

    #undef K
    #define K SHA1C02

    SHA1_STEP (SHA1_F2o, a, b, c, d, e, (c_40s ^ w0s04 ^ w0s09));
    SHA1_STEPX(SHA1_F2o, e, a, b, c, d, (c_41sK));
    SHA1_STEP (SHA1_F2o, d, e, a, b, c, (c_42s ^ w0s06 ^ w0s08));
    SHA1_STEP (SHA1_F2o, c, d, e, a, b, (c_43s ^ w0s10));
    SHA1_STEP (SHA1_F2o, b, c, d, e, a, (c_44s ^ w0s03 ^ w0s06 ^ w0s07));
    SHA1_STEPX(SHA1_F2o, a, b, c, d, e, (c_45sK));
    SHA1_STEP (SHA1_F2o, e, a, b, c, d, (c_46s ^ w0s04 ^ w0s11));
    SHA1_STEP (SHA1_F2o, d, e, a, b, c, (c_47s ^ w0s04___w0s08));
    SHA1_STEP (SHA1_F2o, c, d, e, a, b, (c_48s ^ w0s03 ^ w0s04___w0s08 ^ w0s05 ^ w0s10));
    SHA1_STEP (SHA1_F2o, b, c, d, e, a, (c_49s ^ w0s12));
    SHA1_STEP (SHA1_F2o, a, b, c, d, e, (c_50s ^ w0s08));
    SHA1_STEP (SHA1_F2o, e, a, b, c, d, (c_51s ^ w0s04___w0s06));
    SHA1_STEP (SHA1_F2o, d, e, a, b, c, (c_52s ^ w0s04___w0s08 ^ w0s13));
    SHA1_STEPX(SHA1_F2o, c, d, e, a, b, (c_53sK));
    SHA1_STEP (SHA1_F2o, b, c, d, e, a, (c_54s ^ w0s07 ^ w0s10 ^ w0s12));
    SHA1_STEP (SHA1_F2o, a, b, c, d, e, (c_55s ^ w0s14));
    SHA1_STEP (SHA1_F2o, e, a, b, c, d, (c_56s ^ w0s04___w0s06___w0s07 ^ w0s10 ^ w0s11));
    SHA1_STEP (SHA1_F2o, d, e, a, b, c, (c_57s ^ w0s08));
    SHA1_STEP (SHA1_F2o, c, d, e, a, b, (c_58s ^ w0s04___w0s08 ^ w0s15));
    SHA1_STEP (SHA1_F2o, b, c, d, e, a, (c_59s ^ w0s08___w0s12));

    #undef K
    #define K SHA1C03

    SHA1_STEP (SHA1_F1 , a, b, c, d, e, (c_60s ^ w0s04 ^ w0s08___w0s12 ^ w0s07 ^ w0s14));
    SHA1_STEP (SHA1_F1 , e, a, b, c, d, (c_61s ^ w0s16));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_62s ^ w0s04___w0s06 ^ w0s08___w0s12));
    SHA1_STEP (SHA1_F1 , c, d, e, a, b, (c_63s ^ w0s08));
    SHA1_STEP (SHA1_F1 , b, c, d, e, a, (c_64s ^ w0s04___w0s06___w0s07 ^ w0s08___w0s12 ^ w0s17));
    SHA1_STEPX(SHA1_F1 , a, b, c, d, e, (c_65sK));
    SHA1_STEP (SHA1_F1 , e, a, b, c, d, (c_66s ^ w0s14 ^ w0s16));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_67s ^ w0s08 ^ w0s18));
    SHA1_STEP (SHA1_F1 , c, d, e, a, b, (c_68s ^ w0s11 ^ w0s14 ^ w0s15));
    SHA1_STEPX(SHA1_F1 , b, c, d, e, a, (c_69sK));
    SHA1_STEP (SHA1_F1 , a, b, c, d, e, (c_70s ^ w0s12 ^ w0s19));
    SHA1_STEP (SHA1_F1 , e, a, b, c, d, (c_71s ^ w0s12 ^ w0s16));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_72s ^ w0s05 ^ w0s11 ^ w0s12 ^ w0s13 ^ w0s16 ^ w0s18));
    SHA1_STEP (SHA1_F1 , c, d, e, a, b, (c_73s ^ w0s20));
    SHA1_STEP (SHA1_F1 , b, c, d, e, a, (c_74s ^ w0s08 ^ w0s16));
    SHA1_STEP (SHA1_F1 , a, b, c, d, e, (c_75s ^ w0s06 ^ w0s12 ^ w0s14));

    const u32x c_76s = rotl32 ((c_73s ^ c_68s ^ c_62s ^ c_60s), 1u);
    const u32x c_77s = rotl32 ((c_74s ^ c_69s ^ c_63s ^ c_61s), 1u);
    const u32x c_78s = rotl32 ((c_75s ^ c_70s ^ c_64s ^ c_62s), 1u);
    const u32x c_79s = rotl32 ((c_76s ^ c_71s ^ c_65s ^ c_63s), 1u);

    const u32x w0s21 = rotl32 (w0, 21u);
    const u32x w0s22 = rotl32 (w0, 22U);

    SHA1_STEP (SHA1_F1 , e, a, b, c, d, (c_76s ^ w0s07 ^ w0s08___w0s12 ^ w0s16 ^ w0s21));
    SHA1_STEP (SHA1_F1 , d, e, a, b, c, (c_77s));
    SHA1_STEP (SHA1_F1 , c, d, e, a, b, (c_78s ^ w0s07 ^ w0s08 ^ w0s15 ^ w0s18 ^ w0s20));
    SHA1_STEP (SHA1_F1 , b, c, d, e, a, (c_79s ^ w0s08 ^ w0s22));

    a += SHA1M_A;
    b += SHA1M_B;
    c += SHA1M_C;
    d += SHA1M_D;
    e += SHA1M_E;

    u32x w0_t = a;
    u32x w1_t = b;
    u32x w2_t = c;
    u32x w3_t = d;
    u32x w4_t = e;
    u32x w5_t = 0x80000000;
    u32x w6_t = 0;
    u32x w7_t = 0;
    u32x w8_t = 0;
    u32x w9_t = 0;
    u32x wa_t = 0;
    u32x wb_t = 0;
    u32x wc_t = 0;
    u32x wd_t = 0;
    u32x we_t = 0;
    u32x wf_t = 20 * 8;

    a = SHA1M_A;
    b = SHA1M_B;
    c = SHA1M_C;
    d = SHA1M_D;
    e = SHA1M_E;

    #undef K
    #define K SHA1C00

    SHA1_STEP (SHA1_F0o, a, b, c, d, e, w0_t);
    SHA1_STEP (SHA1_F0o, e, a, b, c, d, w1_t);
    SHA1_STEP (SHA1_F0o, d, e, a, b, c, w2_t);
    SHA1_STEP (SHA1_F0o, c, d, e, a, b, w3_t);
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, w4_t);
    SHA1_STEP (SHA1_F0o, a, b, c, d, e, w5_t);
    SHA1_STEP (SHA1_F0o, e, a, b, c, d, w6_t);
    SHA1_STEP (SHA1_F0o, d, e, a, b, c, w7_t);
    SHA1_STEP (SHA1_F0o, c, d, e, a, b, w8_t);
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, w9_t);
    SHA1_STEP (SHA1_F0o, a, b, c, d, e, wa_t);
    SHA1_STEP (SHA1_F0o, e, a, b, c, d, wb_t);
    SHA1_STEP (SHA1_F0o, d, e, a, b, c, wc_t);
    SHA1_STEP (SHA1_F0o, c, d, e, a, b, wd_t);
    SHA1_STEP (SHA1_F0o, b, c, d, e, a, we_t);
    SHA1_STEP (SHA1_F0o, a, b, c, d, e, wf_t);
    w0_t = rotl32 ((wd_t ^ w8_t ^ w2_t ^ w0_t), 1u); SHA1_STEP (SHA1_F0o, e, a, b, c, d, w0_t);
    w1_t = rotl32 ((we_t ^ w9_t ^ w3_t ^ w1_t), 1u); SHA1_STEP (SHA1_F0o, d, e, a, b, c, w1_t);
    w2_t = rotl32 ((wf_t ^ wa_t ^ w4_t ^ w2_t), 1u); SHA1_STEP (SHA1_F0o, c, d, e, a, b, w2_t);
    w3_t = rotl32 ((w0_t ^ wb_t ^ w5_t ^ w3_t), 1u); SHA1_STEP (SHA1_F0o, b, c, d, e, a, w3_t);

    #undef K
    #define K SHA1C01

    w4_t = rotl32 ((w1_t ^ wc_t ^ w6_t ^ w4_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, w4_t);
    w5_t = rotl32 ((w2_t ^ wd_t ^ w7_t ^ w5_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, w5_t);
    w6_t = rotl32 ((w3_t ^ we_t ^ w8_t ^ w6_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, w6_t);
    w7_t = rotl32 ((w4_t ^ wf_t ^ w9_t ^ w7_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, w7_t);
    w8_t = rotl32 ((w5_t ^ w0_t ^ wa_t ^ w8_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, w8_t);
    w9_t = rotl32 ((w6_t ^ w1_t ^ wb_t ^ w9_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, w9_t);
    wa_t = rotl32 ((w7_t ^ w2_t ^ wc_t ^ wa_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, wa_t);
    wb_t = rotl32 ((w8_t ^ w3_t ^ wd_t ^ wb_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, wb_t);
    wc_t = rotl32 ((w9_t ^ w4_t ^ we_t ^ wc_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, wc_t);
    wd_t = rotl32 ((wa_t ^ w5_t ^ wf_t ^ wd_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, wd_t);
    we_t = rotl32 ((wb_t ^ w6_t ^ w0_t ^ we_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, we_t);
    wf_t = rotl32 ((wc_t ^ w7_t ^ w1_t ^ wf_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, wf_t);
    w0_t = rotl32 ((wd_t ^ w8_t ^ w2_t ^ w0_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, w0_t);
    w1_t = rotl32 ((we_t ^ w9_t ^ w3_t ^ w1_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, w1_t);
    w2_t = rotl32 ((wf_t ^ wa_t ^ w4_t ^ w2_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, w2_t);
    w3_t = rotl32 ((w0_t ^ wb_t ^ w5_t ^ w3_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, w3_t);
    w4_t = rotl32 ((w1_t ^ wc_t ^ w6_t ^ w4_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, w4_t);
    w5_t = rotl32 ((w2_t ^ wd_t ^ w7_t ^ w5_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, w5_t);
    w6_t = rotl32 ((w3_t ^ we_t ^ w8_t ^ w6_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, w6_t);
    w7_t = rotl32 ((w4_t ^ wf_t ^ w9_t ^ w7_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, w7_t);

    #undef K
    #define K SHA1C02

    w8_t = rotl32 ((w5_t ^ w0_t ^ wa_t ^ w8_t), 1u); SHA1_STEP (SHA1_F2o, a, b, c, d, e, w8_t);
    w9_t = rotl32 ((w6_t ^ w1_t ^ wb_t ^ w9_t), 1u); SHA1_STEP (SHA1_F2o, e, a, b, c, d, w9_t);
    wa_t = rotl32 ((w7_t ^ w2_t ^ wc_t ^ wa_t), 1u); SHA1_STEP (SHA1_F2o, d, e, a, b, c, wa_t);
    wb_t = rotl32 ((w8_t ^ w3_t ^ wd_t ^ wb_t), 1u); SHA1_STEP (SHA1_F2o, c, d, e, a, b, wb_t);
    wc_t = rotl32 ((w9_t ^ w4_t ^ we_t ^ wc_t), 1u); SHA1_STEP (SHA1_F2o, b, c, d, e, a, wc_t);
    wd_t = rotl32 ((wa_t ^ w5_t ^ wf_t ^ wd_t), 1u); SHA1_STEP (SHA1_F2o, a, b, c, d, e, wd_t);
    we_t = rotl32 ((wb_t ^ w6_t ^ w0_t ^ we_t), 1u); SHA1_STEP (SHA1_F2o, e, a, b, c, d, we_t);
    wf_t = rotl32 ((wc_t ^ w7_t ^ w1_t ^ wf_t), 1u); SHA1_STEP (SHA1_F2o, d, e, a, b, c, wf_t);
    w0_t = rotl32 ((wd_t ^ w8_t ^ w2_t ^ w0_t), 1u); SHA1_STEP (SHA1_F2o, c, d, e, a, b, w0_t);
    w1_t = rotl32 ((we_t ^ w9_t ^ w3_t ^ w1_t), 1u); SHA1_STEP (SHA1_F2o, b, c, d, e, a, w1_t);
    w2_t = rotl32 ((wf_t ^ wa_t ^ w4_t ^ w2_t), 1u); SHA1_STEP (SHA1_F2o, a, b, c, d, e, w2_t);
    w3_t = rotl32 ((w0_t ^ wb_t ^ w5_t ^ w3_t), 1u); SHA1_STEP (SHA1_F2o, e, a, b, c, d, w3_t);
    w4_t = rotl32 ((w1_t ^ wc_t ^ w6_t ^ w4_t), 1u); SHA1_STEP (SHA1_F2o, d, e, a, b, c, w4_t);
    w5_t = rotl32 ((w2_t ^ wd_t ^ w7_t ^ w5_t), 1u); SHA1_STEP (SHA1_F2o, c, d, e, a, b, w5_t);
    w6_t = rotl32 ((w3_t ^ we_t ^ w8_t ^ w6_t), 1u); SHA1_STEP (SHA1_F2o, b, c, d, e, a, w6_t);
    w7_t = rotl32 ((w4_t ^ wf_t ^ w9_t ^ w7_t), 1u); SHA1_STEP (SHA1_F2o, a, b, c, d, e, w7_t);
    w8_t = rotl32 ((w5_t ^ w0_t ^ wa_t ^ w8_t), 1u); SHA1_STEP (SHA1_F2o, e, a, b, c, d, w8_t);
    w9_t = rotl32 ((w6_t ^ w1_t ^ wb_t ^ w9_t), 1u); SHA1_STEP (SHA1_F2o, d, e, a, b, c, w9_t);
    wa_t = rotl32 ((w7_t ^ w2_t ^ wc_t ^ wa_t), 1u); SHA1_STEP (SHA1_F2o, c, d, e, a, b, wa_t);
    wb_t = rotl32 ((w8_t ^ w3_t ^ wd_t ^ wb_t), 1u); SHA1_STEP (SHA1_F2o, b, c, d, e, a, wb_t);

    #undef K
    #define K SHA1C03

    wc_t = rotl32 ((w9_t ^ w4_t ^ we_t ^ wc_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, wc_t);
    wd_t = rotl32 ((wa_t ^ w5_t ^ wf_t ^ wd_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, wd_t);
    we_t = rotl32 ((wb_t ^ w6_t ^ w0_t ^ we_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, we_t);
    wf_t = rotl32 ((wc_t ^ w7_t ^ w1_t ^ wf_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, wf_t);
    w0_t = rotl32 ((wd_t ^ w8_t ^ w2_t ^ w0_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, w0_t);
    w1_t = rotl32 ((we_t ^ w9_t ^ w3_t ^ w1_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, w1_t);
    w2_t = rotl32 ((wf_t ^ wa_t ^ w4_t ^ w2_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, w2_t);
    w3_t = rotl32 ((w0_t ^ wb_t ^ w5_t ^ w3_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, w3_t);
    w4_t = rotl32 ((w1_t ^ wc_t ^ w6_t ^ w4_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, w4_t);
    w5_t = rotl32 ((w2_t ^ wd_t ^ w7_t ^ w5_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, w5_t);
    w6_t = rotl32 ((w3_t ^ we_t ^ w8_t ^ w6_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, w6_t);
    w7_t = rotl32 ((w4_t ^ wf_t ^ w9_t ^ w7_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, w7_t);
    w8_t = rotl32 ((w5_t ^ w0_t ^ wa_t ^ w8_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, w8_t);
    w9_t = rotl32 ((w6_t ^ w1_t ^ wb_t ^ w9_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, w9_t);
    wa_t = rotl32 ((w7_t ^ w2_t ^ wc_t ^ wa_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, wa_t);
    wb_t = rotl32 ((w8_t ^ w3_t ^ wd_t ^ wb_t), 1u); SHA1_STEP (SHA1_F1, a, b, c, d, e, wb_t);

    if (MATCHES_NONE_VS (e, e_rev)) continue;

    wc_t = rotl32 ((w9_t ^ w4_t ^ we_t ^ wc_t), 1u); SHA1_STEP (SHA1_F1, e, a, b, c, d, wc_t);
    wd_t = rotl32 ((wa_t ^ w5_t ^ wf_t ^ wd_t), 1u); SHA1_STEP (SHA1_F1, d, e, a, b, c, wd_t);
    we_t = rotl32 ((wb_t ^ w6_t ^ w0_t ^ we_t), 1u); SHA1_STEP (SHA1_F1, c, d, e, a, b, we_t);
    wf_t = rotl32 ((wc_t ^ w7_t ^ w1_t ^ wf_t), 1u); SHA1_STEP (SHA1_F1, b, c, d, e, a, wf_t);

    COMPARE_S_SIMD (d, e, c, b);
  }
}

__kernel void m00300_m04 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32x * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV0_buf, __global u32 *d_scryptV1_buf, __global u32 *d_scryptV2_buf, __global u32 *d_scryptV3_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 il_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 w[16];

  w[ 0] = pws[gid].i[ 0];
  w[ 1] = pws[gid].i[ 1];
  w[ 2] = pws[gid].i[ 2];
  w[ 3] = pws[gid].i[ 3];
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
  w[15] = pws[gid].i[15];

  const u32 pw_len = pws[gid].pw_len;

  /**
   * main
   */

  m00300m (w, pw_len, pws, rules_buf, combs_buf, words_buf_r, tmps, hooks, bitmaps_buf_s1_a, bitmaps_buf_s1_b, bitmaps_buf_s1_c, bitmaps_buf_s1_d, bitmaps_buf_s2_a, bitmaps_buf_s2_b, bitmaps_buf_s2_c, bitmaps_buf_s2_d, plains_buf, digests_buf, hashes_shown, salt_bufs, esalt_bufs, d_return_buf, d_scryptV0_buf, d_scryptV1_buf, d_scryptV2_buf, d_scryptV3_buf, bitmap_mask, bitmap_shift1, bitmap_shift2, salt_pos, loop_pos, loop_cnt, il_cnt, digests_cnt, digests_offset);
}

__kernel void m00300_m08 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32x * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV0_buf, __global u32 *d_scryptV1_buf, __global u32 *d_scryptV2_buf, __global u32 *d_scryptV3_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 il_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 w[16];

  w[ 0] = pws[gid].i[ 0];
  w[ 1] = pws[gid].i[ 1];
  w[ 2] = pws[gid].i[ 2];
  w[ 3] = pws[gid].i[ 3];
  w[ 4] = pws[gid].i[ 4];
  w[ 5] = pws[gid].i[ 5];
  w[ 6] = pws[gid].i[ 6];
  w[ 7] = pws[gid].i[ 7];
  w[ 8] = 0;
  w[ 9] = 0;
  w[10] = 0;
  w[11] = 0;
  w[12] = 0;
  w[13] = 0;
  w[14] = 0;
  w[15] = pws[gid].i[15];

  const u32 pw_len = pws[gid].pw_len;

  /**
   * main
   */

  m00300m (w, pw_len, pws, rules_buf, combs_buf, words_buf_r, tmps, hooks, bitmaps_buf_s1_a, bitmaps_buf_s1_b, bitmaps_buf_s1_c, bitmaps_buf_s1_d, bitmaps_buf_s2_a, bitmaps_buf_s2_b, bitmaps_buf_s2_c, bitmaps_buf_s2_d, plains_buf, digests_buf, hashes_shown, salt_bufs, esalt_bufs, d_return_buf, d_scryptV0_buf, d_scryptV1_buf, d_scryptV2_buf, d_scryptV3_buf, bitmap_mask, bitmap_shift1, bitmap_shift2, salt_pos, loop_pos, loop_cnt, il_cnt, digests_cnt, digests_offset);
}

__kernel void m00300_m16 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32x * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV0_buf, __global u32 *d_scryptV1_buf, __global u32 *d_scryptV2_buf, __global u32 *d_scryptV3_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 il_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 w[16];

  w[ 0] = pws[gid].i[ 0];
  w[ 1] = pws[gid].i[ 1];
  w[ 2] = pws[gid].i[ 2];
  w[ 3] = pws[gid].i[ 3];
  w[ 4] = pws[gid].i[ 4];
  w[ 5] = pws[gid].i[ 5];
  w[ 6] = pws[gid].i[ 6];
  w[ 7] = pws[gid].i[ 7];
  w[ 8] = pws[gid].i[ 8];
  w[ 9] = pws[gid].i[ 9];
  w[10] = pws[gid].i[10];
  w[11] = pws[gid].i[11];
  w[12] = pws[gid].i[12];
  w[13] = pws[gid].i[13];
  w[14] = pws[gid].i[14];
  w[15] = pws[gid].i[15];

  const u32 pw_len = pws[gid].pw_len;

  /**
   * main
   */

  m00300m (w, pw_len, pws, rules_buf, combs_buf, words_buf_r, tmps, hooks, bitmaps_buf_s1_a, bitmaps_buf_s1_b, bitmaps_buf_s1_c, bitmaps_buf_s1_d, bitmaps_buf_s2_a, bitmaps_buf_s2_b, bitmaps_buf_s2_c, bitmaps_buf_s2_d, plains_buf, digests_buf, hashes_shown, salt_bufs, esalt_bufs, d_return_buf, d_scryptV0_buf, d_scryptV1_buf, d_scryptV2_buf, d_scryptV3_buf, bitmap_mask, bitmap_shift1, bitmap_shift2, salt_pos, loop_pos, loop_cnt, il_cnt, digests_cnt, digests_offset);
}

__kernel void m00300_s04 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32x * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV0_buf, __global u32 *d_scryptV1_buf, __global u32 *d_scryptV2_buf, __global u32 *d_scryptV3_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 il_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 w[16];

  w[ 0] = pws[gid].i[ 0];
  w[ 1] = pws[gid].i[ 1];
  w[ 2] = pws[gid].i[ 2];
  w[ 3] = pws[gid].i[ 3];
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
  w[15] = pws[gid].i[15];

  const u32 pw_len = pws[gid].pw_len;

  /**
   * main
   */

  m00300s (w, pw_len, pws, rules_buf, combs_buf, words_buf_r, tmps, hooks, bitmaps_buf_s1_a, bitmaps_buf_s1_b, bitmaps_buf_s1_c, bitmaps_buf_s1_d, bitmaps_buf_s2_a, bitmaps_buf_s2_b, bitmaps_buf_s2_c, bitmaps_buf_s2_d, plains_buf, digests_buf, hashes_shown, salt_bufs, esalt_bufs, d_return_buf, d_scryptV0_buf, d_scryptV1_buf, d_scryptV2_buf, d_scryptV3_buf, bitmap_mask, bitmap_shift1, bitmap_shift2, salt_pos, loop_pos, loop_cnt, il_cnt, digests_cnt, digests_offset);
}

__kernel void m00300_s08 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32x * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV0_buf, __global u32 *d_scryptV1_buf, __global u32 *d_scryptV2_buf, __global u32 *d_scryptV3_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 il_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 w[16];

  w[ 0] = pws[gid].i[ 0];
  w[ 1] = pws[gid].i[ 1];
  w[ 2] = pws[gid].i[ 2];
  w[ 3] = pws[gid].i[ 3];
  w[ 4] = pws[gid].i[ 4];
  w[ 5] = pws[gid].i[ 5];
  w[ 6] = pws[gid].i[ 6];
  w[ 7] = pws[gid].i[ 7];
  w[ 8] = 0;
  w[ 9] = 0;
  w[10] = 0;
  w[11] = 0;
  w[12] = 0;
  w[13] = 0;
  w[14] = 0;
  w[15] = pws[gid].i[15];

  const u32 pw_len = pws[gid].pw_len;

  /**
   * main
   */

  m00300s (w, pw_len, pws, rules_buf, combs_buf, words_buf_r, tmps, hooks, bitmaps_buf_s1_a, bitmaps_buf_s1_b, bitmaps_buf_s1_c, bitmaps_buf_s1_d, bitmaps_buf_s2_a, bitmaps_buf_s2_b, bitmaps_buf_s2_c, bitmaps_buf_s2_d, plains_buf, digests_buf, hashes_shown, salt_bufs, esalt_bufs, d_return_buf, d_scryptV0_buf, d_scryptV1_buf, d_scryptV2_buf, d_scryptV3_buf, bitmap_mask, bitmap_shift1, bitmap_shift2, salt_pos, loop_pos, loop_cnt, il_cnt, digests_cnt, digests_offset);
}

__kernel void m00300_s16 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32x * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV0_buf, __global u32 *d_scryptV1_buf, __global u32 *d_scryptV2_buf, __global u32 *d_scryptV3_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 il_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 w[16];

  w[ 0] = pws[gid].i[ 0];
  w[ 1] = pws[gid].i[ 1];
  w[ 2] = pws[gid].i[ 2];
  w[ 3] = pws[gid].i[ 3];
  w[ 4] = pws[gid].i[ 4];
  w[ 5] = pws[gid].i[ 5];
  w[ 6] = pws[gid].i[ 6];
  w[ 7] = pws[gid].i[ 7];
  w[ 8] = pws[gid].i[ 8];
  w[ 9] = pws[gid].i[ 9];
  w[10] = pws[gid].i[10];
  w[11] = pws[gid].i[11];
  w[12] = pws[gid].i[12];
  w[13] = pws[gid].i[13];
  w[14] = pws[gid].i[14];
  w[15] = pws[gid].i[15];

  const u32 pw_len = pws[gid].pw_len;

  /**
   * main
   */

  m00300s (w, pw_len, pws, rules_buf, combs_buf, words_buf_r, tmps, hooks, bitmaps_buf_s1_a, bitmaps_buf_s1_b, bitmaps_buf_s1_c, bitmaps_buf_s1_d, bitmaps_buf_s2_a, bitmaps_buf_s2_b, bitmaps_buf_s2_c, bitmaps_buf_s2_d, plains_buf, digests_buf, hashes_shown, salt_bufs, esalt_bufs, d_return_buf, d_scryptV0_buf, d_scryptV1_buf, d_scryptV2_buf, d_scryptV3_buf, bitmap_mask, bitmap_shift1, bitmap_shift2, salt_pos, loop_pos, loop_cnt, il_cnt, digests_cnt, digests_offset);
}
