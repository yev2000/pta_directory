class HomeController < ApplicationController
  before_action :require_user, except: [:index, :developer]

  # this is here so that we can present some basic "about this application"
  # information about the PTA directory
  
  def index
    if logged_in?
      redirect_from_root_for_logged_in
    end
  end

  def freshuser
  end

  def search

    @search_results = []
    
    if params[:search]
      # here we are looking for almost any string among our data set

      search_classes = [Family, Parent, Student, Teacher, Schoolclass, Address, Contact]

      unfolded_search_results = search_classes.inject([]) { |memo, directory_class| memo + directory_class.search_for(params[:search]) }

      # we need to treat contacts and addresses as special.
      # what we do is "fold" the results of addresses to match against the
      # addressable family or parent
      # and similarly contacts fold to teachers or parents
      folded_search_results = fold_search_results_for_contacts_and_addresses(unfolded_search_results)


      # see if we can order the results somehow
      @search_results = []
      
      folded_search_results.each do |s|
        case
        when s.class == Family
          @search_results << [s.name, "Family", icon_action_link("icon-book", "Details", family_path(s))]
        
        when s.class == Parent
          @search_results << [s.last_first, "Parent", icon_action_link("icon-user", "Details", parent_path(s))]
        
        when s.class == Student
          @search_results << [s.last_first, "Student", icon_action_link("icon-user", "Details", student_path(s))]
        
        when s.class == Teacher
          @search_results << [s.last_first, "Teacher", icon_action_link("icon-user", "Details", teacher_path(s))]

        when s.class == Schoolclass
          @search_results << [s.name, "Class", icon_action_link("icon-list", "Details", schoolclass_path(s))]
        end

        @search_results.sort! do |x,y|
          retval = x[1] <=> y[1]
          retval == 0 ? x[0] <=> y[0] : retval
        end

      end # iterate over folded search results
    end # params specified a search
  end

  def developer
  end

  def administer_families
  end

  private

  def fold_search_results_for_contacts_and_addresses(search_results)
    
    search_set = Set.new

    search_results.each do |entry|
      if (entry.class == Address)
        search_set << entry.addressable
      elsif (entry.class ==  Contact)
        search_set << entry.contactable
      else
        search_set << entry
      end
    end

    # return an array form of the set
    search_set.to_a

  end

end
