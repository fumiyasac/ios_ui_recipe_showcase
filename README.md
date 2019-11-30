# [技術書典5] iOSアプリ開発 - UI実装であると嬉しいレシピブックに掲載するサンプル

### 1. 概要

こちらは、上記書籍にて紹介しているサンプルを収録したリポジトリになります。書籍内で解説の際に利用したサンプルコードの完成版のプロジェクトがそれぞれの章毎にありますので、書籍内の解説をより詳細に理解する際や開発中のアプリにおける実装時の参考等にご活用頂ければ嬉しく思います。

### 2. サンプル図解

こちらはの書籍で紹介しているサンプルにおける概略図になります。

__⭐️第1章サンプル:__

この章では複数のContainerViewを組み合わせてスライドメニューのようなViewとコンテンツの切り替えを行う部分に関して解説をしていきます。
メニューの開閉や現在表示している画面からの切り替えに関する部分はコンテンツ量が多くなるようなアプリではよくお目にかかる部分ではあるものの、いざ自前で実装しようとするとなかなか大変な部分の1つかと思います。

![第1章サンプル図](https://github.com/fumiyasac/ios_ui_recipe_showcase/blob/master/images/capture1_techbook.jpg)

__⭐️第2章サンプル:__

この章ではCustomTransition（カスタムトランジション）による画面遷移に一工夫を加えて遷移前後の画面表示と組み合わせた実装例を解説をしていきます。加えて今回はメディアないしは読み物系のコンテンツを表示しているアプリなどでよくお目にかかるUI表現を含んだ画面と合わせて、遷移の繋ぎ目部分の表現をできるだけ自然な形にするための考慮を行なっています。カスタムトランジションについては、iOSでお目にかかる画面遷移の表現をカスタマイズできるのでUI表現にこだわったアプリを作る際には重宝するテクニックの1つかと思います。

![第2章サンプル図](https://github.com/fumiyasac/ios_ui_recipe_showcase/blob/master/images/capture2_techbook.jpg)

__⭐️第3章サンプル:__

この章ではGestureRecognizerによる指の動きを利用した実装例として、人気アプリ「Tinder」でも使われている「好き」or「嫌い」（Yes or No）を左右のスワイプで答えるようなUIの実装に関して解説をしていきます。
今回はシンプルにカード風のUIを左右にスワイプして画面から消す動きまでの動きを再現した実装になりますが、この形のUIはマッチングアプリをはじめとするユーザーのカジュアルな選択を促すためのUIとして、同様な動きを表現するためのUIライブラリについても数多くあることからも、その心理的な効果や応用可能性への関心が高いことが伺えるかと思います。

![第3章サンプル図](https://github.com/fumiyasac/ios_ui_recipe_showcase/blob/master/images/capture3_techbook.jpg)

__⭐️第4章サンプル:__

この章ではユーザーの情報入力を伴うようなUI実装についての解説をしていきます。この章で解説しているサンプルについては、これまでの章で紹介したサンプルよりもUI表現に関する実装は少なめではありますが、ユーザーの情報入力に関する考慮という点や部品となるViewの再利用と処理の橋渡しについての考慮と言う点に重点を置いたサンプルになります。愚直に実装してしまうと煩雑なコードやUI構造になってしまいがちな部分ですが、ユーザーとの接点にもなる大切な部分ですので、UIのわかりやすさと実装のしやすさを両立した実装が求められる奥が深い例の1つだと思います。

![第4章サンプル図](https://github.com/fumiyasac/ios_ui_recipe_showcase/blob/master/images/capture4_techbook.jpg)

### 3. その他サンプルに関することについて

__【お知らせ: サンプルのバージョンアップ対応について】__

2019.12.01時点での収録サンプルのリポジトリに関しては下記のバージョンで実装したものになっております。

+ macOS Catalina 10.15.1
+ Xcode 11.1
+ Swift 5.1
+ CocoaPods 1.8.4

__【Podfileの記載変更について】__

◎ 第2章のサンプルでのPodfile

```
target 'InteractiveUIExample' do
  use_frameworks!

  # Pods for InteractiveUIExample
  pod 'Cosmos'
  pod 'ActiveLabel'
  pod 'FontAwesome.swift'
end
```

◎ 第4章のサンプルでのPodfile

```
target 'ReservationFormExample' do
  use_frameworks!

  # Pods for ReservationFormExample
  pod 'KYNavigationProgress'
  pod 'Popover'
  pod 'FontAwesome.swift'
end

post_install do |installer|  
  installer.pods_project.targets.each do |target|
    # KYNavigationProgressのSwiftバージョンは4.0へ固定
    if ['KYNavigationProgress'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
    # PopoverのSwiftバージョンは4.2へ固定
    if ['Popover'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.2'
      end
    end
  end
end
```

__【Swift4.2 → Swift5.0.1へのバージョンアップにおける記載変更について】__

基本的には、ライブラリのバージョンアップ以外では大きな変更点はございませんでしたが、下記の部分が変更されています。
（Beforeのままでもエラーにはなりませんが、警告が出てしまいます。）

```
# 第4章においてUIPageViewControllerDataSourceを利用した実装部分の変更

◉ Before:
guard let index = targetViewControllerLists.index(of: viewController) else {
↓
◉ After:
guard let index = targetViewControllerLists.firstIndex(of: viewController) else {
```

__【iOS13 & Xcode11.1へのバージョンアップにおいてこのサンプルで触れていない部分】__

本サンプルでは下記の部分に関しては、今回は対応していませんのでご注意下さい。

+ DarkModeの無効化（現在は強制的にLightModeにしています。）
+ SceneDelegateは利用しない従来のAppDelegateの利用（現状は挙動に問題はありませんが非推奨です。）
