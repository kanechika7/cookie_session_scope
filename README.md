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
