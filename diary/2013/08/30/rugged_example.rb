# -*- coding: utf-8 -*-
require 'rugged'

repo = Rugged::Repository.new('/home/niku/nikulog/.git')
# リポジトリが空かなー
p repo.empty?                   # => false

# 最新どこかなー
p repo.head                     # => #<Rugged::Reference:70000270978500 {name: "refs/heads/master", target: "bdb17d0daebcd398635af5e8549431d16609c0dc"}>

# refs 何があるのかなー
p repo.refs.map(&:name)         # => ["refs/heads/master", "refs/heads/origin-config", "refs/remotes/origin/HEAD", "refs/remotes/origin/config", "refs/remotes/origin/master"]

# ブランチ指定
branch = Rugged::Branch.lookup(repo, 'master')

# ブランチ名
p branch.name                   # => "master"

# branch にできることなにかなー
p branch.public_methods(false)  # => [:delete!, :rename, :move, :head?, :tip, :==, :canonical_name, :name]

# tip
p branch.tip
# =>
# #<Rugged::Commit:70152333116640 {message: "Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する - 5. ユーザー名 ( フルネーム ) 入力待ちで止まる\n", tree: #<Rugged::Tree:70152333116520 {oid: ff835ebc74188be69dc3151fe473019f222d6f34}>
#   <"diary" 0341ab04500cd7a7e6ced7384beee7fa6892a091>
#   <"wiki" eef760277c858fae681dc151ae18235f3a25fda9>
# , parents: ["4efd470bdea29a3beecda168efb323b34dc9ce1e"]}>

# tip にできることなにかなー
p branch.tip.public_methods(false) # => [:message, :epoch_time, :committer, :author, :tree, :tree_id, :tree_oid, :parents, :parent_ids, :parent_oids, :inspect, :diff, :diff_workdir, :time, :to_hash, :modify]

# tree とは
p branch.tip.tree
# =>
# #<Rugged::Tree:69877652348960 {oid: 21103f6647f0647627e281e3954887dfff53edf1}>
#   <"diary" 0341ab04500cd7a7e6ced7384beee7fa6892a091>
#   <"wiki" 0930b289d499742eba2d78e4ca3b0de91f3e522b>

# ツリー指定
tree = branch.tip.tree

# tree ってなにかなー
p tree.class                    # => Rugged::Tree

# tree にできることなにかなー
p tree.public_methods(false)    # => [:count, :length, :get_entry, :get_entry_by_oid, :path, :diff, :diff_workdir, :[], :each, :walk, :inspect, :walk_blobs, :walk_trees, :each_blob, :each_tree]

# each_tree
tree.each_tree { |entry| p entry[:name] }
# =>
# "diary"
# "wiki"

# waker 指定
walker = tree.walk(:postorder)
loop do
  p walker.next
