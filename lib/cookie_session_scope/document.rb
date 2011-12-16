# coding: UTF-8
module CookieSessionScope
  module Document
    extend ActiveSupport::Concern

    #
    #  ~ HOW TO ~
    #
    #  class Model
    #    include Mongoid::Document
    #
    #    include CookieSessionScope::Document
    #    cookie_session_scope 'user_info.sp'
    #
    #
    #
    #  class MoeldsController < ApplicationController
    #
    #    def index
    #      @models = Model.cs_scope session
    #
    #

    included do
      field :sp
    end

    module ClassMethods

      #
      # モデルにspを設定します
      # 
      # class Model
      #   include Mongoid::Document
      #   include CookieSessionScope::Document
      #   cookie_session_scope 'user_info.sp'
      # 
      # @author Nozomu Kanechika
      # @since 4.9.0
      # @version 4.9.0
      # @params c_sp: クッキーのspが入っている場所
      def cookie_session_scope c_sp
        class_eval do
          cattr_accessor :cookie_sp
          self.cookie_sp = c_sp ||= 'user_info.sp'
        end
      end

      #
      # cookieのspを見て、絞込み条件をかけます
      #
      # class ModelsController < ApplicationController
      # 
      #   def index
      #     @models = Model.cs_scope session
      #
      # @author Nozomu Kanechika
      # @since 4.9.0
      # @version 4.9.0
      # @params session: session情報をそのまま入れる
      # @params params: パジネート用
      define_method :cs_scope do |session,params|
        ccs = current_cookie_sp(session)
        array = [{ :sp => /^#{ccs}.*/ }]
        wild_cards(session).each{|wc| array << { :sp => wc } }
        return scoped.any_of(array).page(params[:page]).per(params[:per])
      end

    private

      # cookieのsp情報を取得
      # @author Nozomu Kanechika
      # @since 4.9.0
      # @version 4.9.0
      # @params session
      def current_cookie_sp session
        return @current_cookie_sp if @current_cookie_sp
        begin
          sps = cookie_sp.split(".")
          sp1,spn = sps[0],sps[1..-1]
          ccsp = JSON.parse(session[sp1])
          ccsp = eval("ccsp"+spn.map{|s| "['#{s}']" }.join('')) if spn
        rescue
          raise CookieSessionScope::Error, "session `#{cookie_sp}` is nil."
        end
        @current_cookie_sp = ccsp
      end

      # 絞り込み条件にかける情報取得
      # @author Nozomu Kanechika
      # @since 4.9.0
      # @version 4.9.0
      # @params session
      def wild_cards session
        wcs = []
        ccs = current_cookie_sp(session)
        ccs.split('.').each do |s|
          wcs << ccs.sub(s,"*").sub(/\*.*/,'*')
        end
        return wcs
      end

    end


  end
end
