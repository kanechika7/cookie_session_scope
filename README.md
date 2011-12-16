概要
=====
- モデルのDBアクセスで、クッキーセッションからフィルタリングをかけることができます

機能一覧
--------
- Model field『sp』 と クッキーセッション『sp』 からフィルタリングをかけDBからデータ取得します。

サポート環境
---------
* Rails 3.1.1
* mongoid


使い方
------

## ①  設定

    class Model
      include Mongoid::Document
    
      include CookieSessionScope::Document
      cookie_session_scope 'user_info.sp'
  
  
  
    class MoeldsController < ApplicationController
    
      def index
        @models = Model.cs_scope session,params
    

## ② sp仕様

    ex)
      クッキーセッション sp: a.b.c の場合
    
      取得できるData
             sp
        （×）a.b
        （○）a.*
        （○）a.b.c
        （○）a.b.*
        （○）*
        （○）a.b.c.d
        （×）e
        （×）a.f
    

