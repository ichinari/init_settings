-- カスタムASCIIアート
-- 好きなAAをここに追加してください
-- 各行を [[...]] で囲んで配列に入れます

local M = {}

-- カスタムAA
M.custom = {
  [[                                                                                                   ]],
  [[                                  .               .                                                ]],
  [[                                 ...              ..                                               ]],
  [[                                #1XMa,          .dB0d,                                             ]],
  [[                               .@:JNOHm........JBQ#z<J]                                            ]],
  [[                               .b:zWEttd0dSwWVUrd#T<:J>                                            ]],
  [[                               NJ6tttwSdStXOttttdX-<#  ..+kMMMMMMMMNa,.                            ]],
  [[                              .MOtttrttZttwttrttrttdMMMStrZWpkttdpWttWMN,                          ]],
  [[                              dItttr0tttttZ8OttrttrtMsZWkttZWpOttWprtdbRTN,                        ]],
  [[                             .NAtGOttrttrttttrttwwdXW#ttWRttdpZrtdKttdWOtdMb                       ]],
  [[                          (?<<dmQytVH5z1ztwMHMM0trOttd#ttdRtrdprttZOtt0ttOXKdb                     ]],
  [[                          ..-?WKkt>:?MN@:?OtttXVBBBWMNytrtttO6ttGg8tttOdpUttMNJ.                   ]],
  [[                             7N+:jJJh((J:?1tZBWmgMSttttrtttttq#OtrtZUVttttdNdMm,                   ]],
  [[                          .dBWMNgJ_:?>:::(<jjgMSZ9IttQtttttOMOtttrtttttttdNKZOMm.                  ]],
  [[                         .#<?1OtXkHM#9UOzzlOIwytwwwttrdb+111?NttttttttttttdMmAXpWN,                ]],
  [[                        .#::::(mQNNNMgesOzzlllNVUVVU0tdNgggggMNytrtrttrttdF ,MkttZN                ]],
  [[                       .M@s:(:J= dMNN!JMNN#??(NAAAOttG# dMNM[ .4MNNmK6tttdFdMM#dkmd]               ]],
  [[                       .MNNNMF   dNMM! MMMN. dSttZU0q#  dNMN[  (M#=ztttGd .MNM#UUWMF               ]],
  [[                       .MMNMNM,  dMNM~ JMNM].#ttttqMM%  dMMM) .#>:::(uM   dNMNSwttd]               ]],
  [[                       .MMNMMMN. dMNM~  MMNNJ6OtttMM#   dNMN) Jyr<p(+MM, .MMMMbkkkM                ]],
  [[                        NMM@WNMN.dNMM~  JMMNM::::(MN%   dMNM)  JNMM=MMMb JMM0ttZWM$                ]],
  [[                        MNN# MNMbdMNM~   MMNMmc:G(M#    dMNM)  (MMN~JNMN.MHkkkOGMN_                ]],
  [[                        MMM# ,MMNMNMN_   JMMN/74NMN%    dMMN}  (MNN~ MMMMHkkbHNNMM_                ]],
  [[                        MNM#  -NMNMNM_    MMMb dMN#     dMNM}  (MMM~ JNMNMNNT dMNN_                ]],
  [[                        NMN#   dMNMMN_    JNNM.NMM%     dMMN}  -NMN~  MMMNM   dMNM_                ]],
  [[                        MNM#    WMNMM_     MMNMNM#      dNMM}  -MNM~  ?NNMF   dMMN_                ]],
  [[                        MMN#     MNMN      (MNMMN%      dMNN}  -MMN~          dMNM_                ]],
  [[                                                                                                   ]],
  [[                                                                                                   ]],
}

-- 別の例: シンプルなNeovimロゴ
M.neovim = {
  [[                                                    ]],
  [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
  [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
  [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
  [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
  [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
  [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
  [[                                                    ]],
}

-- シンプルな猫
M.cat = {
  [[       /\_/\  ]],
  [[      ( o.o ) ]],
  [[       > ^ <  ]],
  [[      /|   |\ ]],
  [[     (_|   |_)]],
}

-- 使用するAAを選択（M.custom, M.neovim, M.cat など）
M.selected = M.custom

return M
