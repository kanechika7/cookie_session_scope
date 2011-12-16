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

      # 設定
      # @author Nozomu Kanechika
      # @since
      # @version
      def cookie_session_scope c_sp
        class_eval do
          cattr_accessor :cookie_sp
          self.cookie_sp = c_sp ||= 'user_info.sp'
        end
      end

      define_method :cs_scope do |session|
        ccs   = current_cookie_sp(session)
        array = [{ :sp => /^#{ccs}.*/ }]
        wild_cards(session).each{|wc| array << { :sp => wc } }
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
