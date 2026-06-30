import 'package:bears_video/src/rust/models/recommend_video.dart';

HomeRecommendData get mockHomeRecommend => mockHomeRecommendData;

final mockHomeRecommendData = HomeRecommendData(
  banners: [
    BannerItem(
      id: 1,
      name: 'live',
      content: 'https://pic1.imgdb.cn/item/69bccd30ed27ae3d10a960ed.jpg',
      reqType: 1,
      reqContent: '500502',
      realPackageId: '',
    ),
    BannerItem(
      id: 2,
      name: '偷偷藏不住',
      content: 'https://cdnjson.com/images/2023/07/26/p2894000057.webp',
      reqType: 1,
      reqContent: '728',
      realPackageId: '',
    ),
  ],
  videos: [
    HomeVideoSection(
      id: 1,
      name: '热播剧',
      typeId: 0,
      hasMore: false,
      moreReqType: 2,
      moreText: '',
      vlist: [
        VodItem(
          vodId: 179254,
          vodName: '佳偶天成',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2026-04-25/202604251777090358.jpg',
          vodRemarks: '40集',
          typeId: 2,
        ),
        VodItem(
          vodId: 597886,
          vodName: '低智商犯罪',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2026-05-04/202605041777888534.jpg',
          vodRemarks: '24集',
          typeId: 2,
        ),
        VodItem(
          vodId: 58065,
          vodName: '耀眼',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2026-05-27/202605271779853901.jpg',
          vodRemarks: '全30集',
          typeId: 2,
        ),
        VodItem(
          vodId: 601173,
          vodName: '翘楚',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2026-06-02/202606021780373454.jpg',
          vodRemarks: '全24集',
          typeId: 2,
        ),
        VodItem(
          vodId: 604038,
          vodName: '莫离',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2026-06-09/202606091780976542.jpg',
          vodRemarks: '非璃墨属跑男默契大挑战集全',
          typeId: 2,
        ),
        VodItem(
          vodId: 603968,
          vodName: '迷墙',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2026-06-07/202606071780833175.jpg',
          vodRemarks: '更新至20集',
          typeId: 2,
        ),
      ],
    ),
    HomeVideoSection(
      id: 2,
      name: '日韩',
      typeId: 0,
      hasMore: false,
      moreReqType: 0,
      moreText: '',
      vlist: [
        VodItem(
          vodId: 603732,
          vodName: '铁拳教育',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2026-06-05/202606051780650774.jpg',
          vodRemarks: '全10集',
          typeId: 2,
        ),
        VodItem(
          vodId: 47642,
          vodName: '死期将至',
          vodPic:
              'https://pps.vodfeiss.com/upload/vod/20221031-1/1f0239447520e49e3901ea1024ac4f5f.jpg',
          vodRemarks: 'HD',
          typeId: 1,
        ),
        VodItem(
          vodId: 189206,
          vodName: '与恶魔有约',
          vodPic:
              'https://pps.vodfeiss.com/upload/vod/20231124-1/2233f235d4eb5c358d422fdbdaaf3e00.jpg',
          vodRemarks: '16集全',
          typeId: 2,
        ),
        VodItem(
          vodId: 195080,
          vodName: '京城怪物',
          vodPic:
              'https://pps.vodfeiss.com/upload/vod/20231222-1/ee0898512dc68a8caf9de74bc6f5368d.jpg',
          vodRemarks: '已完结',
          typeId: 2,
        ),
        VodItem(
          vodId: 204057,
          vodName: '请和我的老公结婚',
          vodPic:
              'https://wework.qpic.cn/wwpic3az/857587_ByQ90pnPQKCnLgE_1704381401/0',
          vodRemarks: '已完结',
          typeId: 2,
        ),
        VodItem(
          vodId: 300462,
          vodName: '寄生兽：灰色部队',
          vodPic:
              'https://pps.vodfeiss.com/upload/vod/20240405-1/b01c1ff1aa654467ac177b1e4bc296b1.jpg',
          vodRemarks: '已完结',
          typeId: 2,
        ),
      ],
    ),
    HomeVideoSection(
      id: 3,
      name: '热播漫',
      typeId: 0,
      hasMore: false,
      moreReqType: 2,
      moreText: '',
      vlist: [
        VodItem(
          vodId: 162798,
          vodName: '仙逆',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2023-09-25/16956175061.jpg',
          vodRemarks: '更新至147集',
          typeId: 4,
        ),
        VodItem(
          vodId: 510572,
          vodName: '剑来第二季',
          vodPic:
              'https://img.jisuimage.com/cover/46ca629891f3c3bd16b4a4978d31e483.jpg',
          vodRemarks: '更至陈平安角色曲本心集全',
          typeId: 4,
        ),
        VodItem(
          vodId: 43504,
          vodName: '凡人修仙传',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2022-04-03/16489732380.jpg',
          vodRemarks: '更新至180集',
          typeId: 4,
        ),
        VodItem(
          vodId: 221,
          vodName: '完美世界',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2022-04-01/16487822345.jpg',
          vodRemarks: '更新至275集',
          typeId: 4,
        ),
        VodItem(
          vodId: 399619,
          vodName: '牧神记',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2024-10-27/17299975721.jpg',
          vodRemarks: '更新至89集',
          typeId: 4,
        ),
        VodItem(
          vodId: 2357,
          vodName: '吞噬星空',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2022-04-13/16498245015.jpg',
          vodRemarks: '230',
          typeId: 4,
        ),
      ],
    ),
    HomeVideoSection(
      id: 4,
      name: '热播漫',
      typeId: 0,
      hasMore: false,
      moreReqType: 2,
      moreText: '',
      vlist: [
        VodItem(
          vodId: 162798,
          vodName: '仙逆',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2023-09-25/16956175061.jpg',
          vodRemarks: '更新至147集',
          typeId: 4,
        ),
        VodItem(
          vodId: 510572,
          vodName: '剑来第二季',
          vodPic:
              'https://img.jisuimage.com/cover/46ca629891f3c3bd16b4a4978d31e483.jpg',
          vodRemarks: '更至陈平安角色曲本心集全',
          typeId: 4,
        ),
        VodItem(
          vodId: 43504,
          vodName: '凡人修仙传',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2022-04-03/16489732380.jpg',
          vodRemarks: '更新至180集',
          typeId: 4,
        ),
        VodItem(
          vodId: 221,
          vodName: '完美世界',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2022-04-01/16487822345.jpg',
          vodRemarks: '更新至275集',
          typeId: 4,
        ),
        VodItem(
          vodId: 399619,
          vodName: '牧神记',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2024-10-27/17299975721.jpg',
          vodRemarks: '更新至89集',
          typeId: 4,
        ),
        VodItem(
          vodId: 2357,
          vodName: '吞噬星空',
          vodPic:
              'https://pic3.yzzyimg.online/upload/vod/2022-04-13/16498245015.jpg',
          vodRemarks: '230',
          typeId: 4,
        ),
      ],
    ),
    HomeVideoSection(
      id: 5,
      name: '热播综艺',
      typeId: 3,
      hasMore: true,
      moreReqType: 1,
      moreText: '',
      vlist: [
        VodItem(
          vodId: 399041,
          vodName: '现在就出发第二季',
          vodPic:
              'http://2fimg.youkuyouku.pro/pic/55758e26dd5eb794d23d1ad51443e79b',
          vodRemarks: '正片',
          typeId: 3,
        ),
        VodItem(
          vodId: 497242,
          vodName: '现在就出发第三季',
          vodPic:
              'https://img.jisuimage.com/cover/85ff7d09978a519342151403940ca43e.jpg',
          vodRemarks: '正片',
          typeId: 3,
        ),
        VodItem(
          vodId: 40984,
          vodName: '你好星期六',
          vodPic:
              'https://pps.vodfeiss.com/upload/vod/20221102-1/fd6e7b0bc241ae5ef8487bc864aad9f4.jpg',
          vodRemarks: '20260629(会员精选)',
          typeId: 3,
        ),
        VodItem(
          vodId: 434745,
          vodName: '哈哈哈哈哈第五季',
          vodPic:
              'https://img.jisuimage.com/cover/576a43faa848c65a59e47f3a533a9fe1.jpg',
          vodRemarks: '更新至20250630期',
          typeId: 3,
        ),
        VodItem(
          vodId: 276808,
          vodName: '哈哈哈哈哈第四季',
          vodPic:
              'http://2fimg.youkuyouku.pro/pic/d604e41d0caf5dee5336b6e8a5fa495e',
          vodRemarks: '已完结',
          typeId: 3,
        ),
        VodItem(
          vodId: 557545,
          vodName: '哈哈哈哈哈第六季',
          vodPic:
              'https://img.lzipic.com/upload/vod/20260401-1/a01209e1e57a7f5db64f02810c756efe.webp',
          vodRemarks: '20260628(第2期精编回顾)',
          typeId: 3,
        ),
      ],
    ),
  ],
);
