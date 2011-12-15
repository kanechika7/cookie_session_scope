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
    #    cookie_session_scope 'sp','user_info.sp'
    #
    #
    #
    #  class MoeldsController < ApplicationController
    #
    #    def index
    #      @models = Model.cs_scope session
    #
    #


    module ClassMethods

      # 設定
      # @author Nozomu Kanechika
      # @since
      # @version
      def cookie_session_scope m_sp, c_sp
        class_eval do
          cattr_accessor :model_sp
          cattr_accessor :cookie_sp

          self.model_sp  = m_sp ||= 'sp'
          self.cookie_sp = c_sp ||= 'user_info.sp'
        end
      end

      define_method :cs_scope do |session|
        ccs   = current_cookie_sp(session)
        array = [{ model_sp.to_sym => /^#{ccs}.*/ }]
        wild_cards(session).each{|wc| array << { model_sp.to_sym => wc } }
        return scoped.any_of(array)
      end

      def current_cookie_sp session
        #@current_cookie_sp ||= eval("session"+cookie_sp.split(".").map{|s| "['#{s}']" }.join(''))
        @current_cookie_sp ||= JSON.parse(session["user_info"])["sp"]
      end

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