end
# =>
# ["diary/2011/07/02/", {:name=>"Ruby勉強会@札幌-18.org", :oid=>"24f92bff067eb5c49b4fafbb96bff7ece96b4857", :filemode=>33188, :type=>:blob}]
# ["diary/2011/07/", {:name=>"02", :oid=>"361d4f15c00197e5c56c0bad4679748acde401af", :filemode=>16384, :type=>:tree}]
# ["diary/2011/07/03/", {:name=>"6時間リレーマラソンin札幌ドーム", :oid=>"8301e5b45f7c008f6334094f053917dd6ae82603", :filemode=>33188, :type=>:blob}]
# ["diary/2011/07/", {:name=>"03", :oid=>"c2d35efa8faab315ecbc5a87bb9a13524a326218", :filemode=>16384, :type=>:tree}]
# ["diary/2011/07/04/", {:name=>"dired再読み込み", :oid=>"cfa9348742617590a4217c26a93fbf84f36298bc", :filemode=>33188, :type=>:blob}]
# ["diary/2011/07/", {:name=>"04", :oid=>"56a231bac65b4e3d2afd2c96ac453e7e74d7e7e4", :filemode=>16384, :type=>:tree}]
# ["diary/2011/07/05/", {:name=>"パスを引き出す動き", :oid=>"236ea956868bda317bec6b391f303dfdc35f9053", :filemode=>33188, :type=>:blob}]
# ["diary/2011/07/05/", {:name=>"プロジェクト打ち上げ", :oid=>"92faa0ed57db9d29ccebbd7e60c99598dfdf465b", :filemode=>33188, :type=>:blob}]
# ["diary/2011/07/", {:name=>"05", :oid=>"ee48a5e2786a44c2b3d08db2b2686c51c3c92788", :filemode=>16384, :type=>:tree}]
# ["diary/2011/", {:name=>"07", :oid=>"1d114b89f67e929596cb89b926d216dba7a60be1", :filemode=>16384, :type=>:tree}]
# ["diary/2011/08/07/", {:name=>"披露宴打ち合わせ", :oid=>"6fa278f3993e7c9eaa4bea47a86c31773a729cdf", :filemode=>33261, :type=>:blob}]
# ["diary/2011/08/", {:name=>"07", :oid=>"ccc4cf075d07d4b0dbb326021bce90ae125cd29b", :filemode=>16384, :type=>:tree}]
# ["diary/2011/", {:name=>"08", :oid=>"6cfbdcacd7279d67725458a1d796eabce6cf633b", :filemode=>16384, :type=>:tree}]
# ["diary/2011/09/01/", {:name=>"出直し", :oid=>"6ac34f829eb02fa048eca4ac59067f4737b74112", :filemode=>33188, :type=>:blob}]
# ["diary/2011/09/", {:name=>"01", :oid=>"98373c7fc0fb1ed595f0a20eb24369c77267ef97", :filemode=>16384, :type=>:tree}]
# ["diary/2011/", {:name=>"09", :oid=>"57927fdfeebd6c875e3f5d5060b7394c4bbfbed9", :filemode=>16384, :type=>:tree}]
# ["diary/2011/10/08/", {:name=>"全文検索エンジンgroongaを囲む昼下がりに参加した.org", :oid=>"335d18f9559e054944ac696b4a95a1d44c9acded", :filemode=>33188, :type=>:blob}]
# ["diary/2011/10/", {:name=>"08", :oid=>"cbb70a14f71d7ce8fc630e8291f064b1e0a85ecd", :filemode=>16384, :type=>:tree}]
# ["diary/2011/10/15/", {:name=>"Devdoに参加した", :oid=>"9027069121289795e625996cfd4a6e2cb0a0a7af", :filemode=>33188, :type=>:blob}]
# ["diary/2011/10/", {:name=>"15", :oid=>"0e8f195fc1ae20f17b95d65d18a22e3fb4bf3be5", :filemode=>16384, :type=>:tree}]
# ["diary/2011/10/22/", {:name=>"Ruby勉強会に参加した.org", :oid=>"3ef9223da725e28094f0bb17f742b057d93afe60", :filemode=>33188, :type=>:blob}]
# ["diary/2011/10/", {:name=>"22", :oid=>"34e705ed1f721572e6b5f41bdcace8be299ec25b", :filemode=>16384, :type=>:tree}]
# ["diary/2011/10/23/", {:name=>"OSをLionに変更した.org", :oid=>"ed4a6c0d758ff79e875d88d302a8f6b938d84977", :filemode=>33188, :type=>:blob}]
# ["diary/2011/10/", {:name=>"23", :oid=>"225aa7f68b15c13aa8961038164c871a007371f4", :filemode=>16384, :type=>:tree}]
# ["diary/2011/10/24/", {:name=>"液晶ディスプレイを人に譲った.org", :oid=>"9fb1dd481634a2bf6c4c781a1b074407c1b89608", :filemode=>33188, :type=>:blob}]
# ["diary/2011/10/", {:name=>"24", :oid=>"7854f82dc8005cc0bf10a43f7916d93eaf90fa38", :filemode=>16384, :type=>:tree}]
# ["diary/2011/10/25/", {:name=>"寒くなってきた.org", :oid=>"79ff77a740c8a22db6a07e99364891ffd568a364", :filemode=>33188, :type=>:blob}]
# ["diary/2011/10/", {:name=>"25", :oid=>"292d68c92b5e24b982088f369c7df68f5b2953da", :filemode=>16384, :type=>:tree}]
# ["diary/2011/10/26/", {:name=>"2011 J2 第7節 徳島0-2札幌.org", :oid=>"3ed168253850eed8c67f52059f2807c80d913731", :filemode=>33188, :type=>:blob}]
# ["diary/2011/10/", {:name=>"26", :oid=>"b5c08db22a6b19119df0ce3d0b13305f8d619de4", :filemode=>16384, :type=>:tree}]
# ["diary/2011/10/27/", {:name=>"gomokuが強い.org", :oid=>"af753b15d44d6c14b1c1ff7f5baf559aab6e7376", :filemode=>33188, :type=>:blob}]
# ["diary/2011/10/", {:name=>"27", :oid=>"cd41cc61ad5d7bcc95698c2822a5aa81e2387959", :filemode=>16384, :type=>:tree}]
# ["diary/2011/10/28/", {:name=>"物事の重み付け.org", :oid=>"ac075d350baf65988292fe8f12a4795c600980d7", :filemode=>33188, :type=>:blob}]
# ["diary/2011/10/", {:name=>"28", :oid=>"a65922a5459d6a7c40609c297cd0089c23302963", :filemode=>16384, :type=>:tree}]
# ["diary/2011/10/29/", {:name=>"オロオロすることしかできない.org", :oid=>"d876bf69a1584b9d9f73de2df662b1b81ee9fce4", :filemode=>33188, :type=>:blob}]
# ["diary/2011/10/", {:name=>"29", :oid=>"debcb9b799dcf5274c97fef151432589107b99df", :filemode=>16384, :type=>:tree}]
# ["diary/2011/", {:name=>"10", :oid=>"268f14a3c8af08611faa920f118207076d4eb681", :filemode=>16384, :type=>:tree}]
# ["diary/2011/11/06/", {:name=>"gem生成用スクリプトを作った.org", :oid=>"00c55a88777f94673df61b4594f1425cfd93eada", :filemode=>33188, :type=>:blob}]
# ["diary/2011/11/", {:name=>"06", :oid=>"9fe4cb2bd597fea0fe3b6f2e0fcaec551f6f0174", :filemode=>16384, :type=>:tree}]
# ["diary/2011/11/12/", {:name=>"YAGNIが適用できるのはプログラムだけじゃない.org", :oid=>"816601073667d0fe805ad90c19c93ff2bfbf5dcd", :filemode=>33188, :type=>:blob}]
# ["diary/2011/11/", {:name=>"12", :oid=>"516667cfe779ccaa5e6869cf695fb9fe65a17c4c", :filemode=>16384, :type=>:tree}]
# ["diary/2011/11/16/", {:name=>"朝kell1回目.org", :oid=>"d067ec332b8c56b7923e4aabc8985c4c6f589ec7", :filemode=>33188, :type=>:blob}]
# ["diary/2011/11/", {:name=>"16", :oid=>"ef03cf8f11f2aa52460875cdabd384ace323b0f4", :filemode=>16384, :type=>:tree}]
# ["diary/2011/11/17/", {:name=>"朝kell2回目.org", :oid=>"09df67b2039c1ce0ef3531e324f35c3f4bf2c878", :filemode=>33188, :type=>:blob}]
# ["diary/2011/11/", {:name=>"17", :oid=>"61003ab5c138ef94d22391545e3e4c36f99fab75", :filemode=>16384, :type=>:tree}]
# ["diary/2011/11/18/", {:name=>"朝kell3回目.org", :oid=>"4adc9fc6fc2c76a577aef10fd5c1e8414799e2a1", :filemode=>33188, :type=>:blob}]
# ["diary/2011/11/", {:name=>"18", :oid=>"bcd2215fc36c6f892e28e7a1c3241a9c3916152e", :filemode=>16384, :type=>:tree}]
# ["diary/2011/11/29/", {:name=>"朝kell8回目.org", :oid=>"a0168596971690747b9bf725d7dc2b64f4861e87", :filemode=>33188, :type=>:blob}]
# ["diary/2011/11/", {:name=>"29", :oid=>"0850299efe86199778752881ffdecef66b20824d", :filemode=>16384, :type=>:tree}]
# ["diary/2011/11/30/", {:name=>"朝kell9回目", :oid=>"86ae32f72fd0efbfe6b3b983b1454288c367b706", :filemode=>33188, :type=>:blob}]
# ["diary/2011/11/", {:name=>"30", :oid=>"4765ad3e96512ed925715747c3b27c64ed498ee5", :filemode=>16384, :type=>:tree}]
# ["diary/2011/", {:name=>"11", :oid=>"c50eba686bdd1a0c25f385f3cfc323ef60ea2c23", :filemode=>16384, :type=>:tree}]
# ["diary/2011/12/01/", {:name=>"朝kell10回目", :oid=>"2e08bc2d10e556d85a9872f5e6eb37038b173d5e", :filemode=>33188, :type=>:blob}]
# ["diary/2011/12/", {:name=>"01", :oid=>"95e726216e551a9c8c0686cf1bbc9a238d80301c", :filemode=>16384, :type=>:tree}]
# ["diary/2011/12/02/", {:name=>"朝kell11回目", :oid=>"db2906932d0261fa5006e139dd1d3f467700a931", :filemode=>33188, :type=>:blob}]
# ["diary/2011/12/", {:name=>"02", :oid=>"4f4d27fba405f6addf44dde74342137fc72b78ec", :filemode=>16384, :type=>:tree}]
# ["diary/2011/12/05/", {:name=>"朝kell12回目", :oid=>"94718e7945516cfe6a5623cd8059bdeddad60b64", :filemode=>33188, :type=>:blob}]
# ["diary/2011/12/", {:name=>"05", :oid=>"b3fd00f98ca5c9b9c872f2ca69cbcb723912d0f1", :filemode=>16384, :type=>:tree}]
# ["diary/2011/12/07/", {:name=>"朝kell13回目", :oid=>"bb7f04bb1e071b1a2fef798912413940b551dd93", :filemode=>33188, :type=>:blob}]
# ["diary/2011/12/", {:name=>"07", :oid=>"22594a8b7dcc789042f4d39aec010d2bc7d3d7b8", :filemode=>16384, :type=>:tree}]
# ["diary/2011/12/08/", {:name=>"朝kell14回目", :oid=>"9dd7d79e8cdf3c258391a0beb5fb9312f4665b99", :filemode=>33188, :type=>:blob}]
# ["diary/2011/12/", {:name=>"08", :oid=>"141a8f7286972555b68455c71c29c168be3af06a", :filemode=>16384, :type=>:tree}]
# ["diary/2011/12/12/", {:name=>"朝kell15回目.org", :oid=>"a7ca031c3c989086212db36604ea382ae499ee41", :filemode=>33188, :type=>:blob}]
# ["diary/2011/12/", {:name=>"12", :oid=>"a205ce1a89858830073bae4162c3868cb8b67c68", :filemode=>16384, :type=>:tree}]
# ["diary/2011/12/13/", {:name=>"朝kell16回目.org", :oid=>"e6b412a9e499f65ab3a21651a4f46e7bde779d66", :filemode=>33188, :type=>:blob}]
# ["diary/2011/12/", {:name=>"13", :oid=>"b00291d9ef3cefaf39f7ade305bac2c3663f9801", :filemode=>16384, :type=>:tree}]
# ["diary/2011/12/15/", {:name=>"朝kell18回目.org", :oid=>"9214f4ba15ca1eaf2279216d1cd4882f2911ed75", :filemode=>33188, :type=>:blob}]
# ["diary/2011/12/", {:name=>"15", :oid=>"c5a86e42f0fc07ce6b215518f00b6f90b6f4bf37", :filemode=>16384, :type=>:tree}]
# ["diary/2011/12/22/", {:name=>"ストレングス・ファインダーをやってみた.org", :oid=>"34fcd417b9e98411439b33938b1338d649d1af4a", :filemode=>33188, :type=>:blob}]
# ["diary/2011/12/", {:name=>"22", :oid=>"082190414776fbe41d4b06460eaf2423bea70a50", :filemode=>16384, :type=>:tree}]
# ["diary/2011/", {:name=>"12", :oid=>"8ca5a1e4c1d955320fd9bfa6df196d7e61da501f", :filemode=>16384, :type=>:tree}]
# ["diary/", {:name=>"2011", :oid=>"ed910067cab6a3471ffe1ccfe8b1b1f71c1e24a4", :filemode=>16384, :type=>:tree}]
# ["diary/2012/02/15/", {:name=>"高く飛ぶには深く屈まないといけないんだぜ.org", :oid=>"7d7a0076f2f5101c77de978684a026a30b6bdeb3", :filemode=>33188, :type=>:blob}]
# ["diary/2012/02/", {:name=>"15", :oid=>"78ff18df1cf2f5928c801c4c701218a6fe6699bd", :filemode=>16384, :type=>:tree}]
# ["diary/2012/02/25/", {:name=>"Sapporo.elをした.org", :oid=>"6d4f5bbc34252258de68e275595d8d54bac980d1", :filemode=>33188, :type=>:blob}]
# ["diary/2012/02/", {:name=>"25", :oid=>"cc807149c26573001e8ece57140ae9aa99135281", :filemode=>16384, :type=>:tree}]
# ["diary/2012/", {:name=>"02", :oid=>"e9125f1d4d4211026095c93c1a2061c2df34b20b", :filemode=>16384, :type=>:tree}]
# ["diary/2012/03/", {:name=>"あなたの知らないRails3.2の変更点.org", :oid=>"4a0cfc22e75751aa573ce0a97ac6c3e2ff32c364", :filemode=>33188, :type=>:blob}]
# ["diary/2012/", {:name=>"03", :oid=>"62b66b71359b61dfec760a20e054d57c9983d471", :filemode=>16384, :type=>:tree}]
# ["diary/2012/07/07/", {:name=>"SappoRoRに参加した.org", :oid=>"71e3548c0621e017cb67534954126f83bfb46cc6", :filemode=>33188, :type=>:blob}]
# ["diary/2012/07/", {:name=>"07", :oid=>"a2d861ccc410d18818c45b5ef2cef69614e81471", :filemode=>16384, :type=>:tree}]
# ["diary/2012/07/08/", {:name=>"DevDoに参加した.org", :oid=>"1cc6a5b0acf6acc8f30d50a756c24d86cd564ed5", :filemode=>33188, :type=>:blob}]
# ["diary/2012/07/", {:name=>"08", :oid=>"17c49c191f1d52540e95715e898eadd3bb9d6007", :filemode=>16384, :type=>:tree}]
# ["diary/2012/07/10/", {:name=>"jQueryのserializeは普通のリクエストをajax化する時に便利だった.org", :oid=>"215af1ef45728f02dcbed4804d755d1f6eb1ce97", :filemode=>33188, :type=>:blob}]
# ["diary/2012/07/", {:name=>"10", :oid=>"c06424242fe277e02a11f9dd7640d803e34b8121", :filemode=>16384, :type=>:tree}]
# ["diary/2012/07/11/", {:name=>"夏・札幌.org", :oid=>"b2759f149312467eedb37cec6d4fd7c51ea37139", :filemode=>33188, :type=>:blob}]
# ["diary/2012/07/", {:name=>"11", :oid=>"e4eb23544a15753ac8ba7e8cd6bbc6868614cd6e", :filemode=>16384, :type=>:tree}]
# ["diary/2012/07/15/", {:name=>"札幌ドームマラソンを走った.org", :oid=>"c93259c30320bbb750555b42e3a979f1cceb5772", :filemode=>33188, :type=>:blob}]
# ["diary/2012/07/", {:name=>"15", :oid=>"cb67d30936c076e9030febec8c5cacd1ebbfc2de", :filemode=>16384, :type=>:tree}]
# ["diary/2012/07/21/", {:name=>"元気がない.org", :oid=>"e5ae796c71f3ff2085c1ac8e4473a4fbd444f816", :filemode=>33188, :type=>:blob}]
# ["diary/2012/07/", {:name=>"21", :oid=>"e811fc7ad6496a9c51e69d4c8450e072aa9511b5", :filemode=>16384, :type=>:tree}]
# ["diary/2012/", {:name=>"07", :oid=>"22f709d79c0ab6fc2d6835ba88c52ff5df014c9b", :filemode=>16384, :type=>:tree}]
# ["diary/2012/08/06/", {:name=>"Q&A.jpg", :oid=>"5552c6c49ff8d8e9a24a2374007d936aeb5791f4", :filemode=>33188, :type=>:blob}]
# ["diary/2012/08/06/", {:name=>"Ruby&アジャイル開発セミナー2012 in 札幌に参加した.org", :oid=>"a1f7a452fd26f95db885df85297a60cf4357133d", :filemode=>33188, :type=>:blob}]
# ["diary/2012/08/06/", {:name=>"しまださん.jpg", :oid=>"65bb44a57d648c1fe16ccbfe08003c3340bb0d9f", :filemode=>33188, :type=>:blob}]
# ["diary/2012/08/06/", {:name=>"西村さん.jpg", :oid=>"78a22bcd28b19ee7bc0af6bcdbd07c8a29f8bb1a", :filemode=>33188, :type=>:blob}]
# ["diary/2012/08/", {:name=>"06", :oid=>"416fc3023b8ab4980b92c50e4079c173ed56db01", :filemode=>16384, :type=>:tree}]
# ["diary/2012/08/09/", {:name=>"nwiki0.0.2をリリースした.org", :oid=>"899a2a8c5169c896ff80bcde43cc144413aba290", :filemode=>33188, :type=>:blob}]
# ["diary/2012/08/", {:name=>"09", :oid=>"0f53b0039c8312351e28c92e73b7f157af486d65", :filemode=>16384, :type=>:tree}]
# ["diary/2012/", {:name=>"08", :oid=>"859f2bf6fa1f81474d06b90dfe4d78786abb1bf2", :filemode=>16384, :type=>:tree}]
# ["diary/2012/10/03/", {:name=>"after.png", :oid=>"fbb5d964068b85a8a48d32759daa59715be78f5e", :filemode=>33188, :type=>:blob}]
# ["diary/2012/10/03/", {:name=>"before.png", :oid=>"c50a9060d46bdeacc7a1b177738018f2bdf89943", :filemode=>33188, :type=>:blob}]
# ["diary/2012/10/03/", {:name=>"stackoverflowの日付表示をyyyy-mm-ddにする.org", :oid=>"c6adead1f3df12d8793833b5af3b6daea2334cee", :filemode=>33188, :type=>:blob}]
# ["diary/2012/10/", {:name=>"03", :oid=>"862ff28668a0791b13c280b651ff66daacf5c8ad", :filemode=>16384, :type=>:tree}]
# ["diary/2012/10/04/", {:name=>"生産性が10倍高くなる意識高いスクリプト.rb.org", :oid=>"aa47ead9c2152f75ce7e3bf6256c9258925df759", :filemode=>33188, :type=>:blob}]
# ["diary/2012/10/", {:name=>"04", :oid=>"43c34adcb09da6168143cca0b6d30bb6ba129af6", :filemode=>16384, :type=>:tree}]
# ["diary/2012/10/10/", {:name=>"nwiki0.0.4リリース.org", :oid=>"f95ed1d32789eb588bd13d9f5d75741c0b61a849", :filemode=>33188, :type=>:blob}]
# ["diary/2012/10/", {:name=>"10", :oid=>"64060ceb3a6f3df5934fb53dfbc377ace9bc9d36", :filemode=>16384, :type=>:tree}]
# ["diary/2012/10/18/", {:name=>"terminal-256-colors-emacs.png", :oid=>"9a5989a188bab7962691250b88c116c3aeeaf8ea", :filemode=>33188, :type=>:blob}]
# ["diary/2012/10/18/", {:name=>"ターミナルで起動するemacsを256色で表示する方法（with今何色表示できているかを知る方法）.org", :oid=>"df2ab38160e7b2b61714e15335f3326d6bc6a4fd", :filemode=>33188, :type=>:blob}]
# ["diary/2012/10/", {:name=>"18", :oid=>"6d21be0bef99c26770ef46bd960d9655deecd962", :filemode=>16384, :type=>:tree}]
# ["diary/2012/", {:name=>"10", :oid=>"cfa491c2b9288cf1d98a861df15212404bfea6e4", :filemode=>16384, :type=>:tree}]
# ["diary/2012/11/17/", {:name=>"札幌Javaカンファレンス2012に参加した.org", :oid=>"99f51ad264d3e0f8dd6c9ce44b586774a43f453b", :filemode=>33188, :type=>:blob}]
# ["diary/2012/11/", {:name=>"17", :oid=>"332f0bb1d63f0f72dea2e1a77575fc88488b032b", :filemode=>16384, :type=>:tree}]
# ["diary/2012/", {:name=>"11", :oid=>"0aad976d614adb43767b9502e912efa9152dece0", :filemode=>16384, :type=>:tree}]
# ["diary/", {:name=>"2012", :oid=>"214395aeb7d73a63b442ed71b23c4cef8c9f9d9a", :filemode=>16384, :type=>:tree}]
# ["diary/2013/02/05/", {:name=>"SLA一桁の重みはどのくらい？.org", :oid=>"032a655e5b5ec036c6f7a263da9f5e601ed0289c", :filemode=>33188, :type=>:blob}]
# ["diary/2013/02/", {:name=>"05", :oid=>"0562d6dc2a3b87183b303ae0887b9533ca131ac6", :filemode=>16384, :type=>:tree}]
# ["diary/2013/02/20/", {:name=>"Rubyで全半角混在文字の文字幅を計算する方法.org", :oid=>"24a696d26247d5c796b02d7e42ba3e504437d4b0", :filemode=>33188, :type=>:blob}]
# ["diary/2013/02/", {:name=>"20", :oid=>"7230883180dd79da9a5f2c612c4a0a9f5d5cea3c", :filemode=>16384, :type=>:tree}]
# ["diary/2013/02/21/", {:name=>"helm-consadole-uniform-number-2013-sample.png", :oid=>"2f4c90dc463245cf027fb277adce75ea500dc92f", :filemode=>33261, :type=>:blob}]
# ["diary/2013/02/21/", {:name=>"helmでコンサドーレ札幌2013シーズン選手背番号を探す.org", :oid=>"1bf5b7879858db3ff6462ed5a3d056a3af8a3292", :filemode=>33188, :type=>:blob}]
# ["diary/2013/02/", {:name=>"21", :oid=>"78aba6432236f22f9d6b7d086006869a6834b602", :filemode=>16384, :type=>:tree}]
# ["diary/2013/02/23/", {:name=>"JavaScript道場に参加した.org", :oid=>"666d0412ed091c1cf136681a0b859709a33dac80", :filemode=>33188, :type=>:blob}]
# ["diary/2013/02/", {:name=>"23", :oid=>"1341a9a370fea9e53e94c7b7aabed38cd02121af", :filemode=>16384, :type=>:tree}]
# ["diary/2013/02/26/", {:name=>"今日何があったか書けない.org", :oid=>"6e4190fbdb9d845ccbcdadfaf9a102298b7fdcfa", :filemode=>33188, :type=>:blob}]
# ["diary/2013/02/", {:name=>"26", :oid=>"fefcfac50768154d3fe66a8f5e1314ed0caaf8f1", :filemode=>16384, :type=>:tree}]
# ["diary/2013/02/27/", {:name=>"時間を勘違いして遅刻した日.org", :oid=>"e580bd786991066c62fa46f71b69083b2ef30420", :filemode=>33188, :type=>:blob}]
# ["diary/2013/02/", {:name=>"27", :oid=>"35a352bd4ff83307b13f3aff979b1f262dc4a27c", :filemode=>16384, :type=>:tree}]
# ["diary/2013/02/28/", {:name=>"3月並の暖かさの日.org", :oid=>"842d5c8ee9412f89bbfaa918c40d6c47574cfe0b", :filemode=>33188, :type=>:blob}]
# ["diary/2013/02/", {:name=>"28", :oid=>"cd418db442ecca339c6dcc3f275d058b2e4d54ba", :filemode=>16384, :type=>:tree}]
# ["diary/2013/", {:name=>"02", :oid=>"264cbb5fde7e41e4b58e5284711890d418e496b4", :filemode=>16384, :type=>:tree}]
# ["diary/2013/03/05/", {:name=>"インストーラーでインストールしたvagrantからvagrantプラグインsaharaを利用する.org", :oid=>"977020e01fb57dac03df0462168f89f16d166b68", :filemode=>33188, :type=>:blob}]
# ["diary/2013/03/", {:name=>"05", :oid=>"530501216a8c7343309d02d3a492af1dbb4e670f", :filemode=>16384, :type=>:tree}]
# ["diary/2013/03/11/", {:name=>"LDAPでUNIX情報を管理している場合にuid,gidが重なった場合の対処.org", :oid=>"3654f81df54d3927e3fd25d4315d7c3425f67fe7", :filemode=>33188, :type=>:blob}]
# ["diary/2013/03/", {:name=>"11", :oid=>"d2a98d31e77d30558e31383e69fccb55531df137", :filemode=>16384, :type=>:tree}]
# ["diary/2013/", {:name=>"03", :oid=>"6f679cc0d8364a99dab84b5c2cbe1df5daca009b", :filemode=>16384, :type=>:tree}]
# ["diary/2013/04/02/", {:name=>"mongolabとmongohqどちらを選ぶか.org", :oid=>"e215b5a4e829c707bfdc4a5f243e5797bbb813c6", :filemode=>33188, :type=>:blob}]
# ["diary/2013/04/", {:name=>"02", :oid=>"09b9052ae50894e8bfabbcdff08e6cb68cb86e91", :filemode=>16384, :type=>:tree}]
# ["diary/2013/04/23/", {:name=>"screenのかわりにtmuxを使ってみる.org", :oid=>"20e37f6986228c8730a6ee12aaab3007aa501df5", :filemode=>33188, :type=>:blob}]
# ["diary/2013/04/", {:name=>"23", :oid=>"93228df3588640223598f7a772b9ac990e59fd00", :filemode=>16384, :type=>:tree}]
# ["diary/2013/04/26/", {:name=>"curlでリダイレクト先のデータを取得する.org", :oid=>"b2130aeaf6dc25763f36286569c2b8b91bcec30c", :filemode=>33188, :type=>:blob}]
# ["diary/2013/04/", {:name=>"26", :oid=>"09b66560db37ae730af9a925860aea82f86045ca", :filemode=>16384, :type=>:tree}]
# ["diary/2013/04/30/", {:name=>"emacsでls does not support --dired; see `dired-use-ls-dired' for more details.と出たときの対処方法.org", :oid=>"e7ba2de71a7a0e7e52d757a4c55272660cbe4b34", :filemode=>33188, :type=>:blob}]
# ["diary/2013/04/30/", {:name=>"ember.jsやってみる.org", :oid=>"04a48f365180ed1c9d3844912c4873535584b03a", :filemode=>33188, :type=>:blob}]
# ["diary/2013/04/", {:name=>"30", :oid=>"964f2cd22cae619c704b08ff0cfe7b720895c982", :filemode=>16384, :type=>:tree}]
# ["diary/2013/", {:name=>"04", :oid=>"d07c90bce7311f60c57263b35aee77732d8ae578", :filemode=>16384, :type=>:tree}]
# ["diary/2013/05/01/", {:name=>"ember.jsやってみる2.org", :oid=>"591b19a1a789c707314c9cc87b4fede5c807331c", :filemode=>33188, :type=>:blob}]
# ["diary/2013/05/", {:name=>"01", :oid=>"f2f4af25f718f6c21d2b029bed82dd4ca23b5568", :filemode=>16384, :type=>:tree}]
# ["diary/2013/05/02/", {:name=>"ember.jsやってみる3.org", :oid=>"0025a672e4ef7bbf06bf82aeaed9b9e09d55cb86", :filemode=>33188, :type=>:blob}]
# ["diary/2013/05/", {:name=>"02", :oid=>"99fa72088bc2dca0c299c41709ce643024f12bbe", :filemode=>16384, :type=>:tree}]
# ["diary/2013/05/06/", {:name=>"nwikiのREADME.mdにbadgeを貼った.org", :oid=>"8f400bf058f3678300cb467de5be66b8cb54162f", :filemode=>33188, :type=>:blob}]
# ["diary/2013/05/", {:name=>"06", :oid=>"3bde4c524bbcd249a9b48ad290917d9b3869d433", :filemode=>16384, :type=>:tree}]
# ["diary/2013/05/09/", {:name=>"標準出力のdiffを取る.org", :oid=>"eb89f550710812a559a5d5c9a08b734ca8236621", :filemode=>33188, :type=>:blob}]
# ["diary/2013/05/", {:name=>"09", :oid=>"87ef82d03e08544c54b000729b5daa14dc0f20b0", :filemode=>16384, :type=>:tree}]
# ["diary/2013/05/19/", {:name=>"Sapporo.jsに参加した.org", :oid=>"1a10047678123576e5277742473870215fd950ef", :filemode=>33188, :type=>:blob}]
# ["diary/2013/05/", {:name=>"19", :oid=>"07338edc3b4edcaa6aa77a92803631143fb9a6c2", :filemode=>16384, :type=>:tree}]
# ["diary/2013/05/24/", {:name=>"aptitude updateに失敗したときの対処.org", :oid=>"d7dd2ffbc7e4d1d3828d62fa718c33ddac7d12e3", :filemode=>33188, :type=>:blob}]
# ["diary/2013/05/", {:name=>"24", :oid=>"52dd5b1d573e9489e8cad475ad55e54b5007fe43", :filemode=>16384, :type=>:tree}]
# ["diary/2013/05/28/", {:name=>"友人に連絡とれなくなっていた.org", :oid=>"260ed94f91f518e67223c5aedc986260cd2be106", :filemode=>33188, :type=>:blob}]
# ["diary/2013/05/", {:name=>"28", :oid=>"28313a610d8afa05ed68bc130d0ed7eca3e66e70", :filemode=>16384, :type=>:tree}]
# ["diary/2013/", {:name=>"05", :oid=>"dc4d33cad6b448b33e2101feef0805fad0f90b19", :filemode=>16384, :type=>:tree}]
# ["diary/2013/06/01/", {:name=>"RubyKaigiが終わった.org", :oid=>"9dcbeb79fcb6b94ee8632b3f48dccc592d604e6a", :filemode=>33188, :type=>:blob}]
# ["diary/2013/06/", {:name=>"01", :oid=>"23b24bfcc4b1f00a6385036d2995fe2ca45ffce2", :filemode=>16384, :type=>:tree}]
# ["diary/2013/06/02/", {:name=>"kinen.png", :oid=>"19627ad7c191f63ee7bba1d511c3d010804226ef", :filemode=>33188, :type=>:blob}]
# ["diary/2013/06/02/", {:name=>"versions_of_nwiki.png", :oid=>"0b97e70045ebbf7e8b6b60227dd5b8ca78e29a91", :filemode=>33188, :type=>:blob}]
# ["diary/2013/06/02/", {:name=>"記念プログラミングをしよう.org", :oid=>"baafa4d484fe95db2bb234d30a54685207c9f12e", :filemode=>33188, :type=>:blob}]
# ["diary/2013/06/", {:name=>"02", :oid=>"c6bcfaa97bffeff80fce2566dee672812998d892", :filemode=>16384, :type=>:tree}]
# ["diary/2013/06/25/", {:name=>"google-transrator-toolkit.png", :oid=>"bf6966778ff8d97332376a2e00293208e7843cad", :filemode=>33261, :type=>:blob}]
# ["diary/2013/06/25/", {:name=>"英語のチュートリアルを翻訳した.org", :oid=>"f59ac1779febc409140d52adb3d5868b8a199c87", :filemode=>33188, :type=>:blob}]
# ["diary/2013/06/", {:name=>"25", :oid=>"79b7e54afcd6641e84fe77b1fa788855d3e86ba4", :filemode=>16384, :type=>:tree}]
# ["diary/2013/", {:name=>"06", :oid=>"b8b6f4380db43bd3aa95a0a630a77237309e4ef8", :filemode=>16384, :type=>:tree}]
# ["diary/2013/07/04/", {:name=>"google-server-error!!l.png", :oid=>"9525836ca1e4d7edd97fbae32104de2e5fb82ca1", :filemode=>33188, :type=>:blob}]
# ["diary/2013/07/04/", {:name=>"googleさんエラー画面のタイトルが!!1.org", :oid=>"eaad775bac9896e89f6035234ff62104ec828f0b", :filemode=>33188, :type=>:blob}]
# ["diary/2013/07/", {:name=>"04", :oid=>"3aabd0c8065ed0092cd7d6d4621c475f2c5c21bb", :filemode=>16384, :type=>:tree}]
# ["diary/2013/07/12/", {:name=>"xmpfilterを読む.org", :oid=>"a6e438ce873ac948901bb39e4fcfb863869c4d4f", :filemode=>33188, :type=>:blob}]
# ["diary/2013/07/", {:name=>"12", :oid=>"04998bf0bbd12aacbb1ea863f5a88d7a367c4e89", :filemode=>16384, :type=>:tree}]
# ["diary/2013/07/17/", {:name=>"ArrayにあってEnumerableにないメソッド一覧.org", :oid=>"b4f9c5dbc43dd4f6f00c99c5490a89549c3060f5", :filemode=>33188, :type=>:blob}]
# ["diary/2013/07/", {:name=>"17", :oid=>"9e5094055dcfd5f0d4afc861330dafe2ff635ae3", :filemode=>16384, :type=>:tree}]
# ["diary/2013/07/18/", {:name=>"xmpfilterを読む(2).org", :oid=>"2127051d279d4efe11e55fa9fb05a8ee3e80d058", :filemode=>33188, :type=>:blob}]
# ["diary/2013/07/", {:name=>"18", :oid=>"20e323a52b0bc7d315688c949bbf8e73c6965285", :filemode=>16384, :type=>:tree}]
# ["diary/2013/07/19/", {:name=>"xmpfilterを読む(3).org", :oid=>"d8e29e224a4b182f90104cfeaf111d024fbb8e02", :filemode=>33188, :type=>:blob}]
# ["diary/2013/07/", {:name=>"19", :oid=>"933169dbf20654e3ce9e697ff9119f9c97c609f6", :filemode=>16384, :type=>:tree}]
# ["diary/2013/07/22/", {:name=>"xmpfilterを読む(4).org", :oid=>"78f3ef820ac3562172d8173d4e59fc9bd3169e2d", :filemode=>33188, :type=>:blob}]
# ["diary/2013/07/", {:name=>"22", :oid=>"a2b9c254079893a57c58f4f5e73fa11609787184", :filemode=>16384, :type=>:tree}]
# ["diary/2013/07/30/", {:name=>"sortコマンドで単位付きの数値を整列させる.org", :oid=>"6a3aa08d59ac11195ea6b28924bd12b58ebf5cd8", :filemode=>33188, :type=>:blob}]
# ["diary/2013/07/", {:name=>"30", :oid=>"33c8ea79f8eb3305c3974dc3df5ce50bb8bd00cb", :filemode=>16384, :type=>:tree}]
# ["diary/2013/", {:name=>"07", :oid=>"f9d8f9d6e3a1569e96479339d38a0dd7ef0ded13", :filemode=>16384, :type=>:tree}]
# ["diary/2013/08/02/", {:name=>"ruby2.0時代のデバッガはこれだ.org", :oid=>"64b75c735dcf6a1eca9fd7005baa105e4d2aae3e", :filemode=>33188, :type=>:blob}]
# ["diary/2013/08/", {:name=>"02", :oid=>"7b5f90528a4ed469df41277e0bb800680c51184c", :filemode=>16384, :type=>:tree}]
# ["diary/2013/08/13/", {:name=>"ディレクトリを作るときにモードも一緒に指定するmkdir -m.org", :oid=>"aa96c324146b34297aa432c42c411a3a2022661a", :filemode=>33188, :type=>:blob}]
# ["diary/2013/08/", {:name=>"13", :oid=>"d0ae1e08e669ec24b644fef9f73004665ad0ee5c", :filemode=>16384, :type=>:tree}]
# ["diary/2013/", {:name=>"08", :oid=>"f80918916aaed9916445f971df200fbc673109e9", :filemode=>16384, :type=>:tree}]
# ["diary/", {:name=>"2013", :oid=>"83ee98541e13a686471d80d010475eb0d8b82016", :filemode=>16384, :type=>:tree}]
# ["", {:name=>"diary", :oid=>"0341ab04500cd7a7e6ced7384beee7fa6892a091", :filemode=>16384, :type=>:tree}]
# ["wiki/Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する/", {:name=>"01-stop-at-boot-menu.png", :oid=>"dbcd2c0846d705628b31ef4b4993ef6020b9dde9", :filemode=>33188, :type=>:blob}]
# ["wiki/Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する/", {:name=>"02-stop-at-boot-command.png", :oid=>"c61b899f6b3646f7635c015d1296e2274825842a", :filemode=>33188, :type=>:blob}]
# ["wiki/Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する/", {:name=>"03-fail-at-download-debconf-preconfiguration-file.png", :oid=>"b0ce4748a2df1faf30365796a07bd0bc8d22cfd1", :filemode=>33188, :type=>:blob}]
# ["wiki/Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する/", {:name=>"04-stop-at-input-root-password.png", :oid=>"cdd88a10b334945e4f14225f0d57f5cacdd4eb7f", :filemode=>33188, :type=>:blob}]
# ["wiki/Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する/", {:name=>"05-stop-at-input-user-full-name.png", :oid=>"d5c6c7cfc18a47ffd2f283bb4708a9fd95be7ca6", :filemode=>33188, :type=>:blob}]
# ["wiki/Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する/", {:name=>"06-stop-at-input-username.png", :oid=>"7a20ad352b330bb94c6c40486465aabe42a480df", :filemode=>33188, :type=>:blob}]
# ["wiki/Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する/", {:name=>"07-stop-at-input-password.png", :oid=>"378aec8ad91f3eb57cd4f474bb10f9cb2fcb2cf5", :filemode=>33188, :type=>:blob}]
# ["wiki/Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する/", {:name=>"08-stop-at-input-password-verify.png", :oid=>"6850fd0c3617f2ca4a49111b991424a4bc51346a", :filemode=>33188, :type=>:blob}]
# ["wiki/Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する/", {:name=>"09-stop-at-choose-to-participate-popularity-contest.png", :oid=>"69c58db5431662f7b892c7db9fd958b02494b847", :filemode=>33188, :type=>:blob}]
# ["wiki/Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する/", {:name=>"10-stop-at-choose-software-to-install.png", :oid=>"fda2d8670945100afd7f2fcffc075a61b258a213", :filemode=>33188, :type=>:blob}]
# ["wiki/Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する/", {:name=>"11-stop-at-choose-install-grub-boot-loader.png", :oid=>"b1192ce2c172570aa8bac751b991d246130bf48c", :filemode=>33188, :type=>:blob}]
# ["wiki/Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する/", {:name=>"index.org", :oid=>"f5c1e07504257f71bcb012fb8fbf3a8157fe82f7", :filemode=>33188, :type=>:blob}]
# ["wiki/", {:name=>"Packerを使ってVagrantのBoxを作る方法をステップバイステップで説明する", :oid=>"4c6a46c50f6eba6eef0f86b898a0b1295c1edcdc", :filemode=>16384, :type=>:tree}]
# ["wiki/", {:name=>"anythingプラグインを作る", :oid=>"d78ca87f2f1a755c4b39e264d440a03dd482db1e", :filemode=>33188, :type=>:blob}]
# ["wiki/commitlog/", {:name=>"逆引き", :oid=>"dc293d4304e84a0e4de10fc85f4a9288d8fcdcbc", :filemode=>33188, :type=>:blob}]
# ["wiki/", {:name=>"commitlog", :oid=>"47406d61d6dadf60c9173b7f2120384c0b89feef", :filemode=>16384, :type=>:tree}]
# ["wiki/misc/", {:name=>"どうやって貢献するか.org", :oid=>"824e3735e170c05fba74f742b3a75eb08230e37a", :filemode=>33188, :type=>:blob}]
# ["wiki/", {:name=>"misc", :oid=>"e442f46be6d9aa19015b46ffc294e130f0212c2e", :filemode=>16384, :type=>:tree}]
# ["wiki/reviews/", {:name=>"さあ、才能(じぶん)に目覚めよう―あなたの5つの強みを見出し、活かす.org", :oid=>"db5e2522015e603c99e934def5534f362c069b32", :filemode=>33188, :type=>:blob}]
# ["wiki/reviews/", {:name=>"なるほどUnixプロセス ー Rubyで学ぶUnixの基礎.org", :oid=>"848a3f640edb1160a5f7313b3c4e3bb482265710", :filemode=>33188, :type=>:blob}]
# ["wiki/", {:name=>"reviews", :oid=>"0ceed8042f865edc538f356a82b488d4360c3ec7", :filemode=>16384, :type=>:tree}]
# ["", {:name=>"wiki", :oid=>"648f95adbdb1b9a251fd51b764265e53d008532d", :filemode=>16384, :type=>:tree}]
